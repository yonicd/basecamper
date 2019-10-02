#' @title Unzip large files
#' @description CLI call to unzip that is more robust for large files, which
#'   are truncated by \code{\link[utils]{unzip}} if larger than 4gb.
#' @param directory character, path of directory to unzip the file
#' @param file character, local path of the file to unzip.
#' @return NULL
#' @seealso
#'  \code{\link[utils]{unzip}}
#' @rdname unzip2
#' @export
#' @importFrom utils tail
# https://stackoverflow.com/a/42743886
unzip2 <- function(directory, file) {

    # Set working directory for decompression
    # simplifies unzip directory location behavior
    wd <- getwd()
    setwd(directory)

    on.exit({
      setwd(wd) # Reset working directory
      rm(wd)
    },add = TRUE)

    # Run decompression
    decompression <- system2("unzip",
                             args = c("-o", # include override flag
                                      file),
                             stdout = TRUE)

    if (grepl("Warning message", utils::tail(decompression, 1))) {

      print(decompression)

    }else{

      message('Success!')

    }

}

