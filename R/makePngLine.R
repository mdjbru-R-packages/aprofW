#' Make a small embedded png line from a numerical value
#'
#' @param value numerical value to draw
#' @param xmax maximum possible value (for scale)
#' @param alt alternative text for the image html code
#' @return A string with the embedded image, ready to be inserted in an html
#'   document

makePngLine = function(value, xmax, alt = "") {
    ## http://www.inside-r.org/packages/cran/base64/docs/img
    pngfile = tempfile()
    png(pngfile, width = 300, height = 20, bg = "transparent")
    par(mar = rep(0, 4))
    plot(0, 0, type = "n", bty = "n", axes = F, xlab = "", ylab = "",
         xlim = c(0, xmax), ylim = c(0, 1))
    lines(c(0, value), rep(0.5, 2), lwd = 6, col = "cornflowerblue")
    dev.off()
    return(base64::img(pngfile, alt = alt))
}
