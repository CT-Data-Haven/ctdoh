Households desiring housing
================

This notebook needs a better name. “Households desiring housing” to me
suggests a household wants to move, not that they’re unable to afford
housing. Maybe just “gaps in housing units available to households by
income band” or something? Kind of a mouthful…

There’s a lot going on in this notebook:

  - Count and share of households by income band by area
      - Rounded to pretty numbers for legibility?
  - The kinds of occupations/jobs those residents work in
      - Not exactly germane to the conversation unless we’re talking
        about wage reform, but brings the context back down to earth…
  - Count and share of households in each band that are cost-burdened
    (T2 in DC report)
  - Average (median?) housing-cost-to-income ratio for each income band
  - The approximate monthly housing cost for an affordable unit (30%)
    for each income band.
      - Rounded to pretty numbers for legibility?
  - Count and share of units by those cost bands in the area (T3 in DC
    report).
  - Number of housing units needed for each cost band so each household
    would have an affordable housing cost, vs. the actual count of units
    in those cost bands (F19 in DC report)
  - For each income band, the number of households that can/cannot
    afford to pay more
  - Count of vacant units in each cost band (F20 in DC report).

## Establish groups

After discussion with team on 7/15 we are settled with using median hh
income by county and the groupings below:

\*\*7/21: want to bring up to the team tomorrow adding a very high
income category

  - very low income: \<= 0.3 CMI
  - low income: (0.3–0.5\] CMI
  - mid-low income: (0.5–.8\] CMI
  - mid-high income: (.8–1.2\] CMI
  - high income: (1.2–2.0\] CMI
  - very high income: \> 2.0 CMI

Cost-burden in predictable breaks:

  - No burden: Less than 30% income to housing
  - Cost-burdened: 30%-50% income to housing
  - Severely cost-burdened: More than 50% income to housing

And race/ethnicity into a few major categories so we can look at it by
county:

  - White (NH)
  - Black (NH)
  - Latino (any race)
  - All others (grouped)

And for everyone we’re considering affordable 30%, not the sliding scale
they used in the DC report.

## Define income bands

Would it be preferable to set these as prettier breaks, or use the CT
numbers for all counties?

**A better chart here would be color coded segments indicating each
group’s range, with each area on a new row. Could use arrow ends or
something to communicate the top and bottom. Come back to this idea.**

<table>

<caption>

Income ranges by income band and area

</caption>

<thead>

<tr>

<th style="text-align:left;">

Name

</th>

<th style="text-align:left;">

Very low

</th>

<th style="text-align:left;">

Low

</th>

<th style="text-align:left;">

Mid-low

</th>

<th style="text-align:left;">

Mid-high

</th>

<th style="text-align:left;">

High

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

Fairfield County

</td>

<td style="text-align:left;">

Less than $27,891

</td>

<td style="text-align:left;">

Between $27,891 and $46,484

</td>

<td style="text-align:left;">

Between $46,484 and $74,375

</td>

<td style="text-align:left;">

Between $74,375 and $111,563

</td>

<td style="text-align:left;">

More than $111,563

</td>

</tr>

<tr>

<td style="text-align:left;">

Hartford County

</td>

<td style="text-align:left;">

Less than $21,696

</td>

<td style="text-align:left;">

Between $21,696 and $36,160

</td>

<td style="text-align:left;">

Between $36,160 and $57,857

</td>

<td style="text-align:left;">

Between $57,857 and $86,785

</td>

<td style="text-align:left;">

More than $86,785

</td>

</tr>

<tr>

<td style="text-align:left;">

Litchfield County

</td>

<td style="text-align:left;">

Less than $23,494

</td>

<td style="text-align:left;">

Between $23,494 and $39,157

</td>

<td style="text-align:left;">

Between $39,157 and $62,651

</td>

<td style="text-align:left;">

Between $62,651 and $93,977

</td>

<td style="text-align:left;">

More than $93,977

</td>

</tr>

<tr>

<td style="text-align:left;">

