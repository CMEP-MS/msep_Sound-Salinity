library(mseptools)
library(leaflet)
library(dplyr)

# uniform color palette
domain_vals <- c(0, 40)
color_function <- leaflet::colorNumeric(palette = "Blues",
                                   domain = c(0, 40))

dat <- mssnd_salinity


tomap <- dat$daily
tomap <- left_join(tomap, dat$siteInfo,
                   by = "site_no") |> 
    select(site_no, clean_nm,
           dec_lat_va, dec_lon_va,
           date, sal_mean, sal_min, sal_max)

in_date <- as.Date("2024-08-25")

tomap_sub <- tomap |> 
    filter(date == in_date)



m <- leaflet::leaflet(tomap_sub) |>
    leaflet::addProviderTiles(provider = leaflet::providers$CartoDB.Positron,
                              group = "Positron (CartoDB)") |>
    leaflet::addProviderTiles(provider = leaflet::providers$Esri,
                              group = "Esri") |>
    leaflet::addLayersControl(baseGroups = c("Positron (CartoDB)",
                                             "Esri")) |>
    leaflet::addCircleMarkers(lng = ~dec_lon_va,
                              lat = ~dec_lat_va,
                              fillColor = ~color_function(sal_mean),
                              color = "black",
                              weight = 0.7,
                              radius = 12,
                              fillOpacity = 1,
                              popup = ~paste0(round(sal_mean, 1), " ppt; ", 
                                              clean_nm, ", USGS-", site_no,
                                              "; ", date)) |> 
    leaflet::addLegend(position = "bottomright",
              pal = color_function,
              values = c(0, 10, 20, 30, 40),
              bins = 5)
m
    