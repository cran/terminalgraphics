#' Get the dimensions of the terminal window in pixels
#'
#' @return
#' An integer vector with the width and height of the terminal in pixels
#' (\code{x_pixels} and \code{y_pixels}) and the number of text columns and rows
#' in the terminal window (\code{columns} and \code{rows}).
#' 
#' These values can be zero when the terminal does not support querying the
#' size. Some terminals only support querying the number of columns and rows.
#' Under windows the return value will always be zero as querying the size
#' depends on POSIX support.
#'
#' @seealso
#' \code{\link{term_width}} and \code{\link{term_height}} for only obtaining
#' the width and height in pixels respectively.
#'
#' @export
term_dim <- function() {
  dim <- screen_dim_cpp()
  names(dim) <- c("x_pixels", "y_pixels", "columns", "rows")
  dim
}

