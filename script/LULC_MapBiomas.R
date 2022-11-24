###########################################################
## Script to build histograms 
## Author: Tainá Rocha
## Data: 23 November 2022 
## 4.2.2 R version
## 4.2.0 Rvesion
## 
############################################################

#Library
library(ggplot2)
library(sf)
library(tidyverse)
###############################################    2000    ############################################### 

## Chandless_State_Park = id 1
MB_2000 = readr::read_csv("./results/mapbiomas_ppbio_2000.csv") |>
  dplyr::select(-year) |>
  dplyr::rename(Classes = class) |> 
  dplyr::rename(Site = id )

id_1 = MB_2000 |> 
  filter(Site == 1) |> 
  mutate(Classes = factor(Classes, levels = c("3", "4", "11", "12", "15", "33"), 
                          labels = c("Forest", "Savanna", "Wetland", "Grassland", "Pasture", " River, Lake and Ocean")))
  
Chandless_State_Park = ggplot(id_1, aes(x= Classes, y = area))  + 
  geom_col()


print(Chandless_State_Park + ggtitle("Chandless State Park"))

 
###############################################    2010    ############################################### 

MB_2010 = readr::read_csv("./results/mapbiomas_ppbio_2010.csv") |>
  dplyr::select(-year) |>
  dplyr::rename(Classes = class) |> 
  dplyr::rename(Site = id )

###############################################    2020   ############################################### 

MB_2020 = readr::read_csv("./results/mapbiomas_ppbio_2020.csv") |>
  dplyr::select(-year) |>
  dplyr::rename(Classes = class) |> 
  dplyr::rename(Site = id )

###############################################    2021   ############################################### 

MB_2021 = readr::read_csv("./results/mapbiomas_ppbio_2021.csv") |>
  dplyr::select(-year) |>
  dplyr::rename(Classes = class) |> 
  dplyr::rename(Site = id )

############################################# FUll Bind



full_bind = dplyr::full_join() |> 
  dplyr::select(Site, Classes, Count_2015, Count_2030, Count_2040 )


############################################ Calculation

Calc = full_bind  |> 
  mutate(Cal_2015_2030 = across(Count_2015) - across(Count_2030)) |> 
  mutate(Cal_2015_2040 = across(Count_2015) - across(Count_2040)) |> 
  mutate(Cal_2030_2040 = across(Count_2030) - across(Count_2040)) 

