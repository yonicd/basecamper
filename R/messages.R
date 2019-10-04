#' @title View Messages
#' @description FUNCTION_DESCRIPTION
#' @param x View Message in Viewer
#' @param head PARAM_DESCRIPTION, Default: 1
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


#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param x PARAM_DESCRIPTION
#' @param head PARAM_DESCRIPTION, Default: 1
#' @param file PARAM_DESCRIPTION, Default: ''
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
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
message_to_html <- function(x,head = 1, file = ''){

  if(!nzchar(file))
    file <- tempfile(fileext = '.html')

  for(i in seq_len(pmin(head,xml2::xml_length(x)))){

    message_object <- xml2::xml_child(x,glue::glue('.//post[{i}]'))

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
