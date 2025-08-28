
#' Get the colors used in the kitty terminal
#'
#' @details
#' To get the background and foreground colors, \code{kitten query-terminal} is
#' called. To get all colors and the palette \code{kitty @get-colors} is called
#' using \code{\link{system}}. However, for the last to work
#' \code{allow_remote_control} needs to be set to \code{true} in the config
#' file for kitty.
#' 
#' @return
#' \code{kitty_colors} returns a data.frame with the colors from the theme used
#' by kitty. \code{kitty_background} returns the background color (character
#' vector with the hex-code). \code{kitty_foreground} returns the foreground
#' color. \code{kitty_palette} returns a vector with the 9 main accent colors
#' from the theme.
#'
#' @seealso
#' \code{\link{term_background}}, \code{\link{term_foreground}},
#' \code{\link{term_palette}} for functions that try to return the colors used
#' in any terminal. When running in kitty, these will call
#' \code{kitty_background} etc.
#'
#' @examples
#' if (is_kitty()) {
#'   cat("The background color is '", kitty_background(), "'.")
#' }
#'
#' @rdname kitty_colors
#' @export
kitty_colors <- function() {
  colors <- getOption("kitty_colors")
  if (is.null(colors)) {
    if (!is_kitty()) 
      stop("Your terminal does not seem to be 'kitty'.")
    colors <- system("kitty @get-colors", intern = TRUE)
    colors <- utils::read.table(textConnection(colors), 
      comment = "", header = FALSE)
    names(colors) <- c("name", "value")
    options(kitty_colors = colors)
  }
  colors
}


#' @export
#' @rdname kitty_colors
kitty_background <- function() {
  background <- getOption("kitty_background")
  if (is.null(background)) {
    if (!is_kitty()) 
      stop("Your terminal does not seem to be 'kitty'.")
    background <- system("kitten query-terminal background", intern = TRUE)
    background <- gsub("background: ", "", background)
    options(kitty_background = background)
  }
  background
}

#' @export
#' @rdname kitty_colors
kitty_foreground <- function() {
  foreground <- getOption("kitty_foreground")
  if (is.null(foreground)) {
    if (!is_kitty()) 
      stop("Your terminal does not seem to be 'kitty'.")
    foreground <- system("kitten query-terminal foreground", intern = TRUE)
    foreground <- gsub("foreground: ", "", foreground)
    options(kitty_foreground = foreground)
  }
  foreground
}

#' @export
#' @rdname kitty_colors
kitty_palette <- function() {
  colors <- kitty_colors()
  colors$value[colors$name %in% paste0("color", 1:9)]
}

