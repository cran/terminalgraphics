
#' Determine if terminal supports Sixel
#'
#' @param warn show warnings when the protocol is not supported.
#'
#' @param throw throw an error when we are running in a kitty terminal.
#'
#' @return
#' Returns \code{TRUE} if the current terminal supports the Sixel and
#' \code{FALSE} otherwise. Will also return \code{FALSE} when not running in a
#' terminal.
#'
#' @examples
#' if (has_sixel_support()) {
#'   cat("Yeeh, your terminal supports the sixel!")
#' }
#'
#' @export
has_sixel_support <- function(warn = FALSE, throw = FALSE) {
  # Send query for support
  sup <- query_sixel_support_rcpp()
  if (is.na(sup) || !sup) {
    if (warn) 
      warning("Terminal does not report supporting sixel")
    return(FALSE)
  }
  TRUE
}


warn_sixel_support <- function() {
  warned <- getOption("warned_sixel_support", FALSE)
  if (!warned) {
    if (!has_sixel_support(warn = TRUE)) {
      options("warned_sixel_support" = TRUE)
      warning("This warning is only shown once.")
    }
  }
}
