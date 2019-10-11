#' @importFrom glue glue
#' @rdname get_api
#' @export
basecamp_attachments <- function(id,
                                 host = Sys.getenv('BASECAMP_HOST'),
                                 token = Sys.getenv('BASECAMP_TOKEN')){

  get_query(
    query    = glue::glue('{host}/projects/{id}/attachments.xml'),
    token    = token,
    template = 'attachments'
  )

}

#' @importFrom httr POST upload_file authenticate content_type_xml stop_for_status
#' @importFrom glue glue
upload_attachment <- function(file,
  host = Sys.getenv('BASECAMP_HOST'),
  token = Sys.getenv('BASECAMP_TOKEN')){

  res <- httr::POST(
    url  = glue::glue('{host}/upload'),
    body = httr::upload_file(file),
    httr::authenticate(token, 'X'),
    httr::content_type_xml()
  )

  httr::stop_for_status(res)

  res
}

#' @title Add an attachment to a post
#' @description Add an attachment object to a post
#' @param post Post object to attach to (message or comment)
#' @param file character, Path of file to attach
#' @param attachment_name character, Name of attachment seen in post, Default: 'My File'
#' @param host character, URL of the team, Default: Sys.getenv('BASECAMP_HOST')
#' @param token character, Basecamp Classic API token , Default: Sys.getenv("BASECAMP_TOKEN")
#' @return Post with the attachment embedded in it.
#' @rdname add_attachment
#' @export
#' @importFrom xml2 xml_add_child read_xml
#' @importFrom glue glue
add_attachment <- function(
  post,
  file,
  attachment_name = 'My File',
  host = Sys.getenv('BASECAMP_HOST'),
  token = Sys.getenv('BASECAMP_TOKEN')){

  res <- upload_attachment(file, host = host, token = token)

  tmpl <- paste0(
    readLines(system.file('attach_template.txt',package = 'basecamper')),
                 collapse = '\n')

  xml2::xml_add_child(post,xml2::read_xml(glue::glue(tmpl)))
}

#' @importFrom xml2 xml_text
#' @importFrom httr content
get_attach_id <- function(res){
  xml2::xml_text(xml2::xml_child(httr::content(res),'.//id'))
}
