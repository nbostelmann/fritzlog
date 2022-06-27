fritz_plot <- function(file, plot_type) {
  log <- fritz_log(file)

  p <- ggplot2::ggplot(log, ggplot2::aes(Timestamp)) +
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
      ggplot2::geom_histogram(ggplot2::aes(fill = Device), binwidth = 3600) +
      ggplot2::facet_wrap(ggplot2::vars(Device)) +
      ggplot2::guides(fill = "none"),
    freqpoly = p +
      ggplot2::geom_freqpoly(ggplot2::aes(colour = Device), binwidth = 3600, size = 1),
    stop("plot_type must be either 'freqpoly' or 'histogram'", call. = FALSE)
  )
}
