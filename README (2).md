# Big Billion Days Regional Performance Review

This project builds one traceable analytics pipeline for Flipkart Big Billion Days regional performance: SQL produces the order-level facts, a spreadsheet layer cleans and reconciles them, a dashboard specification turns them into KPIs and recommendations, and an AI-assistance log documents human verification of AI-generated claims.

- SQL compiler and dialect used: SQLite (browser-based SQLite compiler / DB Fiddle SQLite).
- Spreadsheet tool used: Google Sheets.
- Dashboard built in Tableau Public: No. All dashboard KPIs, chart data and layout requirements are specified and reconciled in `docs/dashboard_spec.md`, as permitted by the brief.

## Key findings

North carried the sale with 119300 INR of completed revenue, ahead of South (82500 INR), West (74900 INR) and East (69500 INR). Electronics was the strongest category at 142300 INR, while Home revenue surged from 12600 INR in October to 83200 INR in November. The first promotional priority is a targeted Electronics push in North, supported by its 73400 INR Electronics revenue; Home inventory and promotion should be prioritised in South and East, where Home generated 43800 INR and 37500 INR respectively.

## File index

| File | Part | Purpose |
|---|---|---|
| `README.md` | All | Project overview, tools, findings and assumptions |
| `sql/00_schema_and_seed.sql` | A | Schema creation and seed data |
| `sql/q01.sql` to `sql/q13.sql` | A | Thirteen reporting queries |
| `results/query_results.md` | A | Seed check and results for q01-q13 |
| `data/orders_enriched.csv` | A | Full q09 order-level fact table (90 rows) |
| `docs/spreadsheet_notes.md` | B | Spreadsheet formulas, pivots, validation and reconciliation |
| `data/orders_clean.csv` | B | Cleaned completed-orders export (63 rows) |
| `docs/dashboard_spec.md` | C | Dashboard source, KPIs, worksheets, layout and narrative |
| `sql/d1_corrected.sql` | D | Corrected region-revenue query for Scenario D1 |
| `docs/ai_log.md` | D | AI prompts, defect inspection, verification and decisions |

## Assumptions

- Revenue is defined throughout as the sum of `amount` for `status = 'completed'` orders only.
- The dashboard was specified rather than built in Tableau Public; every required dashboard number is computed and reconciled in the specification.
- `order_month` is retained as plain text in the spreadsheet and CSV exports to prevent automatic date conversion.
- Missing amounts were left blank rather than replaced with zero, because all three affected orders are pending and are excluded from revenue.
