#  E-Commerce Sales Analysis
**Tools:** Excel · SQL &nbsp;|&nbsp; **Dataset:** 541,909 rows · 8 columns &nbsp;|&nbsp; **Source:** Kaggle

---

##  Business Problem

A retail company had no structured visibility into what was actually driving its revenue. It couldn't tell which products were consistently strong sellers, which customers were responsible for the bulk of spending, or whether sales trends were seasonal or random. Without this, decisions about inventory, marketing budgets, and market expansion were mostly guesswork.

**Goal:** Clean and analyze transactional data to surface clear, actionable answers about revenue performance, customer behavior, and market opportunity.

---

## 📁 Repository Structure

```
├── README.md
├── ecommerce_cleaned.csv       # Cleaned dataset (Excel)
└── ecommerce_analysis       # KPI queries (SQL)
```

---

##  Step 1 — Data Cleaning (Excel)

Raw data is messy. This dataset had several issues that would have silently distorted any analysis, so each one was addressed deliberately.

### What I Found

| Issue | Count | Decision |
|---|---|---|
| Products with no description, £0 price, and no customer ID | ~1,454 rows | Removed — no analytical value |
| Special stock codes (POST, BANK CHARGES, DOT, etc.) | ~54,873 codes | Flagged with `IsProduct` column; excluded from revenue queries |
| Missing Customer IDs (likely guest purchases) | ~135,080 rows (~25%) | Labeled `"Unknown"` — retained for order-level analysis |
| Negative quantities (cancellations/returns) | ~10,624 rows | Removed from revenue analysis; noted as useful for future loss/refund analysis if cost data were available |
| Duplicate rows | ~17,028 rows | Removed |
| Zero unit prices | Multiple rows | Removed |
| Unspecified countries | 446 rows | Retained but flagged |

### What I Added

- `IsProduct` column — flags whether a stock code is a real product (vs. postage, charges, etc.)
- `Year` and `Month` columns — for time-series queries
- `TotalPrice` column — `Quantity × UnitPrice`
- Separated `InvoiceDate` into `Date` and `Time` columns
- Lowercased and standardized `Description` values (e.g., removed inconsistent special characters)

**Final cleaned dataset: ~524,879 rows**

---

##  Step 2 — KPI Analysis (SQL)

Queries were organized around four business themes:

### 1. Sales Performance
- **Total Revenue** — Baseline for all other metrics
- **Monthly Revenue Trend** — Is the business growing, declining, or seasonal?
- **Peak Seasons** — When does demand spike?

### 2. Market Analysis
- **Revenue by Country** — Which markets are strongest?
- **Underperforming Regions** — Where is there untapped or declining potential?

### 3. Customer Behavior
- **Top Customers by Revenue (CLV)** — Who are the highest-value buyers?
- **Revenue Concentration** — Do a small number of customers account for most revenue? (Pareto check)
- **Repeat Purchase Rate** — What share of customers came back?

### 4. Business Growth
- **Order Volume Over Time** — Are we getting more transactions?
- **Revenue Drivers** — Is growth coming from more customers, or from existing customers spending more?

> See [`ecommerce_analysis.sql`](./ecommerce_analysis.sql) for all queries.

---

## 💡 Key Insights

> *(To be updated after SQL analysis is complete)*

- **Revenue trend:** ...
- **Top market:** ...
- **High-value customers:** ...
- **Seasonality:** ...
- **Growth driver:** ...

---

##  Business Implications

| Finding | Action |
|---|---|
| Small % of products drive most revenue | Prioritize stock for top performers; reduce inventory risk on low sellers |
| High-value customers are identifiable | Target with personalized retention or loyalty campaigns |
| Strong regional markets are visible | Focus expansion efforts on already-proven geographies |
| Guest purchases are ~25% of orders | Consider capturing customer IDs at checkout to reduce data gaps |

---

##  Tools Used

- **Microsoft Excel** — Data exploration, cleaning, feature engineering
- **SQL** — KPI queries and business analysis

---

*Dataset sourced from Kaggle. This is a portfolio project for practicing end-to-end data analysis.*
