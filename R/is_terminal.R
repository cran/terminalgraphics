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
  Sys.getenv("TERM") == "xterm-kitty" || 
    nchar(Sys.getenv("KITTY_PID")) > 0
}

#' @rdname is_terminal
#' @export
is_ghostty <- function() {
  term <- Sys.getenv("TERM")
  term == "xterm-ghostty"
}

#' @rdname is_terminal
#' @export
is_nvim <- function() {
  nvim <- Sys.getenv("NVIM")
  nchar(nvim) > 0
}

#' @rdname is_terminal
#' @export
is_vim <- function() {
  vim <- Sys.getenv("VIM_TERMINAL")
  nchar(vim) > 0
}


#' @rdname is_terminal
#' @export
is_tmux <- function() {
  nchar(Sys.getenv("TMUX")) > 0 ||
    Sys.getenv("TERM_PROGRAM") == "tmux" ||
    grepl("tmux", Sys.getenv("TERM"), fixed = TRUE)
}



