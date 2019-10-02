
<!-- README.md is generated from README.Rmd. Please edit that file -->

# basecamper

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of basecamper is to work with Basecamp Classic API to interact
with Basecamp directly from R.

What you can do with this package:

  - Query
      - Projects you have privileges to
      - Specific project information
      - Attachments in a project
  - Download attached files in a project
  - Unzip large files (`>4gb`)

## Installation

To use this package clone reop and install locally

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
Sys.setenv(BASECAMP_HOST  = 'https://metrumresearchgroup.basecamphq.com')
```

## Queries

### Projects

``` r
projects <- basecamper::basecamp_projects()
```

#### Projects methods

``` r
print(projects)
#>                             Metrum Institute 
#>                               "Journal Club" 
#>                        Metrum Research Group 
#>                                    "QC help" 
#>            Bill and Melinda Gates Foundation 
#>                 "Growth and Development M&S" 
#>                                        Shire 
#>        "Enzyme Replacement Therapy Programs" 
#>                                   Millennium 
#>                             "MLN100101(QTc)" 
#>                                    Curis Inc 
#>                                    "CUR0101" 
#>                         Boehringer Ingelheim 
#>                "BII0901F(BI685509.sGCA.FIH)" 
#>                        Stemline Therapeutics 
#> "Stemline Hourly Consulting STM0101H(SL401)" 
#>                        Metrum Research Group 
#>                         "Metrum Lab Meeting" 
#>                        Stemline Therapeutics 
#>                   "SL401 Hematolgic Cancers" 
#>                                          BMS 
#>                    "ID01INnhibitor(BMS0701)" 
#>                              AADi Bioscience 
#>                                     "PEComa" 
#>                                  Biogen Idec 
#>                     "Parkinson's (BIO0501F)" 
#>                                          CSL 
#>                                   "CSL0401F" 
#>                       Takeda Pharmaceuticals 
#>             "Vedolizumab Adult SC (TAK0204)" 
#>                                        Roche 
#>                                    "Tamiflu" 
#>                                        Merck 
#>                           "MER0501F(MK3475)" 
#>                                      Novella 
#>                       "PEComa Data Transfer" 
#>                                        IQVIA 
#>           "Vedolizumab: Studies 3030 & 3031" 
#>                       Takeda Pharmaceuticals 
#>                  "Vedolizumab CD (TAK0208F)"
```

``` r
summary(projects)
#> # A tibble: 20 x 3
#>    company                      id       name                              
#>    <chr>                        <chr>    <chr>                             
#>  1 Metrum Institute             7581035  Journal Club                      
#>  2 Metrum Research Group        8514810  QC help                           
#>  3 Bill and Melinda Gates Foun… 11663439 Growth and Development M&S        
#>  4 Shire                        13241655 Enzyme Replacement Therapy Progra…
#>  5 Millennium                   13263727 MLN100101(QTc)                    
#>  6 Curis Inc                    13359673 CUR0101                           
#>  7 Boehringer Ingelheim         13441993 BII0901F(BI685509.sGCA.FIH)       
#>  8 Stemline Therapeutics        13589903 Stemline Hourly Consulting STM010…
#>  9 Metrum Research Group        13860215 Metrum Lab Meeting                
#> 10 Stemline Therapeutics        13925741 SL401 Hematolgic Cancers          
#> 11 BMS                          13981044 ID01INnhibitor(BMS0701)           
#> 12 AADi Bioscience              14029223 PEComa                            
#> 13 Biogen Idec                  14050694 Parkinson's (BIO0501F)            
#> 14 CSL                          14060588 CSL0401F                          
#> 15 Takeda Pharmaceuticals       14166454 Vedolizumab Adult SC (TAK0204)    
#> 16 Roche                        14222531 Tamiflu                           
#> 17 Merck                        14307782 MER0501F(MK3475)                  
#> 18 Novella                      14354698 PEComa Data Transfer              
#> 19 IQVIA                        14516970 Vedolizumab: Studies 3030 & 3031  
#> 20 Takeda Pharmaceuticals       14542533 Vedolizumab CD (TAK0208F)
```

### Project

``` r
(TAKEDA_IQVA <- summary(projects)[[19,'id']])
#> [1] "14516970"
project <- basecamper::basecamp_project(TAKEDA_IQVA)
```

#### Project methods

``` r
print(project)
#> Vedolizumab: Studies 3030 & 3031
#> ID: 14516970
#> Status: active
#> Company : IQVIA
#> Create On: 2019-07-31
#> Last Changed: 2019-10-01T17:29:48Z
```

### Attachments

``` r
attachments <- basecamper::basecamp_attachment(TAKEDA_IQVA)
```

#### Attachments methods

``` r
print(attachments)
#>  [1] "20191001 MLN0002SC 3031 ADAM_Final.zip"                                               
#>  [2] "20190930_MLN0002SC_3030_SDTM_Restricted_Global IA2_rerun_Specs and Compare.zip"       
#>  [3] "20190930_MLN0002SC_3030_SDTM_Restricted_Global IA2 (data cut-off 17MAY2019)_rerun.zip"
#>  [4] "20190930_MLN0002SC_3030_ADaM_Global IA2_rerun_Specs.zip"                              
#>  [5] "20190930_MLN0002SC_3030_ADaM_Global IA2 (data cut-off 17MAY2019)_rerun.zip"           
#>  [6] "20190930_MLN0002SC_3031 SDTM_Restricted_Final (data cut-off 06MAY2019)_17SEP2019.zip" 
#>  [7] "20190930_MLN0002SC_3031 SDTM Specifications and Compare.zip"                          
#>  [8] "20190930_MLN0002SC_3031 ADAM_Final (data cut-off 06MAY2019)_17SEP2019.zip"            
#>  [9] "20190930_MLN0002SC_3031 ADaM Specifications.zip"                                      
#> [10] "20190828_MLN0002SC_3030_SDTM_Final_Global IA2_Restricted.zip"                         
#> [11] "20190828_MLN0002SC_3030_Global_IA2_SDTM Specifications.zip"                           
#> [12] "20190828_MLN0002SC_3030_Global_IA2_Final_ADaM Specifications.zip"                     
#> [13] "20190828_MLN0002SC_3030_Global_IA2_Final_ADAM (data cut-off 17MAY2019).zip"           
#> [14] "MLN0002SC 3031 SDTM specifications.zip"                                               
#> [15] "SDTM_Final (data cut-off 06MAY2019)_05AUG2019.zip"                                    
#> [16] "MLN0002SC 3031 ADaM specifications.zip"                                               
#> [17] "ADAM_Final (data cut-off 06MAY2019)_05AUG2019.zip"
```

``` r
summary(attachments)
#> # A tibble: 17 x 4
#>    filename                    created_on filesize url                     
#>    <chr>                       <date>     <fs::by> <chr>                   
#>  1 20191001 MLN0002SC 3031 AD… 2019-10-01  265.16M https://metrumresearchg…
#>  2 20190930_MLN0002SC_3030_SD… 2019-09-30   13.14M https://metrumresearchg…
#>  3 20190930_MLN0002SC_3030_SD… 2019-09-30   27.34M https://metrumresearchg…
#>  4 20190930_MLN0002SC_3030_AD… 2019-09-30     6.6M https://metrumresearchg…
#>  5 20190930_MLN0002SC_3030_AD… 2019-09-30  446.77M https://metrumresearchg…
#>  6 20190930_MLN0002SC_3031 SD… 2019-09-30   27.28M https://metrumresearchg…
#>  7 20190930_MLN0002SC_3031 SD… 2019-09-30    7.15M https://metrumresearchg…
#>  8 20190930_MLN0002SC_3031 AD… 2019-09-30  149.23M https://metrumresearchg…
#>  9 20190930_MLN0002SC_3031 AD… 2019-09-30    5.49M https://metrumresearchg…
#> 10 20190828_MLN0002SC_3030_SD… 2019-08-30   27.31M https://metrumresearchg…
#> 11 20190828_MLN0002SC_3030_Gl… 2019-08-30    4.83M https://metrumresearchg…
#> 12 20190828_MLN0002SC_3030_Gl… 2019-08-30    6.59M https://metrumresearchg…
#> 13 20190828_MLN0002SC_3030_Gl… 2019-08-30  446.46M https://metrumresearchg…
#> 14 MLN0002SC 3031 SDTM specif… 2019-08-23     4.2M https://metrumresearchg…
#> 15 SDTM_Final (data cut-off 0… 2019-08-23   27.28M https://metrumresearchg…
#> 16 MLN0002SC 3031 ADaM specif… 2019-08-23    5.42M https://metrumresearchg…
#> 17 ADAM_Final (data cut-off 0… 2019-08-23  147.49M https://metrumresearchg…
```

## Download File

``` r
attach_summary <- summary(attachments)

(file_url  <- attach_summary$url[attach_summary$filesize==min(attach_summary$filesize)])
#> [1] "https://metrumresearchgroup.basecamphq.com/projects/14516970/file/252369382/MLN0002SC%203031%20SDTM%20specifications.zip"

td <- tempdir()

basecamp_download(file_url,destdir = td)

list.files(td,pattern = '.zip$')
#> [1] "MLN0002SC_3031_SDTM_specifications.zip"
```

## Unzip

`basecamper::unzip2` runs unzip from CLI which is more robust for files
larger than `4gb` which are truncated by `utils::zip`

``` r

basecamper::unzip2(directory = td,
                   file = list.files(td,pattern = '.zip$',full.names = TRUE))
#> Success!

list.files(td,pattern = '.(pdf|xlsx)$')
#> [1] "MLN0002-3031_SDTM_Specifications_V2.xlsx"
#> [2] "MLN0002SC-3031_SDTM_aCRF_V4.8.pdf"
```
