#' Synthetic 2018 ACS microdata for New Hampshire
#'
#' Example dataset based on the American Community Survey of the state of
#' New Hampshire in 2018. ***This is not real data.*** It was synthesized using
#' [synthpop::syn()]. This data should only be used for examples and cannot be
#' used in real analyses.
#'
#' @docType data
#'
#' @format A data frame.
#' \describe{
#'   \item{PERWT}{weight}
#'   \item{SEX}{encoded sex/gender}
#'   \item{AGE}{age in years}
#'   \item{RACE}{encoded race}
#'   \item{HISPAN}{encoded Hispanic ethnicity}
#'   \item{BPL}{encoded birth place: country or US state or territory}
#'   \item{EDUC}{encoded level of education}
#' }
#'
#' @source Synthesized using data from
#'     [IPUMS-USA](https://usa.ipums.org/usa/index.shtml)
#'
#' @seealso [acs_codes]
#'
#'   Package [ipumsr][ipumsr::ipumsr-package] to get real census microdata
#'
#'   Package [synthpop][synthpop::synthpop-package] to synthesize data

"acs_nh"

#' Encodings for 2018 ACS microdata
#'
#' Encodings for example dataset based on the American Community Survey in 2018.
#'
#' @docType data
#'
#' @format A data frame.
#'
#' @source [IPUMS-USA](https://usa.ipums.org/usa/index.shtml)
#'
#' @seealso [acs_nh]
#'
#'   Package [ipumsr][ipumsr::ipumsr-package] to get real census microdata

"acs_codes"

#' @rdname acs_codes

"acs_codes_long"

#' @rdname acs_codes

"acs_sex_codes"

#' @rdname acs_codes

"acs_bpl_codes"

#' @rdname acs_codes

"acs_educ_codes"
