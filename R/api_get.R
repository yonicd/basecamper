#' @title Basecamp Classic GET API wrappers
#' @description Query companies, people, projects, and attachments visible to the requesting user
#' @param id character, id relevant to the query
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
#' @rdname get_api
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
#' @rdname get_api
#' @export
basecamp_project <- function(id,
                             host = Sys.getenv('BASECAMP_HOST'),
                             token = Sys.getenv('BASECAMP_TOKEN')){

  get_query(
    query    = glue::glue('{host}/projects/{id}.xml'),
    token    = token,
    template = 'project'
  )

}

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

#' @importFrom glue glue
#' @rdname get_api
#' @export
basecamp_account <- function(host = Sys.getenv('BASECAMP_HOST'),
                             token = Sys.getenv('BASECAMP_TOKEN')){

  get_query(
    query    = glue::glue('{host}/account.xml'),
    token    = token,
    template = 'account'
  )

}

#' @importFrom glue glue
#' @rdname get_api
#' @export
basecamp_companies <- function(scope = c('companies','project','company'),
                             id = NULL,
                             host = Sys.getenv('BASECAMP_HOST'),
                             token = Sys.getenv('BASECAMP_TOKEN')){

  if(is.null(id)&scope%in%c('project','company')) stop(glue::glue('argument id must contain a {scope} id'))

  query <- switch(scope,
                  'companies' = glue::glue('{host}/companies.xml'),
                  'project' = glue::glue('{host}/projects/{id}/companies.xml'),
                  'company' = glue::glue('{host}/companies/{id}.xml')
  )

  get_query(
    query    = query,
    token    = token,
    template = ifelse(scope=='company',scope,'companies')
  )

}

#' @importFrom glue glue
#' @rdname get_api
#' @export
basecamp_people <- function(
  scope = c('me','person','project','company'),
  id = NULL,
  host = Sys.getenv('BASECAMP_HOST'),
  token = Sys.getenv('BASECAMP_TOKEN')){

  if(is.null(id)&scope!='me') stop(glue::glue('argument id must contain a {scope} id'))

  query <- switch(scope,
                  'me' = glue::glue('{host}/me.xml'),
                  'person' = glue::glue('{host}/people/{id}.xml'),
                  'project' = glue::glue('{host}/projects/{id}/people.xml'),
                  'company' = glue::glue('{host}/companies/{id}/people.xml')
                  )

  get_query(
    query    = query,
    token    = token,
    template = glue::glue('person_{scope}')
  )

}

#' @importFrom glue glue
#' @rdname get_api
#' @export
basecamp_categories <- function(scope = c('category','project'),
                                id = NULL,
                                host = Sys.getenv('BASECAMP_HOST'),
                                token = Sys.getenv('BASECAMP_TOKEN')){

  if(is.null(id)) stop(glue::glue('argument id must contain a {scope} id'))

  query <- switch(scope,
                  'category' = glue::glue('{host}/category/{id}.xml'),
                  'project' = glue::glue('{host}/projects/{id}/categories.xml')
  )

  get_query(
    query    = query,
    token    = token,
    template = ifelse(scope=='project','category_project',scope)
  )

}

#' @importFrom glue glue
#' @rdname get_api
#' @export
basecamp_messages <- function(scope = c('message','project'),
                              id = NULL,
                              host = Sys.getenv('BASECAMP_HOST'),
                              token = Sys.getenv('BASECAMP_TOKEN')){

  if(is.null(id)) stop(glue::glue('argument id must contain a {scope} id'))

  query <- switch(scope,
                  'message' = glue::glue('{host}/posts/{id}.xml'),
                  'project' = glue::glue('{host}/projects/{id}/posts.xml')
  )

  get_query(
    query    = query,
    token    = token,
    template = ifelse(scope=='project','message_project',scope)
  )

}

#' @importFrom glue glue
#' @importFrom httr GET authenticate stop_for_status headers
#' @rdname get_api
#' @export
new_comment <- function(
  body = 'Your comment',
  scope = c('posts', 'milestones', 'todo_items'),
  id = NULL,
  host = Sys.getenv('BASECAMP_HOST'),
  token = Sys.getenv('BASECAMP_TOKEN')){

  if(is.null(id)) stop(glue::glue('argument id must contain a {scope} id'))

  res <- httr::GET(
    glue::glue('{host}/{scope}/{id}/comments/new.xml'),
    httr::authenticate(token, 'X')
  )

  httr::stop_for_status(res)

  res_xml <- httr::content(res)
  xml2::xml_text(res_xml) <- 'my comment'

  POST_URL <- glue::glue(
    "{host}","{gsub('^POST ','',httr::headers(res)[['x-create-action']])}"
  )

  structure(res_xml, POST_URL = POST_URL)

}

#' @importFrom glue glue
#' @importFrom httr GET authenticate stop_for_status headers
#' @rdname get_api
#' @export
edit_comment <- function(
  host = Sys.getenv('BASECAMP_HOST'),
  token = Sys.getenv('BASECAMP_TOKEN')){

  if(is.null(id)) stop(glue::glue('argument id must contain a comment id'))

  res <- httr::GET(
    glue::glue('{host}/comments/{id}/edit.xml'),
    httr::authenticate(token, 'X')
  )

  httr::stop_for_status(res)

  res_xml <- httr::content(res)

  POST_URL <- glue::glue(
    "{host}","{gsub('^POST ','',httr::headers(res)[['x-update-action']])}"
  )

  structure(res_xml, POST_URL = POST_URL)

}

#' @importFrom glue glue
#' @importFrom httr GET authenticate stop_for_status content
get_query <- function(query, template, token = Sys.getenv('BASECAMP_TOKEN')){

  res <- httr::GET( query, httr::authenticate(token, 'X'))

  httr::stop_for_status(res)

  structure(
    httr::content(res),
    class = c(glue::glue("basecamp_{template}"),"xml_document","xml_node")
  )

}
