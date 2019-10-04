#' @importFrom glue glue
#' @importFrom httr DELETE authenticate stop_for_status
#' @rdname get_api
#' @export
delete_comment <- function(
  id = NULL,
  host = Sys.getenv('BASECAMP_HOST'),
  token = Sys.getenv('BASECAMP_TOKEN')
){

  if(is.null(id)) stop(glue::glue('argument id must contain a comment id'))

  res <- httr::DELETE(
    glue::glue('{host}/comments/{id}.xml'),
    httr::authenticate(token, 'X')
  )

  httr::stop_for_status(res)

}
