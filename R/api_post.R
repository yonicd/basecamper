#' @importFrom httr POST authenticate content_type_xml
post_comment <- function(comment,
                         token = Sys.getenv('BASECAMP_TOKEN')){

  httr::POST(
    url  = attr(comment,"POST_URL"),
    body = comment,
    httr::authenticate(token, 'X'),
    httr::content_type_xml()
  )

}

