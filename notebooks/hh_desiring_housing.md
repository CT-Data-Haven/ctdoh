Households desiring housing
================

This analysis needs a better name. “Households desiring housing” to me
suggests a household wants to move or is unhoused. Maybe just
“households by income and affordable housing units” or something? Kind
of a mouthful…

There’s a lot going on in this notebook:

  - Count and share of households by income band, and further:
      - households by income band by race
      - households by income band by presence of inhabitant with
        disability
  - The kinds of occupations/jobs those household members work in
  - Count and share of households in each band that are cost-burdened
  - Average housing-cost-to-income ratio for each income band
  - Average actual housing cost by cost band
  - Approximate monthly housing cost range for an affordable unit (30%)
    for each income band (henceforth cost bands)
  - Number of households in each income band versus what cost band they
    pay into
  - Count and share of units by cost bands
  - Vacant units in each cost band
  - Number of housing units needed in each cost band so each household
    would have an affordable housing cost, vs. the actual count of units
    in those cost bands. In other words, total households by income band
    versus total units in each cost band.

## Establish groups

After discussion with team on 7/15 we will use median household income
by county and the groupings below. I’m not committed to these names but
needed a convenient shorthand for the analysis.

  - Very low income: \<= 0.3 CMI
  - Low income: (0.3–0.5\] CMI
  - Mid-low income: (0.5–.8\] CMI
  - Mid-high income: (.8–1.2\] CMI
  - High income: \> 1.2 CMI

Cost-burden in predictable breaks:

  - No burden: \<30% income to housing
  - Cost-burdened: \[30%-50%) income to housing
  - Severely cost-burdened: \>=50% income to housing

And race/ethnicity into a few major categories so we can look at it by
county:

  - White (NH)
  - Black (NH)
  - Latino (any race)
  - All others (grouped)

**Add flag for any inhabitant with a disability (should this be further
pared down by type, e.g., ambulatory vs. sensory vs. other vs. none?)**

## Define income bands

Would it be better to use pretty breaks or the same breaks for all
counties? I’m leaving it as-is, assuming we will put just CT in the main
report text but include counties in the appendix.

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

Because the groupings are granular only at the lower income extreme,
High income households *vastly* outnumber lower income households.

FYI, I did look at this by county, and each was very consistent in it
distribution. High income was more than 40% with the rest somewhere
between 10% and 20%. See table below.

![](hh_desiring_housing_files/figure-gfm/hh%20by%20inc%20band%20share-1.png)<!-- -->

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

In the charts below, I’m considering race/ethnicity of head of
household. Statewide, a quarter of all households headed by a Black or
Latino person are very low income, earning less than 30% of the county
household median income, compared to just over a tenth of households
headed by a white person. Some variation exists by county. In the three
largest counties, half of white households are high income.

**Other thoughts for later: Should pivot the data… share of race by
income band rather than share of income band by race. We have lots of
cost burden by race data elsewhere, could pull something in from HER. I
hesitate to divide it up too much more than this, so more of an equity
implication than an analysis crosstab.**

![](hh_desiring_housing_files/figure-gfm/hh%20by%20inc%20band%20by%20race%20bar%20charts-1.png)<!-- -->

Here’s that chart pivoted so the numerator is the population by race of
HOH of a given income band and the denominator is the total population
of that income band. This is less helpful for less populous counties.
![](hh_desiring_housing_files/figure-gfm/pivoted%20race%20bar-1.png)<!-- -->

### Disability

**For breakouts by disability type, see disability.Rmd in notebooks
folder on repo**

### Jobs held by household occupants

Retrieved a list of 2018 occ codes from the Census Bureau at
<https://www.census.gov/topics/employment/industry-occupation/guidance/code-lists.html>.

This table lists the top five occupations, in order from the most
numerous, for household inhabitants—so not just heads of household, but
all household members, including inhabitants with no work experience in
the past 5 years or who have never worked—by household income band by
county.

