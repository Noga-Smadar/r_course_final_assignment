# R course for beginners
# Final assignment by Noga Smadar
# Part 5: analysis
# Section C in the assignment

#### PREPARATION ----
load("df_log.RDATA")
load("df_linear.RDATA")

library(lme4)

#### LOGISTIC REGRESSION ----

# check class 
class(df_log$low_val_group) #numeric

# change to factor 
df_log$low_val_group <- as.factor(df_log$low_val_group)

# check
contrasts(df_log$low_val_group) # 0-0 1-1

# regression model
model <- glm(low_val_group ~ OCI_R + DASS_anxiety + DASS_depression, data = df_log, family = binomial)
summary(model)

exp(coef(model))
exp(confint(model))

#### LINEAR REGRESSION ----

model1 <- lm(mean_dis_z ~ ocir_z + dass_anx_z + dass_dep_z, data = df_linear)
summary(model1)


#### PLOT RESULTS ----
library(ggplot2)

#linear regrssion plots

# means for plots
means <- df_log |>
  group_by(low_val_group) |>
  summarise(OCI_R_mean = mean(OCI_R),
            DASS_anxiety_mean = mean(DASS_anxiety),
            DASS_depression_mean = mean(DASS_depression))

# oc symptoms effect 
ggplot(df_log, aes(x = OCI_R, y = low_val_group, color = low_val_group)) +
  geom_jitter(height = 0.05, width = 0, alpha = 0.5) +
  geom_point(data = means, aes(x = OCI_R_mean), color = "red", size = 3, alpha = 0.5) +
  labs(x = "OCI-R score", y = "Negative/Positive mean valence group") +
  theme(legend.position = "none") +
  theme('minimal')

# anxiety symptoms effect
ggplot(df_log, aes(x = DASS_anxiety, y = low_val_group, color = low_val_group)) +
  geom_jitter(height = 0.05, width = 0, alpha = 0.5) +
  geom_point(data = means, aes(x = DASS_anxiety_mean), color = "red", size = 3, alpha = 0.5) +
  labs(x = "DASS Anxiety Score", y = "Negative/Positive mean valence group") +
  theme(legend.position = "none") +
  theme('minimal')

# depression symptoms effect
ggplot(df_log, aes(x = DASS_depression, y = low_val_group, color = low_val_group)) +
  geom_jitter(height = 0.05, width = 0, alpha = 0.5) +
  geom_point(data = means, aes(x = DASS_depression_mean), color = "red", size = 3, alpha = 0.7) +
  labs(x = "DASS Depression Score", y = "Negative/Positive mean valence group") +
  theme(legend.position = "none") +
  theme('minimal')

# linear regression plot

# Reshape data for ggplot

library(dplyr)
df_linear <- df_linear |>
 rename(OC = ocir_z, Anxiety = dass_anx_z, Depression = dass_dep_z)

library(tidyr)
df_linear_long <- pivot_longer(df_linear, cols = c(OC, Anxiety, Depression), names_to = "variable", values_to = "Value")

  
# scatterplot with linear regression trendlines for each effect
ggplot(df_linear_long, aes(x = Value, y = mean_dis_z)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  facet_wrap(~variable, scales = "free_x") +
  labs(y = "mean abs. dis. from norm", x = "Symptoms")

#### ROC ----
library(pROC)

df_log$predict_model <- predict(model, type = "response")

roc_model <- roc(df_log$low_val_group, df_log$predict_model)

# Confusion matrix
threshold <- 0.5
table(Predicted = (df_log$predict_model > threshold)*1, Actual = df_log$low_val_group)

# AUC
auc(roc_model)

# Plot ROC curves
plot(roc_model, col = "blue", main = "ROC Curve")







