#' Main function to view an aprof object as an html page
#'
#' @param prof aprof object
#'
#' @export

viewProfHtml = function(prof) {
    tmpHtml = tempfile()
    convertAprofToHtml(prof, tmpHtml)
    browseURL(tmpHtml)
}