Middlesex County

</td>

<td style="text-align:left;">

Less than $25,428

</td>

<td style="text-align:left;">

Between $25,428 and $42,380

</td>

<td style="text-align:left;">

Between $42,380 and $67,809

</td>

<td style="text-align:left;">

Between $67,809 and $101,713

</td>

<td style="text-align:left;">

More than $101,713

</td>

</tr>

<tr>

<td style="text-align:left;">

New Haven County

</td>

<td style="text-align:left;">

Less than $20,138

</td>

<td style="text-align:left;">

Between $20,138 and $33,564

</td>

<td style="text-align:left;">

Between $33,564 and $53,702

</td>

<td style="text-align:left;">

Between $53,702 and $80,554

</td>

<td style="text-align:left;">

More than $80,554

</td>

</tr>

<tr>

<td style="text-align:left;">

New London County

</td>

<td style="text-align:left;">

Less than $21,410

</td>

<td style="text-align:left;">

Between $21,410 and $35,684

</td>

<td style="text-align:left;">

Between $35,684 and $57,094

</td>

<td style="text-align:left;">

Between $57,094 and $85,642

</td>

<td style="text-align:left;">

More than $85,642

</td>

</tr>

<tr>

<td style="text-align:left;">

Tolland County

</td>

<td style="text-align:left;">

Less than $25,475

</td>

<td style="text-align:left;">

Between $25,475 and $42,458

</td>

<td style="text-align:left;">

Between $42,458 and $67,933

</td>

<td style="text-align:left;">

Between $67,933 and $101,899

</td>

<td style="text-align:left;">

More than $101,899

</td>

</tr>

<tr>

<td style="text-align:left;">

Windham County

</td>

<td style="text-align:left;">

Less than $19,432

</td>

<td style="text-align:left;">

Between $19,432 and $32,387

</td>

<td style="text-align:left;">

Between $32,387 and $51,819

</td>

<td style="text-align:left;">

Between $51,819 and $77,729

</td>

<td style="text-align:left;">

More than $77,729

</td>

</tr>

<tr>

<td style="text-align:left;">

Connecticut

</td>

<td style="text-align:left;">

Less than $22,832

</td>

<td style="text-align:left;">

Between $22,832 and $38,053

</td>

<td style="text-align:left;">

Between $38,053 and $60,885

</td>

<td style="text-align:left;">

Between $60,885 and $91,327

</td>

<td style="text-align:left;">

More than $91,327

</td>

</tr>

</tbody>

</table>

## Count/share of households by income band

Using the new breakdowns, high income households *vastly* outnumber
lower income households.

FYI, each county was very consistent in its share of households in each
income band. High income was more than 40% with the rest somewhere
between 10% and 20%

![](hh_desiring_housing_files/figure-gfm/hh%20by%20inc%20band%20bar%20chart-1.png)<!-- -->

<table>

<caption>

Number of households by income band

</caption>

<thead>

<tr>

<th style="text-align:left;">

Name

</th>

<th style="text-align:left;">

Very low

</th>

<th style="text-align:left;">

Low

</th>

<th style="text-align:left;">

Mid-low

</th>

<th style="text-align:left;">

Mid-high

</th>

<th style="text-align:left;">

High

</th>

<th style="text-align:left;">

Total

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

Fairfield County

</td>

<td style="text-align:left;">

55,251

</td>

<td style="text-align:left;">

38,220

</td>

<td style="text-align:left;">

51,287

</td>

<td style="text-align:left;">

53,533

</td>

<td style="text-align:left;">

142,201

</td>

<td style="text-align:left;">

340,492

</td>

</tr>

<tr>

<td style="text-align:left;">

Hartford County

</td>

<td style="text-align:left;">

52,900

</td>

<td style="text-align:left;">

37,375

</td>

<td style="text-align:left;">

55,552

</td>

<td style="text-align:left;">

57,614

</td>

<td style="text-align:left;">

145,622

</td>

<td style="text-align:left;">

349,063

