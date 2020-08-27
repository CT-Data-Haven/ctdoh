Split out disability analysis from households desiring housing
================

Tl;dr for code below: I’m making some sociodemographic groups here,
including race (white, Black, Latino, Other), some income groups (very
low, low, mid low, mid high, high) based on median household income, and
cost burden (no burden, cost burden, severe cost burden).

``` r
minc <- get_acs(
    geography = "county",
      table = "B19013",
    state = 09,
      cache_table = T) %>% 
    arrange(GEOID) %>% 
    mutate(countyfip = seq(from = 1, to = 15, by = 2),
                 name = str_remove(NAME, ", Connecticut")) %>% 
    select(countyfip, name, minc = estimate)

ddi <- read_ipums_ddi("../input_data/usa_00043.xml")

pums <- read_ipums_micro(ddi, verbose = F)  %>% 
    mutate_at(vars(YEAR, PUMA, OWNERSHP, OWNERSHPD, RACE, RACED, HISPAN, HISPAND, DIFFREM, DIFFPHYS, DIFFMOB, DIFFCARE, DIFFEYE, DIFFHEAR), as_factor) %>% 
    mutate_at(vars(PERWT, HHWT), as.numeric) %>% 
    mutate_at(vars(HHINCOME, OWNCOST, RENTGRS, OCC), as.integer) %>% 
    janitor::clean_names() %>% 
    left_join(minc, by = "countyfip") %>% 
    mutate(ratio = hhincome / minc) %>% 
    mutate(
        inc_band = cut(
            ratio,
            breaks = c(-Inf, 0.3, 0.5, .8, 1.2, Inf),
            labels = c("Very low", "Low", "Mid-low", "Mid-high", "High"),
            include.lowest = T, right = T)) %>% 
    mutate(
        inc_band = as.factor(inc_band) %>%
            fct_relevel(., "Very low", "Low", "Mid-low", "Mid-high", "High")) %>% 
    mutate(cb = if_else(ownershp == "Rented", (rentgrs * 12) / hhincome, 99999)) %>% 
    mutate(cb = if_else(ownershp == "Owned or being bought (loan)", (owncost * 12) / hhincome, cb)) %>%
    # if housing cost is 0 and income is 0, no burden
    mutate(cb = if_else((rentgrs == 0 & hhincome == 0), 0, cb)) %>%
    mutate(cb = if_else((owncost == 0 & hhincome == 0), 0, cb)) %>%
    #if income is <=0 and housing cost is >0, burden
    mutate(cb = if_else((rentgrs > 0 & hhincome <= 0), 1, cb)) %>%
    mutate(cb = if_else((owncost > 0 & hhincome <= 0), 1, cb)) %>%
    # some people pay more than 100% income to housing, but I will code these as 1
    mutate(cb = if_else(cb > 1, 1, cb)) %>%
    mutate(
        cost_burden = cut(
            cb,
            breaks = c(-Inf, .3, .5, Inf),
            labels = c("No burden", "Cost-burdened", "Severely cost-burdened"),
            include.lowest = T, right = F)) %>% 
        mutate(race2 = if_else(hispan == "Not Hispanic", as.character(race), "Latino")) %>% 
    mutate(race2 = as.factor(race2) %>% 
                    fct_recode(Black = "Black/African American/Negro") %>%
                    fct_other(keep = c("White", "Black", "Latino"), other_level = "Other race") %>%
                    fct_relevel("White", "Black", "Latino", "Other race"))
```

``` r
#logical flag for any disability
pums$has_disability <- apply(pums, 1, function(x) any(grep("Has|Yes", x)))
```

We want 6 categories to group by. These are recorded in the PUMS data as
below:

  - DIFFREM = cognitive disability
  - DIFFPHYS = physical disability
  - DIFFMOB = ambulatory disability
  - DIFFCARE = self care/idependent living difficuly
  - DIFFEYE = vision disability
  - DIFFHEAR = hearing disability

