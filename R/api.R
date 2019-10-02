#' @importFrom xml2 read_xml
#' @importFrom glue glue
get_query <- function(query, template, token = Sys.getenv('BASECAMP_TOKEN')){

  tf <- tempfile(fileext = '.xml')
  on.exit(unlink(tf),add = TRUE)

  system(glue::glue('curl -u {token}:X -L --output {tf} {query}'))

  structure(
    xml2::read_xml(tf),
    class = c(glue::glue("basecamp_{template}"),"xml_document","xml_node")
  )

}


#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param project PARAM_DESCRIPTION
#' @param host PARAM_DESCRIPTION
#' @param token PARAM_DESCRIPTION
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname api
#' @export
#' @importFrom glue glue
basecamp_project <- function(project,
                             host = Sys.getenv('BASECAMP_HOST'),
                             token = Sys.getenv('BASECAMP_TOKEN')){

  get_query(
    query    = glue::glue('{host}/projects/{project}.xml'),
    token    = token,
    template = 'project'
  )

}

#' @importFrom glue glue
#' @rdname api
#' @export
basecamp_projects <- function(host = Sys.getenv('BASECAMP_HOST'),
                              token = Sys.getenv('BASECAMP_TOKEN')){

  get_query(
    query    = glue::glue('{host}/projects.xml'),
    token    = token,
    template = 'projects'
  )

}

#' @importFrom glue glue
#' @rdname api
#' @export
basecamp_attachment <- function(project,
                                host = Sys.getenv('BASECAMP_HOST'),
                                token = Sys.getenv('BASECAMP_TOKEN')){

  get_query(
    query    = glue::glue('{host}/projects/{project}/attachments.xml'),
    token    = token,
    template = 'attachment'
  )

}
