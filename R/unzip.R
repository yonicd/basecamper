#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param directory PARAM_DESCRIPTION
#' @param file PARAM_DESCRIPTION
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso
#'  \code{\link[utils]{head}}
#' @rdname unzip2
#' @export
#' @importFrom utils tail
#https://stackoverflow.com/a/42743886
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

