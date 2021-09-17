
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ndc

<!-- badges: start -->
<!-- badges: end -->

This package includes a function to convert NDCs in 10-digits to
11-digits.

You can download a csv file for NDCs using the [FDA
database](https://www.accessdata.fda.gov/scripts/cder/ndc/index.cfm).

## Installation

``` r
remotes::install_github("jaylkim/ndc")
```

## Example

``` r
library(ndc)
## basic example code
ndc_convert("path/to/file.csv")
```
