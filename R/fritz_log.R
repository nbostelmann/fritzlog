#' Load a log file and transform into a well-formatted tibble
#'
#' @param file A path to a log file.
#'
#' @return A tibble.
#' @export
#'
#' @examples
#' fritz_log("fritz.log")
fritz_log <- function(file) {
  col_names <- list(NULL, c("Date", "Time", "Message"))
  pattern_login <- "WLAN-Gerät angemeldet|WLAN-Gerät hat sich neu angemeldet"
  pattern_device <- "Mbit/s, ([[:print:]]+), IP"

  readr::read_lines(file) |>
    matrix(ncol = 3, byrow = TRUE, dimnames = col_names) |>
    tibble::as_tibble() |>
    dplyr::mutate(
      Timestamp = lubridate::dmy_hms(paste(Date, Time)),
      .keep = "unused",
      .before = 1
    ) |>
    dplyr::filter(stringr::str_detect(Message, pattern_login)) |>
    tidyr::extract(Message, "Device", pattern_device, remove = FALSE) |>
    dplyr::relocate(Device, .after = Timestamp)
}
