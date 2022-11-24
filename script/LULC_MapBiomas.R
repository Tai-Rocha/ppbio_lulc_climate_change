###########################################################
## Script to build histograms 
## Author: Tainá Rocha
## Data: 23 November 2022 
## 4.2.2 R version
## 4.2.0 Rvesion
## 
############################################################

#Library
library(sf)
library(ggplot2)

###############################################    2015    ############################################### 

## Dataframe 1
F_2015 = sf::st_read("./results/2015_global_lulc1km_histo.shp") |>
  dplyr::as_tibble() |> 
  dplyr::select(Site, HISTO_1, HISTO_2, HISTO_3, HISTO_4, HISTO_5, HISTO_6) |>
  dplyr::rename(Water = HISTO_1) |> 
  dplyr::rename(Forest = HISTO_2) |> 
  dplyr::rename(Grassland = HISTO_3) |> 
  dplyr::rename(Barren = HISTO_4) |> 
  dplyr::rename(Cropland = HISTO_5) |> 
  dplyr::rename(Urban = HISTO_6) |>
  tidyr::pivot_longer(-Site, names_to = "Classes", values_to = "Count_2015")  




############################################### SSP5_RCP85 ############################################## 
###############################################    2030    ############################################### 

F_2030 = sf::st_read("./results/2030_global_lulc1km_histo.shp") |>
  dplyr::as_tibble() |> 
  dplyr::select(Site, HISTO_1, HISTO_2, HISTO_3, HISTO_4, HISTO_5, HISTO_6) |>    
  dplyr::rename(Site_2030 = Site) |> 
  dplyr::rename(Water = HISTO_1) |> 
  dplyr::rename(Forest = HISTO_2) |> 
  dplyr::rename(Grassland = HISTO_3) |> 
  dplyr::rename(Barren = HISTO_4) |> 
  dplyr::rename(Cropland = HISTO_5) |> 
  dplyr::rename(Urban = HISTO_6) |> 
  tidyr::pivot_longer(-Site_2030, names_to = "Classes_2030", values_to = "Count_2030")


###############################################    2040   ############################################### 

F_2040 = sf::st_read("./results/2040_global_lulc1km_histo.shp") |>
  dplyr::as_tibble() |> 
  dplyr::select(Site, HISTO_1, HISTO_2, HISTO_3, HISTO_4, HISTO_5, HISTO_6) |>   
  dplyr::rename(Site_2040 = Site) |> 
  dplyr::rename(Water = HISTO_1) |> 
  dplyr::rename(Forest = HISTO_2) |> 
  dplyr::rename(Grassland = HISTO_3) |> 
  dplyr::rename(Barren = HISTO_4) |> 
  dplyr::rename(Cropland = HISTO_5) |> 
  dplyr::rename(Urban = HISTO_6)  |>
  tidyr::pivot_longer(-Site_2040, names_to = "Classes_2040", values_to = "Count_2040") 

############################################# FUll Bind

full_bind = do.call(cbind, list(F_2015, F_2030, F_2040)) |> 
  dplyr::select(Site, Classes, Count_2015, Count_2030, Count_2040 )


############################################ Calculation

Calc = full_bind  |> 
  mutate(Cal_2015_2030 = across(Count_2015) - across(Count_2030)) |> 
  mutate(Cal_2015_2040 = across(Count_2015) - across(Count_2040)) |> 
  mutate(Cal_2030_2040 = across(Count_2030) - across(Count_2040)) 

