#' @export
#'
#' @title Character representation of a POSIXct
#'
#' @param datetime Vector of character or integer datetimes in Ymd[HMS] format
#'   (or POSIXct).
#' @param timezone Olson timezone used to interpret incoming dates (required).
#' @param unit Units used to determine precision of generated time stamps.
#' @param style Style of representation, Default = "ymdhms".
#'
#' @description
#' Uses incoming parameters to return a pair of \code{POSIXct} times in the
#' proper order. Both start and end times will have \code{lubridate::floor_date()}
#' applied to get the nearest \code{unit} unless \code{ceilingEnd = TRUE} in
#' which case the end time will will have \code{lubridate::ceiling_date()}
#' applied.
#'
#' The required \code{timezone} parameter must be one of those found in
#' \code{\link[base]{OlsonNames}}.
#'
#' Formatting output is are affected by both \code{style}:
#'
#' \itemize{
#'   \item{\code{"ymdhms"}}
#'   \item{\code{"julian"}}
#'   \item{\code{"clock"}}
#' }
#'
#' and \code{unit} which determines the temporal precision of the generated
#' representation:
#'
#' \itemize{
#'   \item{\code{"year"}}
#'   \item{\code{"month"}}
#'   \item{\code{"day"}}
#'   \item{\code{"hour"}}
#'   \item{\code{"min"}}
#'   \item{\code{"sec"}}
#' }
#'
#' If `style == "julian"` && `unit = "month"``, the timestamp will contain the
#' Julian day associated with the beginning of the month.
#'
#' @inheritSection dateRange POSIXct inputs
#'
#' @return A vector of time stamps.
#'
#' @examples
#' datetime <- parseDatetime("2019-01-08 12:30:15", timezone = "UTC")
#'
#' timeStamp(datetime, "UTC", unit = "year")
#' timeStamp(datetime, "UTC", unit = "month")
#' timeStamp(datetime, "UTC", unit = "month", style = "julian")
#' timeStamp(datetime, "UTC", unit = "day")
#' timeStamp(datetime, "UTC", unit = "day", style = "julian")
#' timeStamp(datetime, "UTC", unit = "hour")
#' timeStamp(datetime, "UTC", unit = "min")
#' timeStamp(datetime, "UTC", unit = "sec")
#' timeStamp(datetime, "UTC", unit = "sec", style = "julian")
#' timeStamp(datetime, "UTC", unit = "sec", style = "clock")
#' timeStamp(datetime, "America/Los_Angeles", unit = "sec", style = "clock")
#'
timeStamp <- function(
  datetime = NULL,
  timezone = NULL,
  unit = "sec",
  style = "ymdhms"
) {

  # ----- Validate parameters --------------------------------------------------

  stopIfNull(datetime)
  stopIfNull(timezone)
  stopIfNull(unit)
  stopIfNull(style)

  if ( !timezone %in% base::OlsonNames() )
    stop(paste0("Timezone '", timezone, "' is not recognized."))

  if ( !unit %in% c("year", "month", "day", "hour", "min", "sec") )
    stop(paste0("Unit '", unit, "' is not recognized."))

  if ( !style %in% c("ymdhms", "julian", "clock") )
    stop(paste0("Unit '", style, "' is not recognized."))

  # ----- Format datetimes -----------------------------------------------------

  # Guarantee conversion to POSIXct
  datetime <- parseDatetime(datetime, timezone = timezone)

  if ( unit == "year" ) {
    format <- "%Y"

  } else if ( unit == "month" ) {
    if ( style == "ymdhms" )
      format <- "%Y%m"
    if ( style == "julian" ) {
      datetime <- lubridate::floor_date(datetime, unit = "month")
      format <- "%Y%j"
    }
    if ( style == "clock" )
      format <- "%Y-%m"

  } else if ( unit == "day" ) {
    if ( style == "ymdhms" )
      format <- "%Y%m%d"
    if ( style == "julian" )
      format <- "%Y%j"
    if ( style == "clock" )
      format <- "%Y-%m-%d"

  } else if ( unit == "hour" ) {
    if ( style == "ymdhms" )
      format <- "%Y%m%d%H"
    if ( style == "julian" )
      format <- "%Y%j%H"
    if ( style == "clock" )
      format <- "%Y-%m-%dT%H"

  } else if ( unit == "min" ) {
    if ( style == "ymdhms" )
      format <- "%Y%m%d%H%M"
    if ( style == "julian" )
      format <- "%Y%j%H%M"
    if ( style == "clock" )
      format <- "%Y-%m-%dT%H:%M"

  } else if ( unit == "sec" ) {
    if ( style == "ymdhms" )
      format <- "%Y%m%d%H%M%S"
    if ( style == "julian" )
      format <- "%Y%j%H%M%S"
    if ( style == "clock" )
      format <- "%Y-%m-%dT%H:%M:%S"

  }

  timeStamp <- strftime(datetime, format = format, tz = timezone)

  # ----- Return ---------------------------------------------------------------

  return(timeStamp)

}
