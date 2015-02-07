# IMPORTANT(1) : This function downloads the dataset from the url provided by the course.
# if function fails at anypoint during download.file() (not supported method,etc)
# then I encourage you to download the dataset from the web site, unzip it
# and place it under the path "./data/household_power_consumption.txt".
# I tried to make this script as much platform independent as I could but it's not
# tested outside OS X environments (curl used as method here).

#
# Get dataset or download it if not available locally. 
# 
get_dataset <- function() {
    
    dataset_dir <- "data"
    dataset_file <- "household_power_consumption.txt"
    dataset_path <- file.path(getwd(),dataset_dir,dataset_file)
    
    if(file.exists(dataset_path)) return(dataset_path)
    
    # if dataset exists somewhere else the caller should provide it.
    repeat {
        yes <- readline(sprintf("Default dataset path is \"%s\".\nDo you want to use this? [Y/N]:",dataset_path))
        yes <- if(yes == "Y") TRUE else if(yes == "N") FALSE else NULL
        if(!is.null(yes)) break
    }
    if(!yes) {
        repeat {
            dataset_path <- readline("Please provide the ABSOLUTE PATH of the dataset:")
            if(file.exists(dataset_path)) break
            else message("Path you provided does not exist!")
        }
        dataset_ctime <- file.info(dataset_path)$ctime
        message(sprintf("Dataset file \"%s\" creation time : %s.",dataset_path,dataset_ctime))
        return(dataset_path)
    }
    
    # User opted for the default dataset path
    # if dataset dir does not exist create it
    if (!file.exists(dataset_dir)) {
        message(sprintf("Dataset directory \"%s\" does not exist.\nCreating it.",dataset_dir))
        dir.create(dataset_dir)
        message(sprintf("Dataset directory \"%s\" created.",dataset_dir))
    }
    
    # if dataset file does not exist download it (download zip,unzip it and rm zip file)
    if (!file.exists(dataset_path)) {
        message(sprintf("Dataset file \"%s\" does not exist.\nDownloading it.",dataset_path))
        url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        dist <- file.path(dataset_dir,"exdata-data-household_power_consumption.zip")
        
        # download file with method according to platform
        if (.Platform$OS.type == "unix") download.file(url,dist,method="curl")
        else download.file(url,dist,method="wininet")
        
        # unzip downloaded file
        unzip(dist, exdir = dataset_dir)
        
        # check if actual dataset file is eventually there
        if (file.exists(dataset_path)) 
            message(sprintf("Dataset file \"%s\" downloaded and ready for use.",dataset_path))
        
        # remove zip file
        file.remove(dist)
    }
    
    # dataset is available in filesystem get creation time.
    dataset_ctime <- file.info(dataset_path)$ctime
    message(sprintf("Dataset file \"%s\" creation time : %s.",dataset_path,dataset_ctime))
    return(dataset_path)
}