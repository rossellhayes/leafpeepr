# Load a dataset of example microdata
acs_md

# Generate weighting targets
leaf_peep(acs_md)

# Microdata with a weights column
leaf_peep(acs_md, weight_col = "PERWT")
