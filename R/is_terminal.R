#' Determine the type of terminal
#'
#' @details
#' These functions try to detect if R is running in a given terminal. 
#'
#' @return
#' Returns \code{TRUE} if R is running in a given terminal
#' and \code{FALSE} otherwise.
#'
#' @examples
#' if (is_kitty()) {
#'   cat("Yeeh, you are running kitty!")
#' }
#' if (is_ghostty()) {
#'   cat("Yeeh, you are running ghostty!")
#' }
#'
#' @rdname is_terminal
#' @export
is_kitty <- function() {
  term <- Sys.getenv("TERM")
  term == "xterm-kitty"
}

#' @rdname is_terminal
#' @export
is_ghostty <- function() {
  term <- Sys.getenv("TERM")
  term == "xterm-ghostty"
}
