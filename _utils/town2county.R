library(tidyverse)
library(tidycensus)

counties <- get_acs(geography = "county", state = "09", variables = "B01001_001") %>% 
	janitor::clean_names() %>% 
	select(geoid, county = name) %>% 
	mutate(geoid = str_sub(geoid, 1, 5),
				 county = str_remove(county, ", Connecticut"))

town2county <- get_acs(geography = "county subdivision", state = "09", variables = "B01001_001") %>% 
	janitor::clean_names() %>%
	camiller::town_names(name) %>% 
	select(geoid, town = name) %>% 
	mutate(geoid = str_sub(geoid, 1, 5)) %>% 
	left_join(counties, by = "geoid")
