library(readr)
library(dplyr)

# direkt vom catalog laden
excess_catalog <- read_csv(
  "excess_mortality.csv",
  show_col_types = FALSE
)

glimpse(excess_catalog)
names(excess_catalog)

# wie viele länder haben cum_excess_per_million_proj_all_ages?
excess_catalog |>
  filter(!is.na(cum_excess_per_million_proj_all_ages)) |>
  summarise(
    n_countries = n_distinct(entity),
    date_min = min(date, na.rm = TRUE),
    date_max = max(date, na.rm = TRUE)
  )


library(countrycode)

# excess: nearest to 2023-05-05
excess_snap <- excess_catalog |>
  filter(!is.na(cum_excess_per_million_proj_all_ages)) |>
  mutate(code = countrycode::countrycode(
    entity, "country.name", "iso3c",
    custom_match = c(
      "Kosovo" = "XKX",
      "Micronesia (country)" = "FSM",
      "Virgin Islands" = "VIR",
      "Saint Martin" = "MAF"
    )
  )) |>
  filter(!is.na(code)) |>
  group_by(code) |>
  slice_min(abs(date - as.Date("2023-05-05")), with_ties = FALSE) |>
  ungroup() |>
  select(code, excess_mort = cum_excess_per_million_proj_all_ages)

# strukturelle variablen aus owid compact
owid_struct <- read_csv("owid-covid-data.csv", show_col_types = FALSE) |>
  filter(!startsWith(code, "OWID_")) |>
  group_by(code) |>
  slice_max(date, with_ties = FALSE) |>
  ungroup() |>
  select(code, gdp_per_capita, median_age, life_expectancy,
         diabetes_prevalence, hospital_beds_per_thousand,
         population_density, continent)

# join
dat_analysis <- inner_join(excess_snap, owid_struct, by = "code") |>
  filter(complete.cases(pick(everything())))

nrow(dat_analysis)
glimpse(dat_analysis)
install.packages("GGally")
library(ggplot2)
library(GGally)

# quick correlation check
dat_analysis |>
  select(-code, -continent) |>
  cor(use = "complete.obs", method = "pearson") |>
  round(2)

# oder visual
dat_analysis |>
  select(-code, -continent) |>
  ggpairs()