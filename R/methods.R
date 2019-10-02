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
