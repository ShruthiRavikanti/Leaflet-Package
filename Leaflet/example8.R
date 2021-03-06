library(leaflet)

# We will use the quakes dataset for the sake of demo

# create earthquake magnitude range to define the type as follows 
quakes$magrange = cut(quakes$mag, 
                      breaks = c(4, 5, 6, 7), right=FALSE,
                      labels = c("Light[4-5)", "Moderate[5-6)", "Strong[6-7)"))

# Define a color pallete corresponding to the magnitude ranges
pal = colorFactor(palette = c("yellow", "red", "black"), domain=quakes$magrange)

# Create the map object & add circle marker
leaflet(data=quakes) %>% 
  addProviderTiles("Esri.WorldImagery") %>% 
  addCircleMarkers(lng = ~ long, 
                   lat= ~ lat, 
                   color = ~ pal(magrange), #use the pallete
                   label = paste("Magnitude=", quakes$mag, "Type=", quakes$magrange),
                   clusterOptions = markerClusterOptions(showCoverageOnHover = TRUE, zoomToBoundsOnClick = TRUE,
                                        spiderfyOnMaxZoom = TRUE, removeOutsideVisibleBounds = TRUE,
                                        spiderLegPolylineOptions = list(weight = 1.5, color = "#222", opacity=0.5), freezeAtZoom = FALSE)
                    ) %>% 
 
  addLegend("bottomright", pal = pal, values = ~magrange,
            title = "Earthquake Type",
            opacity = 0.6
  )