To be honest, this is a little surprising in places. I expected more
service industry workers in FC and NHC, and I’m surprised at how many
elementary and middle school teachers are workers in higher income
households. Either I have the exact wrong impression of how much
teachers are paid or it’s a common occupation for people whose
partners/spouses pull in big money. And yet, \#thestruggle: adjuncts and
GAs in Tolland County (UConn) getting those minimum wage grad school
stipends while profs in Middlesex Counties make six figures teaching
half the load.

**Mark brought up a good point about common occupations (like teachers,
cashiers) present in each income band. If this is used in the report, it
might be best to just look at the output table and cherry pick some
representative occupations.**

**An alternative approach, similar to I think what was used in the DC
report, is to look at like QWI data to determine which occupations’
average salaries in each county most closely align with the income band.
However, that’s an individual’s salary versus a household’s income.**

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

This dot plot shows the share of cost burdened households in each income
band. Statewide, almost 90% of Very Low income households pay 30%+
income to housing costs.

![](hh_desiring_housing_files/figure-gfm/cb%20rate%20dot%20plot-1.png)<!-- -->

Above, we established 86% of Very Low income households were cost
burdened, so this second dot plot breaks things down by regular and
severe cost burden *(although I don’t think we should do this in the
report\!)*.

**Note, these would add up to 100% if households with no burden were
included, so the chart is read as “16% of very low income households in
Connecticut are cost burdened and another 70% are severely cost
burdened.”**

![](hh_desiring_housing_files/figure-gfm/cb%20burden%20by%20severity%20dot%20plot-1.png)<!-- -->

Quick diversion: is the SCB rate among very low income households
partially explained by some of these households having housing costs and
no/negative negative income?

By definition, the household is in the “Very Low income” income band if
household income is $0 or less because that’s less than 30% CMI. There
are about 15K Very Low income households with no or negative income and
some nonzero housing cost, making them “severely cost burdened” by
definition. These \~15K units make up about 7% of all very low income
households, which is not insignificant, but it’s not the sole motivator
for high SCB rates in this income band.

    ## # A tibble: 2 x 4
    ## # Groups:   income [2]
    ##   income          cost_burden            households households_se
    ##   <chr>           <fct>                       <dbl>         <dbl>
    ## 1 negative_income Severely cost-burdened        366          79.2
    ## 2 no_income       Severely cost-burdened      14470         681.

## Average housing-cost-to-income ratio for each band

Urban’s DC study found that High income households paid about 12% income
to housing, and used that to determine a sliding scale for
affordability. In Connecticut, High income households pay about 16%
income to housing costs. For a household with $200K in income, that’s
about $2667/month, which I just don’t think is that much. For a
household at the lower end of CT’s High income band, earning about
$114K, 16% of income to housing cost would be about $1520/month, which
is just plain offensive to me as a NHV renter.

I don’t think we should assume that because High income households don’t
pay a full 30% that the 16% threshold is what is “affordable” for them.
They *can* pay more, they just *don’t*. Someone earning $114K paying 16%
is the same as someone earning $60K paying 30%. For the sake of fairness
and communication of “affordability,” I think we should do 30% for
everyone.

**7/15:** Talked with the team and I think we’re going to use 30% for
all income bands rather than the sliding scale.

![](hh_desiring_housing_files/figure-gfm/hcost%20to%20income%20ratio%20dotplot-1.png)<!-- -->

And finally… what’s the average *actual* housing cost for each band? How
much are households really paying?

The major takeaway is that Very Low and Low income households are paying
too much. Everyone else is right on target. **See table below for
affordable cost ranges.**

![](hh_desiring_housing_files/figure-gfm/actual%20cost%20dot%20plot-1.png)<!-- -->

This unlabeled dot plot is a little more esoteric. I looked only at
households whose housing costs exceed 30% of income, and took the
weighted average of the gap between what they actually pay for housing
versus what they should pay at a max affordable (30%) threshold. In
other words, how many dollars per month over 30% are they paying?

Very Low (light green) and High income (dark blue) households spend the
most over the affordable threshold. The average gap for households in
all income bands in FC is over $800/month while in most other counties
the gap falls between $400 and $800/month. Over the course of a year,
that’s an extraordinary amount of money these households are not
spending on other necessities, saving, or investing in other expensive
things like higher ed.

![](hh_desiring_housing_files/figure-gfm/affordability%20gap%20dot%20plot-1.png)<!-- -->

