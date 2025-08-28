#' Dump an image raster to the terminal in Sixel format
#'
#' @param raster the image 'raster' e.g. the output of \code{\link{as.raster}}.
#'
#' @details
#' Sixel is a bitmap format supported by some terminals. See, for example, 
#' \url{https://en.wikipedia.org/wiki/Sixel}.
#'
#' @return
#' Called for it's side effect of writing the image to the terminal (standard
#' out). Returns \code{NULL} invisibly.
#'
#' @seealso
#' See \code{\link{raster2tgp}} for output using Terminal Graphics Protocol.
#'
#' @export
raster2sixel <- function(raster) {
  warn_sixel_support()
  if (!requireNamespace("magick", quietly = TRUE)) 
    stop("The magick package needs to be installed for sixel output.")
  img <- magick::image_read(raster)
  fn <- tempfile()
  on.exit(file.remove(fn))
  magick::image_write(img, format = "sixel", path = fn)
  readChar(fn, nchars = file.size(fn)) |> paste0("\n") |> cat()
}

