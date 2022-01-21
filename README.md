# squareone

Analyses supporting the ms "Maintenance of community function through compensation breaks down over time in a desert rodent community". The preprint is currently available on bioRxiv at: https://doi.org/10.1101/2021.10.01.462799 

Repository structure:

- `analyses`: Contains .Rmd scripts to replicate the figures and tables in the main text and supplements.
- `data`: Contains all data files necessary to replicate the analyses in the manuscript. (Alternatively, the `analyses` scripts contain code to re-download from the main Portal Data repo).
- `manuscript`: Contains past versions of the ms and iterations through review.  

To replicate:

* Custom functions for running these analyses are in the R package `soar`, at https://github.com/diazrenata/soar. Install the R package `soar` using: `remotes::install_github("diazrenata/soar")`. Alternatively, you can download the archived version from Zenodo (https://doi.org/10.5281/zenodo.5539880) and install from there. 
* To replicate the analyses and plots referenced in the main text, open `analyses/main_figures.Rmd` and run each section or render the document. 
* To replicate the supplemental analyses, open the supplemental .Rmd files (`analyses/s1_model_results.Rmd` and `analyses/s2_covariates.Rmd`) and run them. 
