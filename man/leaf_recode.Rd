% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/leaf_recode.R
\name{leaf_recode}
\alias{leaf_recode}
\title{Recode columns of a data frame}
\usage{
leaf_recode(tbl, code_tbl)
}
\arguments{
\item{tbl}{Data frame to modify}

\item{code_tbl}{A data frame containing a column of codes and a column of
replacment values with the same name as \code{col}}

\item{col}{The column to recode}

\item{code_col}{The column of \code{code_tbl} containing the codes present in
\code{tbl}}
}
\value{
A data frame with selected columns recoded
}
\description{
\code{leaf_recode()} recodes values in a column of a data frame by joining with a
data frame of recoded values. \code{leaf_recode_all()} recodes all columns that
have matching coumn names between both data frames.
}
\examples{
# A data frame of encoded data
acs_md

# A data frame of recode values
acs_race_codes

#Recode
leaf_recode(acs_md, acs_race_codes)

# You can also specify recoding using formulas
acs_age_codes
leaf_recode(acs_md, acs_age_codes)

# You can use also use a data frame with recode values for multiple columns
# Either a wide data frame
acs_codes
leaf_recode(acs_md, acs_codes)

# Or a long data frame
acs_codes_long
leaf_recode(acs_md, acs_codes_long)
}
\seealso{
\code{\link[dplyr:case_when]{dplyr::case_when()}} to recode data using formulas
}