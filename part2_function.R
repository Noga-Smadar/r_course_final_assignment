# R course for beginners
# Final assignment by Noga Smadar
# Part 2: Creating functions
# Section B3 in the assignment

# a function to calculate subjects' ratings' abs. distances from the IADS standard
compute_distance <- function(df, iads, col_name, id_col_df, id_col_iads) {
  
  
  stimulus_id <- str_remove_all(col_name, "^SAM\\.[0-9]+\\.\\.|_2_1$")
  serial_num <- str_remove_all(col_name, "^SAM\\.|_2_1$")
  
  standard_score <- iads |>
    filter(!!sym(id_col_iads) == stimulus_id) |>
    pull(stimulus_id)
  
  
  new_col_name <- paste0("distance_", serial_num)
  
  df <- df |>
    mutate(!!new_col_name := ifelse(is.na(!!sym(col_name)), NA, abs(!!sym(col_name) - standard_score))) |>
    relocate(!!new_col_name, .after = !!sym(col_name))
  
  return(df)
}

# a function to add mean and var columns for specific ranges in the df
add_mean_var <- add_mean_var <- function(df, col_range, range_name) {
  mean_col_name <- paste0("mean_", range_name)
  var_col_name <- paste0("var_", range_name)
  
  df[[mean_col_name]] <- rowMeans(df[, col_range], na.rm = TRUE)
  df[[var_col_name]] <- apply(df[, col_range], 1, var, na.rm = TRUE)
  
  return(df)
}

