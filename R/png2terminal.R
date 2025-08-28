#' Dump a PNG image to the terminal 
#'
#' @param filename filename of the PNG image
#'
#' @param method method with which the graphical output is written to the
#' terminal. In case of 'auto', it is first checked if the Terminal Graphics
#' Protocol is supported and if so, this is used. Otherwise, Sixel is used.
#'
#' @return
#' Called for it's side effect of writing the image to the terminal (standard
#' out). Returns \code{NULL} invisibly.
#'
#' @seealso
#' See \code{\link{png2tgp}} for output in Terminal Graphics Protocol.  See
#' \code{\link{png2sixel}} for output in Sixel format. 
#'
#' @export
png2terminal <- function(filename, method = c("auto", "tgp", "sixel")) {
  method <- match.arg(method)
  if (method == "auto") {
     method <- if (has_tgp_support()) "tgp" else "sixel"
  }
  if (method == "tgp") {
    png2tgp(filename)
  } else if (method == "sixel") {
    png2sixel(filename)
  }
}