</td>

</tr>

<tr>

<td style="text-align:left;">

Litchfield County

</td>

<td style="text-align:left;">

8,698

</td>

<td style="text-align:left;">

8,655

</td>

<td style="text-align:left;">

11,899

</td>

<td style="text-align:left;">

14,645

</td>

<td style="text-align:left;">

30,090

</td>

<td style="text-align:left;">

73,987

</td>

</tr>

<tr>

<td style="text-align:left;">

Middlesex County

</td>

<td style="text-align:left;">

9,466

</td>

<td style="text-align:left;">

7,567

</td>

<td style="text-align:left;">

10,680

</td>

<td style="text-align:left;">

12,075

</td>

<td style="text-align:left;">

27,105

</td>

<td style="text-align:left;">

66,893

</td>

</tr>

<tr>

<td style="text-align:left;">

New Haven County

</td>

<td style="text-align:left;">

47,160

</td>

<td style="text-align:left;">

37,512

</td>

<td style="text-align:left;">

52,407

</td>

<td style="text-align:left;">

53,410

</td>

<td style="text-align:left;">

139,367

</td>

<td style="text-align:left;">

329,856

</td>

</tr>

<tr>

<td style="text-align:left;">

New London County

</td>

<td style="text-align:left;">

14,344

</td>

<td style="text-align:left;">

10,745

</td>

<td style="text-align:left;">

17,668

</td>

<td style="text-align:left;">

20,979

</td>

<td style="text-align:left;">

43,666

</td>

<td style="text-align:left;">

107,402

</td>

</tr>

<tr>

<td style="text-align:left;">

Tolland County

</td>

<td style="text-align:left;">

7,722

</td>

<td style="text-align:left;">

6,681

</td>

<td style="text-align:left;">

8,039

</td>

<td style="text-align:left;">

10,580

</td>

<td style="text-align:left;">

22,196

</td>

<td style="text-align:left;">

55,218

</td>

</tr>

<tr>

<td style="text-align:left;">

Windham County

</td>

<td style="text-align:left;">

5,836

</td>

<td style="text-align:left;">

4,590

</td>

<td style="text-align:left;">

6,958

</td>

<td style="text-align:left;">

9,000

</td>

<td style="text-align:left;">

18,079

</td>

<td style="text-align:left;">

44,463

</td>

</tr>

<tr>

<td style="text-align:left;">

Connecticut

</td>

<td style="text-align:left;">

201,377

</td>

<td style="text-align:left;">

151,345

</td>

<td style="text-align:left;">

214,490

</td>

<td style="text-align:left;">

231,836

</td>

<td style="text-align:left;">

568,326

</td>

<td style="text-align:left;">

1,367,374

</td>

</tr>

</tbody>

</table>

## Household characteristics by income bands

### Race breakdowns

Considering race/ethnicity of head of household. Statewide, a quarter of
all households headed by a Black or Latino person are very low income,
earning less than 30% of the county household median income, compared to
just over a tenth of households headed by a white person. Some variation
exists by county. In the three largest counties, half of white
households are high income.

**What else do I want to do with this? Could use pivot the data… share
of race by income band rather than share of income band by race. We have
lots of cost burden by race data elsewhere, could pull something in from
HER. I hesitate to divide it up too much more than this.**

![](hh_desiring_housing_files/figure-gfm/hh%20by%20inc%20band%20by%20race%20bar%20charts-1.png)<!-- -->

**Add disability flag and do like pct of hh in each income band
(statewide) with a disabled person living there. Break it down by
disability type?**

### Jobs held by household occupants

Retrieved a list of 2018 occ codes from the Census Bureau at
<https://www.census.gov/topics/employment/industry-occupation/guidance/code-lists.html>.

This table lists the top five occupations, in order from the most
numerous, for household inhabitants—so not just heads of household, but
all household members, including inhabitants with no work experience in
the past 5 years or who have never worked—by household income band by
county.