I think the approach I would use is to turn each of those columns into
Y/N or T/F rather than “Has (disability)” whatever text label they use.

``` r
# John
# I am regarding N/A as no disability -- revisit?
# I'm not sure what N/A means, but let's keep it as only yes if answer in the affirmative, like you have it. - kd
# actually, changing this to make NA's FALSE. I don't think it'll change the counts as we have them but this aligns with how I did it - kd
pums$diffrem_TF <- ifelse(str_detect(pums$diffrem, "N/A"), F, 
                          str_detect(pums$diffrem, "Has"))
pums$diffphys_TF <- ifelse(str_detect(pums$diffphys, "N/A"), F, 
                          str_detect(pums$diffphys, "Has")) 
pums$diffmob_TF <- ifelse(str_detect(pums$diffmob, "N/A"), F, 
                          str_detect(pums$diffmob, "Has")) 
pums$diffcare_TF <- ifelse(str_detect(pums$diffcare, "N/A"), F, 
                          str_detect(pums$diffcare, "Yes")) 
pums$diffeye_TF <- ifelse(str_detect(pums$diffeye, "N/A"), F, 
                          str_detect(pums$diffeye, "Yes")) 
pums$diffhear_TF <- ifelse(str_detect(pums$diffhear, "N/A"), F, 
                          str_detect(pums$diffhear, "Yes")) 
pums$disability_sum <- pums %>% 
  select(diffrem_TF:diffhear_TF) %>% 
  apply(1, sum, na.rm=TRUE)
```

The chunk below pulls the data together by creating a LUT of households
with any occupant with a disability, so we only count the household
once. You’ll need to set it up so we count each household only once per
disability type. In other words, we can have a household counted more
than once if they have an occupant with more than one disability type,
or if they have multiple occupants with different disabilities.

``` r
des <- pums %>%
    filter(pernum == "1", hhincome != 9999999, ownershp != "N/A") %>%
    as_survey_design(., ids = 1, wt = hhwt)

ct_hhlds <- des %>%
    select(hhwt, statefip, inc_band) %>% 
    group_by(statefip, inc_band) %>% 
    summarise(value = survey_total(hhwt)) %>% 
    mutate(name = "Connecticut", level = "1_state") %>% 
    select(-statefip)

hh_w_disability <- pums %>%
    filter(has_disability == T) %>% 
    select(cbserial) %>% #cbserial is the hh code
    unique()

ct_inc_band_disability <- des %>% 
    mutate(disability = if_else(cbserial %in% hh_w_disability$cbserial, T, F)) %>% 
    select(hhwt, inc_band, disability) %>% 
    mutate(name = "Connecticut") %>% 
    group_by(name, inc_band, disability) %>% 
    summarise(value = survey_total(hhwt)) %>% 
    ungroup() %>% 
    group_by(name, inc_band)

ct_total_disability <- ct_inc_band_disability %>% 
    select(-value_se) %>% 
  ungroup() %>% 
    mutate(inc_band = "Total") %>% 
    group_by(name, inc_band, disability) %>% 
    summarise(value = sum(value))

ct_inc_band_disability <- ct_inc_band_disability %>% 
    bind_rows(ct_total_disability)
```

Filters in des limit to just HOH, when we really need to be looking at
all occupants before filtering, so here’s a different approach. Keeping
everything split out for now because I have a hunch we’ll want to
combine some of these types

