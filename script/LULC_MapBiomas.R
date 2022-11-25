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
###############################################    2000    ############################################### 

MB_2000 = readr::read_csv("./results/mapbiomas_ppbio_2000.csv") |>
  dplyr::select(-year) |>
  dplyr::rename(Classes = class) |> 
  dplyr::rename(Site = id )


## Chandless_State_Park = id 1

id_1 = MB_2000 |> 
  filter(Site == 1) |> 
  mutate(Classes = factor(Classes, levels = c("3", "4", "11", "12", "15", "33"), 
                          labels = c("Forest", "Savanna", "Wetland", "Grassland", "Pasture", " River, Lake and Ocean"))) |> 
  dplyr::select(-Site) |> 
  pivot_longer(-Classes, names_to="variable", values_to="value")
  
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



##### Test

MB_2000 = readr::read_csv("./data-raw/mapbiomas_2000_test.csv") 

MB_2010 = readr::read_csv("./data-raw/mapbiomas_2010_test.csv") 

MB_2020 = readr::read_csv("./data-raw/mapbiomas_2020_test.csv") 

#full_join = do.call(cbind, list(MB_2000, MB_2010, MB_2020))

full_bind = do.call(cbind, list(MB_2000, MB_2010, MB_2020)) |> 
  dplyr::select(Id, Class, Area_2000, Area_2010, Area_2020 )


############################################ Calculation

Calc = full_bind  |> 
  mutate(Cal_2000_2010 = across(Area_2000) - across(Area_2010)) |> 
  mutate(Cal_2000_2020 = across(Area_2000) - across(Area_2020)) |> 
  mutate(Cal_2010_2020 = across(Area_2010) - across(Area_2020)) 

######################################### CSP ID1 

CSP = Calc |> 
  filter(Id == "1") |> 
  dplyr::select(Class, Area_2000, Area_2010, Area_2020)|>
  mutate(across('Class', str_replace, '3', 'Forest')) |>
  mutate(across('Class', str_replace, '4', 'Savanna')) |>
  mutate(across('Class', str_replace, '11', 'Wetland')) |>
  mutate(across('Class', str_replace, '12', 'Grassland')) |>
  mutate(across('Class', str_replace, '15', 'Pasture')) |>
  mutate(across('Class', str_replace, '33', 'River')) |> 
  mutate(across('Class', str_replace, 'Forest3', 'River')) |> 
  pivot_longer(-Class, names_to="variable", values_to="value")

ggplot(CSP,aes(x = Class,y = value)) + 
  geom_bar(aes(fill = variable), stat = "identity", position = "dodge") + 
  scale_y_log10() 

CSP_ = ggplot(CSP,aes(x = Class,y = value)) + 
  geom_bar(aes(fill = variable), stat = "identity", position = "dodge") + 
  scale_y_log10()
  
  
print(CSP_ + ggtitle("Chandless State Park"))

