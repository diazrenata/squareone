# squareone

Analyses supporting the ms "Maintenance of community function through compensation breaks down over time in a desert rodent community". The preprint is currently available on bioRxiv at: https://doi.org/10.1101/2021.10.01.462799 

Repository structure:

- `analyses`: Contains .Rmd scripts to replicate the figures and tables in the main text and supplements.
- `data`: Contains all data files necessary to replicate the analyses in the manuscript. (Alternatively, the `analyses` scripts contain code to re-download from the main Portal Data repo).
- `manuscript`: Contains past versions of the ms and iterations through review.  

To replicate:

* Custom functions for downloading and processing data for these analyses are in the R package `soar`, at https://github.com/diazrenata/soar. This is to separate functions that are  called repeatedly in these analyses from the scripts that are only run once.
*  Install the R package `soar` using: `remotes::install_github("diazrenata/soar")`. Alternatively, you can download the archived version from Github (https://github.com/diazrenata/soar) or Zenodo (https://doi.org/10.5281/zenodo.5539880) and install from there. 
* To replicate the analyses and plots referenced in the main text, open `analyses/main_figures.Rmd` and run each section or render the document. 
* To replicate the supplemental analyses, open the supplemental .Rmd files (`analyses/s1_model_results.Rmd` and `analyses/s2_covariates.Rmd`) and run them. 
* Note that the .Rmd documents contain additional notes (commented out) that are probably not of interest to most readers, but may be useful to anyone trying to replicate these analyses exactly or build off of them. 
