#' Light wrapper around the aprof function to profile one function
#'
#' @param expr Expression to profile
#' @param FUN The name of the function to profile, as a string (e.g. "f")
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
#' # Another function calling f
#' g = function(x) {
#'   print(x + x)
#'   output = f(100, 100)
#'   return(output)
#' }
#' 
#' # Profiling:
#' ## f is run
#' prof = aprofFun(f(100, 100), "f")
#' viewProfHtml(prof)
#' ## g is run, profiling either "g" or "f"
#' prof = aprofFun(g(10), "g")
#' viewProfHtml(prof)
#' prof = aprofFun(g(10), "f")
#' viewProfHtml(prof)
#' 
#' @export

aprofFun = function(expr, FUN) {
    sourceTmp = tempfile()
    dump(FUN, sourceTmp)
    prof = aprofW::aprofWrapper(expr, sourceTmp)
    return(prof)
}
