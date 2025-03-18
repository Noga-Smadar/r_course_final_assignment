# R course for beginners
# Final assignment by Noga Smadar
# Part 1: Processing the data 
# Sections B2+3+4 of the assignment

#### PREPARATION ----
library(dplyr)
library(stringr)

# load collected data into a dataframe
df <- read.csv("qualtrics_data.csv")

# load the sound effects' International Affective Digitized Sounds system ratings

iads <- read.csv("database_valence_ratings.csv")

# load demographic data

demographics <- read.csv("./demographics.csv")

#### BASIC ORGANIZATION OF THE DATASET ----

# omit rows from preview sessions and a subject who experienced technical difficulties
df <- df[-c(1, 2, 3, 5, 6, 192),]

# select only relevant columns
df <- df |>
  dplyr::select(subID = Prolific.ID, 
                matches("SAM"), 
                -matches("Timing"), 
                -matches("Practice"),
                attention_choose_1 = Attention.check.1_1,
                attention_choose_6 = Attention.check.2_1,
                matches("OCI.R"),
                matches("DASS"))

# add demographics
df <- df |>
  left_join(demographics, by = "subID") 

# turn "10" ratings on the SAMs into NA
# 10 ratings stand for "i did not hear a sound". 
# (we added this option to account for cases where subjects missed a sound)
df[df == 10] <- NA

# change OCI-R items column titles, change their classes from "character" to "numeric" 
df <- df |>
  rename(OCI1 = OCI.R.1_1, OCI2 = OCI.R.1_2, OCI3 = OCI.R.1_3, 
         OCI_infrequency_poodle = OCI.R.1_4, OCI4 = OCI.R.1_5, 
         OCI5 = OCI.R.2_1, OCI6 = OCI.R.2_2, OCI7 = OCI.R.2_3, 
         OCI8 = OCI.R.2_4, OCI9 = OCI.R.2_5, OCI10 = OCI.R.3_1, 
         OCI11 = OCI.R.3_2, OCI12 = OCI.R.3_3,OCI13 = OCI.R.3_4, 
         OCI14 = OCI.R.3_5, OCI_infrequency_beans = OCI.R.4_1, 
         OCI15 = OCI.R.4_2, OCI16 = OCI.R.4_3, OCI17 = OCI.R.4_4, 
         OCI18 = OCI.R.4_5) |>
  mutate(across(matches("OCI"), as.numeric))

# similar process for the DASS columns
df <- df |> 
  rename(DASS1_anx = DASS.1_1, DASS2_dep = DASS.1_2, 
         DASS3_anx = DASS.1_3, DASS4_dep = DASS.1_4, 
         DASS_infrequency_world = DASS.1_5,
         DASS5_anx = DASS.1_6,DASS6_anx = DASS.1_7, DASS7_dep = DASS.1_8,
         DASS8_dep = DASS.2_1, DASS9_anx = DASS.2_2, 
         DASS10_dep = DASS.2_3, DASS11_dep = DASS.2_4,
         DASS_infrequency_leprechuans = DASS.2_5,
         DASS12_anx = DASS.2_6, DASS13_anx = DASS.2_7, DASS14_dep = DASS.2_8) |>
  mutate(across(matches("DASS"), as.numeric))

# change valence ratings columns from "character" to "numeric" 

df <- df |>
  mutate(across(matches("SAM"), as.numeric))


# reorganize the IADS data for comfort 
iads <- iads |>
  dplyr::select(-X)

iads <- 
  pivot_wider(iads, names_from = sound_id, values_from = valence)



#### CALCULATE POTENTIAL VARIABLES ----

# apply a function that adds a column of subjects' ratings abs. distances from the IADS standard 
# This covers the requirement to apply a function we wrote (B3)
# See the function itself in part 2

# call function
source("part2_function.R")

# try using the "rex" package for a more readable grepl equivalent
library(rex)
sam_columns <- names(df)[re_matches(names(df), rex("SAM."))]

# apply function
for (col in sam_columns) {
  df <- compute_distance(df, iads, col, "stimulus_id", "stimulus_id")
}


# questionnaire scores: sum items, without infrequency items
df <- df |> 
  rowwise() |>
  mutate(OCI_R = sum(c_across(contains("OCI") &
                                !contains("infrequency")), na.rm = TRUE),
         DASS_anxiety = sum(c_across(contains("anx")), na.rm = TRUE),
         DASS_depression = sum(c_across(contains("dep")), na.rm = TRUE)
  )


# Means and variances of valence ratings and distances
# calculate means for positive and negative sounds separately
# application of the add_mean_var function
# See the function itself in part 2

sam_positive_cols <- names(df)[re_matches(names(df), rex("SAM.", or(seq(1,30,1)), "."))]
sam_negative_cols <- names(df)[re_matches(names(df), rex("SAM.", or(seq(31,60,1)), "."))]
distance_cols <- names(df)[re_matches(names(df), rex("distance_"))]
distance_pos_cols <- names(df)[re_matches(names(df), rex("distance_", or(seq(1,30,1)), "."))]
distance_neg_cols <- names(df)[re_matches(names(df), rex("distance_", or(seq(31,60,1)), "."))]

df <- add_mean_var(df, sam_columns, "valence")
df <- add_mean_var(df, sam_positive_cols, "pos")
df <- add_mean_var(df, sam_negative_cols, "neg")
df <- add_mean_var(df, distance_cols, "dis")
df <- add_mean_var(df, distance_pos_cols, "dis_pos")
df <- add_mean_var(df, distance_neg_cols, "dis_neg")


# create a variable for rate of extreme responses

  # call purrr to later use the map_dbl function
library(purrr)


  # calculate a threshold for each column
thresholds <- setNames(
sapply(distance_cols, function(col) mean(df[[col]], na.rm = TRUE) + sd(df[[col]], na.rm = TRUE)),
distance_cols
)

  # create new columns with binary scores for individual ratings
for (col in distance_cols) {
  df[[paste0(col, "_extremist")]] <- ifelse(df[[col]] > thresholds[col], 1, 0)
}

  # calculate the rate of extreme responses
binary_cols <- names(df)[re_matches(names(df), rex("_extremist"))]
df$ext_rate <- as.numeric(rowMeans(df[binary_cols], na.rm = TRUE))


#### EXCLUDE INATTENTIVE RESPONDERS ----

df <- df |>
  filter(!if_any(matches("infrequency_"), ~ .x > 0)) |>
  filter(attention_choose_1 == 1) |>
  filter(attention_choose_6 == 6) 

#### SAVE PROCESSED DATASET ----

write.csv(df, "./processed_data.csv")

save(df, file = "processed_data.RDATA")






