# Load a dataset of example microdata
acs_nh

# Generate weighting targets
leaf_peep(acs_nh)

# Microdata with a weights column
leaf_peep(acs_nh, weight_col = "PERWT")
leaf_peep(acs_nh, weight_col = PERWT)
