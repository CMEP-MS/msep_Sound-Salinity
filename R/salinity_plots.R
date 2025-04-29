library(mseptools)

# get data and pull out stations
dat <- get_mssnd_data(startDate = "2025-01-01")
stns <- sort(unique(dat$siteInfo$clean_nm))

# or put stns in order from west to east
dat$siteInfo <- dat$siteInfo |> 
    dplyr::arrange(dec_lon_va) |> 
    dplyr::mutate(clean_nm = forcats::fct_inorder(clean_nm))

stns <- dat$siteInfo$clean_nm

# color palettes
# named vector for plotly
colors_static <- as.character(khroma::color("roma")(length(stns)))
names(colors_static) <- stns
# function for leaflet
color_fun <- leaflet::colorFactor(palette = colors_static,
                         domain = stns)


# plot and map
plot_mssnd_salinity(dat,
                    colors = colors_static)
map_mssnd_usgs(dat$siteInfo,
               color_function = color_fun)

