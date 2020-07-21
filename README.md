
<!-- README.md is generated from README.Rmd. Please edit that file -->

# basecamper

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of basecamper is to work with Basecamp Classic API to interact
with Basecamp directly from R.

What you can do with this package:

|    Scope    | Query | Post | Edit | Delete | Download | Vignette |
| :---------: | :---: | :--: | :--: | :----: | :------: | :------: |
|  Projects   |   ✅   |      |      |        |          |    ✅     |
|  Messages   |   ✅   |  ✅   |  ✅   |   ✅    |          |          |
|  Comments   |   ✅   |  ✅   |  ✅   |   ✅    |          |    ✅     |
| Attachments |   ✅   |  ✅   |      |        |    ✅     |    ✅     |

## Installation

To use this package clone the repository and install locally

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(basecamper)
```

Set up the TOKEN and HOST

You can find your TOKEN by logging into Basecamp

  - Click on `My info` found in the top right corner of the website
  - At the bottom of this page you will see `Authentication tokens`,
    click on `Show your tokens`
  - Copy the `Token for feed readers or the Basecamp API`, this goes
    into the `BASECAMP_TOKEN` environment variable.

<!-- end list -->

``` r
Sys.setenv(BASECAMP_TOKEN = 'MYTOKEN')
Sys.setenv(BASECAMP_HOST  = 'https://mycompany.basecamphq.com')
```

### Whoami

Checking that the token and host are set right and get back your account
info with the `whoami` function

``` r
basecamper::whoami()
```
