#' Convert NDCs from 10-digits to 11-digits
#'
#' @param path A path (character) to the original csv file downloaded.
#' @param var_name A variable name for the converted NDCs in the output data
#'   (Default: "ndcnum").
#'
#' @return Returns nothing. As a side effect, it creates a .dta file in the same folder.
#' @importFrom magrittr %>%
#' @importFrom dplyr mutate select rename if_else
#' @importFrom rlang .data :=
#' @importFrom stringr str_split str_length str_pad str_c
#' @importFrom purrr map_chr
#' @export
#' @examples
#' \dontrun{
#' ndc_convert("path/to/the/file")
#' }
ndc_convert <- function(path, var_name = "ndcnum") {
  path <- normalizePath(path)
  tbl <- readr::read_csv(path, show_col_types = FALSE)
  ndc_codes <- select(tbl, .data$`NDC Package Code`)
  ndc_codes %>%
    mutate(splits = str_split(.data$`NDC Package Code`, "-")) %>%
    mutate(first = map_chr(.data$splits, ~ .x[1])) %>%
    mutate(second = map_chr(.data$splits, ~ .x[2])) %>%
    mutate(third = map_chr(.data$splits, ~ .x[3])) %>%
    mutate(first11 = if_else(str_length(.data$first) == 4,
                             str_pad(.data$first, width = 5, "0", side = "left"),
                             .data$first)) %>%
    mutate(second11 = if_else(str_length(.data$second) == 3,
                              str_pad(.data$second, width = 4, "0", side = "left"),
                              .data$second)) %>%
    mutate(third11 = if_else(str_length(.data$third) == 1,
                             str_pad(.data$third, width = 2, "0", side = "left"),
                             .data$third)) %>%
    select(-c(.data$splits, .data$first, .data$second, .data$third)) %>%
    mutate({{ var_name }} := str_c(.data$first11, .data$second11, .data$third11)) %>%
    select(.data$`NDC Package Code`, {{ var_name }}) %>%
    rename(ndc_10_digits = .data$`NDC Package Code`) %>%
    haven::write_dta(file.path(dirname(path), "ndc_11_digits.dta"))
}
