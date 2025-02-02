% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_incl_educ_enroll.R
\name{plot_incl_educ_enroll}
\alias{plot_incl_educ_enroll}
\title{Assemble all data components in a list and compute indicators}
\usage{
plot_incl_educ_enroll(
  progres,
  ctr,
  ridl = "data-should-be-on-ridl",
  thisyear = 2021
)
}
\arguments{
\item{progres}{a list with all required frame re-encoded}

\item{ctr}{Country or Business Unit for the dataset dump}

\item{ridl}{name of the project in ridl.unhcr.org, the internal UNHCR repository based on CKAN}

\item{year}{Year of reference}
}
\value{
a list with both a ggplot2 crafted chart and the summary data
}
\description{
The function compute a summary chart 
  * "SE.PRE.ENRR", # School enrollment, preprimary -Age 3-5 (% gross) -
  * "SE.PRM.ENRR", # School enrollment, primary -Age 6 -11(% gross)  
  * "SE.SEC.ENRR", # School enrollment, secondary -Age 12-19 (% gross)
  * "SE.TER.ENRR" # School enrollment, tertiary -Age 20-24  (% gross)
}
\examples{
progresobj <- data_load(dataraw = system.file("demo/", package = "proGresAnalysis") )
progres <- data_recode(progresobj = progresobj,  ctr = "Ecuador")
plot_incl_educ_enroll (progres = progres,
                                    ctr = "Ecuador" ,
                                    ridl = "data-should-be-on-ridl",
                                    thisyear = 2021 )

}
