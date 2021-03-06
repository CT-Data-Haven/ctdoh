Housing units
================

``` r
library(tidyverse)
library(tidycensus)
library(janitor)
library(cwi)
library(camiller)
library(ipumsr)
library(srvyr)
```

Change in total units by tenure (occ + vacant?), units in structure (SF,
2-4 units, 5+ units), number bedrooms. Presumably PUMS because ACS is
households not units. DECD data has vacancy among total units for 2010.
Do we want 2000, 2018?

## Setup PUMS file

``` r
names <- tibble(countyfip = seq(from = 1, to = 15, by = 2),
                                name = c("Fairfield County", "Hartford County", "Litchfield County", "Middlesex County", "New Haven County", "New London County", "Tolland County", "Windham County"))

ddi <- read_ipums_ddi("../input_data/usa_00047.xml")

pums <- read_ipums_micro(ddi, verbose = F) %>% 
    filter(RECTYPE == "H") %>% 
    mutate_at(vars(YEAR, OWNERSHP, VACANCY, UNITSSTR, BEDROOMS), as_factor) %>% 
    mutate_at(vars(HHWT, COUNTYFIP), as.numeric) %>% 
    clean_names() %>% 
    left_join(names, by = "countyfip") %>% 
    select(year, name, ownershp, vacancy, unitsstr, bedrooms, hhwt) %>% 
    mutate(ownershp2 = fct_recode(ownershp,
                                                                `Owner` = "Owned or being bought (loan)",
                                                                `Renter` = "Rented"),
                 ownershp2 = as.character(ownershp2),
                 ownershp2 = if_else(vacancy == "For rent or sale", "Renter", ownershp2),
                 ownershp2 = if_else(vacancy == "For sale only", "Owner", ownershp2),
                 ownershp2 = as.factor(ownershp2)) %>% 
    mutate(type = as.factor(unitsstr) %>% 
                    fct_collapse(., `Single family` = c("1-family house, detached", "1-family house, attached", "Mobile home or trailer", "Boat, tent, van, other"),
                                             Multifamily = c("2-family building", "3-4 family building", "5-9 family building", "10-19 family building", "20-49 family building", "50+ family building"))) %>% 
    mutate(bdr = as.factor(bedrooms) %>% 
                    fct_collapse(., `Studio or 1 bedroom` = c("No bedrooms", "1"),
                                             `2 bedrooms` = "2",
                                             `3 bedrooms` = "3",
                                             `4 or more bedrooms` = c("4 (1970-2000, 2000-2007 ACS/PRCS)", "5+ (1970-2000, 2000-2007 ACS/PRCS)", "6", "7", "8")))
```

# By tenure

``` r
tenure <- pums %>% 
    filter(ownershp2 != "N/A") %>% 
    select(year, name, ownershp2, hhwt) %>% 
    group_by(year, name, ownershp2) %>% 
    summarise(units = sum(hhwt)) %>% 
    ungroup()

write_csv(tenure, path = "../output_data/units_by_tenure_2000_2018.csv")
```

``` r
tenure %>% 
    filter(year != 2010) %>% 
    pivot_wider(id_cols = c(name, ownershp2), names_from = year, names_prefix = "x", values_from = units) %>% 
    mutate(diff = x2018 - x2000) %>% 
    mutate(name = as.factor(name) %>% fct_rev(),
                 ownershp2 = fct_rev(ownershp2)) %>% 
    ggplot(aes(diff, name, group = ownershp2)) +
    geom_col(aes(fill = ownershp2), width = .8, position = position_dodge(.85)) +
    geom_text(aes(label = scales::comma(diff, accuracy = 1)), hjust = 1.04,
                        position = position_dodge(.85), family = "Roboto Condensed") +
    scale_x_continuous(labels = scales::comma_format(),
                                         expand = expansion(mult = c(.1, .1))) +
    guides(fill = guide_legend(title = "", reverse = T)) +
    hrbrthemes::theme_ipsum_rc() +
    labs(title = "Change in total units by tenure, 2000–2018",
             x = "", y = "",
             caption = "Includes vacant units.") +
    theme(plot.title.position = "plot",
                legend.position = "right", 
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank(),
                axis.text.x = element_blank(),
                axis.text.y = element_text(colour = "black"))
```

![](housing_units_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

## By building type

Small multifamily (2-4 units) are so small it messes up the scale of the
bars, so I’m lumping all MF together

``` r
bldg_type <- pums %>% 
    filter(type != "N/A") %>% 
    select(year, name, type, hhwt) %>% 
    group_by(year, name, type) %>% 
    summarise(units = sum(hhwt)) %>% 
    ungroup()

write_csv(bldg_type, path = "../output_data/units_by_bldg_type_2000_2018.csv")
```

``` r
bldg_type %>% 
    filter(year != 2010) %>% 
    pivot_wider(id_cols = c(name, type), names_from = year, names_prefix = "x", values_from = units) %>% 
    mutate(diff = x2018 - x2000) %>% 
    mutate(name = as.factor(name) %>% fct_rev(),
                 type = fct_rev(type)) %>% 
    ggplot(aes(diff, name, group = type)) +
    geom_col(aes(fill = type), width = .8, position = position_dodge(.85)) +
    geom_text(aes(label = scales::comma(diff, accuracy = 1)), hjust = 1.04,
                        position = position_dodge(.85), family = "Roboto Condensed") +
    scale_x_continuous(labels = scales::comma_format(),
                                         expand = expansion(mult = c(.05, .1))) +
    guides(fill = guide_legend(title = "", reverse = T)) +
    hrbrthemes::theme_ipsum_rc() +
    labs(title = "Change in total units by building type, 2000–2018",
             x = "", y = "",
             caption = "Includes vacant units.") +
    theme(plot.title.position = "plot",
                legend.position = "right", 
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank(),
                axis.text.x = element_blank(),
                axis.text.y = element_text(colour = "black"))
```

![](housing_units_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

## By number of bedrooms

0-1, 2, 3, 4+

``` r
bedrooms <- pums %>% 
    filter(bdr != "N/A") %>% 
    select(year, name, bdr, hhwt) %>% 
    group_by(year, name, bdr) %>% 
    summarise(units = sum(hhwt)) %>% 
    ungroup()

write_csv(bedrooms, path = "../output_data/units_by_bedrooms_2000_2018.csv")
```

``` r
bedrooms %>% 
    filter(year != 2010) %>% 
    pivot_wider(id_cols = c(name, bdr), names_from = year, names_prefix = "x", values_from = units) %>% 
    mutate(diff = x2018 - x2000) %>% 
    mutate(name = as.factor(name) %>% fct_rev(),
                 bdr = fct_rev(bdr)) %>% 
    ggplot(aes(diff, name, group = bdr)) +
    geom_col(aes(fill = bdr), width = .8, position = position_dodge(.85)) +
    geom_text(aes(label = scales::comma(diff, accuracy = 1)), hjust = 1.04,
                        position = position_dodge(.85), family = "Roboto Condensed") +
    scale_x_continuous(labels = scales::comma_format(),
                                         expand = expansion(mult = c(.05, .1))) +
    guides(fill = guide_legend(title = "", reverse = T)) +
    hrbrthemes::theme_ipsum_rc() +
    labs(title = "Change in total units by building type, 2000–2018",
             x = "", y = "",
             caption = "Includes vacant units.") +
    theme(plot.title.position = "plot",
                legend.position = "bottom", 
                panel.grid.major = element_blank(),
                panel.grid.minor = element_blank(),
                axis.text.x = element_blank(),
                axis.text.y = element_text(colour = "black"))
```

![](housing_units_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->
