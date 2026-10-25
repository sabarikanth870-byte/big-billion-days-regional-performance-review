# AI-Assisted Analysis with Human-in-the-Loop Verification

## Task 1 — Five-part prompt for Part A q13

**Role:** You are an expert SQL analyst working with a MySQL-compatible database.

**Task:** Write a SQL query that reports each sales representative's completed revenue by order month and classifies performance against their monthly target.

**Context:** The database has three relevant tables. `reps(rep_id, rep_name, region, monthly_target)`; `customers(customer_id, first_name, last_name, city, region, age, rep_id)`; `orders(order_id, customer_id, item, quantity, amount, status, order_month)`. `customers.rep_id` references `reps.rep_id`, and `orders.customer_id` references `customers.customer_id`. The SQL dialect is MySQL.

**Constraints:** Include completed orders only (`status = 'completed'`). Revenue is `SUM(o.amount)`. Group by rep name, order month and monthly target. The performance tier is `Below Target` when revenue is below `monthly_target`, `On Target` when revenue is at least the target but below 1.1 times the target, and `Above Target` otherwise. Do not use CTEs (`WITH`), stored procedures, or a filter on an aggregate or derived alias in `WHERE`; write aggregate and conditional expressions in full.

**Format:** Return raw SQL only, with inline SQL comments explaining each major step.

## Task 2 — Inspection of Scenario D1

| Defect | Classification | Correct clause or fix |
|---|---|---|
| The query reads from a table named `sales`, which does not exist in this database. | Fake method/function | Use the real tables `orders` and `customers`, joined on `customer_id`. |
| The query uses columns `region_name` and `total_sales`, which do not exist. | Fake method/function | Use `customers.region` and calculate revenue as `SUM(orders.amount)`. |
| `WHERE SUM(total_sales) > 80000` places an aggregate in `WHERE`. | Logic error | Move the aggregate condition to `HAVING SUM(o.amount) > 80000`. |
| The claim that North's revenue grew 38% month over month is not supported by the query or the data. | Phantom statistic | Calculate the change from the q11 region-month revenue figures; the actual change is -22.8%. |

## Task 3 — Verification of Scenario D1

`sql/d1_corrected.sql` returns:

| region | revenue |
|---|---:|
| North | 119300 |
| South | 82500 |

Using q11, North's completed revenue was 53500 INR in 2026-09 and 41300 INR in 2026-10. The actual month-over-month change is:

(41300 - 53500) / 53500 * 100 = -22.8%.

The assistant's claim of 38% growth is therefore contradicted by the data: North's revenue actually fell by 22.8% from September to October.

## Task 4 — Human-in-the-loop protocol

**Specification:** The business question was to identify regions with completed revenue above 80000 INR. The specification required revenue to include completed orders only, use the real `orders` and `customers` tables, and apply the threshold after aggregation.

**Execution:** The original assistant query was executed conceptually against the schema and failed because `sales`, `region_name` and `total_sales` do not exist. The corrected query in `sql/d1_corrected.sql` was run successfully against the loaded seed.

**Inspection:** The original answer contained a non-existent table, non-existent columns, an aggregate in `WHERE`, and an unsupported 38% growth claim. The corrected query uses valid tables and columns, filters completed orders in `WHERE`, and applies the 80000 threshold in `HAVING`.

**Verification:** The corrected query returned exactly two rows: North with 119300 INR and South with 82500 INR. The North month-over-month calculation used q11 values of 53500 INR in September and 41300 INR in October, producing -22.8%.

**Decision:** Reject the original assistant answer because its table, columns, filtering logic and growth statistic are all invalid. Accept the corrected version because it runs on the real schema, returns the expected two rows, and its revenue figures reconcile with q11.

## Task 5 — Scenario D2 prompt and repair

**Role:** You are a spreadsheet-debugging expert supporting a business analyst using Google Sheets.

**Task:** Explain why a VLOOKUP returns a not-found error and provide a repaired formula.

**Context:** The `products` tab occupies `A1:C10`, with headers in row 1, item names in column A and unit prices in column C. On the `orders` tab, cell `G2` contains the text ` Smart Watch` with a leading space. The formula `=VLOOKUP(G2, $A$2:$C$10, 3, FALSE)` returns a value-not-found error even though `Smart Watch` exists in the products table.

**Constraints:** Use an exact-match lookup, keep the lookup range absolute, and make the repair robust to leading or trailing spaces without manually editing every order row.

**Format:** Explain the root cause in one or two sentences, then provide only the repaired formula.

**Root cause:** The lookup key in `G2` has a leading space, so its text value is not exactly equal to `Smart Watch` in the products table. An exact-match VLOOKUP therefore cannot find it.

**Repaired formula:**

```excel
=VLOOKUP(TRIM(G2), $A$2:$C$10, 3, FALSE)
```

## Task 6 — Skeptical-analyst check on Part C

**Prompt:** Act as a skeptical business analyst. Challenge my first Part C recommendation: running a targeted Electronics promotional push in North, based on North's 73400 INR Electronics revenue. Identify unstated assumptions and distinguish evidence of cause from mere correlation. Ask for the specific figures or checks needed before approving promotional spend.

**Unstated assumptions and checks:**

1. **Assumption:** North's high Electronics revenue reflects unmet demand rather than a few large orders. **Check:** q07 and the order-level data show whether the 73400 INR is spread across many completed orders or concentrated in a small number; a concentration would weaken the case for a broad promotion.
2. **Assumption:** Promotion will increase incremental completed revenue rather than merely shifting the timing of purchases. **Check:** Compare North Electronics revenue across q11 months and monitor post-campaign revenue against the 73400 INR baseline; a rise without an increase in distinct customers may indicate timing shift rather than growth.
3. **Assumption:** Stock and fulfilment can support additional Electronics demand. **Check:** Review pending and disputed Electronics orders; for example, q06 shows non-completed orders exist, and unresolved pending/disputed volume would weaken the expected revenue conversion from added demand.
4. **Assumption:** Electronics customers in North respond to discounts. **Check:** Compare average order value and quantity per completed Electronics order before and after any test promotion; if average order value falls more than revenue rises, the promotion may not be profitable.
