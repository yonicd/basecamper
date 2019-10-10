
#' @importFrom glue glue
#' @rdname get_api
#' @export
basecamp_people <- function(
  scope = c('person', 'project', 'company', 'me', 'people'),
  id = NULL,
  host = Sys.getenv('BASECAMP_HOST'),
  token = Sys.getenv('BASECAMP_TOKEN')){

  if(is.null(id)&!scope%in%c('me','people')){

    stop(glue::glue('argument id must contain a {scope} id'))

  }

  query <- switch(scope,
                  'me'       = glue::glue('{host}/me.xml'),
                  'person'   = glue::glue('{host}/people/{id}.xml'),
                  'project'  = glue::glue('{host}/projects/{id}/people.xml'),
                  'company'  = glue::glue('{host}/companies/{id}/people.xml'),
                  'people' = glue::glue('{host}/people.xml')
  )

  if(scope=='people'&exists('people',envir = benv)){
    return(get('people',envir = benv))
  }

  res <- get_query(
    query    = query,
    token    = token,
    template = 'person'
  )

  if(scope=='people'){
    assign(x = 'people',res,envir = benv)
  }

  res
}

#' @title Find a person
#' @description Find a person in Basecamp
#' @param ... character, patterns to search for
#' @param scope character, scope of the request
#' @param id character, id relevant to the query
#' @param host character, URL of the team, Default: Sys.getenv('BASECAMP_HOST')
#' @param token character, Basecamp Classic API token , Default: Sys.getenv("BASECAMP_TOKEN")
#' @return named numeric vector
#' @details If the index of people is not loaded in the package yet, it will be
#'  queried and stored in an internal package environment.
#' @rdname find_person
#' @export

find_person <- function(..., scope = 'people', id = NULL,
                        host = Sys.getenv('BASECAMP_HOST'),
                        token = Sys.getenv('BASECAMP_TOKEN')){

  x <- summary(basecamp_people(scope = scope, id = id, host = host, token = token))

  dots <- c(...)

  if(!length(dots))
    return(NULL)

  idx <- lapply(dots,function(p){
    str_ret <- grep(p,x =  x$name)
    if(!length(str_ret))
      warning(glue::glue("No Results for '{p}'"))
    str_ret
  })

  idx <- unique(unlist(idx))

  ret <- x$id[idx]
  names(ret) <- x$name[idx]

  ret

}

whoarewe <- function(person){

  summary(whoami())[['company']]

}
