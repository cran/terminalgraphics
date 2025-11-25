#' Get the color mode of the terminal
#'
#' @details
#' Uses ANSI \code{SI ? 996 n} to determine the color mode. See
#' \url{https://contour-terminal.org/vt-extensions/color-palette-update-notifications/}.
#' 
#' @return
#' Returns \code{NA} when the terminal does not support querying the color 
#' mode. Otherwise returns either 'dark' or 'light'. 
#'
#' @examples
#' term_color_mode()
#'
#' @export
term_color_mode <- function() {
  dsr <- if (is_ghostty()) FALSE else TRUE
  query_color_mode(dsr)
}


query_color_mode <- local({
  color_mode <- NULL
  function(dsr = TRUE) {
    if (is.null(color_mode)) {
      color_mode <<- term_color_mode_rcpp(dsr)
    }
    color_mode
  }
})