## Ranges of affordability for each band

Some future iteration of this analysis should find a way to combine this
table with the actual housing costs chart above, but the topline is that
the average actual costs in Low and Very Low income households exceed
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
have some utility costs are usually in the Very Low cost band but may be
in any income band. There are also a fair amount of people who are high
income but have $0 cash rents (I guess their company owns their
apartments and they live rent free?) who would be in the Very Low cost
band.

![](hh_desiring_housing_files/figure-gfm/income%20vs%20cost%20band%20heat%20map-1.png)<!-- -->

## How many housing units are in each cost bands

Further establishing that there’s a need for housing in lower cost
bands, how many units exist in each band? This adds vacants to the
occupied units above.

Vacant apartments and homes for sale have imputed costs based on
contract rent plus imputed utilities (see below), and homes for sale had
owner-costs imputed based on county average mortgage rates (2019 HMDA
data for approved first lien mortgages for homes intended for owner
occupancy), the median mill rate for each county, and imputed utility
costs.

I used a ratio of RENTGRS to RENT to determine how much utilities run on
top of contract rent (by county). I can’t think of a similar way to do
that for homes for sale so I used the same ratio for owner units, too.

In addition to the occupied units we’ve already looked at, this chart
adds two categories of vacant units: “Vacant-On market” units are listed
as “For rent or sale” or “For sale only,” and “Vacant-Off market” are
vacant units that have been sold or rented but are not yet occupied.

**8/13** Removed off market units from chart.

![](hh_desiring_housing_files/figure-gfm/units%20by%20tenure%20and%20occ%20bar%20chart-1.png)<!-- -->

There are two other major vacancy categories, “Other vacant” and “For
seasonal, recreational, or other occasional use,” but there’s no cost
information associated with those units, so they can’t be sorted into
the appropriate cost bands. Another minor category are housing units
reserved for migrant farm workers. Collectively, these comprise about
83,000 units, which is a ton by CT standards. The cities of Bridgeport,
New Haven, and Hartford all have about 50,000 units each.

    ## # A tibble: 3 x 2
    ##   vacancy                                             hhwt
    ##   <fct>                                              <dbl>
    ## 1 For seasonal, recreational or other occasional use 29578
    ## 2 For migrant farm workers                             129
    ## 3 Other vacant                                       53438

## Households who need housing in each cost band

This bar chart is the major summary of this analysis. It shows occupied
units in each income band versus units available in their cost band. In
essence, the households in each income band need a unit in their cost
band.

The data show significant gaps in the extremes… Very Low and High income
households do not have enough units in their affordability range (though
with High income households I think we care less about whether they have
enough high cost units and more that they aren’t squeezing the middle
out of a place to live).

While there are a lot of middle income units, competition for those
units is coming from above and below. More housing units in the Very Low
range are absolutely needed. Since High income households tend to want
to pay less than 30% for housing, more (well-located and not just single
family) mid-high units could help alleviate some strain on the middle
income households.

