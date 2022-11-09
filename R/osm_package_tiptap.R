# Initial Code from Annika (tiptap)
setwd("C:/Users/Anni/Documents/aTipTap/OSM/R")
#install.packages("osmdata")
library(osmdata)
## Data (c) OpenStreetMap contributors, ODbL 1.0. https://www.openstreetmap.org/copyright
#https://cran.r-project.org/web/packages/osmdata/vignettes/osmdata.html



#=========Bounding boxes (bb)========#
  # Note also that getbb() can return a data frame reporting multiple
  # matches or matrices representing bounding polygons of matches:
bb_df <- getbb(place_name = "berlin", format_out = "data.frame")
bb_poly <- getbb(place_name = "berlin", format_out = "polygon")

  # The overpass API only accepts simple rectangular bounding boxes,
  # and so data requested with a bounding polygon will actually be all
  # data within the corresponding rectangular bounding box, but such 
  # data may be subsequently trimmed to within the polygon with the
  # trim_osmdata() function,

bb <- getbb ('berlin, germany', format_out = 'polygon')
x1 <- opq(bbox = bb) %>%
  add_osm_feature(key = 'amenity', value = 'drinking_water') %>%
  osmdata_sf () %>%
  trim_osmdata (bb)

  #The getbb() function also allows specification of an explicit featuretype,
  #such as street, city, county, state, or country. 
#?getbb()


#======osmdata queries=====#
  #opq = overpass query
  #add_osm_feature = specified in terms of key-value pairs
    #https://wiki.openstreetmap.org/wiki/Map_features
  #osmdata_sf() = simple features
  #osmdata_sp() = spatial features

#requesting all features with the amenity drinking water in Berlin
x2 <- opq(bbox = 'berlin, Germany') %>%
  add_osm_feature(key = 'amenity', value = 'drinking_water')%>%
  osmdata_sf ()%>%
  trim_osmdata (bb)
x2_df <- as.data.frame(x2$osm_points)

#requesting all drinking waters points in Berlin
  #AND
    #that are described as ~"Trinkbrunnen"

x3 <- opq(bbox = 'berlin, Germany') %>%
  add_osm_feature(key = 'amenity', value = 'drinking_water') %>%
  add_osm_feature(key = 'description', value = 'Trinkbrunnen', value_exact = FALSE)%>%
  osmdata_sf ()
x3_df <- as.data.frame(x3$osm_points)

#requesting all drinking waters points in Berlin
  #OR
    #fountains
      # with add_osm_features
x4 <- opq(bbox = 'berlin, Germany') %>%
  add_osm_features(features = c ("\"amenity\"=\"drinking_water\"",
                                 "\"amenity\"=\"fountain\""))%>%
                                                          osmdata_sf ()
x4_df <- as.data.frame(x4$osm_points)

#The same as with add_osm_feature

dat_1 <- opq(bbox = 'berlin, Germany') %>%
  add_osm_feature(key = 'amenity', value = 'drinking_water')%>%
  osmdata_sf ()

dat_2 <- opq(bbox = 'berlin, Germany') %>%
  add_osm_feature(key = 'amenity', value = 'fountain')%>%
  osmdata_sf ()

x5 <- c(dat_1,dat_2)
names(x5$osm_points)

data_points <- as.data.frame(x5$osm_points)

#drinking_water=yes

dat_3 <- opq(bbox = 'Karlsruhe, Germany') %>%
  add_osm_feature(key = 'amenity', value = 'drinking_water')%>%
  add_osm_feature(key = 'drinking_water', value = 'yes', value_exact = FALSE)%>%
  osmdata_sf ()

dat_4 <- opq(bbox = 'Karlsruhe, Germany') %>%
  add_osm_feature(key = 'amenity', value = 'fountain')%>%
  add_osm_feature(key = 'drinking_water', value = 'yes', value_exact = FALSE)%>%
  osmdata_sf ()

x6 <- c(dat_3,dat_4)
names(x6$osm_points)

data_points2 <- as.data.frame(x6$osm_points)



# key_exact can be set to FALSE to approximately match given keys;
# value_exact can be set to FALSE to approximately match given values; and
# match_case can be set to FALSE to match keys and values in both lower and upper case forms.


#=====Plotting the OSM points=====#
#make a query for the drinking_water points described as Trinkbrunnen
sp1 <- opq(bbox = 'berlin, Germany') %>%
  add_osm_feature(key = 'amenity', value = 'drinking_water') %>%
  add_osm_feature(key = 'description', value = 'Trinkbrunnen', value_exact = FALSE)

#make spatial feature of the query
sp_Trinkbrunnen1 <-  osmdata_sp(sp1)
#plot
x11();sp::plot(sp_Trinkbrunnen1$osm_points)

#=====save data as xml=====#
#osmdata_xml() = allows raw OSM data to be returned and optionally saved to disk
#in XML format. 
#These data can be used in any other programs able to read and process XML data,
#such as the open source GIS QGIS or the OSM data editor JOSM.


x7 <- opq(bbox = 'berlin, Germany') %>%
  add_osm_feature(key = 'amenity', value = 'drinking_water') %>%
  add_osm_feature(key = 'description', value = 'Trinkbrunnen', value_exact = FALSE)%>%
  osmdata_xml(file = 'Trinkbrunnen_Berlin.osm')
q  <- opq(bbox = 'berlin, Germany') %>%
  add_osm_feature(key = 'amenity', value = 'drinking_water') %>%
  add_osm_feature(key = 'description', value = 'Trinkbrunnen', value_exact = FALSE)

names(sf::st_read('Trinkbrunnen_Berlin.osm', layer = 'points', quiet = TRUE))
names(osmdata_sf(q, 'Trinkbrunnen_Berlin.osm')$osm_points)




