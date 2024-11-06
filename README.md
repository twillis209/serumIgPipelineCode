
# serumIgPipelineCode

<!-- badges: start -->
<!-- badges: end -->

The goal of serumIgPipelineCode is to ...

## Installation

You can install the development version of serumIgPipelineCode like so:

``` r
# FILL THIS IN! HOW CAN PEOPLE INSTALL YOUR DEV PACKAGE?
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(serumIgPipelineCode)
## basic example code
```

## Development

### Workflow

#### Building package

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

```sh

```

