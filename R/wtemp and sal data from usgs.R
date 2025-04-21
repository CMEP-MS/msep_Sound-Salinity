library(dataRetrieval)
library(dplyr)
library(lubridate)
library(ggplot2)


availableData <- whatNWISdata(siteNumber = "05114000")
LA_Rigolets <- whatNWISdata(siteNumber = "301001089442600",
                             service = c("uv", "dv"))

group_info <- check_param("characteristicgroup")
characteristic_info <- check_param("characteristics")

characteristics_i_want <- characteristic_info |> 
    dplyr::filter(characteristicName %in% c("Salinity",
                                            "Specific conductance",
                                            "Temperature",
                                            "Temperature, water"))
# parameter codes ----
my_parmCds <- na.omit(characteristics_i_want$parameterCode)

# station IDs ----
stns <- c("301001089442600",
          "300722089150100",
          "301429089145600",
          "301912088583300",
          "301527088521500",
          "302318088512600",
          "301849088350000",
          "301141089320300")
my_available_data <- whatNWISdata(siteNumber = stns,
                                  service = c("uv", "dv"))
stn_info <- my_available_data |> 
    select(site_no,
           station_nm,
           dec_lat_va,
           dec_long_va) |> 
    distinct()

one_month_ago <- Sys.Date() %m-% months(1)

my_data_to_get <- my_available_data |> 
    dplyr::filter(parm_cd %in% my_parmCds,
                  end_date >= one_month_ago)

params_i_have <- unique(my_data_to_get$parm_cd)

parm_dict <- characteristic_info |> 
    filter(parameterCode %in% params_i_have)

# 00480 for Salinity
# 00095 for SpC, normalized to 25C
# 00010 for wtemp

# uv ----
month_of_uv <- readNWISuv(siteNumbers = stns,
                   parameterCd = c("00010", "00095", "00480"),
                   startDate = one_month_ago,
                   endDate = Sys.Date(),
                   tz = "America/Regina")

month_of_uv2 <- renameNWISColumns(month_of_uv)
names(month_of_uv2) <- stringr::str_replace(names(month_of_uv2),
                                            "X_00480",
                                            "Sal")
month_of_uv2 <- left_join(month_of_uv2, stn_info)

# dv ----
month_of_dv <- readNWISdv(siteNumbers = stns,
                          parameterCd = c("00010", "00095", "00480"),
                          startDate = one_month_ago,
                          endDate = Sys.Date(),
                          statCd = c("00001", "00002", "00003"))
                    
month_of_dv2 <- renameNWISColumns(month_of_dv)
names(month_of_dv2) <- stringr::str_replace(names(month_of_dv2),
                                            "X_00480",
                                            "Sal")
month_of_dv2 <- left_join(month_of_dv2, stn_info)


# uv plots ----

p <- ggplot(month_of_uv2,
       aes(x = dateTime,
           y = Sal)) +
    geom_line(aes(col = station_nm)) +
    # khroma::scale_color_muted() +
    # scale_color_brewer(palette = "Set2") +
    theme_bw()

# Nature Journal Group
p2 <- p + ggsci::scale_color_npg()
plotly::ggplotly(p2)

# NEJM
p2 <- p + ggsci::scale_color_nejm()
plotly::ggplotly(p2)

# Integrative Genomics Viewer
p2 <- p + ggsci::scale_color_igv()
plotly::ggplotly(p2)


# dv plots ----
p <- ggplot(month_of_dv2,
            aes(x = Date,
                y = Sal)) +
    geom_line(aes(col = station_nm)) +
    # khroma::scale_color_muted() +
    # scale_color_brewer(palette = "Set2") +
    theme_bw()

# Nature Journal Group
p2 <- p + ggsci::scale_color_npg()
plotly::ggplotly(p2)
