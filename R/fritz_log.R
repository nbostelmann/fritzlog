#' Load a log file and transform into a well-formatted tibble
#'
#' @param file A path to a log file.
#'
#' @return A tibble.
#'
#' @examples
#' file <- system.file("extdata", "fritz.log", package = "fritzlog", mustWork = TRUE)
#' fritz_log(file)
#' @export
#' @importFrom rlang .data
fritz_log <- function(file) {
  col_names <- list(NULL, c("Date", "Time", "Message"))
  pattern_login <- "WLAN-Ger\u00E4t angemeldet|WLAN-Ger\u00E4t hat sich neu angemeldet"
  pattern_device <- "Mbit/s, ([[:print:]]+), IP"

  readr::read_lines(file) |>
    matrix(ncol = 3, byrow = TRUE, dimnames = col_names) |>
    tibble::as_tibble() |>
    dplyr::mutate(
      Timestamp = lubridate::dmy_hms(paste(.data$Date, .data$Time)),
      .keep = "unused",
      .before = 1
    ) |>
    dplyr::filter(stringr::str_detect(.data$Message, pattern_login)) |>
    tidyr::extract(.data$Message, "Device", pattern_device, remove = FALSE) |>
    dplyr::relocate(.data$Device, .after = .data$Timestamp)
}
