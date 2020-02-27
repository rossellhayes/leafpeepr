
<!-- README.md is generated from README.Rmd. Please edit that file -->

# leafpeepr <img src="man/figures/logo.png?raw=TRUE" align="right" height="138" />

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![License:
MIT](https://img.shields.io/badge/license-MIT-blueviolet.svg)](https://opensource.org/licenses/MIT)
[![Travis build
status](https://travis-ci.org/rossellhayes/leafpeepr.svg?branch=master)](https://travis-ci.org/rossellhayes/leafpeepr)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/rossellhayes/leafpeepr?branch=master&svg=true)](https://ci.appveyor.com/project/rossellhayes/leafpeepr)
<!-- badges: end -->

> *‘I’m sorry, leaf peeping? Is that something we do now?’* – [President
> Jed Bartlet, *The West Wing*](https://youtube.com/watch?v=0gL3Jh_-cpw)

**leafpeepr** prepares data for weighting with raking packages like
[**autumn**](https://github.com/aaronrudkin/autumn). It creates
weighting targets from census microdata. It can also recode values and
collapse values into an *other* category in both census data and survey
data.

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
acs_nh
#> # A tibble: 13,780 x 7
#>   PERWT   SEX   AGE  RACE HISPAN   BPL  EDUC
#>   <dbl> <dbl> <dbl> <dbl>  <dbl> <dbl> <dbl>
#> 1   124     2    57     1      0    36     8
#> 2    18     2    35     1      0    33    10
#> 3   104     2    15     1      0    33     3
#> 4   213     2    31     1      0    25    10
#> 5   182     1    52     1      0   410    10
#> # ... with 1.378e+04 more rows
```

### Recoding

`leaf_recode()` recodes columns using a data frame as a map.

``` r
acs_sex_codes
#> # A tibble: 2 x 2
#>    code SEX   
#>   <dbl> <chr> 
#> 1     1 Male  
#> 2     2 Female

leaf_recode(acs_nh, acs_sex_codes)
#> # A tibble: 13,780 x 7
#>   PERWT SEX      AGE  RACE HISPAN   BPL  EDUC
#>   <dbl> <chr>  <dbl> <dbl>  <dbl> <dbl> <dbl>
#> 1   124 Female    57     1      0    36     8
#> 2    18 Female    35     1      0    33    10
#> 3   104 Female    15     1      0    33     3
#> 4   213 Female    31     1      0    25    10
#> 5   182 Male      52     1      0   410    10
#> # ... with 1.378e+04 more rows
```

The recoding map can also use formulas.

``` r
acs_bpl_codes
#> # A tibble: 2 x 2
#>   code       BPL            
#>   <chr>      <chr>          
#> 1 ~ . <  120 United States  
#> 2 ~ . >= 120 Another country

leaf_recode(acs_nh, acs_bpl_codes)
#> # A tibble: 13,780 x 7
#>   PERWT   SEX   AGE  RACE HISPAN BPL              EDUC
#>   <dbl> <dbl> <dbl> <dbl>  <dbl> <chr>           <dbl>
#> 1   124     2    57     1      0 United States       8
#> 2    18     2    35     1      0 United States      10
#> 3   104     2    15     1      0 United States       3
#> 4   213     2    31     1      0 United States      10
#> 5   182     1    52     1      0 Another country    10
#> # ... with 1.378e+04 more rows
```

Or a combination of values and formulas.

``` r
acs_educ_codes
#> # A tibble: 4 x 2
#>   code           EDUC                    
#>   <chr>          <chr>                   
#> 1 ~ . %in%   0:5 Non-high school graduate
#> 2 6              High school graduate    
#> 3 ~ . %in%   7:9 Some college            
#> 4 ~ . %in% 10:11 College graduate

leaf_recode(acs_nh, acs_educ_codes)
#> # A tibble: 13,780 x 7
#>   PERWT   SEX   AGE  RACE HISPAN   BPL EDUC                    
#>   <dbl> <dbl> <dbl> <dbl>  <dbl> <dbl> <chr>                   
#> 1   124     2    57     1      0    36 Some college            
#> 2    18     2    35     1      0    33 College graduate        
#> 3   104     2    15     1      0    33 Non-high school graduate
#> 4   213     2    31     1      0    25 College graduate        
#> 5   182     1    52     1      0   410 College graduate        
#> # ... with 1.378e+04 more rows
```

You can recode multiple columns at once using wide or long data frames.

``` r
acs_codes
#> # A tibble: 8 x 12
#>    code SEX    code   RACE   code   HISPAN  code  EDUC   code  BPL   code  AGE  
#>   <dbl> <chr>  <chr>  <chr>  <chr>  <chr>   <chr> <chr>  <chr> <chr> <chr> <chr>
#> 1     1 Male   1      White  0      Not Hi~ ~ . ~ Non-h~ ~ . ~ Unit~ ~ . ~ 17 o~
#> 2     2 Female 2      Black  ~ . %~ Hispan~ 6     High ~ ~ . ~ Anot~ ~ . ~ 18-23
#> 3    NA <NA>   3      AIAN   9      <NA>    ~ . ~ Some ~ <NA>  <NA>  ~ . ~ 24-29
#> 4    NA <NA>   ~ . %~ AAPI   <NA>   <NA>    ~ . ~ Colle~ <NA>  <NA>  ~ . ~ 30-39
#> 5    NA <NA>   7      Other~ <NA>   <NA>    <NA>  <NA>   <NA>  <NA>  ~ . ~ 40-49
#> # ... with 3 more rows
leaf_recode(acs_nh, acs_codes)
#> # A tibble: 13,780 x 7
#>   PERWT SEX    AGE          RACE  HISPAN      BPL           EDUC                
#>   <dbl> <chr>  <chr>        <chr> <chr>       <chr>         <chr>               
#> 1   124 Female 50-59        White Not Hispan~ United States Some college        
#> 2    18 Female 30-39        White Not Hispan~ United States College graduate    
#> 3   104 Female 17 or young~ White Not Hispan~ United States Non-high school gra~
#> 4   213 Female 30-39        White Not Hispan~ United States College graduate    
#> 5   182 Male   50-59        White Not Hispan~ Another coun~ College graduate    
#> # ... with 1.378e+04 more rows

acs_codes_long
#> # A tibble: 25 x 3
#>   variable code  value 
#>   <chr>    <chr> <chr> 
#> 1 SEX      1     Male  
#> 2 SEX      2     Female
#> 3 RACE     1     White 
#> 4 RACE     2     Black 
#> 5 RACE     3     AIAN  
#> # ... with 20 more rows
leaf_recode(acs_nh, acs_codes_long)
#> # A tibble: 13,780 x 7
#>   PERWT SEX    AGE          RACE  HISPAN      BPL           EDUC                
#>   <dbl> <chr>  <chr>        <chr> <chr>       <chr>         <chr>               
#> 1   124 Female 50-59        White Not Hispan~ United States Some college        
#> 2    18 Female 30-39        White Not Hispan~ United States College graduate    
#> 3   104 Female 17 or young~ White Not Hispan~ United States Non-high school gra~
#> 4   213 Female 30-39        White Not Hispan~ United States College graduate    
#> 5   182 Male   50-59        White Not Hispan~ Another coun~ College graduate    
#> # ... with 1.378e+04 more rows
```

### Creating interaction variables

`leaf_interact()` creates an interaction between two variables.

``` r
acs_nh_recoded <- leaf_recode(acs_nh, acs_codes) %>% 
  janitor::clean_names() #Make column names nicer to look at

leaf_interact(acs_nh_recoded, race, hispan)
#> # A tibble: 13,780 x 8
#>   perwt sex    age       race  hispan   bpl       educ          race_x_hispan   
#>   <dbl> <chr>  <chr>     <chr> <chr>    <chr>     <chr>         <chr>           
#> 1   124 Female 50-59     White Not His~ United S~ Some college  White x Not His~
#> 2    18 Female 30-39     White Not His~ United S~ College grad~ White x Not His~
#> 3   104 Female 17 or yo~ White Not His~ United S~ Non-high sch~ White x Not His~
#> 4   213 Female 30-39     White Not His~ United S~ College grad~ White x Not His~
#> 5   182 Male   50-59     White Not His~ Another ~ College grad~ White x Not His~
#> # ... with 1.378e+04 more rows
```

`leaf_interactions()` creates multiple interactions at once using a
list.

``` r
leaf_interactions(acs_nh_recoded, c("race", "educ"), c("sex", "age"))
#> # A tibble: 13,780 x 9
#>   perwt sex    age     race  hispan   bpl    educ     race_x_educ    sex_x_age  
#>   <dbl> <chr>  <chr>   <chr> <chr>    <chr>  <chr>    <chr>          <chr>      
#> 1   124 Female 50-59   White Not His~ Unite~ Some co~ White x Some ~ Female x 5~
#> 2    18 Female 30-39   White Not His~ Unite~ College~ White x Colle~ Female x 3~
#> 3   104 Female 17 or ~ White Not His~ Unite~ Non-hig~ White x Non-h~ Female x 1~
#> 4   213 Female 30-39   White Not His~ Unite~ College~ White x Colle~ Female x 3~
#> 5   182 Male   50-59   White Not His~ Anoth~ College~ White x Colle~ Male x 50-~
#> # ... with 1.378e+04 more rows
```

`leaf_interact_all()` creates interactions between one variable and all
other variables.

``` r
leaf_interact_all(acs_nh_recoded, sex, except = perwt)
#> # A tibble: 13,780 x 12
#>   perwt sex   age   race  hispan bpl   educ  age_x_sex race_x_sex hispan_x_sex
#>   <dbl> <chr> <chr> <chr> <chr>  <chr> <chr> <chr>     <chr>      <chr>       
#> 1   124 Fema~ 50-59 White Not H~ Unit~ Some~ 50-59 x ~ White x F~ Not Hispani~
#> 2    18 Fema~ 30-39 White Not H~ Unit~ Coll~ 30-39 x ~ White x F~ Not Hispani~
#> 3   104 Fema~ 17 o~ White Not H~ Unit~ Non-~ 17 or yo~ White x F~ Not Hispani~
#> 4   213 Fema~ 30-39 White Not H~ Unit~ Coll~ 30-39 x ~ White x F~ Not Hispani~
#> 5   182 Male  50-59 White Not H~ Anot~ Coll~ 50-59 x ~ White x M~ Not Hispani~
#> # ... with 1.378e+04 more rows, and 2 more variables: bpl_x_sex <chr>,
#> #   educ_x_sex <chr>
```

### Generating a target data frame

Once our data is recoded, `leaf_peep()` prepares it to be used as
weighting targets in `autumn::harvest()`

``` r
acs_nh_interacted <- leaf_interactions(
  acs_nh_recoded, c("race", "educ"), c("sex", "age")
)

leaf_peep(acs_nh_interacted, weight_col = perwt)
#> # A tibble: 64 x 3
#>   variable level         proportion
#>   <chr>    <chr>              <dbl>
#> 1 sex      Female            0.502 
#> 2 sex      Male              0.498 
#> 3 age      17 or younger     0.183 
#> 4 age      18-23             0.0825
#> 5 age      24-29             0.0729
#> # ... with 59 more rows
```

### Collapsing categories

`leaf_other()` recategorizes levels into an other category if their
proportion is below a certain cutoff.

``` r
acs_nh_targets <- leaf_peep(acs_nh_interacted, weight_col = perwt)

dplyr::arrange(acs_nh_targets, proportion)
#> # A tibble: 64 x 3
#>    variable    level                                 proportion
#>    <chr>       <chr>                                      <dbl>
#>  1 race_x_educ AIAN x Non-high school graduate         0.000280
#>  2 race_x_educ AIAN x High school graduate             0.000469
#>  3 race_x_educ AIAN x Some college                     0.000626
#>  4 race_x_educ Other race x Some college               0.000830
#>  5 race_x_educ AIAN x College graduate                 0.000881
#>  6 race_x_educ Other race x College graduate           0.00110 
#>  7 race_x_educ Other race x High school graduate       0.00158 
#>  8 race        AIAN                                    0.00226 
#>  9 race_x_educ Other race x Non-high school graduate   0.00256 
#> 10 race_x_educ Black x College graduate                0.00261 
#> # ... with 54 more rows

leaf_other(acs_nh_targets, 0.01) %>% 
  dplyr::arrange(proportion)
#> # A tibble: 44 x 3
#>    variable    level                   proportion
#>    <chr>       <chr>                        <dbl>
#>  1 race_x_educ AAPI x College graduate     0.0127
#>  2 race        Mixed race                  0.0208
#>  3 race        Other                       0.0229
#>  4 race        AAPI                        0.0311
#>  5 sex_x_age   Female x 24-29              0.0358
#>  6 sex_x_age   Male x 24-29                0.0371
#>  7 hispan      Hispanic                    0.0386
#>  8 sex_x_age   Male x 18-23                0.0402
#>  9 sex_x_age   Female x 18-23              0.0423
#> 10 sex_x_age   Male x 70 or older          0.0524
#> # ... with 34 more rows
```

If the other category would itself be under the cutoff proportion, the
next smallest level is added to the other category. To avoid this, set
`inclusive = FALSE`.

``` r
leaf_other(acs_nh_targets, 0.01, inclusive = FALSE) %>% 
  dplyr::arrange(proportion)
#> # A tibble: 45 x 3
#>    variable    level                   proportion
#>    <chr>       <chr>                        <dbl>
#>  1 race        Other                      0.00833
#>  2 race_x_educ AAPI x College graduate    0.0127 
#>  3 race        Black                      0.0146 
#>  4 race        Mixed race                 0.0208 
#>  5 race        AAPI                       0.0311 
#>  6 sex_x_age   Female x 24-29             0.0358 
#>  7 sex_x_age   Male x 24-29               0.0371 
#>  8 hispan      Hispanic                   0.0386 
#>  9 sex_x_age   Male x 18-23               0.0402 
#> 10 sex_x_age   Female x 18-23             0.0423 
#> # ... with 35 more rows
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
