library(mseptools)
library(dplyr)

# get a few years' worth of salinity readings and save them out
yrs <- 2010:2024

# get the data
dat_all <- list()
for(i in seq_along(yrs)){
    start <- paste0(yrs[i], "-01-01")
    end <- paste0(yrs[i], "-12-31")
    dat_in <- get_mssnd_data(startDate = start,
                             endDate = end)
    dat_all[[i]] <- dat_in
}

# extract the individual pieces
data_all <- list()
siteInfo_all <- list()
daily_all <- list()
for(i in seq_along(dat_all)){
    data_all[[i]] <- dat_all[[i]]$data
    siteInfo_all[[i]] <- dat_all[[i]]$siteInfo
    daily_all[[i]] <- dat_all[[i]]$daily
}

# bind
data_all <- bind_rows(data_all)
siteInfo_all <- bind_rows(siteInfo_all) |> 
    distinct() |> 
    arrange(dec_lon_va) |>
    mutate(clean_nm = forcats::fct_inorder(clean_nm))
daily_all <- bind_rows(daily_all)

# put back into a list
mssnd_salinity <- list(data = data_all,
                            siteInfo = siteInfo_all,
                            daily = daily_all)
save(mssnd_salinity, 
     file = here::here("data",
                       "mssnd_salinity.rda"),
     compress = "xz")
