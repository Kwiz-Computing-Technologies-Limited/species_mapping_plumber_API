# load library functions
box::use(
  plumber,
  promises[future_promise, `%...>%`],
  here[here],
  future[plan, multisession],
  RAthena[athena],
  DBI[dbConnect, dbSendQuery, dbGetQuery, dbFetch],
  aws.s3,
  glue,
  ./set_env_variables[define_env, connection],
  sqldf[sqldf]
)

# Set environment variables
define_env()

#* list of continents
#* @get /continents
#* @serializer text
continent_choices = function() {
  list("Europe", "North America", "Africa", "South America", "Asia", "Australia", "Antarctica")
}


#* Define the function to query the table and return countries in a continent
#* @param continent Choose a continent
#* @get /countries
#* @serializer text
country_choices <- function(continent) {
  # Connect to Athena
  con <- connection()

  # Construct the SQL expression to get the unique values of the column
  sql <- paste0('SELECT DISTINCT country FROM "biodiversity_data"."occurence_data" WHERE continent = \'', continent, '\'')
  sql <- paste0(sql, ' AND country IS NOT NULL LIMIT 10000')
  
  # Use the dbGetQuery function to execute the SQL expression on the table in Athena
  results <- dbGetQuery(con, sql)

  # Return the result as a vector
  return(results)
}


#* Define the function to query the table and return stateprovinces in a country
#* @param country Choose a country
#* @get /state_provinces
#* @serializer text
state_choices <- function(country) {
  # Connect to Athena
  con <- connection()
  
  # Construct the SQL expression to get the unique values of the column
  sql <- paste0('SELECT DISTINCT stateprovince FROM "biodiversity_data"."occurence_data" WHERE country = \'', country, '\'')
  sql <- paste0(sql, ' AND stateprovince IS NOT NULL LIMIT 10000')
  
  # Use the dbGetQuery function to execute the SQL expression on the table in Athena
  results <- dbGetQuery(con, sql)

  # Return the result as a vector
  return(results)
}


#* Define the function to query the table and return scientific and vernacular names for species in the selected region
#* @param continent Choose a continent
#* @param country Choose a country
#* @param stateprovince Choose a stateprovince
#* @get /species_names
#* @serializer csv
name_choices <- function(continent = NULL , country = NULL, stateprovince = NULL) {
  # Connect to Athena
  con <- connection()
  
  # Construct the SQL expression to get the unique values of the column
  sql <- 'SELECT DISTINCT scientificName, vernacularName FROM "biodiversity_data"."occurence_data" WHERE '
  
  if (!is.null(stateprovince)) {
    sql <- paste0(sql, 'stateprovince = \'', stateprovince, '\'')
  } else if (!is.null(country)) {
    sql <- paste0(sql, 'country = \'', country, '\'')
  } else if (!is.null(continent)) {
    sql <- paste0(sql, 'continent = \'', continent, '\'')
  } else {
    stop("At least one of stateprovince, country, or continent must be provided.")
  }
    
  sql <- paste0(sql, " LIMIT 10000")
  
  # Use the dbGetQuery function to execute the SQL expression on the table in Athena
  results <- dbGetQuery(con, sql)

  # Return the result as a vector
  return(results)
}



#* Define the function to query the tables and filter based on input values
#* @param continent continent filter
#* @param country country filter
#* @param stateprovince province filter
#* @param scientificname scientificname filter
#* @param vernacularname vernacularname filter
#* @get /filtered_data
#* @serializer csv
filter_data <- function(continent = NULL, country = NULL, stateprovince = NULL, scientificname = NULL, vernacularname = NULL) {
  # Connect to Athena
  con <- connection()
  
  # Construct the SQL expression to filter the occurrence table based on the provided arguments
  sql <- paste0('SELECT o.scientificname, o.vernacularname, o.longitudedecimal, o.latitudedecimal, 
  o.individualcount, o.eventdate, o.eventtime, o.references, m.col5 accessuri FROM ("biodiversity_data"."occurence_data" o
LEFT JOIN "biodiversity_data"."multimedia" m ON (o.id = m.col0)) WHERE (1 = 1) AND')
  if (!is.null(continent)) {
    sql <- paste0(sql, ' continent = \'', continent, '\'')
  }
  if (!is.null(country)) {
    sql <- paste0(sql, ' country = \'', country, '\'')
  }
  if (!is.null(scientificname)) {
    sql <- paste0(sql, ' scientificname = \'', scientificname, '\'')
  }
  if (!is.null(vernacularname)) {
    sql <- paste0(sql, ' vernacularname = \'', vernacularname, '\'')
  }

  sql <- paste0(sql, " LIMIT 10000")

  # Use the dbGetQuery function to execute the SQL expression on the tables in Athena
  filtered_data <- dbGetQuery(con, sql)

  # Return the joined table
  return(filtered_data)
}