``` r
#fake design, subset dataset
x <- pums %>% 
    filter(hhincome != 9999999, ownershp != "N/A") %>%
    select(cbserial, hhwt, inc_band, ends_with("TF"))

#numerators come from these
diffrem <- x %>% 
    filter(diffrem_TF == T) %>% 
    select(cbserial, hhwt, inc_band) %>% 
    mutate(disability_type = "diffrem") %>% 
    unique() %>% 
    select(-cbserial) %>% 
    group_by(inc_band, disability_type) %>% 
    summarise(households = sum(hhwt)) %>% 
    ungroup()

diffphys <- x %>% 
    filter(diffphys_TF == T) %>% 
    select(cbserial, hhwt, inc_band) %>% 
    mutate(disability_type = "diffphys") %>% 
    unique() %>% 
    select(-cbserial) %>% 
    group_by(inc_band, disability_type) %>% 
    summarise(households = sum(hhwt)) %>% 
    ungroup()

diffmob <- x %>% 
    filter(diffmob_TF == T) %>% 
    select(cbserial, hhwt, inc_band) %>% 
    mutate(disability_type = "diffmob") %>% 
    unique() %>% 
    select(-cbserial) %>% 
    group_by(inc_band, disability_type) %>% 
    summarise(households = sum(hhwt)) %>% 
    ungroup()

diffcare <- x %>% 
    filter(diffcare_TF == T) %>% 
    select(cbserial, hhwt, inc_band) %>% 
    mutate(disability_type = "diffcare") %>% 
    unique() %>% 
    select(-cbserial) %>% 
    group_by(inc_band, disability_type) %>% 
    summarise(households = sum(hhwt)) %>% 
    ungroup()

diffeye <- x %>% 
    filter(diffeye_TF == T) %>% 
    select(cbserial, hhwt, inc_band) %>% 
    mutate(disability_type = "diffeye") %>% 
    unique() %>% 
    select(-cbserial) %>% 
    group_by(inc_band, disability_type) %>% 
    summarise(households = sum(hhwt)) %>% 
    ungroup()

diffhear <- x %>% 
    filter(diffhear_TF == T) %>% 
    select(cbserial, hhwt, inc_band) %>% 
    mutate(disability_type = "diffhear") %>% 
    unique() %>% 
    select(-cbserial) %>% 
    group_by(inc_band, disability_type) %>% 
    summarise(households = sum(hhwt)) %>% 
    ungroup()

hh_disabilities_by_type <- bind_rows(diffcare, diffeye, diffhear, diffmob, diffphys, diffrem)
```

``` r
kable(hh_disabilities_by_type)
```

<table>

<thead>

<tr>

<th style="text-align:left;">

inc\_band

</th>

<th style="text-align:left;">

disability\_type

</th>

<th style="text-align:right;">

households

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

Very low

</td>

<td style="text-align:left;">

diffcare

</td>

<td style="text-align:right;">

17754

</td>

</tr>

<tr>

<td style="text-align:left;">

Low

</td>

<td style="text-align:left;">

diffcare

</td>

<td style="text-align:right;">

9960

</td>

</tr>

<tr>

<td style="text-align:left;">

Mid-low

</td>

<td style="text-align:left;">

diffcare

</td>

<td style="text-align:right;">

11711

</td>

</tr>

<tr>

<td style="text-align:left;">

Mid-high

</td>

<td style="text-align:left;">

diffcare

</td>

<td style="text-align:right;">

9614

</td>

</tr>

<tr>

<td style="text-align:left;">

High

</td>

<td style="text-align:left;">

diffcare

</td>

<td style="text-align:right;">

15413

</td>

</tr>

<tr>

<td style="text-align:left;">

Very low

</td>

<td style="text-align:left;">

diffeye

</td>

<td style="text-align:right;">

14957

</td>

</tr>

<tr>

<td style="text-align:left;">

Low

</td>

<td style="text-align:left;">

diffeye

</td>

<td style="text-align:right;">

8445

</td>

</tr>

<tr>

<td style="text-align:left;">

Mid-low

</td>

<td style="text-align:left;">

diffeye

</td>

<td style="text-align:right;">

8894

</td>

</tr>

<tr>

<td style="text-align:left;">

Mid-high

</td>

<td style="text-align:left;">

diffeye

</td>

<td style="text-align:right;">

7405

</td>

</tr>

<tr>

<td style="text-align:left;">

High

</td>

<td style="text-align:left;">

diffeye

</td>

<td style="text-align:right;">

14087

</td>

</tr>

<tr>

<td style="text-align:left;">

Very low

</td>

<td style="text-align:left;">

diffhear

