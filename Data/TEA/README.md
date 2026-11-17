# TEA Data

This folder contains Texas Education Agency (TEA) data used to examine teacher staffing conditions across independent school districts serving any portion of Dallas County.

## Raw Data

The raw data consist of district-level Texas Academic Performance Report (TAPR) PDFs for the following academic years:

- 2019–20
- 2020–21
- 2021–22
- 2022–23
- 2023–24
- 2024–25

The original PDFs are stored by academic year and are not modified.

## Processed Data

The processed TAPR dataset contains one observation per district per academic year.

### `tapr_staffing_analysis.csv`

Contains the selected TAPR variables used for the staffing analysis, including:

- teacher FTE
- students per teacher
- teacher turnover rate
- average teacher experience
- average years with district
- beginning teacher percentage
- teachers with 1–5 years of experience
- contracted instructional staff
- instructional staff percentage
- beginning teacher salary
- average teacher salary
- bilingual/ESL teacher and student counts
- special education teacher and student counts
- CTE teacher and student counts

### `tapr_staffing_with_ratios.csv`

Adds program-level staffing indicators calculated from the extracted TAPR data:

- bilingual/ESL students per assigned teacher FTE
- special education students per assigned teacher FTE
- CTE students per assigned teacher FTE

These measures should be interpreted as staffing-load indicators rather than literal class-size ratios.

### `tapr_staffing_summary.csv`

Contains a smaller set of staffing indicators intended for comparison, visualization, and later analysis with the Facebook topic-analysis results.

## Reproducibility

The TAPR data are generated using the R scripts in the `Code` folder.

1. `01_extract_tapr.R` extracts selected variables from the raw TAPR PDFs and creates `tapr_staffing_analysis.csv`.
2. `02_analyze_tapr.R` creates the program staffing ratios and summary datasets.

The scripts should be run in that order.

## Important Note

TAPR reporting categories are not completely identical across academic years. For example, some CTE student information is unavailable in the 2020–21 TAPR reports. Missing values are retained as `NA` rather than being estimated.
