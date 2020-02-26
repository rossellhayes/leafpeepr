
<!-- README.md is generated from README.Rmd. Please edit that file -->

# leafpeepr <img src="man/figures/logo.png?raw=TRUE" align="right" height="138" />

<!-- badges: start -->

<!-- badges: end -->

> **leaf peeper**: a sightseer who enjoys observing the color change in
> trees’ leaves, especially in the autumn
> 
> **leafpeepr**: an R package for producing raking targets from census
> microdata

**leafpeepr** prepares census microdata to be used for weighting targets
with raking packages like
[**autumn**](https://github.com/aaronrudkin/autumn).

## Installation

``` r
# install.packages("remotes")
remotes::install_github("rossellhayes/leafpeepr")
```

## Usage

Let’s get an example dataset of census microdata ready to be used as
targets for raking.

``` r
library(leafpeepr)
acs_md
#> # A tibble: 59,840 x 7
#>   PERWT   SEX   AGE  RACE HISPAN   BPL  EDUC
#>   <dbl> <dbl> <dbl> <dbl>  <dbl> <dbl> <dbl>
#> 1    36     1    54     1      0     6    11
#> 2    30     2    67     1      0    44    11
#> 3   179     1    39     2      0    48    10
#> 4    75     1    77     2      0    24    10
#> 5    88     1    57     1      0    24     6
#> # ... with 5.984e+04 more rows
```

### Recoding

`leaf_recode()` recodes columns using a data frame as a map.

``` r
acs_race_codes
#>   code       RACE
#> 1    1      White
#> 2    2      Black
#> 3    3       AIAN
#> 4    4       AAPI
#> 5    5       AAPI
#> 6    6       AAPI
#> 7    7 Other race
#> 8    8 Mixed race
#> 9    9 Mixed race

leaf_recode(acs_md, acs_race_codes)
#> # A tibble: 59,840 x 7
#>   PERWT   SEX   AGE RACE  HISPAN   BPL  EDUC
#>   <dbl> <dbl> <dbl> <chr>  <dbl> <dbl> <dbl>
#> 1    36     1    54 White      0     6    11
#> 2    30     2    67 White      0    44    11
#> 3   179     1    39 Black      0    48    10
#> 4    75     1    77 Black      0    24    10
#> 5    88     1    57 White      0    24     6
#> # ... with 5.984e+04 more rows
```

The recoding map can also use formulas.

``` r
acs_age_codes
#>             code           AGE
#> 1    ~ . <=   17 17 or younger
#> 2 ~ . %in% 18:23         18-23
#> 3 ~ . %in% 24:29         24-29
#> 4 ~ . %in% 30:39         30-39
#> 5 ~ . %in% 40:49         40-49
#> 6 ~ . %in% 50:59         50-59
#> 7 ~ . %in% 60:69         60-69
#> 8    ~ . >=   70   70 or older

leaf_recode(acs_md, acs_age_codes)
#> # A tibble: 59,840 x 7
#>   PERWT   SEX AGE          RACE HISPAN   BPL  EDUC
#>   <dbl> <dbl> <chr>       <dbl>  <dbl> <dbl> <dbl>
#> 1    36     1 50-59           1      0     6    11
#> 2    30     2 60-69           1      0    44    11
#> 3   179     1 30-39           2      0    48    10
#> 4    75     1 70 or older     2      0    24    10
#> 5    88     1 50-59           1      0    24     6
#> # ... with 5.984e+04 more rows
```

You can recode multiple columns at once using wide or long data frames.

``` r
acs_codes
#> # A tibble: 12 x 12
#>    code SEX     code RACE   code HISPAN   code EDUC    code   BPL    code  AGE  
#>   <int> <chr>  <int> <chr> <int> <chr>   <int> <chr>   <chr>  <chr>  <chr> <chr>
#> 1     1 Male       1 White     0 Not Hi~     0 Non-hi~ ~ . <~ Unite~ ~ . ~ 17 o~
#> 2     2 Female     2 Black     1 Hispan~     1 Non-hi~ ~ . >~ Anoth~ ~ . ~ 18-23
#> 3    NA <NA>       3 AIAN      2 Hispan~     2 Non-hi~ <NA>   <NA>   ~ . ~ 24-29
#> 4    NA <NA>       4 AAPI      3 Hispan~     3 Non-hi~ <NA>   <NA>   ~ . ~ 30-39
#> 5    NA <NA>       5 AAPI      4 Hispan~     4 Non-hi~ <NA>   <NA>   ~ . ~ 40-49
#> # ... with 7 more rows
leaf_recode(acs_md, acs_codes)
#> # A tibble: 59,840 x 7
#>   PERWT SEX    AGE         RACE  HISPAN       BPL           EDUC                
#>   <dbl> <chr>  <chr>       <chr> <chr>        <chr>         <chr>               
#> 1    36 Male   50-59       White Not Hispanic United States College graduate    
#> 2    30 Female 60-69       White Not Hispanic United States College graduate    
#> 3   179 Male   30-39       Black Not Hispanic United States College graduate    
#> 4    75 Male   70 or older Black Not Hispanic United States College graduate    
#> 5    88 Male   50-59       White Not Hispanic United States High school graduate
#> # ... with 5.984e+04 more rows

acs_codes_long
#> # A tibble: 39 x 3
#>   variable code  value 
#>   <chr>    <chr> <chr> 
#> 1 SEX      1     Male  
#> 2 SEX      2     Female
#> 3 RACE     1     White 
#> 4 RACE     2     Black 
#> 5 RACE     3     AIAN  
#> # ... with 34 more rows
leaf_recode(acs_md, acs_codes_long)
#> # A tibble: 59,840 x 7
#>   PERWT SEX    AGE         RACE  HISPAN       BPL           EDUC                
#>   <dbl> <chr>  <chr>       <chr> <chr>        <chr>         <chr>               
#> 1    36 Male   50-59       White Not Hispanic United States College graduate    
#> 2    30 Female 60-69       White Not Hispanic United States College graduate    
#> 3   179 Male   30-39       Black Not Hispanic United States College graduate    
#> 4    75 Male   70 or older Black Not Hispanic United States College graduate    
#> 5    88 Male   50-59       White Not Hispanic United States High school graduate
#> # ... with 5.984e+04 more rows
```

### Creating interaction variables

`leaf_interact()` creates an interaction between two variables.

``` r
acs_md_recoded <- leaf_recode(acs_md, acs_codes) %>% 
  janitor::clean_names() #Make column names nicer to look at

leaf_interact(acs_md_recoded, race, hispan)
#> # A tibble: 59,840 x 8
#>   perwt sex    age       race  hispan    bpl       educ         race_x_hispan   
#>   <dbl> <chr>  <chr>     <chr> <chr>     <chr>     <chr>        <chr>           
#> 1    36 Male   50-59     White Not Hisp~ United S~ College gra~ White x Not His~
#> 2    30 Female 60-69     White Not Hisp~ United S~ College gra~ White x Not His~
#> 3   179 Male   30-39     Black Not Hisp~ United S~ College gra~ Black x Not His~
#> 4    75 Male   70 or ol~ Black Not Hisp~ United S~ College gra~ Black x Not His~
#> 5    88 Male   50-59     White Not Hisp~ United S~ High school~ White x Not His~
#> # ... with 5.984e+04 more rows
```

`leaf_interactions()` creates multiple interactions at once using a
list.

``` r
leaf_interactions(acs_md_recoded, c("race", "educ"), c("sex", "age"))
#> # A tibble: 59,840 x 9
#>   perwt sex    age     race  hispan   bpl    educ     race_x_educ    sex_x_age  
#>   <dbl> <chr>  <chr>   <chr> <chr>    <chr>  <chr>    <chr>          <chr>      
#> 1    36 Male   50-59   White Not His~ Unite~ College~ White x Colle~ Male x 50-~
#> 2    30 Female 60-69   White Not His~ Unite~ College~ White x Colle~ Female x 6~
#> 3   179 Male   30-39   Black Not His~ Unite~ College~ Black x Colle~ Male x 30-~
#> 4    75 Male   70 or ~ Black Not His~ Unite~ College~ Black x Colle~ Male x 70 ~
#> 5    88 Male   50-59   White Not His~ Unite~ High sc~ White x High ~ Male x 50-~
#> # ... with 5.984e+04 more rows
```

`leaf_interact_all()` creates interactions between one variable and all
other variables.

``` r
leaf_interact_all(acs_md_recoded, sex, except = perwt)
#> # A tibble: 59,840 x 12
#>   perwt sex   age   race  hispan bpl   educ  age_x_sex race_x_sex hispan_x_sex
#>   <dbl> <chr> <chr> <chr> <chr>  <chr> <chr> <chr>     <chr>      <chr>       
#> 1    36 Male  50-59 White Not H~ Unit~ Coll~ 50-59 x ~ White x M~ Not Hispani~
#> 2    30 Fema~ 60-69 White Not H~ Unit~ Coll~ 60-69 x ~ White x F~ Not Hispani~
#> 3   179 Male  30-39 Black Not H~ Unit~ Coll~ 30-39 x ~ Black x M~ Not Hispani~
#> 4    75 Male  70 o~ Black Not H~ Unit~ Coll~ 70 or ol~ Black x M~ Not Hispani~
#> 5    88 Male  50-59 White Not H~ Unit~ High~ 50-59 x ~ White x M~ Not Hispani~
#> # ... with 5.984e+04 more rows, and 2 more variables: bpl_x_sex <chr>,
#> #   educ_x_sex <chr>
```

### Generating a target data frame

Once our data is recoded, `leaf_peep()` prepares it to be used as
weighting targets in `autumn::harvest()`

``` r
acs_md_interacted <- leaf_interactions(
  acs_md_recoded, c("race", "educ"), c("sex", "age")
)

leaf_peep(acs_md_interacted, weight_col = perwt)
#> # A tibble: 64 x 3
#>   variable level         proportion
#>   <chr>    <chr>              <dbl>
#> 1 sex      Female            0.517 
#> 2 sex      Male              0.483 
#> 3 age      17 or younger     0.224 
#> 4 age      18-23             0.0766
#> 5 age      24-29             0.0826
#> # ... with 59 more rows
```

### Collapsing categories

`leaf_other()` recategorizes levels into an other category if their
proportion is below a certain cutoff.

``` r
acs_md_targets <- leaf_peep(acs_md_interacted, weight_col = perwt)

dplyr::arrange(acs_md_targets, proportion)
#> # A tibble: 64 x 3
#>    variable    level                             proportion
#>    <chr>       <chr>                                  <dbl>
#>  1 race_x_educ AIAN x Some college                 0.000386
#>  2 race_x_educ AIAN x Non-high school graduate     0.000432
#>  3 race_x_educ AIAN x College graduate             0.000499
#>  4 race_x_educ AIAN x High school graduate         0.000505
#>  5 race        AIAN                                0.00182 
#>  6 race_x_educ Other race x College graduate       0.00441 
#>  7 race_x_educ Mixed race x Some college           0.00517 
#>  8 race_x_educ Other race x Some college           0.00534 
#>  9 race_x_educ Mixed race x High school graduate   0.00667 
#> 10 race_x_educ Mixed race x College graduate       0.00751 
#> # ... with 54 more rows

leaf_other(acs_md_targets, 0.01) %>% 
  dplyr::arrange(proportion)
#> # A tibble: 53 x 3
#>    variable    level                                 proportion
#>    <chr>       <chr>                                      <dbl>
#>  1 race_x_educ Other race x High school graduate         0.0104
#>  2 race_x_educ AAPI x Non-high school graduate           0.0158
#>  3 race_x_educ Mixed race x Non-high school graduate     0.0174
#>  4 race_x_educ Other race x Non-high school graduate     0.0285
#>  5 race_x_educ AAPI x College graduate                   0.0300
#>  6 sex_x_age   Female x 18-23                            0.0366
#>  7 race        Other                                     0.0386
#>  8 sex_x_age   Male x 18-23                              0.0399
#>  9 sex_x_age   Male x 24-29                              0.0410
#> 10 sex_x_age   Female x 24-29                            0.0416
#> # ... with 43 more rows
```

If the other category would itself be under the cutoff proportion, the
next smallest level is added to the other category. To avoid this, set
`inclusive = FALSE`.

``` r
leaf_other(acs_md_targets, 0.01, inclusive = FALSE) %>% 
  dplyr::arrange(proportion)
#> # A tibble: 54 x 3
#>    variable    level                                 proportion
#>    <chr>       <chr>                                      <dbl>
#>  1 race        Other                                    0.00182
#>  2 race_x_educ Other race x High school graduate        0.0104 
#>  3 race_x_educ AAPI x Non-high school graduate          0.0158 
#>  4 race_x_educ Mixed race x Non-high school graduate    0.0174 
#>  5 race_x_educ Other race x Non-high school graduate    0.0285 
#>  6 race_x_educ AAPI x College graduate                  0.0300 
#>  7 sex_x_age   Female x 18-23                           0.0366 
#>  8 race        Mixed race                               0.0368 
#>  9 sex_x_age   Male x 18-23                             0.0399 
#> 10 sex_x_age   Male x 24-29                             0.0410 
#> # ... with 44 more rows
```

## Credits

Hex sticker font is [Source Code
Pro](https://github.com/adobe-fonts/source-code-pro) by
[Adobe](https://adobe.com).

Image adapted from
[publicdomainvectors.org](https://publicdomainvectors.org/en/free-clipart/Autumn-leaves-vector-background/64717.html)
and [Twemoji](https://github.com/twitter/twemoji) by
[Twitter](https://twitter.com).

-----

Please note that **leafpeepr** is released with a [Contributor Code of
Conduct](https://www.contributor-covenant.org/version/2/0/code_of_conduct/).
