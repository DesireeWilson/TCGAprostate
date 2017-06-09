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
#' `root_files` are what needs to exist and are proof that
#' this is in fact a usable `project_root` directory.
if(length(intersect(c(data_dir,script_dir),list.files()))!=2){
    if(length(intersect(c(data_dir,script_dir),list.files('..')))==2){
        setwd('..');
    } else {
        setwd(paste0(project_root));
    }
}
input_file <- paste0(data_dir,'/pheno.csv');
#' Read the data in
phe <- read_tsv(input_file);
#' Change the `form_completion_date` column to a date
phe$form_completion_date<- as.Date(phe$form_completion_date);
