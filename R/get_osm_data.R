library(osmdata)
library(readxl)
library(dplyr)
library(sf)

# Include n biggest cities
city_top <- 100

# Include selected amenities for quality metric
quality_amenities <- c('access', 'bottle', 'wheelchair')

# Load and prepare city data
city_df <- read_excel(
  here::here("data/raw/staedte.xlsx"),
  skip = 6,
  sheet = 'Städte',
  col_names = c(
    'id',
    'land',
    'rb',
    'kreis',
    'verb',
    'gem',
    'city',
    'zip',
    'area_sqkm',
    'population',
    'pop_men',
    'pop_women',
    'pop_per_sqkm'
  )
)

city_df <- city_df %>%
  select(c('id', 'city', 'area_sqkm', 'population',
           'pop_per_sqkm')) %>%
  mutate(city = gsub("\\,.*", "", city_df$city)) %>%
  head(city_top)


# Load and prepare fountain data
fountain_df <-
  read_excel(here::here('data/raw/anzahl_brunnen.xlsx')) %>%
  select(c('Stadt', 'Anzahl Brunnen (nach Datenliste)')) %>%
  rename('city' = 'Stadt',
         'fountains_official' = 'Anzahl Brunnen (nach Datenliste)')

# Loop through cities collecting drinking_water places and meta data
res_list <- list()
i <- 0

for (city in city_df$city) {
  i <- i + 1
  print(city)
  city_ctry <- paste0(city, ', Germany')
  
  osm <- opq(bbox = city_ctry) %>%
    add_osm_feature(key = 'amenity', value = 'drinking_water') %>%
    osmdata_sf()
  osm_df <- as.data.frame(osm$osm_points)
  print(paste0(city, ': ', nrow(osm_df), ' data points found'))
  
  if (nrow(osm_df) > 0) {
    osm_df$city <- city
    res_list[[i]] <- osm_df
  }
}

# Collect all data and save to csv
res_df <- bind_rows(res_list)
write.table(res_df,
            here::here("data/processed/city_tags.csv"),
            sep = ';')

# Merge drinking place counts with city information
count_df <- res_df %>%
  count(city) %>%
  rename(fountains_osm = n)
city_summary_df <- left_join(city_df, count_df)
city_summary_df$fountains_per_1000 <-
  round(city_summary_df$fountains_osm /
          (city_summary_df$population / 1000),
        2)

# Determine quality of points
quality_df <- data.frame(city = res_df$city)

for (col in quality_amenities) {
  quality_df[col] <- as.integer(!is.na(res_df[col]))
}

quality_df$quality <- round(rowSums(quality_df[, -1]) /
                              length(quality_amenities), 2)

city_quality_df <- quality_df %>% group_by(city) %>%
  summarise(mean_quality = mean(quality)) %>%
  mutate(across(where(is.numeric), round, 3)) %>%
  arrange(-mean_quality)

# Merge and save summary to csv
city_summary_df <- left_join(city_summary_df, fountain_df)
city_summary_df <- left_join(city_summary_df, city_quality_df)
city_summary_df$official_vs_osm <- city_summary_df$fountains_osm -
  city_summary_df$fountains_official

write.table(city_summary_df,
            here::here("data/processed/city_summary.csv"),
            sep = ';')

# Missing
missing_df <- res_df %>%
  summarise_all(list(~ sum(is.na(.)) / nrow(res_df))) %>%
  round(3) %>%
  t %>%
  as.data.frame() %>%
  rename('Missing' = 'V1') %>%
  arrange(Missing)

write.table(missing_df,
            here::here("data/processed/missing_tags.csv"),
            sep = ';')
