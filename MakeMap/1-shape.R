library(geojsonio)
library(rmapshaper)
library(rgdal)

# This is for generating GeoJSON file for Canada Census Divisions

# Import the shapefile into R as SpatialPolygon Dataframe.
if(getwd() != "/home/wburr/doc/Talks/18_TIES/MakeMap") { setwd("/home/wburr/doc/Talks/18_TIES/MakeMap") }
canada_division <- readOGR(dsn = "./", layer = "gcsd000a11a_e")

# Filter to Ontario
ontario <- canada_division %>% 
    filter(PRNAME == "Ontario")
# get rid of UTF-8 stuff (should work-around, but no internet)
ontario <- ontario[-c(387, 481), ]
ontario <- ontario %>% filter(CSDTYPE != "S-\xc9")
ontario_json <- geojson_json(ontario)

# Simplify the polygons to reduce the final output file size.
ontario_sim <- ms_simplify(ontario_json)

# Clip to get rid of the northern end of the country.
ontario_clipped <- ms_clip(ontario_sim, bbox = c(-155, 35, -45, 74))

# Write out the final GeoJSON to the file system.
geojson_write(ontario_clipped, file = "./ontario.geojson")

################################################################################
#
#  Now have a JSON-format spatial setup for Ontario
#

