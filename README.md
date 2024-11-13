
# serumIgPipelineCode

<!-- badges: start -->
<!-- badges: end -->

This R package provides ancillary code for the serum Ig paper pipeline.

## Installation

You can install the development version of serumIgPipelineCode like so:

``` r
devtools::install_github('twillis209/serumIgPipelineCode')
```

This package is also available on `anaconda` on the `twillis209` channel as `r-serum-ig-pipeline-code`.

## Development

### Workflow

#### Building package after changes

```sh
Rscript -e "devtools::document()
R CMD build .
R CMD check serumIgPipelinecode_x.tar.gz
```

#### Building `conda` package

I use `rattler-build` to do this.

Full disclosure: I generated a template `recipe.yaml` using:
```sh
rattler-build generate-recipe cran ggplot2
```
then edited that.

The package is built with

```sh
rattler-build build --recipe recipe.yaml --output-dir ../r-serum-ig-pipeline-code
```

I then upload the artifact (in this case for `linux-64`) with:

```sh
rattler-build upload anaconda ../r-serum-ig-pipeline-code/linux-64/r-serum-ig-pipeline-code-0.1.0-hb0f4dca_0.conda --owner twillis209
```

This depends on the `RATTLER_AUTH_FILE` environment variable pointing at a JSON file containing an access token for `anaconda.org`.
