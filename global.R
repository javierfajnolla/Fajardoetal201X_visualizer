library(tidyverse)
library(raster)
library(rgdal)

# Load data to display
# solutions <- stack(
#   raster("../../_results/prioritization/intermediate_data/pu_0833/problems_allsp/results/pre_RASTER_bmat_halftg.tif"),
#   raster("../../_results/prioritization/intermediate_data/pu_0833/problems_allsp/results/pre45_RASTER_bmat_halftg.tif"),
#   raster("../../_results/prioritization/intermediate_data/pu_0833/problems_allsp/results/pre85_RASTER_bmat_halftg.tif")
#   )
solutions <- list.files("data/solutions", full.names = T, pattern = "rds") %>% 
  purrr::map(readRDS) %>% 
  stack %>% 
  setNames(c("pre", "pre45", "pre85"))


# Set NA value to not selected sites, so these sites are shown as transparent
solutions <- solutions %>% as.list %>% 
  purrr::map(~.x %>% reclassify(tibble(is = 0, becomes = NA))) %>% 
  purrr::map(~.x %>% trim)

# Solutions in shapefile format
sol1 <- readOGR("data/solutions/Final_pre_05_50_NObmat_blm180_based_in_future_mincost10.shp")
sol2 <- readOGR("data/solutions/Final_pre45_05_50_NObmat_blm180_based_in_future_mincost10.shp")
sol3 <- readOGR("data/solutions/Final_pre85_05_50_NObmat_blm180_based_in_future_mincost10.shp")

# Load other data to display
## Study area borders
TAC_border <- readOGR("data/SIG", "PAT_simplified")

# PAs <- readOGR("data/SIG", "AP_PAT_Complete")

PAs <- readOGR("data/SIG", "PAT_PA_todos_niveles_2018")
PAs <- PAs[PAs$area_influ == 0, ]
PAs <- PAs[PAs$del_viewer != 1, ]
# PAs <- PAs[PAs$terrest == 1, ]
  

# PAs_TAC <- readOGR("")

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