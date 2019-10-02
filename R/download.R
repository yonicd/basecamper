#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param url PARAM_DESCRIPTION
#' @param destdir PARAM_DESCRIPTION, Default: getwd()
#' @param destfile PARAM_DESCRIPTION, Default: basename(url)
#' @param token PARAM_DESCRIPTION, Default: Sys.getenv("BASECAMP_TOKEN")
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso
#'  \code{\link[glue]{glue}}
#' @rdname basecamp_download
#' @export
#' @importFrom glue glue
basecamp_download <- function(url,
                              destdir  = getwd(),
                              destfile = basename(url),
                              token    = Sys.getenv('BASECAMP_TOKEN')){

  path <- file.path(destdir,fix_filename(destfile))

  system(glue::glue('curl -u {token}:X -L --output {path} {url}'))

}

#' @importFrom utils URLdecode
fix_filename <- function(x){
  gsub('\\s','_',utils::URLdecode(x))
}
