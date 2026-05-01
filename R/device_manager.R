# Keeps track of changes on a ragg device; returns a list with two functions:
# - plot: will dump the image of the device to the terminal.
# - update: checks is the image has changed and if so, will call plot().
#
#device_manager <- function(ragg_dev, display_fun, dev_open, options) {
device_manager <- function(display_fun, options, ...) {
  ragg_dev <- ragg_open(options, ...)
  # Keep track of the current dimension of the device; when the dimension has
  # changed; the reopen method will open a new device with the updated
  # dimensions.
  dim <- ragg_calc_dim(options)
  # The image; needed to check if there are changes for old versions or ragg
  raster <- ragg_dev()

  reopen <- function() {
    newdim <- ragg_calc_dim(options)
    if (all(newdim == dim)) return();
    dim <<- newdim
    # Keep track of old name of device
    oldname <- grDevices::dev.cur() |> names()
    pos <- which(names(devices$devices) == oldname)
    # Close old device open new device
    grDevices::dev.off()
    # TODO handle ...
    ragg_dev <<- ragg_open(options, ...)
    # Update the list of devices with the new device name
    newname <- grDevices::dev.cur() |> names()
    if (newname == "null device") stop("Failed to open device")
    names(devices$devices)[pos] <- newname
    raster <<- ragg_dev()
  }
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
    if (utils::packageVersion("ragg") > "1.5.0") {
      if (isTRUE(attr(raster_new, "changed"))) {
        plot(raster_new)
      }
    } else {
      if (!isTRUE(all.equal(raster_new, raster))) {
        plot(raster_new)
      }
    }
  }
  list(plot = plot, update = update, reopen = reopen)
}


ragg_open <- function(options, ...) {
  dim <- ragg_calc_dim(options)
  ragg::agg_capture(width = dim[1], height = dim[2], 
    units = options$units, res = options$res, ...)
}

ragg_calc_dim <- function(options) {
  width <- if (options$width_set) options$width else 
    term_default_width()
  height <- if (options$height_set) options$height else 
    term_default_height(width)
  c(width, height)
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

term_reopen <- function(...) {
  if (!exists("devices", devices)) return()
  cur <- grDevices::dev.cur() |> names()
  man <- devices$devices[[cur]]
  if (!is.null(man)) {
    man$reopen()
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