![](hh_desiring_housing_files/figure-gfm/units%20v%20hh%20bar%20chart-1.png)<!-- -->

    ## $hh_by_inc_band
    ## # A tibble: 54 x 9
    ## # Groups:   level, name [9]
    ##    level  name    inc_band  value value_se statefip.x statefip.y  share sharemoe
    ##    <fct>  <chr>   <fct>     <dbl>    <dbl>  <int+lbl>  <int+lbl>  <dbl>    <dbl>
    ##  1 1_sta… Connec… Total    1.37e6    3502.         NA NA         NA       NA    
    ##  2 1_sta… Connec… Very low 2.01e5    2402.         NA  9 [Conne…  0.147    0.002
    ##  3 1_sta… Connec… Low      1.51e5    2070.         NA  9 [Conne…  0.111    0.001
    ##  4 1_sta… Connec… Mid-low  2.14e5    2454.         NA  9 [Conne…  0.157    0.002
    ##  5 1_sta… Connec… Mid-high 2.32e5    2421.         NA  9 [Conne…  0.17     0.002
    ##  6 1_sta… Connec… High     5.68e5    3148.         NA  9 [Conne…  0.416    0.002
    ##  7 2_cou… Fairfi… Total    3.40e5    2753.         NA NA         NA       NA    
    ##  8 2_cou… Fairfi… Very low 5.53e4    1313.         NA NA          0.162    0.004
    ##  9 2_cou… Fairfi… Low      3.82e4    1073.         NA NA          0.112    0.003
    ## 10 2_cou… Fairfi… Mid-low  5.13e4    1207.         NA NA          0.151    0.003
    ## # … with 44 more rows
    ## 
    ## $income_ranges
    ## # A tibble: 9 x 6
    ##   Name      `Very low`    Low           `Mid-low`      `Mid-high`      High     
    ##   <chr>     <chr>         <chr>         <chr>          <chr>           <chr>    
    ## 1 Fairfiel… Less than $2… Between $27,… Between $46,4… Between $74,37… More tha…
    ## 2 Hartford… Less than $2… Between $21,… Between $36,1… Between $57,85… More tha…
    ## 3 Litchfie… Less than $2… Between $23,… Between $39,1… Between $62,65… More tha…
    ## 4 Middlese… Less than $2… Between $25,… Between $42,3… Between $67,80… More tha…
    ## 5 New Have… Less than $2… Between $20,… Between $33,5… Between $53,70… More tha…
    ## 6 New Lond… Less than $2… Between $21,… Between $35,6… Between $57,09… More tha…
    ## 7 Tolland … Less than $2… Between $25,… Between $42,4… Between $67,93… More tha…
    ## 8 Windham … Less than $1… Between $19,… Between $32,3… Between $51,81… More tha…
    ## 9 Connecti… Less than $2… Between $22,… Between $38,0… Between $60,88… More tha…
    ## 
    ## $hh_by_race_inc_band
    ## # A tibble: 216 x 10
    ## # Groups:   level, name, race2 [36]
    ##    level name  race2 inc_band  value value_se statefip.x statefip.y  share
    ##    <fct> <chr> <fct> <fct>     <dbl>    <dbl>  <int+lbl>  <int+lbl>  <dbl>
    ##  1 1_st… Conn… White Total    996437    3346. NA         NA         NA    
    ##  2 1_st… Conn… White Very low 113213    1720.  9 [Conne…  9 [Conne…  0.114
    ##  3 1_st… Conn… White Low       97152    1558.  9 [Conne…  9 [Conne…  0.097
    ##  4 1_st… Conn… White Mid-low  144503    1910.  9 [Conne…  9 [Conne…  0.145
    ##  5 1_st… Conn… White Mid-high 171246    1982.  9 [Conne…  9 [Conne…  0.172
    ##  6 1_st… Conn… White High     470323    2851.  9 [Conne…  9 [Conne…  0.472
    ##  7 1_st… Conn… Black Total    125094    2102. NA         NA         NA    
    ##  8 1_st… Conn… Black Very low  32076    1078.  9 [Conne…  9 [Conne…  0.256
    ##  9 1_st… Conn… Black Low       19632     872.  9 [Conne…  9 [Conne…  0.157
    ## 10 1_st… Conn… Black Mid-low   24342     958.  9 [Conne…  9 [Conne…  0.195
    ## # … with 206 more rows, and 1 more variable: sharemoe <dbl>
    ## 
    ## $pivot_race_inc_band
    ## # A tibble: 270 x 4
    ##    name        race2 inc_band  value
    ##    <chr>       <chr> <fct>     <dbl>
    ##  1 Connecticut White Total    996437
    ##  2 Connecticut White Very low 113213
    ##  3 Connecticut White Low       97152
    ##  4 Connecticut White Mid-low  144503
    ##  5 Connecticut White Mid-high 171246
    ##  6 Connecticut White High     470323
    ##  7 Connecticut Black Total    125094
    ##  8 Connecticut Black Very low  32076
    ##  9 Connecticut Black Low       19632
    ## 10 Connecticut Black Mid-low   24342
    ## # … with 260 more rows
    ## 
    ## $common_jobs_by_inc_band
    ## # A tibble: 400 x 6
    ## # Groups:   name, inc_band [40]
    ##    level   name       inc_band workers   occ occ_label                          
    ##    <chr>   <chr>      <fct>      <dbl> <int> <chr>                              
    ##  1 2_coun… Fairfield… Very low    2715  4720 Cashiers                           
    ##  2 2_coun… Fairfield… Very low    2035  9920 Unemployed, with no work experienc…
    ##  3 2_coun… Fairfield… Very low    2023  4230 Maids and housekeeping cleaners    
    ##  4 2_coun… Fairfield… Very low    1313  4600 Childcare workers                  
    ##  5 2_coun… Fairfield… Very low    1265  4251 Landscaping and groundskeeping wor…
    ##  6 2_coun… Fairfield… Very low    1250  3602 Personal care aides                
    ##  7 2_coun… Fairfield… Very low    1241  4760 Retail salespersons                
    ##  8 2_coun… Fairfield… Very low    1222  4220 Janitors and building cleaners     
    ##  9 2_coun… Fairfield… Very low    1144  3603 Nursing assistants                 
    ## 10 2_coun… Fairfield… Very low     866  4020 Cooks                              
    ## # … with 390 more rows
    ## 
    ## $cb_by_inc_band
    ## # A tibble: 178 x 10
    ## # Groups:   level, name, inc_band [45]
    ##    level name  inc_band cost_burden  value value_se statefip.x statefip.y  share
    ##    <fct> <chr> <fct>    <fct>        <dbl>    <dbl>  <int+lbl>  <int+lbl>  <dbl>
    ##  1 1_st… Conn… Very low Total       201377    2402. NA         NA         NA    
    ##  2 1_st… Conn… Very low No burden    28364     947.  9 [Conne…  9 [Conne…  0.141
    ##  3 1_st… Conn… Very low Cost-burde…  31411     969.  9 [Conne…  9 [Conne…  0.156
    ##  4 1_st… Conn… Very low Severely c… 141602    2049.  9 [Conne…  9 [Conne…  0.703
    ##  5 1_st… Conn… Low      Total       151345    2070. NA         NA         NA    
    ##  6 1_st… Conn… Low      No burden    36305     976.  9 [Conne…  9 [Conne…  0.24 
    ##  7 1_st… Conn… Low      Cost-burde…  61210    1367.  9 [Conne…  9 [Conne…  0.404
    ##  8 1_st… Conn… Low      Severely c…  53830    1294.  9 [Conne…  9 [Conne…  0.356
    ##  9 1_st… Conn… Mid-low  Total       214490    2454. NA         NA         NA    
    ## 10 1_st… Conn… Mid-low  No burden   106477    1730.  9 [Conne…  9 [Conne…  0.496
    ## # … with 168 more rows, and 1 more variable: sharemoe <dbl>
    ## 
    ## $cb_shares
    ## # A tibble: 27 x 5
    ##    level      name              cost_burden             value share
    ##    <fct>      <chr>             <fct>                   <dbl> <dbl>
    ##  1 1_state    Connecticut       No burden              876299 0.641
    ##  2 1_state    Connecticut       Cost-burdened          256442 0.188
    ##  3 1_state    Connecticut       Severely cost-burdened 234633 0.172
    ##  4 2_counties Fairfield County  No burden              205374 0.603
    ##  5 2_counties Fairfield County  Cost-burdened           67587 0.198
    ##  6 2_counties Fairfield County  Severely cost-burdened  67531 0.198
    ##  7 2_counties Hartford County   No burden              230189 0.659
    ##  8 2_counties Hartford County   Cost-burdened           61851 0.177
    ##  9 2_counties Hartford County   Severely cost-burdened  57023 0.163
    ## 10 2_counties Litchfield County No burden               50980 0.689
    ## # … with 17 more rows
    ## 
    ## $cb_rates_inc_band
    ## # A tibble: 135 x 6
    ## # Groups:   level, name, inc_band [45]
    ##    level   name        inc_band cost_burden  value  share
    ##    <fct>   <chr>       <fct>    <fct>        <dbl>  <dbl>
    ##  1 1_state Connecticut Very low Total       201377 NA    
    ##  2 1_state Connecticut Very low No burden    28364  0.141
    ##  3 1_state Connecticut Very low Burden      173013  0.859
    ##  4 1_state Connecticut Low      Total       151345 NA    
    ##  5 1_state Connecticut Low      No burden    36305  0.24 
    ##  6 1_state Connecticut Low      Burden      115040  0.76 
    ##  7 1_state Connecticut Mid-low  Total       214490 NA    
    ##  8 1_state Connecticut Mid-low  No burden   106477  0.496
    ##  9 1_state Connecticut Mid-low  Burden      108013  0.504
    ## 10 1_state Connecticut Mid-high Total       231836 NA    
    ## # … with 125 more rows
    ## 
    ## $avg_cost_ratio_inc_band
    ## # A tibble: 45 x 4
    ## # Groups:   name [9]
    ##    name             inc_band wm_cb level     
    ##    <chr>            <fct>    <dbl> <chr>     
    ##  1 Fairfield County Very low 0.716 2_counties
    ##  2 Fairfield County Low      0.474 2_counties
    ##  3 Fairfield County Mid-low  0.352 2_counties
    ##  4 Fairfield County Mid-high 0.268 2_counties
    ##  5 Fairfield County High     0.169 2_counties
    ##  6 Hartford County  Very low 0.705 2_counties
    ##  7 Hartford County  Low      0.446 2_counties
    ##  8 Hartford County  Mid-low  0.318 2_counties
    ##  9 Hartford County  Mid-high 0.232 2_counties
    ## 10 Hartford County  High     0.157 2_counties
    ## # … with 35 more rows
    ## 
    ## $avg_cost_inc_band
    ## # A tibble: 45 x 4
    ## # Groups:   name [9]
    ##    name             inc_band wm_cost level     
    ##    <chr>            <fct>      <dbl> <chr>     
    ##  1 Connecticut      Very low   1000. 1_state   
    ##  2 Connecticut      Low        1201. 1_state   
    ##  3 Connecticut      Mid-low    1359. 1_state   
    ##  4 Connecticut      Mid-high   1563. 1_state   
    ##  5 Connecticut      High       2286. 1_state   
    ##  6 Fairfield County Very low   1234. 2_counties
    ##  7 Fairfield County Low        1524. 2_counties
    ##  8 Fairfield County Mid-low    1751. 2_counties
    ##  9 Fairfield County Mid-high   2054. 2_counties
    ## 10 Fairfield County High       3207. 2_counties
    ## # … with 35 more rows
    ## 
    ## $affordable_cost_table
    ## # A tibble: 9 x 6
    ##   Name       `Very low`   Low          `Mid-low`       `Mid-high`      High     
    ##   <chr>      <chr>        <chr>        <chr>           <chr>           <chr>    
    ## 1 Fairfield… Less than $… Between $69… Between $1,162… Between $1,859… More tha…
    ## 2 Hartford … Less than $… Between $54… Between $904 a… Between $1,446… More tha…
    ## 3 Litchfiel… Less than $… Between $58… Between $979 a… Between $1,566… More tha…
    ## 4 Middlesex… Less than $… Between $63… Between $1,060… Between $1,695… More tha…
    ## 5 New Haven… Less than $… Between $50… Between $839 a… Between $1,343… More tha…
    ## 6 New Londo… Less than $… Between $53… Between $892 a… Between $1,427… More tha…
    ## 7 Tolland C… Less than $… Between $63… Between $1,061… Between $1,698… More tha…
    ## 8 Windham C… Less than $… Between $48… Between $810 a… Between $1,295… More tha…
    ## 9 Connectic… Less than $… Between $57… Between $951 a… Between $1,522… More tha…
    ## 
    ## $all_units_inc_and_cost_bands
    ## # A tibble: 70,616 x 6
    ## # Groups:   name [8]
    ##     hhwt name               minc inc_band hcost cost_band
    ##    <dbl> <chr>             <dbl> <fct>    <int> <chr>    
    ##  1    16 Fairfield County  92969 Mid-high  4208 High     
    ##  2    11 New London County 71368 Mid-high  2169 High     
    ##  3    21 New London County 71368 Mid-high   551 Low      
    ##  4    19 New Haven County  67128 High      6607 High     
    ##  5    24 New Haven County  67128 High      1176 Mid-low  
    ##  6    15 Fairfield County  92969 High      4908 High     
    ##  7     7 New London County 71368 High      4140 High     
    ##  8    16 Hartford County   72321 High      1853 Mid-high 
    ##  9     6 New London County 71368 Low       6546 High     
    ## 10    12 Hartford County   72321 Mid-low    767 Low      
    ## # … with 70,606 more rows
    ## 
    ## $units_by_cost_and_income
    ## # A tibble: 90 x 5
    ## # Groups:   name [9]
    ##    name             inc_band group       value level     
    ##    <chr>            <chr>    <chr>       <dbl> <chr>     
    ##  1 Fairfield County High     households 142201 2_counties
    ##  2 Fairfield County High     units       90766 2_counties
    ##  3 Fairfield County Low      households  38220 2_counties
    ##  4 Fairfield County Low      units       51660 2_counties
    ##  5 Fairfield County Mid-high households  53533 2_counties
    ##  6 Fairfield County Mid-high units       82083 2_counties
    ##  7 Fairfield County Mid-low  households  51287 2_counties
    ##  8 Fairfield County Mid-low  units       86663 2_counties
    ##  9 Fairfield County Very low households  55251 2_counties
    ## 10 Fairfield County Very low units       29320 2_counties
    ## # … with 80 more rows
    ## 
    ## $hh_cost_band_vs_units_cost_band
    ## # A tibble: 25 x 3
    ## # Groups:   inc_band [5]
    ##    inc_band cost_band units
    ##    <fct>    <fct>     <dbl>
    ##  1 Very low High       8865
    ##  2 Very low Low       52714
    ##  3 Very low Mid-high  22327
    ##  4 Very low Mid-low   59737
    ##  5 Very low Very low  57734
    ##  6 Low      High       7975
    ##  7 Low      Low       43194
    ##  8 Low      Mid-high  23901
    ##  9 Low      Mid-low   58814
    ## 10 Low      Very low  17461
    ## # … with 15 more rows
    ## 
    ## $units_by_tenure_occupancy_cost_band
    ## # A tibble: 252 x 5
    ## # Groups:   name, tenure, occupancy [54]
    ##    name             tenure occupancy cost_band units
    ##    <chr>            <chr>  <fct>     <fct>     <dbl>
    ##  1 Fairfield County owner  occupied  high      80938
    ##  2 Fairfield County owner  occupied  mid_high  58876
    ##  3 Fairfield County owner  occupied  mid_low   43757
    ##  4 Fairfield County owner  occupied  low       31419
    ##  5 Fairfield County owner  occupied  very_low  11126
    ##  6 Hartford County  owner  occupied  high      58470
    ##  7 Hartford County  owner  occupied  mid_high  68359
    ##  8 Hartford County  owner  occupied  mid_low   52064
    ##  9 Hartford County  owner  occupied  low       37433
    ## 10 Hartford County  owner  occupied  very_low   7036
    ## # … with 242 more rows
    ## 
    ## $units_and_households
    ## # A tibble: 90 x 4
    ##    name        band     group       value
    ##    <chr>       <fct>    <chr>       <dbl>
    ##  1 Connecticut Very low households 201377
    ##  2 Connecticut Very low units      115309
    ##  3 Connecticut Low      households 151345
    ##  4 Connecticut Low      units      234972
    ##  5 Connecticut Mid-low  households 214490
    ##  6 Connecticut Mid-low  units      419683
    ##  7 Connecticut Mid-high households 231836
    ##  8 Connecticut Mid-high units      362648
    ##  9 Connecticut High     households 568326
    ## 10 Connecticut High     units      296548
    ## # … with 80 more rows

## Add homeless households?

Mark suggests <https://cceh.org> for subcounty estimates, but I’m not
sure how best to align CANs to counties, so instead I think this should
be separate and included in the statewide count.

Looks like in 2018 there were 2,253 adults-only households, 370
adults-and-children households, and 7 children-only households for a
total of 2,630 households (3,383 people). We should add these households
to very low income units needed.

Source: <https://cceh.org/data/interactive/2018pitdashboard/>
