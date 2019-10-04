#' @export
#' @importFrom xml2 xml_text xml_find_all
print.basecamp_account <- function(x,...){

  name <- xml2::xml_text(xml2::xml_child(x,'.//name'))
  holder_id <- xml2::xml_text(xml2::xml_child(x,'.//account-holder-id'))

  print(glue::glue(
    '{name}','Account Holder ID: {holder_id}',.sep = '\n'
    )
  )

}

#' @export
print.basecamp_person_me <- function(x,...){

 class(x)[1] <- 'basecamp_person'
 print(x)

}

#' @export
print.basecamp_person_person <- function(x,...){

  class(x)[1] <- 'basecamp_person'
  print(x)

}

#' @export
#' @importFrom xml2 xml_child
#' @importFrom glue glue
print.basecamp_person_project <- function(x,...){

  for( i in seq_len(xml2::xml_length(x)) ){

    print(
      structure(
      xml2::xml_child(x,glue::glue('.//person[{i}]')),
      class = c("basecamp_person","xml_document","xml_node")
    )
    )

  }

}


#' @export
#' @importFrom xml2 xml_child
#' @importFrom glue glue
print.basecamp_person_company <- function(x,...){

  for( i in seq_len(xml2::xml_length(x)) ){

    print(
      structure(
        xml2::xml_child(x,glue::glue('.//person[{i}]')),
        class = c(glue::glue("basecamp_person"),"xml_document","xml_node")
      )
    )

  }

}

#' @export
#' @importFrom xml2 xml_text xml_find_all
#' @importFrom glue glue
print.basecamp_person <- function(x,...){

  person_id <- xml2::xml_text(xml2::xml_child(x,'.//id'))
  person_title <- xml2::xml_text(xml2::xml_child(x,'.//title'))

  person_name <- xml2::xml_text(xml2::xml_child(x,'.//user-name'))
  first_name <- xml2::xml_text(xml2::xml_child(x,'.//first-name'))
  last_name <- xml2::xml_text(xml2::xml_child(x,'.//last-name'))

  print(glue::glue(
    '{first_name} {last_name} {person_title}',
    'User Name: {person_name}',
    'User ID: {person_id}',
    '\n',
    .sep = '\n'
  )
  )

}

#' @export
#' @importFrom xml2 xml_child
#' @importFrom glue glue
print.basecamp_companies <- function(x,...){

  for( i in seq_len(xml2::xml_length(x)) ){

    print(
      structure(
        xml2::xml_child(x,glue::glue('.//company[{i}]')),
        class = c(glue::glue("basecamp_company"),"xml_document","xml_node")
      )
    )

  }

}

#' @export
#' @importFrom xml2 xml_text xml_find_all
#' @importFrom glue glue
print.basecamp_company <- function(x,...){

  company_id <- xml2::xml_text(xml2::xml_child(x,'.//id'))
  company_name <- xml2::xml_text(xml2::xml_child(x,'.//name'))

  print(glue::glue(
    '{company_name} (ID: {company_id})',
    '\n',
    .sep = '\n'
  )
  )

}

#' @export
#' @importFrom xml2 xml_text xml_find_all
print.basecamp_attachments <- function(x,...){

  print(xml2::xml_text(xml2::xml_find_all(x,'.//attachment/name')))

}

#' @export
#' @importFrom tibble tibble
#' @importFrom xml2 xml_text xml_find_all
print.basecamp_projects <- function(x,...){

  val <- xml2::xml_text(xml2::xml_find_all(x,'.//project/name'))

  names(val) <- xml2::xml_text(xml2::xml_find_all(x,'.//project/company/name'))

  print(val)

}

#' @export
#' @importFrom tibble tibble
#' @importFrom xml2 xml_text xml_find_all
print.basecamp_project <- function(x,...){

  created_on  <- xml2::xml_text(xml2::xml_find_all(x,'.//created-on'))
  id          <- xml2::xml_text(xml2::xml_find_all(x,'.//id'))
  last_change <- xml2::xml_text(xml2::xml_find_all(x,'.//last-changed-on'))
  name        <- xml2::xml_text(xml2::xml_find_all(x,'.//name'))
  status      <- xml2::xml_text(xml2::xml_find_all(x,'.//status'))
  company     <- xml2::xml_text(xml2::xml_find_all(x,'.//company/name'))

  print(glue::glue('{name[1]}',
             'ID: {id[1]}',
             'Status: {status}',
             'Company : {company}',
             'Create On: {created_on}',
             'Last Changed: {last_change}',.sep = '\n'))

}

#' @export
#' @importFrom xml2 xml_child
#' @importFrom glue glue
print.basecamp_category_project <- function(x,...){

  for( i in seq_len(xml2::xml_length(x)) ){

    print(
      structure(
        xml2::xml_child(x,glue::glue('.//category[{i}]')),
        class = c(glue::glue("basecamp_category"),"xml_document","xml_node")
      )
    )

  }

}

#' @export
#' @importFrom xml2 xml_child
#' @importFrom glue glue
print.basecamp_category <- function(x,...){

project <- xml2::xml_text(xml2::xml_child(x,'./project-id'))
count <- xml2::xml_text(xml2::xml_child(x,'./elements-count'))
name <- xml2::xml_text(xml2::xml_child(x,'./name'))
type <- xml2::xml_text(xml2::xml_child(x,'./type'))

if(count>0){

  print(glue::glue('Project: {project}',
                   'Type: {type}',
                   'Name: {name}',
                   'Count: {count}',
                   '\n',
                   .sep = '\n'))

}



}


#' @export
#' @importFrom tibble tibble
#' @importFrom xml2 xml_text xml_find_all
#' @importFrom fs as_fs_bytes
summary.basecamp_attachments <- function(object,...){

  tibble::tibble(
    filename = xml2::xml_text(xml2::xml_find_all(object,'.//attachment/name')),
    created_on = as.Date(xml2::xml_text(xml2::xml_find_all(object,'.//attachment/created-on'))),
    filesize = fs::as_fs_bytes(xml2::xml_text(xml2::xml_find_all(object,'.//attachment/byte-size'))),
    url = xml2::xml_text(xml2::xml_find_all(object,'.//attachment/download-url'))
  )

}

#' @export
#' @importFrom tibble tibble
#' @importFrom xml2 xml_text xml_find_all
summary.basecamp_projects <- function(object,...){

  tibble::tibble(
    company  = xml2::xml_text(xml2::xml_find_all(object,'.//project/company/name')),
    id = xml2::xml_text(xml2::xml_find_all(object,'.//project/id')),
    name = xml2::xml_text(xml2::xml_find_all(object,'.//project/name'))
  )

}

#' @export
#' @importFrom xml2 xml_child
#' @importFrom glue glue
summary.basecamp_companies <- function(object,...){

  tibble::tibble(
    name = trimws(xml2::xml_text(xml2::xml_find_all(object,'.//name'))),
    id = xml2::xml_text(xml2::xml_find_all(object,'.//id'))
  )


}

#' @export
#' @importFrom xml2 xml_child
#' @importFrom glue glue
summary.basecamp_category_project <- function(object,...){

  tibble::tibble(
    project = xml2::xml_text(xml2::xml_find_all(object,'./category/project-id')),
    count   = xml2::xml_text(xml2::xml_find_all(object,'./category/elements-count')),
    name    = xml2::xml_text(xml2::xml_find_all(object,'./category/name')),
    type    = xml2::xml_text(xml2::xml_find_all(object,'./category/type')),
  )

}
