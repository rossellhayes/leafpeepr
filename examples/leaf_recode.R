# A data frame of encoded data
acs_nh

# A data frame of recode values
acs_sex_codes

#Recode
leaf_recode(acs_nh, acs_sex_codes)

# You can also specify recoding using formulas
acs_bpl_codes
leaf_recode(acs_nh, acs_bpl_codes)

# Or a mix of values and formulas
acs_educ_codes
leaf_recode(acs_nh, acs_educ_codes)

# You can use also use a data frame with recode values for multiple columns
# Either a wide data frame
acs_codes
leaf_recode(acs_nh, acs_codes)

# Or a long data frame
acs_codes_long
leaf_recode(acs_nh, acs_codes_long)