To be honest, this is a little surprising in places. I expected more
food service workers in general, and I’m surprised at how many
elementary and middle school teachers are workers in higher income
households. Either I have the exact wrong impression of how much
teachers are paid or it’s a common occupation for people whose
partners/spouses pull in big money. And yet, \#thestruggle: adjuncts and
GAs in Tolland County (UConn) getting those minimum wage grad school
stipends while profs in New Haven and Middlesex Counties make six
figures teaching half the load.

**Mark brought up a good point about common occupations (like teachers,
cashiers) present in each income band. If this is used in the report, it
might be best to look at the output and cherry pick some representative
occupations.**

<table>

<caption>

Common occupations for workers by household income band

</caption>

<thead>

<tr>

<th style="text-align:left;">

Name

</th>

<th style="text-align:left;">

Very low

</th>

<th style="text-align:left;">

Low

</th>

<th style="text-align:left;">

Mid-low

</th>

<th style="text-align:left;">

Mid-high

</th>

<th style="text-align:left;">

High

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

Fairfield County

</td>

<td style="text-align:left;">

Cashiers; Unemployed, with no work experience in the last 5 years or
earlier or never worked; Maids and housekeeping cleaners; Childcare
workers; Landscaping and groundskeeping workers

</td>

<td style="text-align:left;">

Maids and housekeeping cleaners; Janitors and building cleaners;
Landscaping and groundskeeping workers; Cashiers; Childcare workers

</td>

<td style="text-align:left;">

Cashiers; Maids and housekeeping cleaners; Janitors and building
cleaners; Secretaries and administrative assistants, except legal,
medical, and executive; Retail salespersons

</td>

<td style="text-align:left;">

Elementary and middle school teachers; Cashiers; Retail salespersons;
Secretaries and administrative assistants, except legal, medical, and
executive; Driver/sales workers and truck drivers

</td>

<td style="text-align:left;">

Managers, all other; Elementary and middle school teachers; Accountants
and auditors; Financial managers; Chief executives

</td>

</tr>

<tr>

<td style="text-align:left;">

Hartford County

</td>

<td style="text-align:left;">

Cashiers; Unemployed, with no work experience in the last 5 years or
earlier or never worked; Personal care aides; Janitors and building
cleaners; Nursing assistants

</td>

<td style="text-align:left;">

Cashiers; Janitors and building cleaners; Unemployed, with no work
experience in the last 5 years or earlier or never worked; Retail
salespersons; Nursing assistants

</td>

<td style="text-align:left;">

Cashiers; Retail salespersons; Nursing assistants; Unemployed, with no
work experience in the last 5 years or earlier or never worked;
Secretaries and administrative assistants, except legal, medical, and
executive

</td>

<td style="text-align:left;">

Cashiers; Secretaries and administrative assistants, except legal,
medical, and executive; Janitors and building cleaners; Driver/sales
workers and truck drivers; Customer service representatives

</td>

<td style="text-align:left;">

Managers, all other; Elementary and middle school teachers; Registered
nurses; Accountants and auditors; Retail salespersons

</td>

</tr>

<tr>

<td style="text-align:left;">

Litchfield County

</td>

<td style="text-align:left;">

Retail salespersons; Laborers and freight, stock, and material movers,
hand; Personal care aides; Cashiers; Janitors and building cleaners

</td>

<td style="text-align:left;">

Janitors and building cleaners; First-Line supervisors of retail sales
workers; Waiters and waitresses; Personal care aides; Customer service
representatives

</td>

<td style="text-align:left;">

Janitors and building cleaners; Cashiers; Secretaries and administrative
assistants, except legal, medical, and executive; Driver/sales workers
and truck drivers; Bookkeeping, accounting, and auditing clerks

</td>

<td style="text-align:left;">

First-Line supervisors of retail sales workers; Elementary and middle
school teachers; Landscaping and groundskeeping workers; Retail
salespersons; Secretaries and administrative assistants, except legal,
medical, and executive

</td>

<td style="text-align:left;">

