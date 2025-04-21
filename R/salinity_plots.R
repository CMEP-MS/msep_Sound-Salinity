library(mseptools)
library(plotly)

dat <- get_mssnd_data()

to_plo <- left_join(dat$data, dat$siteInfo,
                    by = "site_no")
to_ploDaily <- left_join(dat$daily, dat$siteInfo,
                         by = "site_no")

# plot ----
# my_colors <- RColorBrewer::brewer.pal(8, "GnBu")
# my_colors <- as.character(khroma::color("muted")(8))
my_colors <- as.character(khroma::color("roma")(8))


p <- plot_ly(to_plo,
             type = "scatter",
             mode = "lines",
             x = ~dateTime,
             y = ~Sal_Inst,
             color = ~station_nm,
             colors = my_colors,
             legendgroup = ~station_nm,
             showlegend = TRUE)
p |> 
    layout(
        title = list(
            text = "Salinity in the Mississippi Sound",
            x = 0.02,
            y = 0.98,  
            yanchor = "top"
        ),
        xaxis = list(
            title = "Date",
            rangeslider = list(type = "date",
                               thickness = 0.05),
            zerolinecolor = '#ffff', 
            zerolinewidth = 1
        ),
        yaxis = list(
            title = "Salinity (ppt)"
        ))


p2 <- plot_ly(to_ploDaily,
             type = "scatter",
             mode = "lines",
             x = ~date,
             y = ~sal_mean,
             color = ~station_nm,
             colors = my_colors,
             legendgroup = ~station_nm,
             showlegend = FALSE) 
p2 |> 
    layout(
        title = list(
            text = "Daily Mean Salinity in the Mississippi Sound",
            x = 0.02,
            y = 0.98,  
            yanchor = "top"
        ),
        xaxis = list(
            title = "Date",
            rangeslider = list(type = "date",
                               thickness = 0.05),
            zerolinecolor = '#ffff', 
            zerolinewidth = 1
        ),
        yaxis = list(
            title = "Salinity (ppt)"
        ))

subplot(p, p2, nrows = 2, shareX = TRUE)|> 
    layout(
        # legend = list(orientation = "h", x = 0.5, xanchor = "center", y = -0.1),
        # margin = list(b = 80),
        xaxis = list(
            title = "Date",
            rangeslider = list(type = "date",
                               thickness = 0.05),
            zerolinecolor = '#ffff', 
            zerolinewidth = 1
        ),
        yaxis = list(
            title = "Salinity (ppt)"
        ))
