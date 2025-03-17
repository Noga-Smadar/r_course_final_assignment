# R course for beginners
# Final assignment by Noga Smadar
# Part 2: creating a function to calculate subjects' ratings' abs. distances from the IADS standard
# For section B3 in the final assignment

compute_distance <- function(df, iads, col_name, id_col_df, id_col_iads) {
  
  
  stimulus_id <- str_remove_all(col_name, "^SAM\\.[0-9]+\\.\\.|_2_1$")
  
  
  standard_score <- iads |>
    filter(!!sym(id_col_iads) == stimulus_id) |>
    pull(stimulus_id)
  
  
  new_col_name <- paste0(stimulus_id, "_distance")
  
  df <- df |>
    mutate(!!new_col_name := ifelse(is.na(!!sym(col_name)), NA, abs(!!sym(col_name) - standard_score))) |>
    relocate(!!new_col_name, .after = !!sym(col_name))
  
  return(df)
}

