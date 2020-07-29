Housing permits
================

``` r
library(tidyverse)
library(rvest)
library(readxl)
library(janitor)
library(cwi)
library(camiller)
```

Permits, 2001-2019… town-level at
<https://portal.ct.gov/DECD/Content/About_DECD/Research-and-Publications/01_Access-Research/Exports-and-Housing-and-Income-Data>

# Fetch

Jacking Camille’s scrape code

``` r
permit_url <- "https://portal.ct.gov/DECD/Content/About_DECD/Research-and-Publications/01_Access-Research/Exports-and-Housing-and-Income-Data"
decd_base <- "https://portal.ct.gov"

read_html(permit_url) %>%
  html_node("body") %>%
  html_nodes("p:contains('Construction') + ul") %>%
  html_node("li") %>%
  html_nodes("a") %>%
  html_attr("href") %>%
  `[`(1:17) %>%
  walk(function(rel_url) {
    url <- paste0(decd_base, rel_url)
    year <- str_extract(url, "\\d{4}")
    ext <- str_extract(url, "xlsx?")
    download.file(url, destfile = str_glue("../input_data/housing_permit_downloads/housing_permits_{year}.{ext}"))
  })

housing_read <- list.files(file.path("..", "input_data", "housing_permit_downloads"), full.names = T) %>%
  set_names() %>%
  set_names(str_extract, "\\d+") %>%
  map(read_excel, skip = 2)
```

# Clean

Lydia’s table asks for groups as: SF, MF 2-4, and MF 5+

``` r
source("../_utils/town2county.R")

permits <- housing_read %>% 
  map(select, c(1, 3:8)) %>%
  map(~setNames(., c("name", "total", "1 unit", "2 units", "3 to 4 units", "5+ units", "demos"))) %>%
  map_dfr(~filter(., str_detect(total, "\\d")), .id = "year") %>%
  mutate_at(-2, as.numeric) %>% 
  select(-total, -demos) %>%
  gather(key = units, value = value, -year, -name) %>%
  mutate(units = as_factor(units) %>% 
                fct_collapse(units,
                                         `1 unit` = "1 unit",
                                         `2 to 4 units` = c("2 units", "3 to 4 units"),
                                         `5+ units` = "5+ units")) %>% 
    left_join(town2county, by = c("name" = "town")) %>% 
    select(year, name, county, units, value)

write_csv(permits, "../output_data/housing_permits_2001_2019.csv")
```

``` r
permits %>% 
    select(-name) %>% 
    group_by(county, year, units) %>% 
    summarise(value = sum(value)) %>% 
    filter(!is.na(county)) %>% 
    ggplot(aes(year, value, group = units)) +
    geom_line(aes(color = units)) +
    facet_grid(facets = "county")
```

![](housing_permits_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->
