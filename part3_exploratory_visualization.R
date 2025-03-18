# R course for beginners
# Final assignment by Noga Smadar
# Part 3: Exploratory visual presentation of the data 
# Covers sections A2 of the assignment

load("processed_data.RDATA")

library(ggplot2)
library(ggdist)
library(tidyverse)

#### DISTRIBUTIONS OF VALENCE RATING-BASED VARIABLES

# mean distance histogram
ggplot(data = df,
       aes(x = mean_dis)) +
  geom_histogram(fill = 'steelblue2', color = 'steelblue4', binwidth = 0.1)+
  xlab("mean distance") +
  ylab("count") +
  ggtitle("Histogram of mean distance from the IADS standard") +
  theme('classic')

# mean valence dotplot
ggplot(df, aes(x = mean_valence)) + 
  geom_dotplot(fill = "violet")+
  xlim(0,9) +  
  xlab("mean valence rating") +
  ggtitle("Dotplot of Mean Valence Rating") +
  theme('classic')

# transform df to allow comparison between distances for neg / pos stimuli

dis <- df |>
  select(mean_dis, mean_dis_pos, mean_dis_neg) |>
  rename(overall = mean_dis, 
         positive = mean_dis_pos, 
         negative = mean_dis_neg) |>
  pivot_longer(cols = everything(), 
               names_to = "distance_type", 
               values_to = "mean_distance")

# distance by type
ggplot(dis, aes(x = distance_type, y = mean_distance, fill = distance_type, color = distance_type)) +
  stat_halfeye(adjust = 0.5, width = 0.6, justification = -0.4, .width = 0, alpha = 0.5) +
  geom_boxplot(width = 0.2, outlier.shape = NA, alpha = 0.6) +
  geom_jitter(width = 0.2, size = 1.5, alpha = 0.5) +
  theme_minimal() +
  coord_flip() +
  labs(title = "Rainclouds for mean distance by stimuli valence type and overall", x = "type", y = "mean_distance") +
  theme(legend.position = "none")


# extreme response rate dotplot with CI
ggplot(df, aes(x = ext_rate, y = 0)) +
  stat_dotsinterval(
    fill = "sienna1",     
    color = "sienna4",    
    dotsize = 0.6,          
    binwidth = 0.02,      
    slab_alpha = 0.6,     
    interval_size = 1,     
    .width = c(0.5, 0.8, 0.95)
  ) +
  xlab("Extreme Response Rate") +
  ylab("Density + Confidence Intervals") +
  ggtitle("Extreme Response Rate Distribution with Dots and CI") +
  theme_minimal()

#### DISTRIBUTIONS OF QUESTIONNAIRE SCORES 

# obsessive complusive symptoms halfeye
ggplot(df, aes(x = OCI_R)) +
  stat_halfeye(.width = c(0.7, 0.8, 0.9), color = "maroon" ) +
  xlim(0, 100) + 
  ylab("density") +
  ggtitle("Halfeye of OCI-R Scores") +
  theme_classic()


# anxiety histogram with CI
ggplot(df, aes(x = DASS_anxiety)) +
  stat_histinterval(.width = c(0.7, 0.8, 0.9), color = "wheat" ) +
  ggtitle("Anxiety Symptoms Histogram with CI") +
  ylab("density") +
  theme_classic()

# depression eye
ggplot(df, aes(x = DASS_depression)) +
  stat_eye(.width = c(0.7, 0.8, 0.9), color = "wheat" ) +
  ggtitle("Depression Symptoms eye") +
  ylab("density") +
  theme_classic()

#### RELATIONSHIPS ----

# oc and mean valence 
ggplot(data = df,
       aes(x = OCI_R, y = mean_valence)) +
  geom_point(color = 'salmon', size = 0.8)+
  geom_smooth(method = lm, color = 'red3') +
  ggtitle("OC and Mean Valence") +
  theme('minimal')

# anxiety and mean valence
ggplot(data = df,
       aes(x = DASS_anxiety, y = mean_valence)) +
  geom_point(color = 'salmon', size = 0.8)+
  geom_smooth(method = lm, color = 'yellow') +
  ggtitle("Anxiety and Mean Valence") +
  theme('minimal')


# depression and mean valence
ggplot(data = df,
       aes(x = DASS_depression, y = mean_valence)) +
  geom_point(color = 'salmon', size = 0.8)+
  geom_smooth(method = lm, color = 'royalblue') +
  ggtitle("Depression and Mean Valence") +
  theme('minimal')


# OC and mean valence - negative stimuli
ggplot(data = df,
       aes(x = OCI_R, y = mean_neg)) +
  geom_point(color = 'green3', size = 0.8)+
  geom_smooth(method = lm, color = 'red3') +
  ggtitle("OC and Mean Valence - Negative Sounds") +
  theme('minimal')

# anxiety and mean valence - negative stimuli
ggplot(data = df,
       aes(x = DASS_anxiety, y = mean_neg)) +
  geom_point(color = 'green3', size = 0.8)+
  ggtitle("Anxiety and Mean Valence - Negative Sounds") +
  geom_smooth(method = lm, color = 'yellow') +
  theme('minimal')

# depression and mean valence - negative stimuli
ggplot(data = df,
       aes(x = DASS_depression, y = mean_neg)) +
  geom_point(color = 'green3', size = 0.8)+
  geom_smooth(method = lm, color = 'royalblue') +
  ggtitle("Depression and Mean Valence - Negative Sounds") +
  theme('minimal')


# oc and mean devation from norm ratings
ggplot(data = df,
       aes(x = OCI_R, y = mean_dis)) +
  geom_point(color = 'cyan4', size = 0.8)+
  geom_smooth(method = lm, color = 'red3') +
  ggtitle("OC and Mean Absolute Distance from Norm Ratings") +
  theme('minimal')


# anxiety and mean devation from norm ratings
ggplot(data = df,
       aes(x = DASS_anxiety, y = mean_dis)) +
  geom_point(color = 'cyan4', size = 0.8)+
  geom_smooth(method = lm, color = 'yellow') +
  ggtitle("Anxiety and Mean Absolute Distance from Norm Ratings") +
  theme('minimal')

# depression and mean devation from norm ratings
ggplot(data = df,
       aes(x = DASS_depression, y = mean_dis)) +
  geom_point(color = 'cyan4', size = 0.8)+
  geom_smooth(method = lm, color = 'royalblue') +
  ggtitle("Depression and Mean Absolute Distance from Norm Ratings") +
  theme('minimal')




