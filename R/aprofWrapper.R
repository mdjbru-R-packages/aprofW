#' Light wrapper around the aprof function
#'
#' @param expr Expression to profile
#' @param sourceFile The file with the source code to be profiled
#' @return An aprof object
#'
#' @examples
#' # The function to profile
#' f = function(n, sim) {
#'   # Simulate some data
#'   x = rnorm(n, mean = 0, sd = 2)
#'   t = data.frame(x)
#'   for (i in 1:sim) {
#'    y = x + rnorm(x, mean = 0, sd = 0.5)
#'     t = cbind(t, y)
#'   }
#'   return(t)
#' }
#' 
#' # Dump the function to a tmp file
#' mySourceFile = tempfile()
#' dump("f", file = mySourceFile)
#'
#' # Profile
#' prof = aprofWrapper(f(100, 100), mySourceFile)
#' # Visualise
#' viewProfHtml(prof)
#' 
#' @export
                                        

aprofWrapper = function(expr, sourceFile) {
    if (sourceFile != "") {
        source(sourceFile)
    }
    rprofTmp = tempfile()
    Rprof(file = rprofTmp, interval = 0.001, line.profiling = TRUE)
    eval(parse(text = expr))
    Rprof(NULL)
    prof = aprof::aprof(src = sourceFile, rprofTmp)
    return(prof)
}
