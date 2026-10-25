# Spreadsheet Cleaning and Pivot Layer Notes

## Setup

- Spreadsheet tool: Google Sheets.
- Tabs created: `orders` and `products`.
- Rows imported into `orders`: 90 (from `data/orders_enriched.csv`).
- The `products` tab occupies range `A1:C10` (header in row 1; 9 product rows below it).
- `order_month` was imported as Plain text; values remain in the form `2026-09`.
- Filter applied on the `orders` tab: `status = completed`.
- Sort applied before building `completed_orders`: `amount`, largest to smallest.
- The 63 visible completed rows were pasted as values into the `completed_orders` tab.
- The XLOOKUP fallback was tested in a spare cell with the key `Mystery Item`; it displays `UNKNOWN_ITEM`.

## Formulas added on the orders tab

First data row is row 2.

| Column | Formula |
|---|---|
| clean_first_name | `=PROPER(TRIM(B2))` |
| clean_last_name | `=PROPER(TRIM(C2))` |
| category | `=VLOOKUP(H2, products!$A$2:$C$10, 2, FALSE)` |
| unit_price | `=IFERROR(XLOOKUP(H2, products!$A$2:$A$10, products!$C$2:$C$10, "UNKNOWN_ITEM"), "UNKNOWN_ITEM")` |
| revenue_calc | `=I2*J2` |

Here, `H2` is the item, `I2` is unit_price and `J2` is quantity in the working layout. All lookup ranges use absolute references so they can be copied down all 90 rows.

## Completed-order aggregates

| Metric | Value |
|---|---:|
| COUNT of amount | 63 |
| SUM of amount | 346200 |
| AVERAGE of amount | 5495.24 |
| MIN of amount | 1100 |
| MAX of amount | 15600 |

## Pivot table (i): Revenue by category and region

| Category | North | South | East | West | Grand Total |
|---|---|---|---|---|---|
| Electronics | 73400 | 28700 | 21400 | 18800 | 142300 |
| Apparel | 19400 | 10000 | 10600 | 37500 | 77500 |
| Home | 26500 | 43800 | 37500 | 18600 | 126400 |
| Grand Total | 119300 | 82500 | 69500 | 74900 | 346200 |

## Pivot table (ii): Revenue and order count by month

| Order Month | Count of order_id | Sum of amount |
|---|---|---|
| 2026-09 | 19 | 98300 |
| 2026-10 | 20 | 93100 |
| 2026-11 | 24 | 154800 |
| Grand Total | 63 | 346200 |

## Reconciliation

| Metric | Spreadsheet | Part A q05 | Match/Mismatch |
|---|---:|---:|---|
| COUNT | 63 | 63 | Match |
| SUM | 346200 | 346200 | Match |
| AVERAGE | 5495.24 | 5495.24 | Match |

## Data validation

- Missing amounts: three orders have NULL amounts — order IDs 1001, 1010 and 1064, as returned by Part A q02. All three are pending orders, so they are excluded from the completed-orders layer and from revenue. Their `amount` cells were left blank rather than filled with zero, because zero would falsely imply a completed sale value of zero.
- Data types: `order_id`, `unit_price`, `quantity`, `amount` and `revenue_calc` were confirmed as numeric values; `order_month` was kept as text.
- Duplicate order IDs: none; all 90 order IDs are unique.
- Outliers among completed orders: the largest completed amount is 15600 INR. It occurs for order IDs 1061, 1065, 1069 and 1077; these are legitimate three-unit Air Fryer orders, not data errors.
- Decision for an inheriting analyst: keep `order_month` as text and calculate revenue from `unit_price * quantity` in `revenue_calc`; do not overwrite the original `amount` column, so the source value remains auditable.

## Export

`data/orders_clean.csv` contains the `completed_orders` data range only: one header row plus 63 data rows, with the 13 required columns in the specified order.
