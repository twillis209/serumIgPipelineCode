##' Process summary statistics for Manhattan plot
##'
##' Code originally from Daniel Roelfs, modified by Tom Willis
##' https://danielroelfs.com/blog/how-i-create-manhattan-plots-using-ggplot/
##'
##' @param dat data.table containing summary statistics
##' @param chr_col character string containing the column name for chromosome
##' @param bp_col character string containing the column name for position
##' @param p_col character string containing the column name for p-value
##' @return list containing data.table with updated chromosome and position
##' columns, axis set, and y-axis limits
##' @author Daniel Roelfs
##' @author Tom Willis
##' @import data.table
##' @importFrom dplyr group_by summarise mutate select inner_join filter pull
##' @export
process_sumstats_for_manhattan <- function(dat, chr_col = "chromosome", bp_col = "base_pair_location", p_col = "p_value") {

  dat <- data.table::copy(dat)

  data.table::setnames(dat, c(chr_col, bp_col, p_col), c("chr", "bp", "p"))

  dat[chr == "X", chr := 23]

  dat[, chr := as.integer(chr)]

  dat <- dat[chr %in% seq(1, 23)]

  data_cum <- dat %>%
    dplyr::group_by(chr) %>%
    dplyr::summarise(max_bp = max(bp)) %>%
    dplyr::mutate(bp_add = lag(cumsum(as.numeric(max_bp)), default = 0)) %>%
    dplyr::select(chr, bp_add)

  data <- dat %>%
    dplyr::inner_join(data_cum, by = "chr") %>%
    dplyr::mutate(bp_cum = as.numeric(bp) + as.numeric(bp_add))

  axis_set <- data %>%
    dplyr::group_by(chr) %>%
    dplyr::summarize(center = mean(bp_cum))

  # Ignore typically large peak from MHC when setting y scale
  ylim <- data[chr != 6] %>%
    filter(p == min(p)) %>%
    dplyr::mutate(ylim = abs(floor(log10(p))) + 2) %>%
    dplyr::pull(ylim)

  return(list(data = data, axis_set = axis_set, ylim = ylim))
}

##' Draw Manhattan plot using processed summary statistics
##'
##' Code originally from Daniel Roelfs, modified by Tom Willis
##' https://danielroelfs.com/blog/how-i-create-manhattan-plots-using-ggplot/
##'
##' @param processed_sumstats list containing data.table with updated chromosome and position values
##' @param palette character vector containing colors for chromosomes
##' @param title character string containing the title for the plot
##' @author Daniel Roelfs
##' @author Tom Willis
##' @importFrom ggplot2 ggplot geom_hline geom_point scale_x_continuous scale_color_manual scale_size_continuous scale_y_continuous labs theme ggtitle
##' @importFrom ggtext element_markdown
##' @export
draw_manhattan <- function(processed_sumstats, palette = c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7"), title = '') {
  gwas_data <- processed_sumstats$data
  axis_set <- processed_sumstats$axis_set
  ylim <- processed_sumstats$ylim

  ggplot2::ggplot(ggplot2::aes(x = bp_cum, y = p, color = as.factor(chr)), data = gwas_data) +
  ggplot2::geom_hline(yintercept = 5e-8, color = "grey40", linetype = "dashed") +
  ggplot2::geom_hline(yintercept = 1e-5, color = "grey40", linetype = "dashed") +
  ggplot2::geom_point(size = 0.3) +
  ggplot2::scale_x_continuous(label = axis_set$chr, breaks = axis_set$center) +
  ggplot2::scale_color_manual(values = rep(palette, unique(length(axis_set$chr)))) +
  ggplot2::scale_size_continuous(range = c(0.5, 3)) +
  scale_y_neglog10() +
  ggplot2::labs(x = NULL, 
       y = "-log<sub>10</sub>(p)") +
  ggplot2::theme( 
    legend.position = "none",
    panel.grid.major.x = ggplot2::element_blank(),
    panel.grid.minor.x = ggplot2::element_blank(),
    axis.title.y = ggtext::element_markdown(),
    axis.text.x = ggplot2::element_text(angle = 60, size = 8, vjust = 0.5)
  ) +
  ggplot2::ggtitle(title)
}

##' @importFrom scales trans_new
neglog_trans <- function(base = exp(1)){
  scales::trans_new("neglog",
            transform = function(x) -log(x, base),
            inverse = function(x) base^(-x),
            domain = c(1e-100, Inf)
            )
}

neglog10_trans <- function(){ neglog_trans(base = 10) }

##' @importFrom scales trans_breaks trans_format math_format
##' @importFrom ggplot2 scale_x_continuous
##' @export
scale_x_neglog10 <- function(...){
  ggplot2::scale_x_continuous(..., 
                     trans = neglog10_trans(), 
                     breaks = scales::trans_breaks(function(x) {log10(x)*-1}, function(x){10^(-1*x)}), 
                     labels = scales::trans_format(function(x) {log10(x)*-1}, scales::math_format(.x)))
}

##' @importFrom scales trans_breaks trans_format math_format
##' @importFrom ggplot2 scale_y_continuous
##' @export
scale_y_neglog10 <- function(...){
  ggplot2::scale_y_continuous(..., 
                     trans = neglog10_trans(), 
                     breaks = scales::trans_breaks(function(x) {log10(x)*-1}, function(x){10^(-1*x)}), 
                     labels = scales::trans_format(function(x) {log10(x)*-1}, scales::math_format(.x)))
}