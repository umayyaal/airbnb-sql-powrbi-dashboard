# 🌍 Global Airbnb Market Analytics — SQL + Power BI

## 📖 Project Overview

This project is an end-to-end data analytics solution built on real, unprocessed Airbnb listing data from four major global cities—**New York, London, Paris, and Barcelona**. The objective was to transform large-scale, messy public datasets into an interactive business intelligence dashboard capable of answering meaningful market and host performance questions.

Unlike many portfolio projects that begin with cleaned datasets, this project starts with raw CSV exports containing inconsistent formatting, mixed data types, and millions of calendar records. The complete analytics pipeline was designed from scratch, covering data validation in Python, a layered ETL process in MySQL, analytical SQL views, star-schema modeling, DAX calculations, and a three-page Power BI dashboard.

The final report enables users to compare city-level performance, understand the drivers behind pricing and occupancy differences, identify high-performing neighbourhoods and listings, and evaluate whether factors such as Superhost status and host experience are actually associated with better business outcomes.

Throughout the project, emphasis was placed on building a realistic analytics workflow that mirrors industry practices—performing data cleaning and transformation in the database layer, keeping Power BI focused on modeling, visualization, and business storytelling.

**Project Scale**

- ~216,000 Airbnb listings
- ~78 million calendar records
- 4 global cities
- ~$2.73B estimated market revenue analyzed

--

## 📊 Dashboard Preview

