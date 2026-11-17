library(pdftools)
library(stringr)
library(dplyr)
library(tibble)
library(readr)

tapr_root <- file.path(
  "data",
  "raw",
  "TEA"
)

output_file <- file.path(
  "data",
  "processed",
  "TEA",
  "tapr_staffing_analysis.csv"
)

dir.create(
  dirname(output_file),
  recursive = TRUE,
  showWarnings = FALSE
)

all_files <- list.files(
  tapr_root,
  pattern = "\\.pdf$",
  recursive = TRUE,
  full.names = TRUE,
  ignore.case = TRUE
)

if (length(all_files) == 0) {
  stop("No TAPR PDF files were found in data/raw/TEA.")
}

clean_num <- function(x) {
  if (length(x) == 0 || all(is.na(x))) {
    return(NA_real_)
  }

  x <- x[1]

  if (is.na(x)) {
    return(NA_real_)
  }

  suppressWarnings(
    as.numeric(
      str_remove_all(x, "[,$%]")
    )
  )
}

first_capture <- function(text, pattern) {
  if (length(text) == 0 || all(is.na(text))) {
    return(NA_character_)
  }

  text <- paste(
    text,
    collapse = "\n"
  )

  result <- str_match(
    text,
    regex(
      pattern,
      ignore_case = TRUE,
      multiline = TRUE
    )
  )

  if (
    nrow(result) == 0 ||
    ncol(result) < 2 ||
    is.na(result[1, 2])
  ) {
    return(NA_character_)
  }

  result[1, 2]
}

get_value <- function(text, label) {
  clean_num(
    first_capture(
      text,
      paste0(
        "(?:",
        label,
        ")\\s*:?\\s+",
        "([0-9,]+(?:\\.[0-9]+)?)"
      )
    )
  )
}

get_pair <- function(text, label) {
  text <- paste(
    text,
    collapse = "\n"
  )

  pattern <- paste0(
    "(?m)^\\s*(?:",
    label,
    ")\\s*:?\\s+",
    "([0-9,]+(?:\\.[0-9]+)?)\\s+",
    "([0-9]+(?:\\.[0-9]+)?)%"
  )

  result <- str_match(
    text,
    regex(
      pattern,
      ignore_case = TRUE,
      multiline = TRUE
    )
  )

  if (
    nrow(result) == 0 ||
    ncol(result) < 3 ||
    is.na(result[1, 2])
  ) {
    return(
      c(
        value = NA_real_,
        pct = NA_real_
      )
    )
  }

  c(
    value = clean_num(result[1, 2]),
    pct = clean_num(result[1, 3])
  )
}

get_salary <- function(text, label) {
  clean_num(
    first_capture(
      text,
      paste0(
        "(?m)^\\s*(?:",
        label,
        ")\\s*:?\\s+\\$([0-9,]+)"
      )
    )
  )
}

