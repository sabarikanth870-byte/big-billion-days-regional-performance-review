# Dashboard Specification — BBD Regional Performance

## Data source

Connect Tableau Public to `data/orders_clean.csv`.

| Column | Type |
|---|---|
| order_id | Dimension |
| order_month | Dimension |
| clean_first_name | Dimension |
| clean_last_name | Dimension |
| region | Dimension |
| rep_name | Dimension |
| item | Dimension |
| category | Dimension |
| unit_price | Measure |
| quantity | Measure |
| amount | Measure |
| revenue_calc | Measure |
| status | Dimension |

## KPI cards

| KPI | Calculation | Value |
|---|---|---:|
| Total Revenue | SUM(amount) | 346200 INR |
| Total Units Sold | SUM(quantity) | 106 units |

The Total Revenue card equals Part A q05's `total_revenue` of 346200 INR because both use the same 63 completed orders.

## Chart sheets

### Revenue by Region

- Chart type: Bar chart.
- Rows: `region`; Columns: SUM(amount); Colour: `region`.
- Reason: A ranked bar chart makes regional revenue differences immediately comparable.
- Data:

| Region | Revenue (INR) |
|---|---|
| North | 119300 |
| South | 82500 |
| West | 74900 |
| East | 69500 |
| Total | 346200 |

### Revenue by Category

- Chart type: Bar chart.
- Rows: `category`; Columns: SUM(amount); Colour: `category`.
- Reason: A bar chart is appropriate for comparing revenue across a small set of categories.
- Data:

| Category | Revenue (INR) |
|---|---|
| Electronics | 142300 |
| Home | 126400 |
| Apparel | 77500 |
| Total | 346200 |

### Revenue Trend by Month and Category

- Chart type: Line chart.
- Columns: `order_month`; Rows: SUM(amount); Colour: `category`.
- Reason: A line chart shows the month-over-month direction of each category.
- Data:

| Order Month | Electronics | Apparel | Home | Total |
|---|---|---|---|---|
| 2026-09 | 43000 | 24700 | 30600 | 98300 |
| 2026-10 | 49900 | 30600 | 12600 | 93100 |
| 2026-11 | 49400 | 22200 | 83200 | 154800 |
| Total | [142300, 77500, 126400] | 346200 |

### Region x Category Detail

- Chart type: Text table.
- Rows: `region`; Columns: `category`; Text: SUM(amount).
- Reason: A text table exposes the exact region-category values behind the summary charts.
- Data:

| Region | Electronics | Apparel | Home | Region Total |
|---|---|---|---|---|
| North | 73400 | 19400 | 26500 | 119300 |
| South | 28700 | 10000 | 43800 | 82500 |
| East | 21400 | 10600 | 37500 | 69500 |
| West | 18800 | 37500 | 18600 | 74900 |
| Total | 142300 | 77500 | 126400 | 346200 |

## Dashboard layout

Top to bottom:

1. Two KPI cards: Total Revenue and Total Units Sold.
2. Category filter, placed in the top band directly below the KPI cards.
3. Revenue Trend by Month and Category line chart.
4. Revenue by Region and Revenue by Category bar charts.
5. Region x Category Detail text table.

Use a vertical container for the full dashboard. Place the two KPI cards and the category filter in one horizontal container at the top. Place the trend chart in its own horizontal container, the two bar charts in another horizontal container, and the detail table in the final horizontal container.

The category filter is applied to all four worksheets that use this data source. When a user clicks a bar in Revenue by Region with **Use as Filter** switched on, the other charts and the detail table update to show only orders from the selected region.

## Visualization summary

The dashboard shows that BBD completed revenue totalled 346200 INR across 106 units. North leads regional revenue, Electronics leads category revenue, and Home revenue is heavily concentrated in November.

## Summary analysis

- North is the strongest region with 119300 INR, ahead of South at 82500 INR, West at 74900 INR and East at 69500 INR.
- Electronics is the leading category at 142300 INR, ahead of Home at 126400 INR and Apparel at 77500 INR.
- Home revenue rises sharply from 12600 INR in 2026-10 to 83200 INR in 2026-11, while Electronics remains comparatively stable at 49900 INR in October and 49400 INR in November.
- Comparing regions, North's Electronics revenue of 73400 INR is more than double West's Electronics revenue of 18800 INR.

## Recommendations

1. Run a targeted Electronics promotional push in North, supported by its 73400 INR Electronics revenue; watch weekly completed Electronics revenue and units sold to judge the lift.
2. Increase Air Fryer / Home inventory and promotion in South and East for the next sale cycle, motivated by Home revenue of 43800 INR in South and 37500 INR in East; monitor Home revenue, stock-out days and completed order count.
3. Run a lower-discount Apparel conversion campaign in South, where Apparel revenue is only 10000 INR despite South's 82500 INR total; measure Apparel revenue, conversion rate and average order value after the campaign.

## Reconciliation

| Measure | Value (INR) |
|---|---:|
| Total Revenue KPI | 346200 |
| Sum of Revenue by Region | 346200 |
| Sum of Revenue by Category | 346200 |
| Part B pivot grand total | 346200 |

All four values are equal.