Elementary and middle school teachers; Managers, all other; Registered
nurses; Chief executives; Customer service representatives

</td>

</tr>

<tr>

<td style="text-align:left;">

Middlesex County

</td>

<td style="text-align:left;">

Customer service representatives; Cashiers; Driver/sales workers and
truck drivers; First-Line supervisors of retail sales workers; Nursing
assistants

</td>

<td style="text-align:left;">

Cashiers; Waiters and waitresses; Office clerks, general; Maids and
housekeeping cleaners; Inspectors, testers, sorters, samplers, and
weighers

</td>

<td style="text-align:left;">

Cashiers; Secretaries and administrative assistants, except legal,
medical, and executive; First-Line supervisors of retail sales workers;
Customer service representatives; Nursing assistants

</td>

<td style="text-align:left;">

Managers, all other; Elementary and middle school teachers; Registered
nurses; Secretaries and administrative assistants, except legal,
medical, and executive; Janitors and building cleaners

</td>

<td style="text-align:left;">

Elementary and middle school teachers; Managers, all other; Registered
nurses; Chief executives; Postsecondary teachers

</td>

</tr>

<tr>

<td style="text-align:left;">

New Haven County

</td>

<td style="text-align:left;">

Unemployed, with no work experience in the last 5 years or earlier or
never worked; Cashiers; Customer service representatives; Personal care
aides; Janitors and building cleaners

</td>

<td style="text-align:left;">

Cashiers; Unemployed, with no work experience in the last 5 years or
earlier or never worked; Personal care aides; Nursing assistants; Retail
salespersons

</td>

<td style="text-align:left;">

Cashiers; Nursing assistants; Retail salespersons; First-Line
supervisors of retail sales workers; Janitors and building cleaners

</td>

<td style="text-align:left;">

Janitors and building cleaners; First-Line supervisors of retail sales
workers; Retail salespersons; Cashiers; Secretaries and administrative
assistants, except legal, medical, and executive

</td>

<td style="text-align:left;">

Elementary and middle school teachers; Managers, all other; Registered
nurses; Secretaries and administrative assistants, except legal,
medical, and executive; First-Line supervisors of retail sales workers

</td>

</tr>

<tr>

<td style="text-align:left;">

New London County

</td>

<td style="text-align:left;">

Maids and housekeeping cleaners; Janitors and building cleaners; Waiters
and waitresses; Unemployed, with no work experience in the last 5 years
or earlier or never worked; Cashiers

</td>

<td style="text-align:left;">

Cashiers; Janitors and building cleaners; Retail salespersons; Cooks;
Laborers and freight, stock, and material movers, hand

</td>

<td style="text-align:left;">

Janitors and building cleaners; Cashiers; Gambling services workers;
Landscaping and groundskeeping workers; Nursing assistants

</td>

<td style="text-align:left;">

Secretaries and administrative assistants, except legal, medical, and
executive; Driver/sales workers and truck drivers; Cashiers; First-Line
supervisors of retail sales workers; Elementary and middle school
teachers

</td>

<td style="text-align:left;">

Managers, all other; Elementary and middle school teachers; Military
enlisted tactical operations and air/weapons specialists and crew
members; Registered nurses; Cashiers

</td>

</tr>

<tr>

<td style="text-align:left;">

Tolland County

</td>

<td style="text-align:left;">

Waiters and waitresses; Postsecondary teachers; Customer service
representatives; Nursing assistants; Cashiers

</td>

<td style="text-align:left;">

Waiters and waitresses; Driver/sales workers and truck drivers; Chefs
and head cooks; Receptionists and information clerks; Customer service
representatives

</td>

<td style="text-align:left;">

Retail salespersons; Driver/sales workers and truck drivers; Teaching
assistants; Childcare workers; First-Line supervisors of retail sales
workers

</td>

<td style="text-align:left;">

Accountants and auditors; Elementary and middle school teachers;
Cashiers; Secretaries and administrative assistants, except legal,
medical, and executive; Registered nurses

