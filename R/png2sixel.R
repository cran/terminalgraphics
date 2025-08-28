#' Dump a PNG image to the terminal in Sixel format
#'
#' @param filename filename of the PNG image
#'
#' @return
#' Called for it's side effect of writing the image to the terminal (standard
#' out). Returns \code{NULL} invisibly.
#'
#' @export
png2sixel <- function(filename) {
  warn_sixel_support()
  if (!requireNamespace("magick", quietly = TRUE)) 
    stop("The magick package needs to be installed for sixel output.")
  img <- magick::image_read(filename)
  fn <- tempfile()
  on.exit(file.remove(fn))
  magick::image_write(img, format = "sixel", path = fn)
  readChar(fn, nchars = file.size(fn)) |> paste0("\n") |> cat()
}

