rm(list=ls())
library(healthiar)
library(tidyverse)
#Create a reproducible exposure dataframe
exdat_noise_long <-
  exdat_noise_ha %>%
  select(-erf_percent,-number,-yld) %>% 
  pivot_longer(
    cols = starts_with("population_exposed_"),
    names_to = "region",
    values_to = "exposed"
  ) %>%
  mutate(region = str_split_i(region, "_", 3)) %>%
  mutate(regionID = region %>%
           as.factor() %>%
           as.numeric())
#this works
HA1<-exdat_noise_long%>%
  {
    attribute_health(
      approach_risk = "absolute_risk",
      exp_central = .$exposure_mean,
      pop_exp = .$exposed,
      erf_eq_central = "78.9270-3.1162*c+0.0342*c^2"
    )
  }
#this gives an error "Error in `tibble::tibble()`"
#probably, the reason is, that now,  geo-specific input data (e.g. bhd_...), exp_...) has to be provided as a list.
HA2 <- exdat_noise_long %>%
  {
    attribute_health(
      geo_id_disaggregated = .$regionID,
      approach_risk = "absolute_risk",
      exp_central = .$exposure_mean,
      pop_exp = .$exposed,
      erf_eq_central = "78.9270-3.1162*c+0.0342*c^2"
    )
  }
#trying to solve this requirement
#this fails and gives "Fehler: For absolute risk, the length of exp_central must be higher than 1."
HA3 <- exdat_noise_long %>%
  {
    attribute_health(
      geo_id_disaggregated = .$regionID,
      approach_risk = "absolute_risk",
      exp_central = .$exposure_mean %>% as.list,
      pop_exp = .$exposed %>% as.list,
      erf_eq_central = "78.9270-3.1162*c+0.0342*c^2"
    )
  } 
