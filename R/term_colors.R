#' Get the colors used in the terminal
#'
#' @return 
#' \code{term_background} and \code{term_foreground} will return a length 1
#' vector with a color. \code{term_palette} will return a vector of colors.
#'
#' @details
#' Getting the color palette used in the terminal is terminal specific.
#' Currently only the kitty terminal is supported. For other terminals default
#' colors are returned. Unless set using \code{\link{options}} (see below).
#'
#' When the option \code{term_background} is set, that is returned by 
#' \code{term_background()}. The same with the options \code{term_foreground}
#' and \code{term_palette} by \code{term_foreground()} and \code{term_palette()}
#' respectively.
#'
#' @seealso
#' \code{\link{kitty_colors}} for the functions returning the specific colors
#' used in the kitty terminal. Also see \code{\link{term_color_mode}} which is
#' used to determine the color mode.
#'
#' @examples
#' term_background()
#'
#' options(term_background = "black", term_foreground = "white", 
#'   term_palette = grDevices::hcl.colors("Pastel1", n = 9),
#'   term_col = TRUE)
#' # term_col enables automatic use of the colors by tgp() and sixel()
#' 
#' @rdname term_colors
#' @export
term_background <- function() {
  background <- getOption("term_background")
  if (is.null(background)) {
    background <- if (is_kitty()) {
      kitty_background()
    } else if (isTRUE(all.equal(term_color_mode(), "dark"))) {
      "#333333"
    } else {
      "white"
    }
    options(term_background = background)
  }
  background
}

#' @rdname term_colors
#' @export
term_foreground <- function() {
  foreground <- getOption("term_foreground")
  if (is.null(foreground)) {
    foreground <- if (is_kitty()) {
      kitty_foreground()
    } else if (isTRUE(all.equal(term_color_mode(), "dark"))) {
      "white"
    } else {
      "black"
    }
    options(term_foreground = foreground)
  }
  foreground
}

#' @rdname term_colors
#' @export
term_palette <- function() {
  palette <- getOption("term_palette")
  if (is.null(palette)) {
    palette <- if (is_kitty()) {
      kitty_palette()
    } else if (isTRUE(all.equal(term_color_mode(), "dark"))) {
      grDevices::hcl.colors("Dark2", n = 9)
    } else {
      grDevices::hcl.colors("Dark2", n = 9)
    }
    options(palette = term_palette)
  }
  palette
}

