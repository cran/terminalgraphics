#' Terminal Graphics Protocol Device
#'
#' @param width The width of the image. Passed on to
#' \code{\link[ragg]{agg_capture}}.
#'
#' @param height The height of the image. Passed on to
#' \code{\link[ragg]{agg_capture}}.
#'
#' @param units The units in which 'height' and 'width' are given. Passed on to
#' \code{\link[ragg]{agg_capture}}.
#'
#' @param res The resolution of the image. Passed on to
#' \code{\link[ragg]{agg_capture}}.
#'
#' @param ... passed on to the underlying \code{\link[ragg]{agg_capture}}
#' device.
#'
#' @param term_col Logical value indicating that the foreground and background
#' colors used in the plot should be set to that of the terminal.
#'
#' @param term_bg Logical value indicating that the background color used in
#' the plot should be set to that of the terminal.
#'
#' @param term_fg Logical value indicating that the foreground color used in
#' the plot should be set to that of the terminal.
#'
#' @details
#' The function tries to detect whether the terminal supports Sixel. If not, it
#' will issue a warning but still output the image to the terminal. Terminals
#' that to not support Sixel will ignore the output. The warning is shown only
#' once. Please file an issue when the terminal does support Sixel while
#' \code{\link{has_sixel_support}} returns \code{FALSE}. The warning can be
#' disabled using \code{options(warned_sixel_support = TRUE)}.
#'
#'
#' @return
#' \code{sixel} is called for its side effect of opening a graphics device.
#' Invisibly returns an list with two functions: \code{plot} will plot the
#' current contents of the device in the terminal and \code{update} will plot
#' the current contents of the device in the terminal if the contents have
#' changed since the last plot.
#'
#' \code{\link{term_replot}} will redraw the content of the device in the
#' terminal. In principle \code{\link{term_replot}} is called automatically
#' when the contents of the device changed. This function can be used to force
#' plotting. 
#'
#' When \code{term_bg = TRUE} the background color of the graphics device
#' ('\code{bg}') will be set using \code{\link[graphics]{par}}. When
#' \code{term_fg = TRUE} the foreground color ('\code{fg}', '\code{col}',
#' '\code{col.axis}', '\code{col.lab}', '\code{col.main}', and '\code{sub}')
#' will be set using \code{\link[graphics]{par}}.
#'
#' @examples
#' if (has_sixel_support()) {
#'   # Open device
#'   sixel()
#'   plot(rnorm(100))
#'   abline(h = 0, lwd = 2, col = term_palette()[1])
#' }
#'
#' @rdname sixel
#' @export
sixel <- function(
    width = term_default_width(), height = term_default_height(width), 
    units = "px", res = term_default_res(), ..., 
    term_col = getOption("term_col", FALSE), term_bg = term_col, term_fg = term_col) {
  warn_sixel_support()
  options <- list(width = width, height = height, units = units, res = res,
    width_set = !missing(width), height_set = !missing(height))
  # Create closure that will handle redrawing
  man <- device_manager(raster2sixel, options, ...)
  cur <- grDevices::dev.cur() |> names()
  if (cur == "null device") stop("Failed to open device")
  if (!exists("devices", devices)) devices$devices <- list()
  devices$devices[[cur]] <- man
  # Set colours
  if (term_bg) { 
    background <- term_background()
    graphics::par(bg = background)
  }
  if (term_fg) { 
    foreground <- term_foreground()
    graphics::par(fg = foreground, col = foreground, 
      col.axis = foreground, col.lab = foreground, 
      col.main = foreground, col.sub = foreground)
  }
  # Add callback handler; this will check after each command if the plot device
  # has changed; and if so, will redraw the plot in the terminal.
  addTaskCallback(term_update, name = "gp")
  setHook("before.plot.new", term_reopen)
  invisible(man)
}

