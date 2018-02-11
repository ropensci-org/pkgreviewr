check_rstudio <- function() {
    # check if rstudio available
    if (!rstudioapi::isAvailable()) {
        stop(strwrap(paste("pkreviewr is designed to work with Rstudio version" ,
                           "1.0 and above.", "Please install or launch in Rstudio to proceed.",
                           "Visit <https://www.rstudio.com/products/rstudio/download/>",
                           " to download the latest version"), prefix = "\n"))
    }

    # check rstudio version > 1.0.0
    rs_version <- rstudioapi::getVersion()
    if (rs_version < "1.0.0") {
        stop(strwrap(paste("pkreviewr is designed to work with notebooks in Rstudio version" ,
                           "1.0 and above.",
                           "Please update to RStudio version 1.0 or greater to proceed.",
                           "You are running RStudio",
                           as.character(rs_version)), prefix = "\n"))
    }
}