> This report was built and tested in Power BI Desktop. I don't currently have a Power BI Pro license, so I'm unable to publish it live to the Power BI Service — the screenshots below show all three report pages, and the full interactive `.pbix` file is included in this repo (`powerbi\airbnb_dashboard.pbix`) and can be opened for free in [Power BI Desktop](https://www.microsoft.com/en-us/power-platform/products/power-bi/desktop).

### Page 1 — Market Overview
![Overview page](images\01_overview_page.JPG)

### Page 2 — Market Deep Dive (Pricing & Segmentation)
![Market Deep Dive page](images\02_market_deep_dive_page.JPG)

### Page 3 — Host & Performance Analysis
![Host and Performance page](images\03_host_performance_page.JPG)

---

## 🧭 Project Story

The dashboard is built around one central question, unpacked across three pages:

**"Where should we focus attention in this market — and why?"**

1. **Overview** — Which markets perform best, at a glance?
2. **Market Deep Dive** — Why? What's driving those differences underneath the headline numbers?
3. **Host & Performance** — Who's actually winning, and does conventional wisdom about "good hosting" hold up?

Full narrative writeup connecting all three pages: [`docs/powerbi_storyline.md`](docs/powerbi_storyline.md)

---

## 🔑 Key Business Insights

- **Paris leads on both occupancy (61.25%) and price ($321.23)** — an unusual pairing, since higher price would normally suppress demand. **Barcelona lags on both dimensions** (41.05% occupancy, $240.62 price) — suggesting a possibly oversupplied or softening market.
- **Price varies ~20x within a single city** (from $65 to $1,384/night by neighbourhood) — city-level averages mask enormous internal variation, and are a poor basis for pricing or investment decisions on their own.
- **No clean relationship between price and occupancy** at the neighbourhood level — price alone does not reliably predict booking performance.
- **Superhosts show * slight lower* occupancy than non-superhosts** (52.24% vs. 56.83%) at nearly identical price points — a counterintuitive finding that challenges the assumption that Airbnb's own quality badge predicts stronger demand.
- **Host experience shows a non-linear relationship with performance** — Average prices remain fairly consistent across all host experience groups (approximately $276–$295 per night), while occupancy varies much more, peaking among hosts with 6–10 years of experience. This indicates that host experience is more closely associated with occupancy than with pricing, although other factors may also influence this relationship.

*(Full findings, caveats, and business framing for each page are documented in [`docs/powerbi_storyline.md`](docs/powerbi_storyline.md))*

---

## 🏗️ Architecture

```
Inside Airbnb (raw CSV, per city)
        │
        ▼
Python (csv module) — CSV validation & re-escaping
        │
        ▼
MySQL 8.0
  ├─ Staging layer      (raw import, all TEXT columns)
  ├─ Cleaned layer       (defensive type-casting, listings_clean)
  ├─ Aggregation layer   (calendar_monthly_agg — 78M rows → ~2.8M)
  └─ Analytical views    (occupancy %, revenue, window-function rankings)
        │
        ▼
Power BI Desktop
  ├─ Star-schema data model (listings_clean ↔ calendar_monthly_agg)
  ├─ DAX measures (SUM, SUMX, AVERAGE, RELATED, DISTINCTCOUNT, DIVIDE, SWITCH)
  └─ 3-page report
```

**Why SQL does the heavy lifting, not Power BI:** all cleaning, type-casting, and aggregation happens in MySQL before the data ever reaches Power BI. This keeps the BI layer fast and focused on visualization, and reflects how this kind of pipeline is typically built in practice — pushing set-based computation to the database engine rather than a client tool.

---

## 🛠️ Tech Stack

- **Data source:** [Inside Airbnb](http://insideairbnb.com) (public, free, real-world scraped listing data)
- **Cleaning:** Python (`csv` module) — RFC-4180-compliant CSV re-validation
- **Database:** MySQL 8.0
- **BI/Visualization:** Power BI Desktop (DAX, star-schema modeling)
- **SQL concepts demonstrated:** staging/ETL design, defensive type-casting, `GROUP BY` + conditional aggregation, multi-table joins, window functions (`DENSE_RANK() OVER (PARTITION BY ...)`), views, indexing
- **DAX concepts demonstrated:** `SUM`, `SUMX`, `RELATED` cross-table calculations, `DIVIDE` (safe division), `AVERAGE`, `DISTINCTCOUNT`, `SWITCH(TRUE(), ...)` for calculated columns/bucketing, sort-by-column

---

## 📁 Repository Structure

```
├── README.md
├── sql/                                  → all SQL build scripts, in run order
│   ├── 01_create_staging_tables.sql
│   ├── 02_create_listings_clean.sql
│   ├── 03_create_calendar_monthly_agg.sql
│   ├── 04_create_occupancy_views.sql
│   ├── 05_create_listings_annual_performance.sql
│   ├── 06_create_rank_listings_occupancy_view.sql
│   └── 07_create_listings_monthly_revenue_view.sql
├── powerbi/
│   └── airbnb_dashboard.pbix             → full interactive report file
├── screenshots/
│   ├── 01_overview_page.png
│   ├── 02_market_deep_dive_page.png
│   └── 03_host_performance_page.png
└── docs/
    ├── project_summary.md      → full build log: every step, issue, and fix
    └── powerbi_storyline.md                     → cross-page narrative & final insights
```

---

## 🐛 Notable Problems Solved

A few of the more substantial issues encountered and resolved during this build — full detail in [`docs/project_summary.md`](docs/project_summary.md):

- **Malformed CSV rows** from inconsistent quote-escaping in the source data, fixed with a Python re-validation/re-escaping pass before import.
- **A 12-hour unindexed `UPDATE`** on a 34-million-row table, resolved by moving value assignment inline into the `LOAD DATA INFILE` step and adding indexes on frequently-filtered columns.
- **A silent data integrity bug** — one city's revenue was completely missing from a summary view with no error. Traced to two source files (listings and calendar) for the same city having been pulled from different scrape dates, so their listing IDs didn't match. Fixed by re-sourcing the correct file and validating join-key overlap before re-importing.
- **A referential integrity gap** between the Power BI fact and dimension tables (570 orphaned calendar records with no matching listing), found via an unexpected blank category in a slicer, diagnosed with a `LEFT JOIN`, and fixed at the SQL layer.
- **A misleading "Top 10 by Revenue" table** caused by four independent, compounding issues (non-unique listing names causing row collisions, an ID field being incorrectly summed, a genuine outlier from real host pricing behavior, and a Top N filter sorting by the wrong field) — each diagnosed and fixed in turn.

---

## ⚠️ Data Limitations

- **Occupancy ≠ confirmed bookings.** The source calendar data marks a date "unavailable" whether it was booked by a guest *or* manually blocked by the host — these can't be distinguished in the public dataset.
- **Calendar data is a forward-looking snapshot** (~12 months from the scrape date, mid-2026 to mid-2027), not historical booking activity. Dates further from the scrape date are less reliable, since hosts haven't fully updated availability that far out — the Overview page is filtered to the near-term window for this reason.
- **Revenue figures are estimates** (`nightly price × booked days`), not actuals — they don't account for pricing changes over time, discounts, fees, or cancellations.

---

## 📬 About

Built as a portfolio project to demonstrate end-to-end data analyst / business analyst skills — data sourcing, SQL-based ETL, data modeling, DAX, and dashboard design — using real, messy, public data rather than a pre-cleaned dataset.
