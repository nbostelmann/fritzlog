#' Load a log file and create a graphical summary of device login activity
#'
#' @param file A path to a log file.
#' @param plot_type The type of plot. Can either be "histogram" (the default) or "freq_poly".
#'
#' @return A ggplot2 plot.
#'
#' @examples
#' file <- system.file("extdata", "fritz.log", package = "fritzlog", mustWork = TRUE)
#' fritz_plot(file, plot_type = "histogram")
#' @export
#' @importFrom rlang .data
fritz_plot <- function(file, plot_type = c("histogram", "freqpoly")) {
  plot_type <- rlang::arg_match(plot_type)

  log <- fritz_log(file)

  p <- ggplot2::ggplot(log, ggplot2::aes(.data$Timestamp)) +
    ggplot2::scale_x_datetime(
      date_breaks = "1 day",
      date_labels = "%a %d %b"
    ) +
    ggplot2::scale_y_continuous(
      breaks = scales::breaks_pretty(),
      expand = ggplot2::expansion(mult = c(0, 0.1))
    ) +
    ggplot2::labs(
      y = "Connections",
      title = "WiFi connections per hour by device"
    ) +
    ggplot2::theme_light() +
    ggplot2::theme(panel.grid.minor.x = ggplot2::element_line(linetype = "dashed"))

  switch(plot_type,
    histogram = p +
      ggplot2::geom_histogram(ggplot2::aes(fill = .data$Device), binwidth = 3600) +
      ggplot2::facet_wrap(ggplot2::vars(.data$Device)) +
      ggplot2::guides(fill = "none"),
    freqpoly = p +
      ggplot2::geom_freqpoly(ggplot2::aes(colour = .data$Device), binwidth = 3600, size = 1)
  )
}
