install.packages("remotes")
library(remotes)
library(credentials)
credentials::set_github_pat()
remotes::install_github(
  repo = "best-cost/best-cost_WPs",
  subdir = "/r_package/healthiar",
  force = TRUE,
  build_vignettes = TRUE
)