</td>

<td style="text-align:left;">

Managers, all other; Elementary and middle school teachers; Secretaries
and administrative assistants, except legal, medical, and executive;
Registered nurses; Cashiers

</td>

</tr>

<tr>

<td style="text-align:left;">

Windham County

</td>

<td style="text-align:left;">

Unemployed, with no work experience in the last 5 years or earlier or
never worked; Janitors and building cleaners; Maids and housekeeping
cleaners; Waiters and waitresses; Retail salespersons

</td>

<td style="text-align:left;">

Laborers and freight, stock, and material movers, hand; Retail
salespersons; Personal care aides; Nursing assistants; Driver/sales
workers and truck drivers

</td>

<td style="text-align:left;">

Janitors and building cleaners; Driver/sales workers and truck drivers;
Landscaping and groundskeeping workers; Food preparation workers; Cooks

</td>

<td style="text-align:left;">

Nursing assistants; First-Line supervisors of retail sales workers;
Driver/sales workers and truck drivers; Secretaries and administrative
assistants, except legal, medical, and executive; Customer service
representatives

</td>

<td style="text-align:left;">

Registered nurses; Cashiers; Elementary and middle school teachers;
Driver/sales workers and truck drivers; Secretaries and administrative
assistants, except legal, medical, and executive

</td>

</tr>

</tbody>

</table>

## Cost burden by income band

Real quick top level summary of cost burden before we get into the
details.

![](hh_desiring_housing_files/figure-gfm/cb%20totals%20bar%20chart-1.png)<!-- -->

No surprise that cost burden rates among very low income households are
more than 80%. At the statewide level that’s more than 14x the rate of
high income households.

![](hh_desiring_housing_files/figure-gfm/cb%20rate%20dot%20plot-1.png)<!-- -->

Breaking this down by regular and severe cost burden (although I don’t
think we should do this in the report\!) in Fairfield and New Haven
Counties, about the same share of low income households are cost
burdened or severely cost burdened. Two-thirds or more very low income
households are severely cost burdened.

**Note, these would add up to 100% if households with no burden were
included, so the chart is read as “16% of very low income households in
Connecticut are cost burdened and another 70% are severely cost
burdened.”**

![](hh_desiring_housing_files/figure-gfm/cb%20burden%20by%20severity%20dot%20plot-1.png)<!-- -->

Quick diversion: is the SCB rate among very low income households
partially explained by some of these households having housing costs and
no/negative negative income?

By definition, the household is in the “very low income” income band if
household income is $0 or less because that’s less than 30% CMI. There
are about 15K poor households with no or negative income and some
nonzero housing cost, making them “severely cost burdened” by
definition. These \~15K units make up about 7% of all very low income
households, which is not insignificant, but it’s not the sole motivator
for high SCB rates in this income band.

    ## # A tibble: 2 x 4
    ##   income          cost_burden            households households_se
    ##   <chr>           <fct>                       <dbl>         <dbl>
    ## 1 negative_income Severely cost-burdened        366          79.2
    ## 2 no_income       Severely cost-burdened      14470         681.

## Average housing-cost-to-income ratio for each band

Urban’s DC study found that higher income households paid about 12%
income to housing. In CT it’s about 16%. For a household with $200K in
income, that’s about $2667/month in housing costs, which I just don’t
think is that high considering there are some kinda crappy 2BRs in East
Rock that go for that much.

For a household at the lower end of CT’s affluent band, earning about
$114K, 16% of income to housing cost would be about $1520, which as a
renter strikes me as unbelievably low for someone of those means. It’s
the same as 30% for someone earning $60K. Why is that OK?

**7/15:** Talked with the team and I think we’re going to use 30% for
all income bands rather than the sliding scale.

![](hh_desiring_housing_files/figure-gfm/hcost%20to%20income%20ratio%20dotplot-1.png)<!-- -->

One last thing real quick… what’s the average *actual* housing cost for
each band?

