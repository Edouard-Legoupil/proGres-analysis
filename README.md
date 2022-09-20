
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `{proGresAnalysis}` <img src="man/figures/progres.png" width="200" align="right" />

An R package for advanced statistical analysis of [Refugee Registration
database & assistance
tracking](https://www.unhcr.org/registration-guidance/chapter3/registration-tools/)

-   Basic demographic variables

-   Specific needs

-   Case management events

-   Individual assistance events

## Installation and usage

You can install `{proGresAnalysis}` from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("edouard-legoupil/proGres-analysis")
```

Once `{proGresAnalysis}` installed, you can create a new RMD using the
custom template.

Using [RStudio](https://www.rstudio.com/):

-   Step 1: Click the “File” menu then “New File” and choose “R
    Markdown”.

-   Step 2: In the “From Template” tab, choose one of the built-in
    templates.

You will then just need to fill in the [YAML
parameters](https://rmarkdown.rstudio.com/lesson-6.html):

-   `ridl`: “tto-extraction-02-2022”
-   `dir`:
-   `country`: “Trinidad and Tobago”

## Output

The package is designed to work on a standard query in the registration
database that aggregates key variables at household levels. Many reports
are already produced from proGres but they mostly look at univariate
analysis, i.e each variable within the dataset is displayed one by one.
This package is an attempt to explore various dimensions interact
between each others.

The package include a function to retrieve that data and another one to
tidy the results. The main output is an Exploratory Data Analysis Report
generated as a powerpoint and ready for [Joint Data
Interpretation](https://www.youtube.com/watch?v=0jE-Y7g88K4&feature=youtu.be&t=2305)

## Feedback

Users are welcome to flag bugs, suggest improvements and/or submit
feature request
[here](https://github.com/edouard-legoupil/proGres-analysis/issues/new)
