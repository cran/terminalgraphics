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
  if (length(dim) < 4 || is.na(dim[3]) || dim[3] == 0 || 
      is.na(dim[4]) || dim[4] == 0) {
    if (warn) 
      warning("Terminal does not report its size in pixels.")
    return(FALSE)
  }
  # Send query for support
  sup <- query_tgp_support_rcpp()
  if (is.na(sup) || !sup) {
    if (warn) 
      warning("Terminal does not report supporting terminal graphics protocol")
    return(FALSE)
  }
  TRUE
}


warn_tgp_support <- function() {
  warned <- getOption("warned_tgp_support", FALSE)
  if (!warned) {
    if (!has_tgp_support(warn = TRUE)) {
      options("warned_tgp_support" = TRUE)
      warning("This warning is only shown once.")
    }
  }
}

