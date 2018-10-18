library(raster)
library(rgdal)

solutions <- stack(
  raster("../../_results/prioritization/intermediate_data/pu_0833/problems_allsp/results/pre_RASTER_bmat_halftg.tif"),
  raster("../../_results/prioritization/intermediate_data/pu_0833/problems_allsp/results/pre45_RASTER_bmat_halftg.tif"),
  raster("../../_results/prioritization/intermediate_data/pu_0833/problems_allsp/results/pre85_RASTER_bmat_halftg.tif")
  )
names(solutions) <- c("pre", "pre45", "pre85")

# NA value to not selected sites, so these sites are shown as transparent
solutions <- solutions %>% as.list %>% 
  purrr::map(~.x %>% reclassify(tibble(is = 0, becomes = NA))) %>% 
  purrr::map(~.x %>% trim)


TAC_border <- readOGR("data/SIG", "PAT_simplified")

# library(dplyr)
# 
# allzips <- readRDS("data/superzip.rds")
# allzips$latitude <- jitter(allzips$latitude)
# allzips$longitude <- jitter(allzips$longitude)
# allzips$college <- allzips$college * 100
# allzips$zipcode <- formatC(allzips$zipcode, width=5, format="d", flag="0")
# row.names(allzips) <- allzips$zipcode
# 
# cleantable <- allzips %>%
#   select(
#     City = city.x,
#     State = state.x,
#     Zipcode = zipcode,
#     Rank = rank,
#     Score = centile,
#     Superzip = superzip,
#     Population = adultpop,
#     College = college,
#     Income = income,
#     Lat = latitude,
#     Long = longitude
#   )