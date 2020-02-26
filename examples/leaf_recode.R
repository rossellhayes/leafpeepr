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
