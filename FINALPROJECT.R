fastfood <- read.csv("fastfood.csv") # LOADING DATASET
library(tidyverse)
head(fastfood)
summary(fastfood)
str(fastfood)
colSums(is.na(fastfood)) # CHECKING FOR MISSING VALUES
fastfood <- fastfood |> select(-vit_a, -vit_c,-calcium) # REMOVING COLUMNS
fastfood <- fastfood |> filter(!is.na(fiber), !is.na(protein)) # DROPPING ROWS
duplicated_rows <- fastfood[duplicated(fastfood),] # CHECKING FOR DUPLICATES
nrow(duplicated_rows)
fastfood <- fastfood[!duplicated(fastfood), ] # REMOVING DUPLICATES
library(dplyr)
low_cal <- fastfood |> # FILTERING FOR LOW-CALORIE MEALS
  filter(calories < 500)
avg_cal <- fastfood |> # GROUPING BY RESTAURANT TO GET AVG CALS
  group_by(restaurant) |>
  summarise(avg_calories = mean(calories, na.rm = TRUE))
mean(fastfood$calories, na.rm = TRUE) # MEAN CALORIES
sd(fastfood$total_fat, na.rm = TRUE) # STD DEV OF TOTAL FAT
unique(fastfood$restaurant)
# ONE-TAILED T-TEST
# H0: No difference in mean calories between McDonald's and Burger King
# H1: McDonald's meals have higher calories on average than Burger King
mcd <- filter(fastfood, restaurant == "Mcdonalds")
bk <- filter (fastfood, restaurant == "Burger King")
t.test(mcd$calories, bk$calories, alternative = "greater")
# P-value (0.164) > 0.05 — FAILURE TO REJECT H0
# LINEAR REGRESSION # Does total fat predict the number of calories?
model <- lm(calories ~ total_fat, data = fastfood)
summary(model)
ggplot(fastfood %>% filter(restaurant %in% c("Mcdonalds", "Burger King")),
       aes(x = restaurant, y = calories, fill = restaurant)) +
  geom_boxplot() +
  labs(title =  "Calories by Restaurant",
       x = "Restaurant",
       y = "Calories")
ggplot(fastfood, aes(x = total_fat, y = calories)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", color = "blue") +
  labs(title = "Relationship between total fat and calories",
       x = "Total fat (g)",
       y = "Calories")
fastfood %>%
  group_by(restaurant) %>%
  summarize(mean_cals = mean(calories, na.rm = TRUE)) %>%
  ggplot(aes(x = reorder(restaurant, -mean_cals), y = mean_cals, fill = restaurant)) +
  geom_col() +
  labs(title = "Average Calories by Restaurant",
       x = "Restaurant",
       y = "Average Calories")
