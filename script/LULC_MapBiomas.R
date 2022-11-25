###########################################################
## Script to build histograms 
## Author: Tainá Rocha
## Data: 23 November 2022 
## 4.2.2 R version
############################################################

#Library
library(dplyr)
library(ggplot2)
library(sf)
library(stringr)
library(tidyverse)

###############################################     ############################################### 

## Read  data 

MB_2000 = readr::read_csv("./data/mapbiomas_2000.csv") 

MB_2010 = readr::read_csv("./data/mapbiomas_2010.csv") 

MB_2020 = readr::read_csv("./data/mapbiomas_2020.csv") 

#full_join = do.call(cbind, list(MB_2000, MB_2010, MB_2020))

full_bind = do.call(cbind, list(MB_2000, MB_2010, MB_2020)) |> 
  dplyr::select(Id, Class, Area_2000, Area_2010, Area_2020 )


############################################ Calculation

Calc = full_bind  |> 
  mutate(Cal_2000_2010 = across(Area_2000) - across(Area_2010)) |> 
  mutate(Cal_2000_2020 = across(Area_2000) - across(Area_2020)) |> 
  mutate(Cal_2010_2020 = across(Area_2010) - across(Area_2020)) 

######################################### CSP ID1 

CSP = full_bind |> 
  filter(Id == "1") |> 
  dplyr::select(Class, Area_2000, Area_2010, Area_2020)|>
  mutate(across('Class', str_replace, '3', 'Forest')) |>
  mutate(across('Class', str_replace, '4', 'Savanna')) |>
  mutate(across('Class', str_replace, '11', 'Wetland')) |>
  mutate(across('Class', str_replace, '12', 'Grassland')) |>
  mutate(across('Class', str_replace, '15', 'Pasture')) |>
  mutate(across('Class', str_replace, '33', 'River')) |> 
  mutate(across('Class', str_replace, 'Forest3', 'River')) |> 
  dplyr::rename("2000" = Area_2000) |> 
  dplyr::rename("2010" = Area_2010) |> 
  dplyr::rename("2020" = Area_2020) |> 
  pivot_longer(-Class, names_to="variable", values_to="value")
  

ggplot(CSP,aes(x = Class,y = value)) + 
  geom_bar(aes(fill = variable), stat = "identity", position = "dodge") + 
  scale_y_log10()  +
  labs(x = "", fill = "Years")

CSP_ = ggplot(CSP,aes(x = Class,y = value)) + 
  geom_bar(aes(fill = variable), stat = "identity", position = "dodge") + 
  scale_y_log10()  +
  labs(x = "", fill = "Years")
  
  
print(CSP_ + ggtitle("Chandless State Park"))

######################################### ID2 

