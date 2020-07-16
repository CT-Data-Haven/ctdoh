library(tidyverse)
library(vroom)

# HMDA loan application data (LAR)
# data from: https://ffiec.cfpb.gov/data-publication/dynamic-national-loan-level-dataset/2019
# codebook: https://ffiec.cfpb.gov/documentation/2019/lar-data-fields/
# 7GB raw data split into 9 files of 2M rows in terminal with top row appended
# raw data are zipped up on black external hd

in_path <- "~/Desktop/hmda/"

file_list <- list.files(path = in_path)

out <- file_list %>% map(~vroom(file = paste(in_path, ., sep = ""), delim = "|") %>%
										filter(state_code == "CT", loan_purpose == 1, action_taken == 1,
													 grepl("Single", derived_dwelling_category)) %>%
										select(state_code, county_code, interest_rate, loan_amount,
													 total_units, hoepa_status, income,
													 starts_with("derived"), starts_with("tract")) %>% 
											mutate(total_units = as.numeric(total_units)))

df <- bind_rows(out)

write_csv(df, "./input_data/hmda_2019_lar.csv")

BRRR::skrrrahh(sound = 22)