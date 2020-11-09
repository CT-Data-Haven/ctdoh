library(tidyverse)
library(sf)
library(osrm)
options(osrm.server = "http://127.0.0.1:5000/")

to_iso <- readRDS(here::here("input_data/housing_to_isochrone.rds"))

iso_sf <- to_iso %>%
  # slice(1:10) %>%
  group_by(uid) %>%
  nest() %>%
  # mutate(iso = imap(data, osrmIsochrone, breaks = c(15, 30), returnclass = "sf")) %>%
  mutate(iso = imap(data, function(d, i) {
    if (i %% 100 == 0) print(i)
    osrmIsochrone(d, breaks = 15, returnclass = "sf")
  })) %>%
  ungroup() %>%
  unnest(iso)

iso_sf %>%
  select(uid, max, geometry) %>%
  filter(max == 15) %>%
  st_as_sf() %>%
  saveRDS(here::here("output_data/housing_isochrones_15min.rds"))
