library(tidyverse)
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)

# Leaflet bindings are a bit slow; for now we'll just sample to compensate
set.seed(100)
# zipdata <- allzips[sample.int(nrow(allzips), 10000),]
# By ordering by centile, we ensure that the (comparatively rare) SuperZIPs
# will be drawn last and thus be easier to see
# zipdata <- zipdata[order(zipdata$centile),]

function(input, output, session) {
  
  ## Interactive Map ###########################################
  
  # Create the map
  # output$map <- renderLeaflet({
  #   leaflet() %>%
  #     addTiles(
  #       urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
  #       attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
  #     ) %>%
  #     setView(lng = -80, lat = -5, zoom = 4.5)
  # })
  
  
  output$map <- renderLeaflet({
    leaflet() %>% 
      # addTiles() %>%
      addProviderTiles("Esri.WorldPhysical", group = "Relieve") %>%
      # addTiles(options = providerTileOptions(noWrap = TRUE), group = "Countries") %>%
      # addLayersControl(baseGroups = c("Relieve", "Countries"),
      #                  options = layersControlOptions(collapsed = FALSE)) %>% 
      setView(lng = -80, lat = -5, zoom = 4.5) %>% 
      addMapPane("borders", zIndex = 410) %>% 
      # addMapPane("borders", zIndex = 420) %>% 
      addPolygons(data = TAC_border,
                  options = pathOptions(pane = "borders"),
                  weight = 2,
                  fillOpacity = 0,
                  opacity = 0.8,
                  color = "#595959") %>% 
      addPolygons(data = PAs,
                  options = pathOptions(pane = "borders"),
                  weight = 2,
                  fillOpacity = 0.5,
                  opacity = 1,
                  color = "#595959",
                  # label = ~paste0(category, " ", name, " \n Network: ", level)) %>% 
                  label = ~paste0(category, " ", name, " - Network: ", level)) %>% 
      clearControls()
      
  })
  
  # Create map proxy to make further changes to existing map
  map <- leafletProxy("map")
  
  
  observe({
    
    # Select the color palette picked by the user
    # Color palettes
    ## For a continuous raster
    # Get range of values in the solution and center the color scale in the middle
    # range_values <- c(min(values(solutions[[1]]), na.rm = T),
    #                   max(values(solutions[[1]]), na.rm = T))
    # range_values <- c(-max(abs(solutions[[1]])), max(abs(solutions[[1]])))
    # glue::glue("#>   Preparing a color palette") %>% message
    # pal <- colorNumeric(palette = c("#c0002d", "#f8f5f5", "#0069a8"),
    #                     domain = range_values,
    #                     na.color = "transparent",
    #                     reverse = TRUE)
    
    ## For a discrete raster (1 - 0)
    # if(input$color == "blue") display_color <- "#0069a8"
    # if(input$color == "red") display_color <- "#8E113F"
    # if(input$color == "green") display_color <- "#1AB256"
    display_color <- "#0069a8"
    
    # pal <- colorNumeric(palette = display_color,
    #                     # domain = range_values,  # Continuous rasters
    #                     domain = c(0,1),
    #                     na.color = "transparent",
    #                     reverse = TRUE)
    
    
    # Overlay the selected raster
    
    if(input$solution == "pre"){
      
      # Display layer
      map %>% 
        clearControls() %>%    # Refreshes the legend
        clearGroup("solutions") %>%
        clearGroup("borders") %>%
        # addMapPane("solutionss", zIndex = 500) %>% 
        # addMapPane("borders", zIndex = 430) %>% 
        # fitBounds(lng1 = extent(solutions[[1]])[1],    # zoom to raster extent
        #           lat1 = extent(solutions[[1]])[3], 
        #           lng2 = extent(solutions[[1]])[2], 
        #           lat2 = extent(solutions[[1]])[4]) %>% 
        addPolygons(data = sol1,
                    group = "solutions",
                    # options = pathOptions(pane = "solutionss"),
                    weight = 1,
                    fillOpacity = input$opacity,
                    opacity = input$opacity,
                    color = "#E5323F") #%>% 
        # addRasterImage(solutions[[1]],
        #                colors = pal,
        #                opacity = input$opacity,
        #                group = "solutions") %>%
        # addLegend(pal = pal, 
        #           # values = range_values,  # Continuous rasters
        #           values = c(0,1),
        #           group = "solutions",
        #           labFormat = labelFormat(transform = function(x) sort(x, decreasing = TRUE)))
      
      # Prepare layer to download
      output$download_solution <- downloadHandler(
        filename = "Fajardo2019_Priority_areas_present.tif",
        content = function(file) {
          res <- writeRaster(solutions[[1]], filename = file, format = "GTiff", overwrite = T)
          # Show the corresponding output filename
          print(res@file@name)
          
          # Rename it to the correct filename
          file.rename(res@file@name, file)
        }
      )
      
    }
    
    if(input$solution == "pre45"){
      
      # Display layer
      map %>% 
        clearControls() %>%    # Refreshes the legend
        clearGroup("solutions") %>%
        # fitBounds(lng1 = extent(solutions[[2]])[1],    # zoom to raster extent
        #           lat1 = extent(solutions[[2]])[3], 
        #           lng2 = extent(solutions[[2]])[2], 
        #           lat2 = extent(solutions[[2]])[4]) %>% 
        addPolygons(data = sol2,
                    group = "solutions",
                    # options = pathOptions(pane = "solutionss"),
                    weight = 1,
                    fillOpacity = input$opacity,
                    opacity = input$opacity,
                    color = "#E5323F") #%>% 
        # addRasterImage(solutions[[2]],
        #                colors = pal,
        #                opacity = input$opacity,
        #                group = "solutions") %>%
        # addLegend(pal = pal, 
        #           # values = range_values,  # Continuous rasters
        #           values = c(0,1),
        #           group = "solutions",
        #           labFormat = labelFormat(transform = function(x) sort(x, decreasing = TRUE)))
      
      # Prepare layer to download
      output$download_solution <- downloadHandler(
        filename = "Fajardo2019_Priority_areas_present_and_RCP4.5.tif",
        content = function(file) {
          res <- writeRaster(solutions[[2]], filename = file, format = "GTiff", overwrite = T)
          # Show the corresponding output filename
          print(res@file@name)
          
          # Rename it to the correct filename
          file.rename(res@file@name, file)
        }
      )
    }
    
    if(input$solution == "pre85"){
      
      # Display layer
      map %>% 
        clearControls() %>%    # Refreshes the legend
        clearGroup("solutions") %>%
        # fitBounds(lng1 = extent(solutions[[3]])[1],    # zoom to raster extent
        #           lat1 = extent(solutions[[3]])[3], 
        #           lng2 = extent(solutions[[3]])[2], 
        #           lat2 = extent(solutions[[3]])[4]) %>% 
        addPolygons(data = sol3,
                    group = "solutions",
                    # options = pathOptions(pane = "solutionss"),
                    weight = 1,
                    fillOpacity = input$opacity,
                    opacity = input$opacity,
                    color = "#E5323F") #%>% 
        # addRasterImage(solutions[[3]],
        #                colors = pal,
        #                opacity = input$opacity,
        #                group = "solutions") %>%
        # addLegend(pal = pal, 
        #           # values = range_values,  # Continuous rasters
        #           values = c(0,1),
        #           group = "solutions",
        #           labFormat = labelFormat(transform = function(x) sort(x, decreasing = TRUE)))
      
      # Prepare layer to download
      output$download_solution <- downloadHandler(
        filename = "Fajardo2019_Priority_areas_present_and_RCP8.5.tif",
        content = function(file) {
          res <- writeRaster(solutions[[3]], filename = file, format = "GTiff", overwrite = T)
          # Show the corresponding output filename
          print(res@file@name)
          
          # Rename it to the correct filename
          file.rename(res@file@name, file)
        }
      )
    }
  })
  
  # observe({
  #   output$download_solution <- downloadHandler(
  #     filename = "Fajardo2019_Priority_areas_present.tif",
  #     content = function(file) {
  #       res <- writeRaster(solutions[[1]], filename = file, format = "GTiff", overwrite = T)
  #       # Show the corresponding output filename
  #       print(res@file@name)
  #       
  #       # Rename it to the correct filename
  #       file.rename(res@file@name, file)
  #     }
  #   )
  # })
  
  
  # A reactive expression that returns the set of zips that are
  # in bounds right now
  # zipsInBounds <- reactive({
  #   if (is.null(input$map_bounds))
  #     return(zipdata[FALSE,])
  #   bounds <- input$map_bounds
  #   latRng <- range(bounds$north, bounds$south)
  #   lngRng <- range(bounds$east, bounds$west)
  #   
  #   subset(zipdata,
  #          latitude >= latRng[1] & latitude <= latRng[2] &
  #            longitude >= lngRng[1] & longitude <= lngRng[2])
  # })
  
  # Precalculate the breaks we'll need for the two histograms
  # centileBreaks <- hist(plot = FALSE, allzips$centile, breaks = 20)$breaks
  
  # output$histCentile <- renderPlot({
  #   # If no zipcodes are in view, don't plot
  #   if (nrow(zipsInBounds()) == 0)
  #     return(NULL)
  #   
  #   hist(zipsInBounds()$centile,
  #        breaks = centileBreaks,
  #        main = "SuperZIP score (visible zips)",
  #        xlab = "Percentile",
  #        xlim = range(allzips$centile),
  #        col = '#00DD00',
  #        border = 'white')
  # })
  
  # output$scatterCollegeIncome <- renderPlot({
  #   # If no zipcodes are in view, don't plot
  #   if (nrow(zipsInBounds()) == 0)
  #     return(NULL)
  #   
  #   print(xyplot(income ~ college, data = zipsInBounds(), xlim = range(allzips$college), ylim = range(allzips$income)))
  # })
  
  # This observer is responsible for maintaining the circles and legend,
  # according to the variables the user has chosen to map to color and size.
  # observe({
  #   colorBy <- input$color
  #   sizeBy <- input$size
  #   
  #   if (colorBy == "superzip") {
  #     # Color and palette are treated specially in the "superzip" case, because
  #     # the values are categorical instead of continuous.
  #     colorData <- ifelse(zipdata$centile >= (100 - input$threshold), "yes", "no")
  #     pal <- colorFactor("viridis", colorData)
  #   } else {
  #     colorData <- zipdata[[colorBy]]
  #     pal <- colorBin("viridis", colorData, 7, pretty = FALSE)
  #   }
  #   
  #   if (sizeBy == "superzip") {
  #     # Radius is treated specially in the "superzip" case.
  #     radius <- ifelse(zipdata$centile >= (100 - input$threshold), 30000, 3000)
  #   } else {
  #     radius <- zipdata[[sizeBy]] / max(zipdata[[sizeBy]]) * 30000
  #   }
  #   
  #   leafletProxy("map", data = zipdata) %>%
  #     clearShapes() %>%
  #     addCircles(~longitude, ~latitude, radius=radius, layerId=~zipcode,
  #                stroke=FALSE, fillOpacity=0.4, fillColor=pal(colorData)) %>%
  #     addLegend("bottomleft", pal=pal, values=colorData, title=colorBy,
  #               layerId="colorLegend")
  # })
  
  # Show a popup at the given location
  # showZipcodePopup <- function(zipcode, lat, lng) {
  #   selectedZip <- allzips[allzips$zipcode == zipcode,]
  #   content <- as.character(tagList(
  #     tags$h4("Score:", as.integer(selectedZip$centile)),
  #     tags$strong(HTML(sprintf("%s, %s %s",
  #                              selectedZip$city.x, selectedZip$state.x, selectedZip$zipcode
  #     ))), tags$br(),
  #     sprintf("Median household income: %s", dollar(selectedZip$income * 1000)), tags$br(),
  #     sprintf("Percent of adults with BA: %s%%", as.integer(selectedZip$college)), tags$br(),
  #     sprintf("Adult population: %s", selectedZip$adultpop)
  #   ))
  #   leafletProxy("map") %>% addPopups(lng, lat, content, layerId = zipcode)
  # }
  
  # When map is clicked, show a popup with city info
  # observe({
  #   leafletProxy("map") %>% clearPopups()
  #   event <- input$map_shape_click
  #   if (is.null(event))
  #     return()
  #   
  #   isolate({
  #     showZipcodePopup(event$id, event$lat, event$lng)
  #   })
  # })
  
  
  ## Data Explorer ###########################################
  
  # observe({
  #   cities <- if (is.null(input$states)) character(0) else {
  #     filter(cleantable, State %in% input$states) %>%
  #       `$`('City') %>%
  #       unique() %>%
  #       sort()
  #   }
  #   stillSelected <- isolate(input$cities[input$cities %in% cities])
  #   updateSelectInput(session, "cities", choices = cities,
  #                     selected = stillSelected)
  # })
  # 
  # observe({
  #   zipcodes <- if (is.null(input$states)) character(0) else {
  #     cleantable %>%
  #       filter(State %in% input$states,
  #              is.null(input$cities) | City %in% input$cities) %>%
  #       `$`('Zipcode') %>%
  #       unique() %>%
  #       sort()
  #   }
  #   stillSelected <- isolate(input$zipcodes[input$zipcodes %in% zipcodes])
  #   updateSelectInput(session, "zipcodes", choices = zipcodes,
  #                     selected = stillSelected)
  # })
  # 
  # observe({
  #   if (is.null(input$goto))
  #     return()
  #   isolate({
  #     map <- leafletProxy("map")
  #     map %>% clearPopups()
  #     dist <- 0.5
  #     zip <- input$goto$zip
  #     lat <- input$goto$lat
  #     lng <- input$goto$lng
  #     showZipcodePopup(zip, lat, lng)
  #     map %>% fitBounds(lng - dist, lat - dist, lng + dist, lat + dist)
  #   })
  # })
  # 
  # output$ziptable <- DT::renderDataTable({
  #   df <- cleantable %>%
  #     filter(
  #       Score >= input$minScore,
  #       Score <= input$maxScore,
  #       is.null(input$states) | State %in% input$states,
  #       is.null(input$cities) | City %in% input$cities,
  #       is.null(input$zipcodes) | Zipcode %in% input$zipcodes
  #     ) %>%
  #     mutate(Action = paste('<a class="go-map" href="" data-lat="', Lat, '" data-long="', Long, '" data-zip="', Zipcode, '"><i class="fa fa-crosshairs"></i></a>', sep=""))
  #   action <- DT::dataTableAjax(session, df)
  #   
  #   DT::datatable(df, options = list(ajax = list(url = action)), escape = FALSE)
  # })
}