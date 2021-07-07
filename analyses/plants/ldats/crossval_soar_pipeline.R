library(MATSS)
library(drake)
library(LDATS)
#remotes::install_github("diazrenata/cvlt")
library(cvlt)
expose_imports(cvlt)
## include the functions in packages as dependencies
#  - this is to help Drake recognize that targets need to be rebuilt if the
#    functions have changed


plantdat <- drake::drake_plan(
  winter_plants_CC = target(soar::get_plants_annual_ldats()),
  summer_plants_CC = target(soar::get_plants_annual_ldats(census_season = "summer")),
  winter_plants_EE = target(soar::get_plants_annual_ldats(plot_type = "EE")),
  summer_plants_EE = target(soar::get_plants_annual_ldats(census_season = "summer", plot_type = "EE"))
)

datasets <- plantdat


if(FALSE) {
  methods <- drake::drake_plan(
    ldats_fit = target(fit_ldats_crossval(dataset, buffer = 2, k = ks, lda_seed = seeds, cpts = cpts, nit = 50),
                       transform = cross(
                         dataset = !!rlang::syms(datasets$target),
                         ks = !!c(2),
                         seeds = !!seq(2, 2, by = 2),
                         cpts = !!c(0:1),
                         return_full = F,
                         return_fits = F,
                         summarize_ll = F
                       )),
    all_dataset_fits = target(dplyr::bind_rows(ldats_fit),
                              transform = combine(ldats_fit, .by = dataset)),
    best_config = target(select_cvlt(all_dataset_fits),
                         transform = map(all_dataset_fits)),
    best_mod = target(run_best_model(dataset, best_config),
                      transform = map(best_config, .by = dataset)),
    best_mod_summary = target(summarize_model(best_mod),
                              transform = map(best_mod)),
    all_summaries = target(dplyr::bind_rows(best_mod_summary),
                           transform = combine(best_mod_summary))
  )
} else {
  methods <- drake::drake_plan(
    ldats_fit = target(fit_ldats_crossval(dataset, buffer = 2, k = ks, lda_seed = seeds, cpts = cpts, nit = 100),
                       transform = cross(
                         dataset = !!rlang::syms(datasets$target),
                         ks = !!c(0,2:5),
                         seeds = !!seq(2, 100, by = 2),
                         cpts = !!c(0:4),
                         return_full = F,
                         return_fits = F,
                         summarize_ll = F
                       )),
    all_dataset_fits = target(dplyr::bind_rows(ldats_fit),
                              transform = combine(ldats_fit, .by = dataset)),
    best_config = target(select_cvlt(all_dataset_fits),
                         transform = map(all_dataset_fits)),
    best_mod = target(run_best_model(dataset, best_config),
                      transform = map(best_config, .by = dataset))#,
   # best_mod_summary = target(summarize_model(best_mod),
    #                          transform = map(best_mod)),
    #all_summaries = target(dplyr::bind_rows(best_mod_summary),
    #                       transform = combine(best_mod_summary))
  )  
}



## The full workflow
workflow <- dplyr::bind_rows(
  datasets,
  methods
)


## Set up the cache and config
db <- DBI::dbConnect(RSQLite::SQLite(), here::here("analysis", "drake", "drake-cache-soar.sqlite"))
cache <- storr::storr_dbi("datatable", "keystable", db)
cache$del(key = "lock", namespace = "session")

## Run the pipeline
nodename <- Sys.info()["nodename"]
if(grepl("ufhpc", nodename)) {
  print("I know I am on the HiPerGator!")
  library(clustermq)
  options(clustermq.scheduler = "slurm", clustermq.template = "slurm_clustermq.tmpl")
  ## Run the pipeline parallelized for HiPerGator
  make(workflow,
       force = TRUE,
       cache = cache,
       cache_log_file = here::here("analyses", "plants", "ldats", "cache_log_soar.txt"),
       verbose = 1,
       parallelism = "clustermq",
       jobs = 40,
       caching = "master", memory_strategy = "autoclean") # Important for DBI caches!
} else {
  
  # Run the pipeline on multiple local cores
  system.time(make(workflow, cache = cache, cache_log_file = here::here("analyses", "plants", "ldats", "cache_log_cvlt.txt"), verbose = 1, memory_strategy = "autoclean"))
}


DBI::dbDisconnect(db)
rm(cache)


