library(mseptools)

# get data and pull out stations
dat <- get_mssnd_data(startDate = "2025-01-01")
stns <- sort(unique(dat$siteInfo$clean_nm))

# color palettes
# named vector for plotly
colors_static <- as.character(khroma::color("roma")(length(stns)))
names(colors_static) <- stns
# function for leaflet
color_fun <- leaflet::colorFactor(palette = colors_static,
                         domain = names(colors_static))


# plot and map
plot_mssnd_salinity(dat,
                    colors = colors_static)
map_mssnd_usgs(dat$siteInfo,
               color_function = color_fun)

