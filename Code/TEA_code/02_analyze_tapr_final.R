library(dplyr)
library(readr)

input_file <- file.path(
  "data",
  "processed",
  "TEA",
  "tapr_staffing_analysis.csv"
)

analysis_file <- file.path(
  "data",
  "processed",
  "TEA",
  "tapr_staffing_with_ratios.csv"
)

summary_file <- file.path(
  "data",
  "processed",
  "TEA",
  "tapr_staffing_summary.csv"
)

tapr <- read_csv(
  input_file,
  show_col_types = FALSE
)

safe_ratio <- function(numerator, denominator) {
  ifelse(
    is.na(numerator) |
      is.na(denominator) |
      denominator <= 0,
    NA_real_,
    numerator / denominator
  )
}

tapr_analysis <- tapr |>
  mutate(
    bilingual_students_per_teacher = safe_ratio(
      bilingual_esl_student_count,
      bilingual_esl_teacher_fte
    ),

    special_ed_students_per_teacher = safe_ratio(
      special_ed_student_count,
      special_ed_teacher_fte
    ),

    cte_students_per_teacher = safe_ratio(
      cte_student_count,
      cte_teacher_fte
    )
  )

tapr_summary <- tapr_analysis |>
  select(
    district,
    tea_district_id,
    academic_year,

    teacher_fte,
    students_per_teacher,
    teacher_turnover_rate,

    avg_teacher_experience,
    avg_years_with_district,

    beginning_teacher_pct,
    teacher_1_5_pct,

    beginning_teacher_salary,
    avg_teacher_salary,

    bilingual_students_per_teacher,
    special_ed_students_per_teacher,
    cte_students_per_teacher
  ) |>
  arrange(
    academic_year,
    district
  )

write_csv(
  tapr_analysis,
  analysis_file
)

write_csv(
  tapr_summary,
  summary_file
)

message(
  "Saved analysis data to ",
  analysis_file
)

message(
  "Saved summary data to ",
  summary_file
)
