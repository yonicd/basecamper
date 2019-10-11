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

  structure(res_xml,
            POST_URL = POST_URL,
            PROJECT_ID = id)

}

#' @title Post a message
#' @description Post a message to Basecamp
#' @param message object created by [new_message][basecamper::create_message]
#' @param token character, Basecamp Classic API token , Default: Sys.getenv("BASECAMP_TOKEN")
#' @return [response][httr::response]
#' @rdname post_message
#' @export
#' @importFrom httr POST authenticate content_type stop_for_status
post_message <- function(message,
                         token = Sys.getenv('BASECAMP_TOKEN')){

  res <- httr::POST(
    url  = attr(message,"POST_URL"),
    body = as.character(message),
    httr::authenticate(token, 'X'),
    httr::content_type("text/xml")
  )

  httr::stop_for_status(res)

  res

}


#' @title View Messages
#' @description FUNCTION_DESCRIPTION
#' @param file path to file to view
#' @param viewer PARAM_DESCRIPTION, Default: getOption("viewer")
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname view_messages
#' @export

view_messages <- function(file, viewer = getOption("viewer")){

  viewer(file)

}


#' @title Convert message content to HTML
#' @description Uses the message ID in the message object to query the comments
#'   associated with it and
#' @param message message object returned by [basecamper][basecamper::basecamp_message]
#' @param index numeric, indicies of comments to query (1 is earliest), Default: 1
#' @param file character, path to save the HTML output, Default: ''
#' @return filepath to the html created
#' @details if file is '' then a tmepfile will be written created and written to.
#' @examples
#' \dontrun{
#' if(interactive()){
#'
#'  project_messages <- basecamper::basecamp_messages('project','14542533')
#'
#'  x <- message_to_html(project_messages)
#'
#'  view_messages(x)
#'
#'  }
#' }
#' @rdname message_to_html
#' @export
#' @importFrom xml2 xml_length xml_child xml_text xml_double
#' @importFrom glue glue
message_to_html <- function(message,index = 1, file = ''){

  if(!nzchar(file))
    file <- tempfile(fileext = '.html')

  msg_vec <- rev(seq_len(xml2::xml_length(message)))

  index <- msg_vec[index[index <= xml2::xml_length(message)]]

  for(i in seq_along(index)){

    message_object <- xml2::xml_child(message,glue::glue('.//post[{index[i]}]'))

    message_id <- xml2::xml_text(xml2::xml_child(message_object,'.//id'))

    message_comment_count <- xml2::xml_double(xml2::xml_child(message_object,'.//comments-count'))

    message_comments <- get_query(
      query    = glue::glue('{Sys.getenv("BASECAMP_HOST")}/posts/{message_id}/comments.xml'),
      token    = Sys.getenv('BASECAMP_TOKEN'),
      template = 'comments'
    )

    message_body <- xml2::xml_text(xml2::xml_child(message_object,'.//display-body'))

    message_author <- xml2::xml_text(xml2::xml_child(message_object,'.//author-name'))
    message_title <- xml2::xml_text(xml2::xml_child(message_object,'.//title'))
    message_date <- xml2::xml_text(xml2::xml_child(message_object,'.//posted-on'))
    message_summary <- glue::glue('{message_date}:{message_author}:{message_title}')
    cat(glue::glue('<br><details><summary>{message_summary}</summary>{message_body}</details><br>'),file=file,append = TRUE)
    J <- xml2::xml_length(message_comments)
    for(j in seq_len(J)){

      this_comment <- xml2::xml_child(message_comments,glue::glue('.//comment[{j}]'))
      comment_body <- xml2::xml_text(xml2::xml_child( this_comment,'.//body'))
      comment_author <- xml2::xml_text(xml2::xml_child( this_comment,'.//author-name'))
      comment_date <- xml2::xml_text(xml2::xml_child( this_comment,'.//created-at'))
      comment_summary <- glue::glue('{comment_date}:{comment_author}')
      if(j==1){
        cat('<ul>',file=file,append = TRUE)
      }
      cat(glue::glue('<li><details><summary>{comment_summary}</summary>{comment_body}</details></li>'),file=file,append = TRUE)
      if(j==J){
        cat('</ul>',file=file,append = TRUE)
      }
    }

  }

  structure(file,class = c('basecamp_message','character'))

}


#' @export
#' @rdname edit_post
private_message <- function(object){

  edit_attr(object,'private',TRUE)

}

#' @export
#' @rdname edit_post
public_message <- function(object){

  edit_attr(object,'private',FALSE)

}