extract_tapr <- function(file) {
  pages <- pdf_text(file)

  full_text <- paste(
    pages,
    collapse = "\n"
  )

  staff_text <- paste(
    pages[
      str_detect(
        pages,
        regex(
          "Staff Information",
          ignore_case = TRUE
        )
      )
    ],
    collapse = "\n"
  )

  student_program_text <- paste(
    pages[
      str_detect(
        pages,
        regex(
          "Students? by Instructional Program",
          ignore_case = TRUE
        )
      )
    ],
    collapse = "\n"
  )

  district <- str_trim(
    first_capture(
      full_text,
      "District Name:\\s*([^\\n\\r]+)"
    )
  )

  tea_district_id <- first_capture(
    full_text,
    "District Number:\\s*([0-9]{6})"
  )

  academic_year <- first_capture(
    full_text,
    "(20[0-9]{2}-[0-9]{2}) Texas Academic Performance Report"
  )

  teachers <- get_pair(
    staff_text,
    "Teachers"
  )

  beginning_teachers <- get_pair(
    staff_text,
    "Beginning Teachers"
  )

  teachers_1_5 <- get_pair(
    staff_text,
    "1-5 Years Experience"
  )

  students_per_teacher <- get_value(
    staff_text,
    "Number of Students per Teacher"
  )

  teacher_turnover_rate <- get_value(
    staff_text,
    "Turnover Rate for Teachers"
  )

  instructional_staff_pct <- get_value(
    staff_text,
    "Instructional Staff Percent"
  )

  contracted_instructional_staff_fte <- get_value(
    staff_text,
    "Contracted Instructional Staff"
  )

  avg_teacher_experience <- get_value(
    staff_text,
    "Average Years Experience of Teachers"
  )

  if (is.na(avg_teacher_experience)) {
    avg_teacher_experience <- clean_num(
      first_capture(
        staff_text,
        paste0(
          "Average Years Experience of Campus Staff",
          "[\\s\\S]*?",
          "Teachers\\s+",
          "([0-9]+(?:\\.[0-9]+)?)"
        )
      )
    )
  }

  avg_years_with_district <- get_value(
    staff_text,
    "Average Years Experience of Teachers with District"
  )

  if (is.na(avg_years_with_district)) {
    avg_years_with_district <- get_value(
      staff_text,
      "Teachers with District"
    )
  }

  beginning_teacher_salary <- get_salary(
    staff_text,
    "Beginning Teachers"
  )

  actual_salary_text <- first_capture(
    staff_text,
    paste0(
      "Average Actual Salaries",
      "(?: \\(regular duties only\\))?:?",
      "([\\s\\S]*?)",
      "(?:Staff Exclusions|Instructional Staff Percent|Turnover Rate for Teachers)"
    )
  )

  avg_teacher_salary <- get_salary(
    actual_salary_text,
    "Teachers"
  )

  cte_teacher_pattern <- "Career\\s*(?:&|and|/)\\s*Technical(?:\\s+Education)?"

  cte_student_pattern <- paste0(
    "Career\\s*(?:&|and|/)\\s*Technical(?:\\s+Education)?",
    "(?!\\s*\\()"
  )

  bilingual_teacher <- get_pair(
    staff_text,
    "Bilingual/ESL Education"
  )

  special_ed_teacher <- get_pair(
    staff_text,
    "Special Education"
  )

  cte_teacher <- get_pair(
    staff_text,
    cte_teacher_pattern
  )

  bilingual_student <- get_pair(
    student_program_text,
    "Bilingual/ESL Education"
  )

  special_ed_student <- get_pair(
    student_program_text,
    "Special Education"
  )

  cte_student <- get_pair(
    student_program_text,
    cte_student_pattern
  )

  tibble(
    district = district,
    tea_district_id = tea_district_id,
    academic_year = academic_year,

    teacher_fte = teachers["value"],
    students_per_teacher = students_per_teacher,
    teacher_turnover_rate = teacher_turnover_rate,

    avg_teacher_experience = avg_teacher_experience,
    avg_years_with_district = avg_years_with_district,

    beginning_teacher_pct = beginning_teachers["pct"],
    teacher_1_5_pct = teachers_1_5["pct"],

    contracted_instructional_staff_fte =
      contracted_instructional_staff_fte,

    instructional_staff_pct = instructional_staff_pct,

    beginning_teacher_salary = beginning_teacher_salary,
    avg_teacher_salary = avg_teacher_salary,

    bilingual_esl_teacher_fte = bilingual_teacher["value"],
    special_ed_teacher_fte = special_ed_teacher["value"],
    cte_teacher_fte = cte_teacher["value"],

    bilingual_esl_student_count = bilingual_student["value"],
    special_ed_student_count = special_ed_student["value"],
    cte_student_count = cte_student["value"],

    source_file = basename(file)
  )
}

results <- vector(
  "list",
  length(all_files)
)

for (i in seq_along(all_files)) {
  message(
    "[",
    i,
    "/",
    length(all_files),
    "] ",
    basename(all_files[i])
  )

  results[[i]] <- extract_tapr(
    all_files[i]
  )
}

tapr_staffing_analysis <- bind_rows(
  results
) |>
  arrange(
    academic_year,
    district
  )

write_csv(
  tapr_staffing_analysis,
  output_file
)

message(
  "Saved ",
  nrow(tapr_staffing_analysis),
  " rows and ",
  ncol(tapr_staffing_analysis),
  " columns to ",
  output_file
)
