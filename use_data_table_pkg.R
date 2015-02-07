
# IMPORTANT : This function uses the data.table package for reading
# this big (126.8 MB) dataset, so it asks caller for downloading the package.

# Check if the data.table (enhanced) package exist.
# If it doesn't ask if caller wants to install it from CRAN.
#
# Returns TRUE/FALSE if the caller is going to use the "data.table" package.
# If package is not found asks the caller whether to install it or not.
# If package is found then it uses the package. 
#
use_data_table_pkg <- function() {
    pkg="data.table"
    if(!(pkg %in% rownames(installed.packages()))) {
        repeat {
            yes <- readline(sprintf("Package \"%s\" not found.\nDo you want to install it ? [Y/N]:",pkg))
            yes <- if(yes == "Y") TRUE else if(yes == "N") FALSE else NULL
            if(!is.null(yes)) break
        }
        
        if(yes) {
            message(sprintf("Installing package \"%s\".",pkg))
            install.packages(pkg)
            message(sprintf("Package \"%s\" is now installed.",pkg))
            
            return(TRUE)
        } else {
            message(sprintf("Not going to install package \"%s\".",pkg))
            message("Working with the standard \"data.frame\" instead.")
            return(FALSE)
        }
    } else {
        message(sprintf("Package \"%s\" found.",pkg))
        return(TRUE)
    }
}