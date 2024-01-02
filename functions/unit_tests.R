source("./functions/fun_data_filter.R")
source("./functions/set_env_variables.R")

library(testthat)

# Test athena connection
test_that("connection returns an object of class 'AthenaConnection'", {
  # Call the function
  result <- connection()
  
  # Check if the result is an object of class 'AthenaConnection'
  expect_s4_class(result, "AthenaConnection")
})


# Define the test for getting countries from continent
test_that("country_choices returns 'The Netherlands' for continent 'Europe'", {
  # Call the function with 'Europe' as the argument
  result <- country_choices('Europe')
  
  # Check if 'The Netherlands' is in the result
  expect_true('The Netherlands' %in% result$country)
})


# Define the test for getting state/provinces from country
test_that("state_choices returns 'Noord-Brabant' for country 'The Netherlands'", {
  # Call the function with 'Europe' as the argument
  result <- state_choices('The Netherlands')
  
  # Check if 'The Netherlands' is in the result
  expect_true('Noord-Brabant' %in% result$stateprovince)
})

# test that the scientificName and vernacularName is returned correctly for the selected stateprovince:
test_that("name_choices returns 'Rorippa palustris' and 'Marsh Yellow-cress' for stateprovince 'Overijssel'", {
  # Call the function with 'Overijssel' as the argument
  result <- name_choices(stateprovince = 'Overijssel')
  
  # Check if 'Rorippa palustris' and 'Marsh Yellow-cress' are in the same row of the result
  expect_true(any(result$scientificName %in% 'Rorippa palustris' & result$vernacularName %in% 'Marsh Yellow-cress'))
})


# Define the test to check that the filtered table is a dataframe with longitude, latitude and count columns
test_that("filter_data returns a dataframe with columns 'longitudedecimal', 'latitudedecimal', and 'individualcount' for vernacularname 'Great Tit'", {
  # Call the function with 'Great Tit' as the argument
  result1 <- filter_data(vernacularname = 'Great Tit')
  
  
  # Check if the result is a data frame
  expect_true(is.data.frame(result1))

  # Check if the result has the expected columns
  expect_true(all(c('scientificname', 'vernacularname', 'longitudedecimal', 'latitudedecimal', 'individualcount', 'habitat', 'eventdate', 'eventtime', 'references', 'accessuri') %in% colnames(result1)))
})


kenya = filter_data(country = "Kenya")
