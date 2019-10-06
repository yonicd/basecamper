#' @importFrom glue glue
#' @importFrom httr GET authenticate stop_for_status headers
#' @rdname get_api
#' @export
create_message <- function(id = NULL,
                           host = Sys.getenv('BASECAMP_HOST'),
                           token = Sys.getenv('BASECAMP_TOKEN')){

  if(is.null(id)) stop('argument id must contain a project id')

  res <- httr::GET(
    glue::glue('{host}/projects/{id}/posts/new.xml'),
    httr::authenticate(token, 'X')
  )

  httr::stop_for_status(res)

  res_xml <- httr::content(res)

  POST_URL <- glue::glue(
    "{host}","{gsub('^POST ','',httr::headers(res)[['x-create-action']])}"
  )

  structure(res_xml, POST_URL = POST_URL)

}

#' @importFrom glue glue
#' @importFrom httr GET authenticate stop_for_status headers
#' @rdname get_api
#' @export
create_comment <- function(
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

#' @importFrom xml2 xml_child xml_text<-
edit_attr <- function(object,field,val){

  val <- switch(class(val),
                  'character' = val,
                  'logical'   = tolower(as.character(val)),
                  'numeric'   = as.character(val)
                  )

  message_attr <- xml2::xml_child(object,glue::glue('.//{field}'))
  xml2::xml_text(message_attr) <- val

  object

}


#' @title Edit a Basecamp Post
#' @description Edit post object fields
#' @param object post object
#' @param value new value to replace with
#' @return post object
#' @rdname edit_post
#' @export
edit_title <- function(object, value){

  edit_attr(object,'title',value)

}

#' @export
#' @rdname edit_post
edit_body <- function(object, value){

  edit_attr(object,'body',value)

}

#' @export
#' @rdname edit_post
edit_category_id <- function(object, value){

  edit_attr(object,'category-id',value)

}

#' @export
#' @rdname edit_post
edit_milestone_id <- function(object, value){

  edit_attr(object,'milestone-id',value)

}

#' @export
#' @rdname edit_post
edit_privacy <- function(object, value){

  edit_attr(object,'private',value)

}


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

