#' @title Download file from Basecamp
#' @description Download a file from Basecamp Classic
#' @param url character, URL location of the file
#' @param destdir character, directory to save the file on local disk, Default: getwd()
#' @param destfile character, name of file to save on local disk, Default: basename(url)
#' @param token character, Basecamp Classic API token , Default: Sys.getenv("BASECAMP_TOKEN")
#' @return a resoponse object
#' @rdname basecamp_download
#' @export
#' @importFrom glue glue
# @importFrom httr GET authenticate write_disk
basecamp_download <- function(url,
                              destdir  = getwd(),
                              destfile = basename(url),
                              token    = Sys.getenv('BASECAMP_TOKEN')){

  path <- file.path(destdir,fix_filename(destfile))

  system(glue::glue('curl -u {token}:X -L --output {path} {url}'))

  # res <- httr::GET(
  #   url = url,
  #   httr::authenticate(token, 'X'),
  #   httr::progress(),
  #   httr::write_disk(path = path, overwrite = overwrite)
  # )
  #
  # httr::stop_for_status(res)
  #
  # res

}

#' @importFrom utils URLdecode
fix_filename <- function(x){
  gsub('\\s','_',utils::URLdecode(x))
}
