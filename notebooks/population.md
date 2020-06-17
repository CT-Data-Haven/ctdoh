Population trends
================

``` r
library(tidyverse)
library(tidycensus)
library(janitor)
library(tigris)
library(sf)
library(cwi)

out <- list()
```

Collecting and lightly cleaning basic population data for multiple
geographies and each year available starting in 2000 through latest
available.

  - Total pop - state, county, town
  - Pop change - *(natural, international, domestic)* - state, county;
    town not available through PES
  - Change by age *(need to define bands)* - state, county; town?
  - Change by race *(major three/four and other?)* - state, county;
    town?
  - Change by household type/size *(see town reports)* - state, county;
    town?
  - Change by income *(need to define bands)* - state, county; town?

### Total pop

State and county: Pre-2010 state and county data from Census intercensal
counts. 2010-2018 data from deci/ACS. Town data only post-2010 via ACS,
and 2000 and 2010 via deci, at limited demographic disaggregations. Not
sure what to do about income here.

``` r
# 2000-2010 intercensal data comes in spreadsheets from
# https://www.census.gov/data/datasets/time-series/demo/popest/intercensal-2000-2010-counties.html
# see data dictionary in companion pdf
intercensal <- read_csv("../input_data/co-est00int-alldata-09.csv") %>%
    clean_names()

out$state_county_demographics_2000_2010 <- intercensal

acs_years <- list("2011" = 2011, "2012" = 2012, "2013" = 2013, "2014" = 2014, "2015" = 2015, "2016" = 2016, "2017" = 2017, "2018" = 2018)

deci_years <- list("2000" = 2000, "2010" = 2010)

#b01001 - sex by age
#median income?? - b19013
#pop by race - b03002
#tenure - b25003
#hh type - b11001 (through 2016?)

sex_by_age <- acs_years %>% map(~multi_geo_acs(table = "B01001", year = ., new_england = F))
sex_by_age_bind <- Reduce(rbind, sex_by_age)

race <- acs_years %>% map(~multi_geo_acs(table = "B03002", year = ., new_england = F))
race_bind <- Reduce(rbind, race)

tenure <- acs_years %>% map(~multi_geo_acs(table = "B25003", year = ., new_england = F))
tenure_bind <- Reduce(rbind, tenure)

hh_type <- acs_years %>% map(~multi_geo_acs(table = "B11001", year = ., new_england = F))
hh_type_bind <- Reduce(rbind, hh_type)

out$sex_by_age_state_county_town_2011_2018 <- sex_by_age_bind
out$race_state_county_town_2011_2018 <- race_bind
out$tenure_state_county_town_2011_2018 <- tenure_bind
out$hh_type_state_county_town_2011_2019 <- hh_type_bind

#still need to get and bind deci for 00 and 10
```

### Pop change

Periods are annual estimates from July 1–June 30 where period 2 is 2011,
period 3 is 2012, etc. **EXCEPTION:** Period 1 is April 1–June 30, 2010
because of decennial census.

``` r
period_lut <- tibble(
    estimate_range = c(
        "April 1, 2010–June 30, 2010",
        "July 1, 2010–June 30, 2011",
        "July 1, 2011–June 30, 2012",
        "July 1, 2012–June 30, 2013",
        "July 1, 2013–June 30, 2014",
        "July 1, 2014–June 30, 2015",
        "July 1, 2015–June 30, 2016",
        "July 1, 2016–June 30, 2017",
        "July 1, 2017–June 30, 2018"),
    period = seq(1:9))

ct_components <- get_estimates(
    geography = "state", 
    state = "09", 
    product = "components", 
    time_series = T)

county_components <- get_estimates(
    geography = "county", 
    state = "09", 
    product = "components", 
    time_series = T)

state_county_pop_change_2010_2018 <- bind_rows(ct_components, county_components) %>%
    clean_names() %>% 
    mutate(variable = str_to_lower(variable)) %>% 
    filter(variable %in% c(
        "births", "deaths", "naturalinc", "domesticmig", "internationalmig")) %>% 
    left_join(period_lut, by = "period") %>% 
    select(geoid, name, estimate_range, variable, value)

out$pop_change_2010_2018 <- state_county_pop_change_2010_2018
```

``` r
saveRDS(out, "../output_data/population_tables.RDS")
```
