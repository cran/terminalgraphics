#' Determine if we are running in a kitty terminal
#'
#' @return
#' Returns \code{TRUE} if R is running in a kitty terminal
#' and \code{FALSE} otherwise. 
#'
#' @examples
#' if (is_kitty()) {
#'   cat("Yeeh, you are running kitty!")
#' }
#'
#' @export
is_kitty <- function() {
  term <- Sys.getenv("TERM")
  term == "xterm-kitty"
}

