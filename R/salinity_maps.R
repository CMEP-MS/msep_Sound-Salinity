library(mseptools)
library(leaflet)
library(dplyr)

# uniform color palette
domain_vals <- c(0, 40)
color_function <- leaflet::colorNumeric(palette = "YlGnBu",
                                   domain = c(0, 40))

dat <- mssnd_salinity


tomap <- dat$daily
tomap <- left_join(tomap, dat$siteInfo,
                   by = "site_no") |> 
    select(site_no, clean_nm,
           dec_lat_va, dec_lon_va,
           date, sal_mean, sal_min, sal_max)

in_date <- as.Date("2023-06-01")

tomap_sub <- tomap |> 
    filter(date == in_date)



m <- map_mssnd_salinity(tomap_sub)
m |> 
    addScaleBar(position = "bottomleft") |> 
    addControl(
        html = "<h3 style='text-align:center; color:black; background-color:white; padding:5px; border-radius:5px; opacity:0.8;'>My Map Title</h3>",
        position = "bottomright"
    )
    