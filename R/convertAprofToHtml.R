#' Convert an aprof object into an html output
#'
#' @param prof aprof object
#' @param htmlFile string, path to the output file
#'

convertAprofToHtml = function(prof, htmlFile) {
    ## Get the source code
    sourceFile = prof$sourcefile
    sourceCode = readLines(sourceFile)
    sourceParser = highlight::highlight(sourceFile,
                                        renderer = highlight::renderer_html(F),
                                        output = NULL)
    stopifnot(length(sourceParser) == (length(sourceCode) + 2))
    sourceParser = sourceParser[2: (length(sourceParser) - 1)]
    ## Get time density
    lineDensity = aprof::readLineDensity(prof)
    timeDensity = data.frame(line = lineDensity[["Line.Numbers"]],
                             time = lineDensity[["Time.Density"]])
    timeMax = max(timeDensity$time)
    ## Fill in zero time
    nLines = length(sourceCode)
    allLines = 1:nLines
    missingLines = allLines[!allLines %in% timeDensity$line]
    missingTime = data.frame(line = missingLines, time = 0)
    timeDensity = rbind(timeDensity, missingTime)
    timeDensity = timeDensity[order(timeDensity$line), ]
    ## Make html output
    html = file(htmlFile, "w")
    w = function(text) {
        writeLines(text, html)
    }
    w("<!DOCTYPE html>")
    w("<html>")
    w("<title>")
    w(paste0("Aprof ", sourceFile))
    w("</title>")
    ## CSS
    w("<head>")
    w("<style>")
    w(".lineNumber {text-align: center; min-width: 70px;}")
    w(".lineNumber {font-size: 12px;}")
    w("body {font-family: sans-serif;}")
    w("h1 {text-align: center;}")
    w("table {border: 1px solid black; margin-left: auto; margin-right: auto;}")
    w("tr {line-height: 0;}")
    w("th {background: #dddddd; height: 40px;}")
    w("tr:nth-child(even) {background: #efefef}")
    w("tr:nth-child(odd) {background: #fdfdfd}")
    w("pre {padding-left: 10px;}")
    ## Highlight
    w("pre .comment {color: green; font-weight: bold;}")
    w("pre .symbol {color: purple; font-weight: bold;}")
    w("pre .functioncall {color: blue; font-weight: bold;}")
    w("pre .keyword {color: salmon; font-weight: bold;}")
    w("pre .string {color: darkgreen; font-weight: normal;}")
    w("pre .number {color: grey; font-weight: normal;}")

    w("</style>")
    w("</head>")
    w("<body>")
    w(paste0("<h1>Profiling results for ", sourceFile, "</h1>"))
    w("<table class=\"profileTable\">")
    ## Headers
    w("<tr><th>Line</th><th>Code</th><th>Execution time</th></tr>")
    ## Profile
    for (i in 1:nrow(timeDensity)) {
        text = paste0("<tr><td class=\"lineNumber\">", as.character(i), "</td>")
        text = paste0(text, "<td class=\"sourceCode\"><code><pre>",
                      sourceParser[i], "</pre></code></td>")
        text = paste0(text, "<td class=\"executionTime\">",
                      makePngLine(timeDensity$time[i], timeMax), "</td></tr>")
        w(text)
    }
    ## End
    w("</table>")
    w("</body>")
    w("</html>")
    close(html)
}
