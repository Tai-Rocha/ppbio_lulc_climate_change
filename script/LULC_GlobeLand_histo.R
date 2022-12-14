###########################################################
## Script to build Graphics 
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
  

############################# Chandless State Park ID1



######################################### Federal University of Amazonas ID 3

FUM = Calc |> 
  filter(Site == "Federal University of Amazonas") |> 
  dplyr::select(Classes, Count_2015, Count_2030, Count_2040)|>
  dplyr::rename("2015" = Count_2015) |>
  dplyr::rename("2030" = Count_2030) |>
  dplyr::rename("2040" = Count_2040) |> 
  pivot_longer(-Classes, names_to="variable", values_to="value")

ggplot(FUM,aes(x = Classes,y = value)) + 
  geom_bar(aes(fill = variable),stat = "identity",position = "dodge") + 
  scale_y_log10() +
  labs(x = "", fill = "Years")

FUMPLOT_ = ggplot(FUM,aes(x = Classes,y = value)) + 
  geom_bar(aes(fill = variable),stat = "identity",position = "dodge") + 
  scale_y_log10() +
  labs(x = "", fill = "Years")
  

print(FUMPLOT_ + ggtitle("Federal University of Amazonas"))


#############################

