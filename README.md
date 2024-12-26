
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
Rscript -e "attachment::att_amend_desc()"
R CMD build .
R CMD check serumIgPipelinecode_x.tar.gz
```

I publish releases to GitHub using the GitHub CLI interactively:

```sh
gh release create
```

Remember to upload the package archive :

```sh
gh release upload --clobber v0.x.0 serumIgPipelineCode_0.x.0.tar.gz
```

GitHub will include the source code.

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
rattler-build upload anaconda ../r-serum-ig-pipeline-code/linux-64/r-serum-ig-pipeline-code-0.2.0-hb0f4dca_0.conda --owner twillis209
```

This depends on the `RATTLER_AUTH_FILE` environment variable pointing at a JSON file containing an access token for `anaconda.org`.