</td>

<td style="text-align:right;">

18103

</td>

</tr>

<tr>

<td style="text-align:left;">

Low

</td>

<td style="text-align:left;">

diffhear

</td>

<td style="text-align:right;">

14583

</td>

</tr>

<tr>

<td style="text-align:left;">

Mid-low

</td>

<td style="text-align:left;">

diffhear

</td>

<td style="text-align:right;">

17509

</td>

</tr>

<tr>

<td style="text-align:left;">

Mid-high

</td>

<td style="text-align:left;">

diffhear

</td>

<td style="text-align:right;">

15120

</td>

</tr>

<tr>

<td style="text-align:left;">

High

</td>

<td style="text-align:left;">

diffhear

</td>

<td style="text-align:right;">

31272

</td>

</tr>

<tr>

<td style="text-align:left;">

Very low

</td>

<td style="text-align:left;">

diffmob

</td>

<td style="text-align:right;">

33706

</td>

</tr>

<tr>

<td style="text-align:left;">

Low

</td>

<td style="text-align:left;">

diffmob

</td>

<td style="text-align:right;">

19097

</td>

</tr>

<tr>

<td style="text-align:left;">

Mid-low

</td>

<td style="text-align:left;">

diffmob

</td>

<td style="text-align:right;">

19998

</td>

</tr>

<tr>

<td style="text-align:left;">

Mid-high

</td>

<td style="text-align:left;">

diffmob

</td>

<td style="text-align:right;">

18087

</td>

</tr>

<tr>

<td style="text-align:left;">

High

</td>

<td style="text-align:left;">

diffmob

</td>

<td style="text-align:right;">

27996

</td>

</tr>

<tr>

<td style="text-align:left;">

Very low

</td>

<td style="text-align:left;">

diffphys

</td>

<td style="text-align:right;">

47037

</td>

</tr>

<tr>

<td style="text-align:left;">

Low

</td>

<td style="text-align:left;">

diffphys

</td>

<td style="text-align:right;">

27160

</td>

</tr>

<tr>

<td style="text-align:left;">

Mid-low

</td>

<td style="text-align:left;">

diffphys

</td>

<td style="text-align:right;">

28619

</td>

</tr>

<tr>

<td style="text-align:left;">

Mid-high

</td>

<td style="text-align:left;">

diffphys

</td>

<td style="text-align:right;">

24147

</td>

</tr>

<tr>

<td style="text-align:left;">

High

</td>

<td style="text-align:left;">

diffphys

</td>

<td style="text-align:right;">

37749

</td>

</tr>

<tr>

<td style="text-align:left;">

Very low

</td>

<td style="text-align:left;">

diffrem

</td>

<td style="text-align:right;">

32791

</td>

</tr>

<tr>

<td style="text-align:left;">

Low

</td>

<td style="text-align:left;">

diffrem

</td>

<td style="text-align:right;">

17900

</td>

</tr>

<tr>

<td style="text-align:left;">

Mid-low

</td>

<td style="text-align:left;">

diffrem

</td>

<td style="text-align:right;">

18843

</td>

</tr>

<tr>

<td style="text-align:left;">

Mid-high

</td>

<td style="text-align:left;">

diffrem

</td>

<td style="text-align:right;">

15465

</td>

</tr>

<tr>

<td style="text-align:left;">

High

</td>

<td style="text-align:left;">

diffrem

</td>

<td style="text-align:right;">

29978

</td>

</tr>

</tbody>

</table>

``` r
kable(ct_inc_band_disability)
```

<table>

<thead>

<tr>

<th style="text-align:left;">

name

</th>

<th style="text-align:left;">

inc\_band

</th>

<th style="text-align:left;">

disability

</th>

<th style="text-align:right;">

value

</th>

<th style="text-align:right;">

value\_se

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

Connecticut

</td>

<td style="text-align:left;">

Very low

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:right;">

124879

</td>

<td style="text-align:right;">

1939.616

</td>

</tr>

<tr>

