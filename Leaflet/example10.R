## Shape Click Event 
## Zoom in to the country and display corresponding click data when clicked

## Source of shape file
# http://thematicmapping.org/downloads/world_borders.php
## Set working directory ## 
## Download the shape files to working directory ##
##download.file("http://thematicmapping.org/downloads/TM_WORLD_BORDERS_SIMPL-0.3.zip" , destfile="TM_WORLD_BORDERS_SIMPL-0.3.zip")
## Unzip them ##
## unzip("TM_WORLD_BORDERS_SIMPL-0.3.zip")


library(leaflet)
library(rgdal) 
library(shiny)

## Load the shape file to a Spatial Polygon Data Frame (SPDF) using the readOGR() function
myspdf = readOGR(dsn=getwd(), layer="TM_WORLD_BORDERS_SIMPL-0.3")


##  ui code 
ui <- bootstrapPage(
  tags$style(type = "text/css", "html, 
             body {width:100%;height:100%}"),
  leafletOutput("mymap", width= "100%", height = "100%"),
  
  # Absolute panel 
  absolutePanel(top = 10, right = 10, fixed = TRUE,
               tags$div(style = "opacity: 0.70; background: #FFFFEE; padding: 8px; ", 
                        helpText("Welcome to the World map"),
                        textOutput("text"))))
## End of ui code




##  server code 
server <- function(input, output, session) {
  
  output$mymap <- renderLeaflet({
    # Create the map data and add polygons to it
    leaflet(data=myspdf) %>% 
      addTiles() %>% 
      setView(lat=10, lng=0, zoom=2) %>% 
      addPolygons(fillColor = "green",
                  highlight = highlightOptions(weight = 5,
                                               color = "red",
                                               fillOpacity = 0.7,
                                               bringToFront = TRUE),
                  label = ~NAME,
                  layerId = ~NAME) # add a layer ID to each shape. This will be used to identify the shape clicked
    
  })
  
  observe(
    {  click = input$mymap_shape_click
    #  subset the spdf object to get the lat, lng and country name of the selected shape (Country in this case)
    sub = myspdf[myspdf$NAME==input$mymap_shape_click$id, c("LAT", "LON", "NAME")]
    lat = sub$LAT
    lng = sub$LON
    nm=sub$NAME
    if(is.null(click))
      return()
    else
      leafletProxy("mymap") %>%
      setView(lng = lng , lat = lat, zoom = 5) %>%
      clearMarkers() %>% 
      addMarkers(lng =lng , lat = lat, popup = nm) 
      }
  )

# Observe to display click data when a shape (country in this case) is clicked
observe(
  {click = input$mymap_shape_click
  sub = myspdf[myspdf$NAME==input$mymap_shape_click$id, c("LAT", "LON", "NAME")]
  lat = sub$LAT
  lng = sub$LON
  nm = sub$NAME
  if(is.null(click))
    return()
  else
    output$text <- renderText({paste("Latitude= ", lat, 
                                     "Longitude=", lng,
                                     "Country=", nm
    )})}
  
)

}

shinyApp(ui, server)







