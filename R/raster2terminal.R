#' Dump an image raster to the terminal 
#'
#' @param raster the image 'raster' e.g. the output of \code{\link{as.raster}}.
#'
#' @param method method with which the graphical output is written to the
#' terminal. In case of 'auto', it is first checked if the Terminal Graphics
#' Protocol is supported and if so, this is used. Otherwise, Sixel is used.
#'
#' @param ... passed on to the underlying method such as
#' \code{\link{raster2tgp}} and \code{\link{raster2sixel}}.
#'
#' @return
#' Called for it's side effect of writing the image to the terminal (standard
#' out). Returns \code{NULL} invisibly.
#'
#' @seealso
#' See \code{\link{raster2tgp}} for output in Terminal Graphics Protocol.  See
#' \code{\link{raster2sixel}} for output in Sixel format. 
#'
#' @export
raster2terminal <- function(raster, method = c("auto", "tgp", "sixel"), ...) {
  method <- match.arg(method)
  if (method == "auto") {
     method <- if (has_tgp_support()) "tgp" else "sixel"
  }
  if (method == "tgp") {
    raster2tgp(raster, ...)
  } else if (method == "sixel") {
    raster2sixel(raster)
  }
}

