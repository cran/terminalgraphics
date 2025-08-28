#' Get the colors used in the terminal
#'
#' @return 
#' \code{term_background} and \code{term_foreground} will return a length 1
#' vector with a color. \code{term_palette} will return a vector of colors.
#'
#' @details
#' Getting the color palette used in the terminal is terminal specific.
#' Currently only the kitty terminal is supported. For other terminals default
#' colors are returned.
#'
#' @seealso
#' \code{\link{kitty_colors}} for the functions returning the specific colors
#' used in the kitty terminal.
#'
#' @examples
#' term_background()
#' 
#' @rdname term_colors
#' @export
term_background <- function() {
  if (is_kitty()) {
    kitty_background()
  } else {
    "white"
  }
}

#' @rdname term_colors
#' @export
term_foreground <- function() {
  if (is_kitty()) {
    kitty_foreground()
  } else {
    "black"
  }
}

#' @rdname term_colors
#' @export
term_palette <- function() {
  if (is_kitty()) {
    kitty_palette()
  } else {
    grDevices::hcl.colors("Dark2", n = 9)
  }
}