![](hh_desiring_housing_files/figure-gfm/actual%20cost%20dot%20plot-1.png)<!-- -->

Here, I looked only at households whose housing costs exceed 30% of
income, and took the weighted average of the gap between what they
actually pay for housing versus what they should pay at an affordable
(30%) threshold. Very low and high income households spend the most over
the affordable threshold. The average gap for households in all income
bands in FC is over $800/month while in most other counties the gap
falls between $400 and $800/month.

![](hh_desiring_housing_files/figure-gfm/affordability%20gap%20dot%20plot-1.png)<!-- -->

## Affordable housing costs to households in each band

Some future iteration of this notebook should find a way to combine this
table with the actual housing costs chart above, but the topline is that
the average actual costs in low and very low income households exceeds
the affordable threshold (except low income households in Windham
County). The middle-to-high income households’ average actual housing
cost is within the affordable range.

<table>

<caption>

Affordable monthly housing cost ranges by income band and area

</caption>

<thead>

<tr>

<th style="text-align:left;">

Name

</th>

<th style="text-align:left;">

Very low

</th>

<th style="text-align:left;">

Low

</th>

<th style="text-align:left;">

Mid-low

</th>

<th style="text-align:left;">

Mid-high

</th>

<th style="text-align:left;">

High

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

Fairfield County

</td>

<td style="text-align:left;">

Less than $697

</td>

<td style="text-align:left;">

Between $697 and $1,162

</td>

<td style="text-align:left;">

Between $1,162 and $1,859

</td>

<td style="text-align:left;">

Between $1,859 and $2,789

</td>

<td style="text-align:left;">

More than $2,789

</td>

</tr>

<tr>

<td style="text-align:left;">

Hartford County

</td>

<td style="text-align:left;">

Less than $542

</td>

<td style="text-align:left;">

Between $542 and $904

</td>

<td style="text-align:left;">

Between $904 and $1,446

</td>

<td style="text-align:left;">

Between $1,446 and $2,170

</td>

<td style="text-align:left;">

More than $2,170

</td>

</tr>

<tr>

<td style="text-align:left;">

Litchfield County

</td>

<td style="text-align:left;">

Less than $587

</td>

<td style="text-align:left;">

Between $587 and $979

</td>

<td style="text-align:left;">

Between $979 and $1,566

</td>

<td style="text-align:left;">

Between $1,566 and $2,349

</td>

<td style="text-align:left;">

More than $2,349

</td>

</tr>

<tr>

<td style="text-align:left;">

Middlesex County

</td>

<td style="text-align:left;">

Less than $636

</td>

<td style="text-align:left;">

Between $636 and $1,060

</td>

<td style="text-align:left;">

Between $1,060 and $1,695

</td>

<td style="text-align:left;">

Between $1,695 and $2,543

</td>

<td style="text-align:left;">

More than $2,543

</td>

</tr>

<tr>

<td style="text-align:left;">

New Haven County

</td>

<td style="text-align:left;">

Less than $503

</td>

<td style="text-align:left;">

Between $503 and $839

</td>

<td style="text-align:left;">

Between $839 and $1,343

</td>

<td style="text-align:left;">

Between $1,343 and $2,014

</td>

<td style="text-align:left;">

More than $2,014

</td>

</tr>

<tr>

<td style="text-align:left;">

New London County

</td>

<td style="text-align:left;">

Less than $535

</td>

<td style="text-align:left;">

Between $535 and $892

</td>

<td style="text-align:left;">

Between $892 and $1,427

</td>

<td style="text-align:left;">

Between $1,427 and $2,141

</td>

<td style="text-align:left;">

More than $2,141

</td>

</tr>

<tr>

<td style="text-align:left;">

Tolland County

</td>

<td style="text-align:left;">

Less than $637

</td>

<td style="text-align:left;">

Between $637 and $1,061

</td>

<td style="text-align:left;">

Between $1,061 and $1,698

</td>

<td style="text-align:left;">

Between $1,698 and $2,547

</td>

<td style="text-align:left;">

