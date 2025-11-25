# Keeps track of changes on a ragg device; returns a list with two functions:
# - plot: will dump the image of the device to the terminal.
# - update: checks is the image has changed and if so, will call plot().
#
device_manager <- function(ragg_dev, display_fun) {
  raster <- ragg_dev()
  plot <- function(raster_new) {
    if (missing(raster_new)) raster_new <- ragg_dev(native = TRUE)
    raster <<- raster_new
    display_fun(raster)
    cat("\n")
  }
  update <- function() {
    raster_new <- ragg_dev(native = TRUE)
    # ragg > 1.5 can tagg the raster if plot commands have happened
    # this is much faster than comparing the rasters and als much
    # reliable
    if (utils::packageVersion("raster") > "1.5.0") {
      if (attr(raster_new, "changed")) {
        plot(raster_new)
      }
    } else {
      if (!isTRUE(all.equal(raster_new, raster))) {
        plot(raster_new)
      }
    }
  }
  list(plot = plot, update = update)
}


term_update <- function(...) {
  if (!exists("devices", devices)) return()
  cur <- grDevices::dev.cur() |> names()
  man <- devices$devices[[cur]]
  if (!is.null(man)) {
    man$update()
  }
  TRUE
}


#' Replot the current device in the terminal.
#'
#' @return
#' Called for outputting the current contents of a \code{\link{sixel}} or
#' \code{\link{tgp}} device into the terminal.
#'
#' @export
term_replot <- function() {
  if (!exists("devices", devices)) stop("No devices registered")
  cur <- grDevices::dev.cur() |> names()
  man <- devices$devices[[cur]]
  if (!is.null(man)) {
    man$plot()
  }
}
