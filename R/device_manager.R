
# Keeps track of changes on a ragg device; returns a list with two functions:
# - plot: will dump the image of the device to the terminal.
# - update: checks is the image has changed and if so, will call plot().
#
device_manager <- function(ragg_dev, display_fun) {
  raster <- ragg_dev()
  plot <- function() {
    raster <<- ragg_dev()
    display_fun(raster)
    cat("\n")
  }
  update <- function() {
    raster_new <- ragg_dev()
    if (!isTRUE(all.equal(raster_new, raster))) {
      plot()
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

