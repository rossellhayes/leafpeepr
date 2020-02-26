list_of_lists      <- list(as.list(letters[1:4]), as.list(1:4))
list_of_characters <- list(letters[1:4], LETTERS[1:4])
list_of_integers   <- list(1:4, 5:8)

# Test if all elements of a list are lists
is_list_of_lists(list_of_lists)
is_list_of_lists(list_of_characters)
is_list_of_lists(list_of_integers)

# Test if all elements of a list are character vectors
is_list_of_characters(list_of_lists)
is_list_of_characters(list_of_characters)
is_list_of_characters(list_of_integers)

# Use any test function to test all elements of a list...
# ... with a function name
is_list_of(list_of_integers, is.integer)
# ... an anonymous function
is_list_of(list_of_integers, function(x) all(x %% 1 == 0))
# ... or a purrr-style lambda
is_list_of(list_of_integers, ~ all(. %% 1 == 0))

# All functions give a warning and return FALSE if their input is not a list
is_list_of_lists(1:4)
is_list_of_characters(1:4)
is_list_of(1:4, is.integer)
