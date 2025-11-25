#' Determine if terminal supports Terminal Graphics Protocol
#'
#' @param warn show warnings when the protocol is not supported.
#'
#' @param throw throw an error when we are running in a kitty terminal.
#'
#' @return
#' Returns \code{TRUE} if the current terminal supports the Terminal Graphics
#' Protocol and \code{FALSE} otherwise. Will also return \code{FALSE} when not
#' running in a terminal.
#'
#' @examples
#' if (has_tgp_support()) {
#'   cat("Yeeh, your terminal supports the terminal graphics protocol!")
#' }
#'
#' @export
has_tgp_support <- function(warn = FALSE, throw = FALSE) {
  # Check if the terminal reports its dimensions in pixels; if not we don't
  # want to support it.
  dim <- term_dim()
  if ( length(dim) < 4 || is.na(dim[3]) || dim[3] == 0 || 
       is.na(dim[4]) || dim[4] == 0) {
    if (warn) warning("Terminal does not report its size in pixels.")
    return(FALSE)
  }
  # Send query for support
  supported <- !is.na(query_tgp_support())
  if (!supported) {
    if (warn) {
      warning("Terminal does not report supporting terminal graphics protocol")
      if (tmux() && !tmux_passthrough()) 
        warning("Allow-passthrough is not enabled in tmux.")
    }
    return(FALSE)
  }
  TRUE
}

query_tgp_support <- local({
  support <- NULL
  function() {
    if (is.null(support)) {
      if (tmux() && !tmux_passthrough()) {
        #warning("Passthrough is not enabled in tmux;", 
          #" terminal graphics protocol is not supported.")
        support <<- NA
      } else {
        support <<- query_tgp_support_rcpp()
      }
    }
    support
  }
})

warn_tgp_support <- function() {
  warned <- getOption("warned_tgp_support", FALSE)
  if (!warned) {
    if (!has_tgp_support(warn = TRUE)) {
      options("warned_tgp_support" = TRUE)
      warning("This warning is only shown once.")
    }
  }
}


tmux <- function() {
  term <- Sys.getenv("TERM_PROGRAM")
  term == "tmux"
}

tmux_passthrough <- function() {
  term <- Sys.getenv("TERM_PROGRAM")
  if (term != "tmux") return(FALSE)
  sup <- system("tmux show-options -g allow-passthrough", intern = TRUE)
  sup == "allow-passthrough on"
}

