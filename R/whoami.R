#' @title whoami function for Basecamp
#' @description Query basic personal information for Basecamp account
#' @param host character, URL of the team, Default: Sys.getenv('BASECAMP_HOST')
#' @param token character, Basecamp Classic API token , Default: Sys.getenv("BASECAMP_TOKEN")
#' @return xml_document
#' @export
whoami <- function(host = Sys.getenv('BASECAMP_HOST'),
                   token = Sys.getenv('BASECAMP_TOKEN')){


  if(!exists('me',envir = benv)){

    res <- basecamp_people('me',host = host,token = token)
    assign(x = 'me',res,envir = benv)

  }

  get('me',envir = benv)

}