<td style="text-align:left;">

Connecticut

</td>

<td style="text-align:left;">

Very low

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:right;">

76498

</td>

<td style="text-align:right;">

1509.591

</td>

</tr>

<tr>

<td style="text-align:left;">

Connecticut

</td>

<td style="text-align:left;">

Low

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:right;">

105139

</td>

<td style="text-align:right;">

1776.579

</td>

</tr>

<tr>

<td style="text-align:left;">

Connecticut

</td>

<td style="text-align:left;">

Low

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:right;">

46206

</td>

<td style="text-align:right;">

1125.341

</td>

</tr>

<tr>

<td style="text-align:left;">

Connecticut

</td>

<td style="text-align:left;">

Mid-low

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:right;">

164046

</td>

<td style="text-align:right;">

2214.536

</td>

</tr>

<tr>

<td style="text-align:left;">

Connecticut

</td>

<td style="text-align:left;">

Mid-low

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:right;">

50444

</td>

<td style="text-align:right;">

1163.525

</td>

</tr>

<tr>

<td style="text-align:left;">

Connecticut

</td>

<td style="text-align:left;">

Mid-high

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:right;">

186625

</td>

<td style="text-align:right;">

2232.000

</td>

</tr>

<tr>

<td style="text-align:left;">

Connecticut

</td>

<td style="text-align:left;">

Mid-high

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:right;">

45211

</td>

<td style="text-align:right;">

1058.285

</td>

</tr>

<tr>

<td style="text-align:left;">

Connecticut

</td>

<td style="text-align:left;">

High

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:right;">

484239

</td>

<td style="text-align:right;">

3034.160

</td>

</tr>

<tr>

<td style="text-align:left;">

Connecticut

</td>

<td style="text-align:left;">

High

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:right;">

84087

</td>

<td style="text-align:right;">

1363.296

</td>

</tr>

<tr>

<td style="text-align:left;">

Connecticut

</td>

<td style="text-align:left;">

Total

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:right;">

1064928

</td>

<td style="text-align:right;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

Connecticut

</td>

<td style="text-align:left;">

Total

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:right;">

302446

</td>

<td style="text-align:right;">

NA

</td>

</tr>

</tbody>

</table>

``` r
hh_disabilities_count_share <- ct_hhlds %>% 
    ungroup() %>% 
    mutate(disability_type = "total") %>% 
    select(inc_band, disability_type, households = value) %>% 
    bind_rows(hh_disabilities_by_type) %>% 
    group_by(inc_band) %>% 
    calc_shares(group = disability_type, denom = "total", value = households)
```

Taking a slightly different look than the table above, the plot below
shows the share of households in each income band that have an occupant
with a disability (so the numerator is households with an occupant with
a disability in a given income band, and the denominator is all
households in that income band).

While the High band has the most (by count) households with an occupant
with a disability, it has the smallest share.

**I think we might want a plot faceted by disability type.**

![](disability_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

![](disability_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

Finally, what are the average cost burden rates for households with an
occupant with a disability?

``` r
ct_cost_ratio_inc_band_disability <- pums %>% 
    mutate(disability = if_else(cbserial %in% hh_w_disability$cbserial, T, F)) %>% 
    filter(pernum == "1", hhincome != 9999999, ownershp != "N/A") %>% 
    select(hhwt, inc_band, disability, cb) %>% 
    mutate(mult = cb * hhwt) %>% 
    group_by(inc_band, disability) %>% 
    summarise(avg_cost_ratio = sum(mult) / sum(hhwt)) %>% 
    ungroup() %>% 
    mutate(name = "Connecticut")
```

Read this chart as: “Households with an occupant with a disability in
the Very Low cost band spend, on average, 66% of household income on
housing costs.”

So the average cost ratio for households with an occupant with a
disability is slightly lower than households without a disabled
occupant, but the general trends in cost ratio across the cost bands
still hold.

**I think this chart is fine as it is, and I just included it so this
notebook has all the disability tabulations in it.**

![](disability_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->
