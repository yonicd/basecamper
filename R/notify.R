#' @importFrom glue glue
#' @importFrom xml2 read_xml
create_recipients <- function(person){

  if(inherits(person,'character')){
    stop('Use find_person() to convert name to Basecamp id')
  }

  ret <- glue::glue('<notifications>',
                      paste0(glue::glue('<notify>{person}</notify>'),
                             collapse="\n"),
                      '</notifications>',.sep = '\n')

  structure(xml2::read_xml(ret),class = c('basecamp_recipients',"xml_document","xml_node"))

}

#' @title Add Recipients to a Message
#' @description Add recipients to a message
#' @param post post containing message to add recipients
#' @param recipients xml created by create_recipients
#' @return character
#' @rdname add_recipients
#' @export
#' @importFrom xml2 xml_children
add_recipients <- function(post, recipients){

  xml_recipients <- xml_children(create_recipients(recipients))

  xml2::xml_add_child(post,xml_recipients)

}

