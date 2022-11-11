library (readxl)
y <- read_excel("assassinatos_v7.xls", na = "-")
View(y)

y$Longitude <- gsub(",", ".", y$Longitude)
y$Latitude <- gsub(",", ".", y$Latitude)

y$Longitude <- as.numeric(y$Longitude)
y$Latitude <- as.numeric(y$Latitude)

y <- y %>%
  rename(Conflito = "Nome do Conflito",
         Nome = "Nome da Vitima") 

library(leaflet)
library(leaflet.extras)
library(leafem)
library(htmlwidgets)

pal <- colorFactor(
  palette = 'Reds',
  domain = y$Sexo
)

labs <- lapply(seq(nrow(y)), function(i) {
  paste0( '<p>', y[i, "Conflito"], '<p></p>',
          y[i, "Nome"],'</p><p>',
          y[i, "Categoria"],'</p><p>', 
          y[i, "Sexo"],'</p><p>',
          y[i, "Idade"],'</p><p>',
          y[i, "Municipios"], '<p></p>', 
          y[i, "Estado"],'</p><p>',
          y[i, "Bioma"], '<p></p>',
          y[i, "Ano"], '</p>') 
})

img <- "https://pbs.twimg.com/profile_images/781261591543242752/ANOrZfwm_400x400.jpg"

leaflet(y) %>% addTiles() %>% 
  addHeatmap(lng=~Longitude,lat=~Latitude,intensity=~Vitimas,
             max=100,radius=30,gradient="Reds")%>% 
  addCircles(lng = ~Longitude, lat = ~Latitude, 
             color = ~pal(Sexo), 
             popup=paste("<b>Nome do Conflito:</b>", y$Conflito, "<br>",
                         "<b>Nome da Vítima:</b>", y$Nome, "<br>", 
                         "<b>Categoria:</b>", y$Categoria, "<br>",
                         "<b>Sexo:</b>", y$Sexo, "<br>",
                         "<b>Idade:</b>", y$Idade, "<br>", 
                         "<b>Município:</b>", y$Municipios, "<br>",
                         "<b>Estado:</b>", y$Estado, "<br>",
                         "<b>Bioma:</b>", y$Bioma, "<br>",
                         "<b>Ano:</b>", y$Ano)) %>%
  addEasyButton(easyButton(
    icon="fa-globe", title="Zoom",
    onClick=JS("function(btn, map){ map.setZoom(3); }"))) %>%
  addResetMapButton() %>% 
  addMeasure(position="topleft", primaryLengthUnit = "meters", primaryAreaUnit = "hectares") %>%
  addLogo(img, position="topleft", width = 60, height = 60)%>%
  addProviderTiles(providers$OpenStreetMap, group = "Open Street Map") %>%
  addProviderTiles(providers$Esri.WorldImagery, group = "ESRI World Imagery") %>% 
  addLayersControl(
    baseGroups = c("Open Street Map","ESRI World Imagery"),
    options = layersControlOptions(collapsed = FALSE)) %>%
  addMiniMap(toggleDisplay = TRUE) 


