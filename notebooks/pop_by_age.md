Pop by age
================

``` r
library(tidyverse)
library(tidycensus)
library(janitor)
library(cwi)
library(camiller)
```

Collecting and lightly cleaning basic population data for multiple
geographies and each year available starting in 2000 through latest
available.

Using 5-year bands - state, county intercensal and ACS 2000-2018; town
ACS 2011-2018 and deci 2010

2000-2010 intercensal data comes in spreadsheets from
<https://www.census.gov/data/datasets/time-series/demo/popest/intercensal-2000-2010-counties.html>

See data dictionary in companion pdf in input\_data.

## Fetch

``` r
intercensal <- read_csv("../input_data/co-est00int-alldata-09.csv") %>%
    clean_names()

acs_years <- list("2011" = 2011, "2012" = 2012, "2013" = 2013, "2014" = 2014, "2015" = 2015, "2016" = 2016, "2017" = 2017, "2018" = 2018)

#b01001 - sex by age
sex_by_age <- acs_years %>% map(~multi_geo_acs(table = "B01001", year = ., new_england = F))
sex_by_age_bind <- Reduce(rbind, sex_by_age) %>% label_acs()

deci_years <- list("2000" = 2000, "2010" = 2010)

deci_pops <- deci_years %>% map(~multi_geo_decennial(table = "P012", year = .))

deci_pops_bind <- Reduce(rbind, deci_pops) %>% label_decennial() 
```

## Clean

``` r
deci_pop <- deci_pops_bind %>% 
    separate(label, into = c("total", "gender", "age"), sep = "!!", fill = "right") %>% 
    clean_names() %>% 
    filter(!variable %in% c("P012002", "P012026")) %>% #remove total male, total female
    mutate(age = if_else(variable == "P012001", "total_pop", age),
                 moe = 0) %>% 
    select(-gender, -total, -variable, -state) %>% 
    rename(estimate = value)

acs_pop <- sex_by_age_bind %>%
    separate(label, into = c("total", "gender", "age"), sep = "!!", fill = "right") %>% 
    clean_names() %>%
    filter(!grepl("_002|_026", variable)) %>% #remove total, total male, total female
  mutate(age = if_else(variable == "B01001_001", "total_pop", age)) %>% 
    select(-gender, -total, -variable, -state) %>% 
    bind_rows(deci_pop) %>% 
    mutate(age = str_replace_all(age, " ", "_") %>% 
                    str_to_lower()) %>% 
    mutate(age = as.factor(age) %>% 
                    fct_relevel(., "under_5_years", "5_to_9_years") %>% 
                    fct_collapse(.,
                                             `15_to_19_years` = c("15_to_17_years", "18_and_19_years"),
                                             `20_to_24_years` = c("20_years", "21_years", "22_to_24_years"),
                                             `60_to_64_years` = c("60_and_61_years", "62_to_64_years"),
                                             `65_to_69_years` = c("65_and_66_years", "67_to_69_years"))) %>% 
    group_by(year, level, geoid, name, county, var = age) %>% 
    summarise(estimate = sum(estimate),
                        moe = moe_sum(moe = moe, estimate = estimate)) %>% 
    ungroup() %>% 
    group_by(year, level, geoid, name, county) %>% 
    mutate(moe = replace_na(moe, 0),
                 moe = round(moe, 0)) %>% 
    calc_shares(group = var, denom = "total_pop", value = estimate, moe = moe)

age_lut <- tibble(agegrp = c(99, seq(1:18)),
                                    age = unique(acs_pop$var)) %>% 
    add_row(agegrp = 0, age = "under_5_years")

period_lut <- tibble(
    estimate_date = c(
        "remove_april_2000",
        "remove_july_2000",
        seq(2001, 2009),
        "remove_april_2010",
        "remove_july_2010"),
    year = seq(1:13))

int_pop <- intercensal %>% 
    mutate(geoid = paste(state, county, sep = "")) %>% 
  select(geoid, name = ctyname, year, agegrp, estimate = tot_pop) %>% 
    left_join(age_lut, by = "agegrp") %>% 
    left_join(period_lut, by = "year") %>% 
    filter(!grepl("remove", estimate_date)) %>% 
    select(-year, -agegrp) %>% 
    rename(var = age, year = estimate_date) %>% 
    mutate(year = as.numeric(year),
                 level = "2_counties", county = NA, moe = 0,
                 level = as.factor(level),
                 var = as.factor(var) %>% 
                    fct_relevel(., "under_5_years", "5_to_9_years")) %>% 
    group_by(year, level, geoid, name, county, var) %>% 
    summarise(estimate = sum(estimate), moe = sum(moe)) %>% 
    ungroup() %>% 
    group_by(year, level, geoid, name, county) %>% 
    calc_shares(group = var, denom = "total_pop", value = estimate, moe = moe)

int_ct <- int_pop %>% 
    ungroup() %>% 
    select(-geoid, -level, -name, -share, -sharemoe) %>% 
    group_by(year, county, var) %>% 
    summarise(estimate = sum(estimate), moe = sum(moe)) %>% 
    mutate(name = "Connecticut", level = "1_state", geoid = "09",
                 level = as.factor(level)) %>% 
    ungroup() %>% 
    group_by(year, level, geoid, name, county) %>% 
    calc_shares(group = var, denom = "total_pop", value = estimate, moe = moe)

pop_by_age_out <- bind_rows(int_pop, int_ct, acs_pop) %>% 
    mutate(level = fct_relevel(level, "1_state", "2_counties", "3_towns")) %>% 
    arrange(level, geoid, year)

pop_by_age_out %>% 
    write_csv(., "../output_data/pop_by_age_2000_2018.csv")
```

## Calculate change

``` r
age_change <- pop_by_age_out %>%
    select(-share, -moe, -sharemoe) %>%
    rename(age = var) %>% 
    group_by(level, geoid, county, age) %>%
    arrange(name, year, age) %>%
    mutate(diff = estimate - lag(estimate, default = first(estimate))) %>%
    arrange(level, geoid, year, age) %>%
    mutate(measure = "pop_change_from_prev_data_year") %>%
    select(-estimate) %>%
    rename(estimate = diff) %>% 
    select(year, level, geoid, name, county, age, measure, estimate)
    
age_change %>% 
    write_csv("../output_data/pop_by_age_change_2000_2018.csv")
```