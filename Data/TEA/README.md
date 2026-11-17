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

This file contains the selected TAPR variables used to describe teacher staffing conditions.

| Variable | Explanation |
|---|---|
| `district` | Name of the independent school district. |
| `tea_district_id` | Six-digit identifier assigned to each district by the Texas Education Agency. |
| `academic_year` | School year represented by the TAPR report. |
| `teacher_fte` | Number of teachers measured in full-time equivalents. **FTE** means full-time equivalent, so one full-time teacher equals 1.0 FTE and a half-time teacher equals 0.5 FTE. This is not necessarily the same as teacher headcount. |
| `students_per_teacher` | Number of students per teacher reported by TEA. This provides a general measure of staffing capacity relative to student enrollment, but it should not be interpreted as average classroom size. |
| `teacher_turnover_rate` | Percentage of teachers who leave or change from the district's teaching workforce from one year to the next. A higher rate can indicate greater workforce instability. |
| `avg_teacher_experience` | Average number of years of teaching experience among teachers in the district. |
| `avg_years_with_district` | Average number of years teachers have worked in their current district. This provides information about district-level retention and workforce stability. |
| `beginning_teacher_pct` | Percentage of the teacher workforce classified by TEA as beginning teachers. |
| `teacher_1_5_pct` | Percentage of teachers with between 1 and 5 years of teaching experience. |
| `contracted_instructional_staff_fte` | Full-time equivalent instructional staff provided through contracted staffing arrangements rather than the district's regular workforce. |
| `instructional_staff_pct` | Percentage of the district's total staff classified as instructional staff. |
| `beginning_teacher_salary` | Average salary reported for beginning teachers. |
| `avg_teacher_salary` | Average actual salary reported for teachers in the district. |
| `bilingual_esl_teacher_fte` | Full-time equivalent teachers assigned to bilingual or English as a Second Language (ESL) education. |
| `special_ed_teacher_fte` | Full-time equivalent teachers assigned to special education. |
| `cte_teacher_fte` | Full-time equivalent teachers assigned to Career and Technical Education (CTE). |
| `bilingual_esl_student_count` | Number of students participating in bilingual or ESL education. |
| `special_ed_student_count` | Number of students participating in special education. |
| `cte_student_count` | Number of students participating in Career and Technical Education. |
| `source_file` | Name of the TAPR PDF from which the district-year observation was extracted. |

### `tapr_staffing_with_ratios.csv`

This file contains all variables from `tapr_staffing_analysis.csv` plus three calculated staffing indicators.

| Variable | Explanation |
|---|---|
| `bilingual_students_per_teacher` | Number of bilingual/ESL students divided by bilingual/ESL teacher FTE. This is best interpreted as a program staffing-load indicator rather than a literal class-size ratio. |
| `special_ed_students_per_teacher` | Number of special education students divided by special education teacher FTE. This provides a way to compare special education staffing capacity across districts and years. |
| `cte_students_per_teacher` | Number of CTE students divided by CTE teacher FTE. This is a program staffing indicator and should not be interpreted as the number of students physically assigned to one teacher. |

### `tapr_staffing_summary.csv`

This file contains a smaller set of staffing indicators selected for comparison, visualization, and later analysis with the Facebook topic-analysis results.

## Key Terms

**FTE (Full-Time Equivalent):** A standardized measure of staffing. One full-time employee equals 1.0 FTE. Two employees each working half-time would also equal 1.0 FTE.

**Teacher Headcount vs. Teacher FTE:** Headcount measures the number of individual teachers, while FTE measures the amount of full-time staffing those teachers represent. This project uses FTE because TAPR reports many staffing measures in this form.

**Turnover Rate:** A measure of how much the teacher workforce changes from one year to the next. It can provide evidence of workforce instability but does not directly measure the number of vacant positions.

**Students per Teacher:** A district-level staffing measure comparing student enrollment with teacher staffing. It is not the same as average classroom size.

**Program Staffing Ratio:** A calculated measure comparing the number of students participating in a program with the amount of teacher FTE assigned to that program. These ratios are used as indicators of staffing load and should not be interpreted as literal teacher caseloads or class sizes.

## Reproducibility

The TAPR data are generated using the R scripts in the `Code` folder.

1. `01_extract_tapr.R` extracts selected staffing variables from the raw TAPR PDFs and creates `tapr_staffing_analysis.csv`.
2. `02_analyze_tapr.R` creates the program staffing ratios and summary datasets.

The scripts should be run in that order.

## Important Note

TAPR reporting categories are not completely identical across academic years. When a measure is not reported for a particular year, the value is retained as `NA` rather than estimated or replaced.
