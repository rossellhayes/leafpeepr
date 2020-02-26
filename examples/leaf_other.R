# Set up an example data frame with some very small levels
df <- dplyr::tibble(
  variable   = c(rep("letter", 4), rep("number", 4)),
  level      = c(letters[1:4], 1:4),
  proportion = c(0.6, 0.395, 0.0045, 0.0045, 0.6, 0.395, 0.0055, 0.0035)
)

# Consolidate small categories so that all values are above the cutoff
leaf_other(df, cutoff = 0.005)

# You can give a different name to the other category
leaf_other(df, cutoff = 0.005, other = "REDACTED")
leaf_other(df, cutoff = 0.005, other = NA)

# If the other category is smaller than the cutoff, leaf_other() will convert
# the next smallest value to other, even if it is larger than the cutoff.
# Use `inclusive = FALSE` to only convert categories smaller than the cutoff.
leaf_other(df, cutoff = 0.005, inclusive = FALSE)
