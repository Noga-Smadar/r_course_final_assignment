# R course for beginners
# Final assignment by Noga Smadar
# Part 4: Additional Processing
# Addition to section B2 in the assignment

# prepare
load("processed_data.RDATA")

library(dplyr)

# create a group variable with the most positive and negative raters 
# based on top/bottom mean valence quartiles 
df$quartile <- cut(df$mean_valence, 
                    breaks = quantile(df$mean_valence, probs = c(0, 0.25, 0.5, 0.75, 1), na.rm = TRUE), 
                    labels = c(1, 2, 3, 4), 
                    include.lowest = TRUE)
df_log <- df |>
  filter(quartile != 2, quartile != 3) |>
  select(OCI_R, DASS_anxiety, DASS_depression, mean_valence, quartile) |>
  mutate(low_val_group = ifelse(quartile == 1, 1, 0)) 

save(df_log, file = "df_log.RDATA")

# scale variables since they differ in range, for more intuitive interpertation

df$ocir_z = scale(df$OCI_R)
df$dass_anx_z = scale(df$DASS_anxiety)
df$dass_dep_z = scale(df$DASS_depression)
df$mean_dis_z = scale(df$mean_dis)

df_linear <- df |>
  select(ocir_z, dass_anx_z, dass_dep_z, mean_dis_z) 

save(df_linear, file = "df_linear.RDATA")
