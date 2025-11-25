#' Get the height of the terminal window in pixels
#'
#' @return
#' An integer with the number of pixels the terminal is high. This value can be
#' zero when the terminal does not support querying the size.
#'
#' @seealso
#' \code{\link{term_width}} for the terminal width and \code{\link{term_dim}}
#' for all dimensions including the dimensions in rows and columns.
#'
#' @export
term_height <- function() {
  term_dim()[[2]]
}
