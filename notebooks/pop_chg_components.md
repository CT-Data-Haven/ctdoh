Pop change components
================

``` r
library(tidyverse)
library(tidycensus)
library(janitor)
library(cwi)
library(camiller)
library(censusapi)
```

Collecting and lightly cleaning basic population data for multiple
geographies and each year available starting in 2000 through latest
available.

Change by component - *(natural, international, domestic)* - state and
county only; town not available.

Periods are annual estimates from July 1–June 30 where period 2 is 2011,
period 3 is 2012, etc. **EXCEPTION:** Period 1 is April 1–June 30, 2010
because of decennial census.

Vars and codes are found here:
<https://www.census.gov/data/developers/data-sets/popest-popproj/popest/popest-vars/2017.html>

For dates, I’m going to take the year the estimate ends (so the June 30
date in the code list at the link above).

``` r
period_lut <- tibble(
    year = seq(2010, 2018),
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
```

Taking Kyle Walker at his word that these components don’t exist at
sub-county level. They are available by MSA/CSA but that’s not helpful
for our purposes.

``` r
components <- bind_rows(ct_components, county_components) %>%
    clean_names() %>% 
    mutate(variable = str_to_lower(variable),
                 name = str_remove(name, ", Connecticut"),
                 level = as.factor(if_else(name == "Connecticut", "1_state", "2_counties")),
                 county = as.character(NA)) %>% 
    filter(variable %in% c(
        "births", "deaths", "naturalinc", "domesticmig", "internationalmig")) %>% 
    left_join(period_lut, by = "period") %>% 
    select(year, level, geoid, name, county, var = variable, estimate = value)

write_csv(components, "../output_data/pop_change_components_2010_2018")
```

2000-2010 intercensals unavailable with tidycensus. After looking
through APIs I’m not sure these estimates exist prior to 2010. Need to
confer with Urban.
