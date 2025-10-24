#------------------------------------------------------------------------------
# R Data Loader | Tidy Tuesday | Henley Passport Index Data
# https://github.com/rfordatascience/tidytuesday/tree/main/data/2025/2025-09-09
# 10/22/2025 awalmer
#------------------------------------------------------------------------------

# Set Up ------------------------------------------------------------------

library(tidytuesdayR)
library(httr)
library(tidyverse)
library(jsonlite)

setwd("/Users/auraleewalmer/Documents/github-vis/vis/src/")


# Load Data ---------------------------------------------------------------

tuesdata <- tidytuesdayR::tt_load(2025, week = 36)
#country_lists <- tuesdata$country_lists
rank_by_year <- tuesdata$rank_by_year


# Clean Data --------------------------------------------------------------

## FOR UPDATED DATA:

# req <- GET("api.henleypassportindex.com/api/v3/countries")
# 
# parsed <- req$content |> 
#   rawToChar() |> 
#   fromJSON()
# 
# rank_by_year <- parsed$countries |> 
#   filter(has_data) |> 
#   tidyr::unnest_longer(col = data) |> 
#   select(code, country, region, data, year = data_id) |> 
#   unnest_wider(col = data)
# 
# 
# country_lists |>
#   mutate(across(c(3:7),
#                 ~map(.x, ~fromJSON(.x)[[1]] |> tibble())))


# Convert vars to integers:
rank_by_year[, c("rank", "visa_free_count", "year")] <- lapply(rank_by_year[, c("rank", "visa_free_count", "year")], as.integer)


# Heat Map Data Prep ------------------------------------------------------

# unique years: 20: 2006 to 2025
# countries by region. so make a separate df per region?
# e.g. ASIA -- 32 unique countries.
# so a heatmap that is 20 by 32? 

# list of unique countries within Asia:
unique(rank_by_year[rank_by_year$region=="ASIA",]$country)
asia <- rank_by_year[rank_by_year$region=="ASIA",]
asia$country[asia$country=='Hong Kong (SAR China)'] <- 'Hong Kong'
asia$country[asia$country=='Macao (SAR China)'] <- 'Macao'
asia$country[asia$country=='Taiwan (Chinese Taipei)'] <- 'Taiwan'


## Functions for building + cleaning region data:

# Region Data Frame:
filterByRegion <- function(passport_data, region) {
  region_data <- passport_data[passport_data$region==region,]
  region_data_2025 <- region_data[region_data$year==2025,]
  region_data_2025 <- region_data_2025[order(-region_data_2025$visa_free_count), ]
  region_data_2025$region_rank_2025 <- seq(1, nrow(region_data_2025))
  region_data <- left_join(region_data, region_data_2025[c("country","region_rank_2025")], by = "country")
  region_data <- region_data[order(region_data$region_rank_2025), ]
  return(region_data)
}

# Cleaned Region Data Frame:
cleanRegionData <- function(region_data, replace_0=c("yes","no"), remove_0709=c("yes","no")) {
  cleandata <- region_data
  if (replace_0=="yes") {
    cleandata$visa_free_count[cleandata$visa_free_count==0] <- NA
  } else {}
  if (remove_0709=="yes") {
    cleandata <- cleandata[cleandata$year!=2007 & cleandata$year!=2009,]
  } else {}
  return(cleandata)
}

replaceNames <- function(cleandata, number_name_replacements, 
                         list_old_names, list_new_names) {
  for (i in 1:number_name_replacements) {
    cleandata$country[cleandata$country==list_old_names[[i]]] <- list_new_names[[i]]
  }
  return(cleandata)
}

dfWriteJSON <- function(list_dfs) {
  for (d in 1:length(list_dfs)) {
    name <- names(list_dfs)[[d]]
    df <- list_dfs[[d]]
    write_json(df, paste0("data/", name, "-passport.json"), stream = TRUE, pretty = TRUE)
  }
}


## Use the functions:

#Asia:
asia <- filterByRegion(rank_by_year, "ASIA")
asia <- cleanRegionData(asia, replace_0="yes", remove_0709="yes")
asia_names_old <- list('Hong Kong (SAR China)', 'Macao (SAR China)', 'Taiwan (Chinese Taipei)')
asia_names_new <- list('Hong Kong', 'Macao', 'Taiwan')
asia <- replaceNames(asia, 3, asia_names_old, asia_names_new)

# Europe:
europe <- filterByRegion(rank_by_year, "EUROPE")
europe <- cleanRegionData(europe, replace_0="yes", remove_0709="yes")
europe_names_old <- list('Bosnia and Herzegovina', 'Russian Federation')
europe_names_new <- list('Bosnia (B&H)', 'Russian Fed.')
europe <- replaceNames(europe, 2, europe_names_old, europe_names_new)

# Africa:
africa <- filterByRegion(rank_by_year, "AFRICA")
africa <- cleanRegionData(africa, replace_0="yes", remove_0709="yes")
africa_names_old <- list('Cape Verde Islands', 'Central African Republic', 'Sao Tome and Principe')
africa_names_new <- list('Cape Verde Isl.', 'Centr. African Rep.', 'Sao Tome & Princ.')
africa <- replaceNames(africa, 3, africa_names_old, africa_names_new)


## Export to JSON:
region_df_list <- list("asia"=asia, "europe"=europe, "africa"=africa)
dfWriteJSON(region_df_list)


