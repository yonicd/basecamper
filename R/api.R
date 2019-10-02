#' @title Basecamp Classic API wrappers
#' @description Query projects, project and attachments in a project
#' @param project character, Basecamp project id
#' @param host character, URL of the team, Default: Sys.getenv('BASECAMP_HOST')
#' @param token character, Basecamp Classic API token , Default: Sys.getenv("BASECAMP_TOKEN")
#' @return xml_document
#' @details A host url is from the following template: https://\{teamname\}.basecamphq.com
#' @examples
#' \dontrun{
#' if(interactive()){
#'
#'  (projects <- basecamp_projects())
#'
#'  (summary_projects <- summary(projects))
#'
#'  basecamp_project(summary_projects$id[1])
#'
#'  (project_attachments <- basecamp_attachments(summary_projects$id[1]))
#'
#'  summary(project_attachments)
#'
#'  }
#' }
#' @rdname api
#' @export
#' @importFrom glue glue
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
basecamp_attachments <- function(project,
                                host = Sys.getenv('BASECAMP_HOST'),
                                token = Sys.getenv('BASECAMP_TOKEN')){

  get_query(
    query    = glue::glue('{host}/projects/{project}/attachments.xml'),
    token    = token,
    template = 'attachments'
  )

}

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
