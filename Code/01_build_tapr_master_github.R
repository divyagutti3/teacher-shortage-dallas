library(pdftools)
library(stringr)
library(dplyr)
library(purrr)
library(tibble)
library(readr)

project_candidates <- c(
  getwd(),
  path.expand("~/Library/Mobile Documents/com~apple~CloudDocs/Documents/teacher-shortage-dallas"),
  path.expand("~/Documents/teacher-shortage-dallas")
)

project_root <- project_candidates[
  dir.exists(file.path(project_candidates, "data", "raw", "tea", "tapr"))
][1]

if (is.na(project_root)) {
  stop("Could not find data/raw/tea/tapr.")
}

tapr_root <- file.path(
  project_root,
  "data",
  "raw",
  "tea",
  "tapr"
)

all_files <- list.files(
  tapr_root,
  pattern = "\\.pdf$",
  recursive = TRUE,
  full.names = TRUE,
  ignore.case = TRUE
)

if (length(all_files) == 0) {
  stop("No TAPR PDF files were found.")
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

  text <- paste(text, collapse = "\n")

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
  text <- paste(text, collapse = "\n")

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

extract_one_tapr <- function(file) {
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

  student_text <- paste(
    pages[
      str_detect(
        pages,
        regex(
          "Student Information|Student Profile|Student Enrollment|Mobility|Program Information",
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

  district_id <- first_capture(
    full_text,
    "District Number:\\s*([0-9]{6})"
  )

  academic_year <- first_capture(
    full_text,
    "(20[0-9]{2}-[0-9]{2}) Texas Academic Performance Report"
  )

  county <- first_capture(
    full_text,
    "County Name:\\s*([A-Z -]+)"
  )

  if (is.na(county)) {
    county <- first_capture(
      full_text,
      "\\([0-9]{6}\\)\\s*-\\s*([A-Z -]+?)\\s+COUNTY"
    )
  }

  county <- str_to_title(
    str_trim(county)
  )

  total_staff <- get_pair(
    staff_text,
    "Total Staff"
  )

  professional_staff <- get_pair(
    staff_text,
    "Professional Staff"
  )

  teachers <- get_pair(
    staff_text,
    "Teachers"
  )

  professional_support <- get_pair(
    staff_text,
    "Professional Support"
  )

  campus_admin <- get_pair(
    staff_text,
    "Campus Administration \\(School Leadership\\)"
  )

  central_admin <- get_pair(
    staff_text,
    "Central Administration"
  )

  educational_aides <- get_pair(
    staff_text,
    "Educational Aides"
  )

  auxiliary_staff <- get_pair(
    staff_text,
    "Auxiliary Staff"
  )

  african_american <- get_pair(
    staff_text,
    "African American"
  )

  hispanic <- get_pair(
    staff_text,
    "Hispanic"
  )

  white <- get_pair(
    staff_text,
    "White"
  )

  american_indian <- get_pair(
    staff_text,
    "American Indian"
  )

  asian <- get_pair(
    staff_text,
    "Asian"
  )

  pacific_islander <- get_pair(
    staff_text,
    "Pacific Islander"
  )

  two_plus_races <- get_pair(
    staff_text,
    "Two or More Races"
  )

  males <- get_pair(
    staff_text,
    "Males"
  )

  females <- get_pair(
    staff_text,
    "Females"
  )

  no_degree <- get_pair(
    staff_text,
    "No Degree"
  )

  bachelors <- get_pair(
    staff_text,
    "Bachelors"
  )

  masters <- get_pair(
    staff_text,
    "Masters"
  )

  doctorate <- get_pair(
    staff_text,
    "Doctorate"
  )

  beginning <- get_pair(
    staff_text,
    "Beginning Teachers"
  )

  exp_1_5 <- get_pair(
    staff_text,
    "1-5 Years Experience"
  )

  exp_6_10 <- get_pair(
    staff_text,
    "6-10 Years Experience"
  )

  exp_11_20 <- get_pair(
    staff_text,
    "11-20 Years Experience"
  )

  exp_21_30 <- get_pair(
    staff_text,
    "21-30 Years Experience"
  )

  exp_over_30 <- get_pair(
    staff_text,
    "Over 30 Years Experience"
  )

  exp_over_20 <- get_pair(
    staff_text,
    "Over 20 Years Experience"
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

  students_per_teacher <- get_value(
    staff_text,
    "Number of Students per Teacher"
  )

  beginning_teacher_salary <- get_salary(
    staff_text,
    "Beginning Teachers"
  )

  teacher_salary_1_5 <- get_salary(
    staff_text,
    "1-5 Years Experience"
  )

  teacher_salary_6_10 <- get_salary(
    staff_text,
    "6-10 Years Experience"
  )

  teacher_salary_11_20 <- get_salary(
    staff_text,
    "11-20 Years Experience"
  )

  teacher_salary_21_30 <- get_salary(
    staff_text,
    "21-30 Years Experience"
  )

  teacher_salary_over_30 <- get_salary(
    staff_text,
    "Over 30 Years Experience"
  )

  teacher_salary_over_20_legacy <- get_salary(
    staff_text,
    "Over 20 Years Experience"
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

  avg_professional_support_salary <- get_salary(
    actual_salary_text,
    "Professional Support"
  )

  avg_campus_admin_salary <- get_salary(
    actual_salary_text,
    "Campus Administration \\(School Leadership\\)"
  )

  avg_central_admin_salary <- get_salary(
    actual_salary_text,
    "Central Administration"
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

  shared_services_text <- first_capture(
    staff_text,
    paste0(
      "Shared Services Arrangement Staff:?",
      "([\\s\\S]*?)",
      "Contracted Instructional Staff"
    )
  )

  shared_services_professional_staff <- get_value(
    shared_services_text,
    "Professional Staff"
  )

  shared_services_educational_aides <- get_value(
    shared_services_text,
    "Educational Aides"
  )

  shared_services_auxiliary_staff <- get_value(
    shared_services_text,
    "Auxiliary Staff"
  )

  cte_pattern <- "Career\\s*(?:&|and|/)\\s*Technical(?:\\s+Education)?"

  bilingual_teacher <- get_pair(
    staff_text,
    "Bilingual/ESL Education"
  )

  cte_teacher <- get_pair(
    staff_text,
    cte_pattern
  )

  compensatory_teacher <- get_pair(
    staff_text,
    "Compensatory Education"
  )

  gifted_teacher <- get_pair(
    staff_text,
    "Gifted\\s*(?:&|and)\\s*Talented Education"
  )

  regular_teacher <- get_pair(
    staff_text,
    "Regular Education"
  )

  special_ed_teacher <- get_pair(
    staff_text,
    "Special Education"
  )

  bilingual_student <- get_pair(
    student_text,
    "Bilingual/ESL Education"
  )

  cte_student <- get_pair(
    student_text,
    cte_pattern
  )

  gifted_student <- get_pair(
    student_text,
    "Gifted\\s*(?:&|and)\\s*Talented Education"
  )

  special_ed_student <- get_pair(
    student_text,
    "Special Education"
  )

  at_risk_student <- get_pair(
    student_text,
    "At-Risk"
  )

  homeless_student <- get_pair(
    student_text,
    "Homeless"
  )

  immigrant_student <- get_pair(
    student_text,
    "Immigrant"
  )

  mobility <- get_pair(
    student_text,
    "Total Mobile Students"
  )

  tibble(
    district = district,
    tea_district_id = district_id,
    academic_year = academic_year,
    tapr_primary_county = county,

    total_staff_fte = total_staff["value"],
    total_staff_pct = total_staff["pct"],
    professional_staff_fte = professional_staff["value"],
    professional_staff_pct = professional_staff["pct"],
    teacher_fte = teachers["value"],
    teacher_pct = teachers["pct"],
    professional_support_fte = professional_support["value"],
    professional_support_pct = professional_support["pct"],
    campus_admin_fte = campus_admin["value"],
    campus_admin_pct = campus_admin["pct"],
    central_admin_fte = central_admin["value"],
    central_admin_pct = central_admin["pct"],
    educational_aides_fte = educational_aides["value"],
    educational_aides_pct = educational_aides["pct"],
    auxiliary_staff_fte = auxiliary_staff["value"],
    auxiliary_staff_pct = auxiliary_staff["pct"],

    teacher_african_american_fte = african_american["value"],
    teacher_african_american_pct = african_american["pct"],
    teacher_hispanic_fte = hispanic["value"],
    teacher_hispanic_pct = hispanic["pct"],
    teacher_white_fte = white["value"],
    teacher_white_pct = white["pct"],
    teacher_american_indian_fte = american_indian["value"],
    teacher_american_indian_pct = american_indian["pct"],
    teacher_asian_fte = asian["value"],
    teacher_asian_pct = asian["pct"],
    teacher_pacific_islander_fte = pacific_islander["value"],
    teacher_pacific_islander_pct = pacific_islander["pct"],
    teacher_two_plus_races_fte = two_plus_races["value"],
    teacher_two_plus_races_pct = two_plus_races["pct"],
    male_teacher_fte = males["value"],
    male_teacher_pct = males["pct"],
    female_teacher_fte = females["value"],
    female_teacher_pct = females["pct"],

    teacher_no_degree_fte = no_degree["value"],
    teacher_no_degree_pct = no_degree["pct"],
    teacher_bachelors_fte = bachelors["value"],
    teacher_bachelors_pct = bachelors["pct"],
    teacher_masters_fte = masters["value"],
    teacher_masters_pct = masters["pct"],
    teacher_doctorate_fte = doctorate["value"],
    teacher_doctorate_pct = doctorate["pct"],

    beginning_teacher_fte = beginning["value"],
    beginning_teacher_pct = beginning["pct"],
    teacher_1_5_fte = exp_1_5["value"],
    teacher_1_5_pct = exp_1_5["pct"],
    teacher_6_10_fte = exp_6_10["value"],
    teacher_6_10_pct = exp_6_10["pct"],
    teacher_11_20_fte = exp_11_20["value"],
    teacher_11_20_pct = exp_11_20["pct"],
    teacher_21_30_fte = exp_21_30["value"],
    teacher_21_30_pct = exp_21_30["pct"],
    teacher_over_30_fte = exp_over_30["value"],
    teacher_over_30_pct = exp_over_30["pct"],
    teacher_over_20_fte_legacy = exp_over_20["value"],
    teacher_over_20_pct_legacy = exp_over_20["pct"],

    avg_teacher_experience = avg_teacher_experience,
    avg_years_with_district = avg_years_with_district,
    students_per_teacher = students_per_teacher,

    beginning_teacher_salary = beginning_teacher_salary,
    teacher_salary_1_5 = teacher_salary_1_5,
    teacher_salary_6_10 = teacher_salary_6_10,
    teacher_salary_11_20 = teacher_salary_11_20,
    teacher_salary_21_30 = teacher_salary_21_30,
    teacher_salary_over_30 = teacher_salary_over_30,
    teacher_salary_over_20_legacy = teacher_salary_over_20_legacy,
    avg_teacher_salary = avg_teacher_salary,
    avg_professional_support_salary = avg_professional_support_salary,
    avg_campus_admin_salary = avg_campus_admin_salary,
    avg_central_admin_salary = avg_central_admin_salary,

    teacher_turnover_rate = teacher_turnover_rate,
    instructional_staff_pct = instructional_staff_pct,
    contracted_instructional_staff_fte = contracted_instructional_staff_fte,

    shared_services_professional_staff_fte =
      shared_services_professional_staff,
    shared_services_educational_aides_fte =
      shared_services_educational_aides,
    shared_services_auxiliary_staff_fte =
      shared_services_auxiliary_staff,

    bilingual_esl_teacher_fte = bilingual_teacher["value"],
    bilingual_esl_teacher_pct = bilingual_teacher["pct"],
    cte_teacher_fte = cte_teacher["value"],
    cte_teacher_pct = cte_teacher["pct"],
    compensatory_ed_teacher_fte = compensatory_teacher["value"],
    compensatory_ed_teacher_pct = compensatory_teacher["pct"],
    gifted_talented_teacher_fte = gifted_teacher["value"],
    gifted_talented_teacher_pct = gifted_teacher["pct"],
    regular_ed_teacher_fte = regular_teacher["value"],
    regular_ed_teacher_pct = regular_teacher["pct"],
    special_ed_teacher_fte = special_ed_teacher["value"],
    special_ed_teacher_pct = special_ed_teacher["pct"],

    bilingual_esl_student_count = bilingual_student["value"],
    bilingual_esl_student_pct = bilingual_student["pct"],
    cte_student_count = cte_student["value"],
    cte_student_pct = cte_student["pct"],
    gifted_talented_student_count = gifted_student["value"],
    gifted_talented_student_pct = gifted_student["pct"],
    special_ed_student_count = special_ed_student["value"],
    special_ed_student_pct = special_ed_student["pct"],
    at_risk_student_count = at_risk_student["value"],
    at_risk_student_pct = at_risk_student["pct"],
    homeless_student_count = homeless_student["value"],
    homeless_student_pct = homeless_student["pct"],
    immigrant_student_count = immigrant_student["value"],
    immigrant_student_pct = immigrant_student["pct"],
    mobile_student_count = mobility["value"],
    student_mobility_pct = mobility["pct"],

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

  results[[i]] <- tryCatch(
    extract_one_tapr(all_files[i]),
    error = function(e) {
      stop(
        "Extraction failed for ",
        basename(all_files[i]),
        ": ",
        conditionMessage(e)
      )
    }
  )
}

tapr_master <- bind_rows(
  results
) |>
  arrange(
    academic_year,
    district
  )

processed_dir <- file.path(
  project_root,
  "data",
  "processed",
  "tea"
)

dir.create(
  processed_dir,
  recursive = TRUE,
  showWarnings = FALSE
)

write_csv(
  tapr_master,
  file.path(
    processed_dir,
    "tapr_staffing_master.csv"
  )
)


message(
  "Saved ",
  nrow(tapr_master),
  " rows to data/processed/tea/tapr_staffing_master.csv"
)
