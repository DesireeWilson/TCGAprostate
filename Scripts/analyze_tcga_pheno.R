#' Load needed libraries
library(readr);
#' ### Project variables
#'
#' Declare project path, only once, and build other paths from it.
project_root <- '~/Desktop/TCGAprostate';
#' Check to see whether you are already in `project_root`
#' If not, see if you are one level below it, and if so
#' change to it. Only if you are not in either of these
#' Attempt to change to `project_root` and possibly get
#' an error as a result (which is why we try not to
#' change directories if we don't absolutely have to)
#'
#' Where to look for data and scripts, respectively
data_dir <- 'ImportantFiles';
script_dir <- 'Scripts';
#' `data_dir` and `script_dir` need to exist and are proof that
#' this is in fact a usable `project_root` directory.
if(length(intersect(c(data_dir,script_dir),list.files()))!=2){
    if(length(intersect(c(data_dir,script_dir),list.files('..')))==2){
        setwd('..');
    } else {
        # this is the part that might fail, for example if 
        # this is a Windows computer and doesn't know what
        # "~" means, so we only do this if we can't find 
        # the needed files any other way
        setwd(paste0(project_root));
    }
}
#' If we managed to find our way to `project_root` from
#' here on out, we can use hardcoded _relative_ paths
#' (as long as we're pretty sure we won't need to rename
#' them. If we do expect them to change a lot, we should
#' create additional variables up front with the 
#' path-fragments and `paste0` them together with with
#' `data_dir` and `script_dir`
input_file <- paste0(data_dir,'/pheno.csv');
#' Read the data in
phe <- read_tsv(input_file);
#' Change the `form_completion_date` column to a date
phe$form_completion_date<- as.Date(phe$form_completion_date);
