#' Get the with of the terminal window in pixels
#'
#' @return
#' An integer with the number of pixels the terminal is wide This value can be
#' zero when the terminal does not support querying the size. Under windows the
#' return value will always be zero as querying the size depends on POSIX
#' support.
#'
#' @seealso
#' \code{\link{term_height}} for the terminal height and \code{\link{term_dim}}
#' for all dimensions including the dimensions in rows and columns.
#'
#' @export
term_width <- function() {
  term_dim()[[1]]
}