More than $2,547

</td>

</tr>

<tr>

<td style="text-align:left;">

Windham County

</td>

<td style="text-align:left;">

Less than $486

</td>

<td style="text-align:left;">

Between $486 and $810

</td>

<td style="text-align:left;">

Between $810 and $1,295

</td>

<td style="text-align:left;">

Between $1,295 and $1,943

</td>

<td style="text-align:left;">

More than $1,943

</td>

</tr>

<tr>

<td style="text-align:left;">

Connecticut

</td>

<td style="text-align:left;">

Less than $571

</td>

<td style="text-align:left;">

Between $571 and $951

</td>

<td style="text-align:left;">

Between $951 and $1,522

</td>

<td style="text-align:left;">

Between $1,522 and $2,283

</td>

<td style="text-align:left;">

More than $2,283

</td>

</tr>

</tbody>

</table>

## What income band do households live in, what cost band do they pay in?

There are many more higher income households than units in that cost
band, so high income households have to occupy housing affordable to
lower-income households. Likewise, the same holds at the other extreme:
there are many more very low income households than very low income
units and they have to occupy more expensive housing than they can
afford.

Knowing that households paying into a cost band are a subset of
households across many income bands, here’s a heat map of households by
income band and the cost band they pay into. Add each row and you’ll get
the total number of households in each income band. Add each column and
you’ll get the total of all households in each cost band.

There are a couple caveats… people who own their homes outright and just
have some utility costs are usually in the very low cost band but may be
in any income band. There are also a fair amount of people who are high
income but have $0 cash rents (I guess their company or someone else
pays their rent?) who would be in the very low cost band.

![](hh_desiring_housing_files/figure-gfm/income%20vs%20cost%20band%20heat%20map-1.png)<!-- -->

## How many housing units are in each cost bands

Establishing that there’s a need for housing in lower cost bands, how
many units exist in each band? This adds vacants to the occupied units
above.

Using ratio of rentgrs / rent to determine how much on top of contract
payment utilities, etc. might be. I can’t think of a similar way to do
that for homes for sale so I’m just gonna use the same ratio for owner
unis, too.

In addition to the occupied units we’ve already looked at, this chart
adds two categories of vacant units: “Vacant-On market” units are listed
as “For rent or sale” or “For sale only,” and “Vacant-Off market” are
vacant units that have been sold or rented but are not yet occupied.

![](hh_desiring_housing_files/figure-gfm/units%20by%20tenure%20and%20occ%20bar%20chart-1.png)<!-- -->

There are two other major vacancy categories, “Other vacant” and “For
seasonal, recreational, or other occasional use”, but there’s no cost
information associated with those units, so they can’t be sorted into
the appropriate cost bands. Another minor category are housing units
reserved for migrant farm workers. Collectively, these comprise about
83,000 units, which is a ton by CT standards. Bridgeport, New Haven,
Hartford all have about 50,000 units each.

    ## # A tibble: 3 x 2
    ##   vacancy                                             hhwt
    ##   <fct>                                              <dbl>
    ## 1 For seasonal, recreational or other occasional use 29578
    ## 2 For migrant farm workers                             129
    ## 3 Other vacant                                       53438

## Households who need housing in each cost band

To get a table of gaps and surpluses, I think I need to determine how
many units are needed in each cost band (so, by default this will be the
number of households in each income band if low income households should
pay low income prices, right?), then count up the number of households
whose costs are in each cost band and add the vacants by contract and
mortgage costs. So how many households in each income band, vs. how many
units in each cost band. Seems legit?

## Add homeless?

Mark suggests <https://cceh.org> for subcounty estimates, but I’m not
sure how best to align CANs to counties, so instead I think this should
be separate and included in the statewide count.

Looks like in 2018 there were 2,253 adults-only households, 370
adults-and-children households, and 7 children-only households for a
total of 2,630 households (3,383 people). We should add these households
to very low income units needed.

Source: <https://cceh.org/data/interactive/2018pitdashboard/>
