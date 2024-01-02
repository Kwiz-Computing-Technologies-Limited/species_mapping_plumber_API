box::use(
  promises[future_promise, `%...>%`],
  here[here],
  future[plan, multisession],
  RAthena[athena],
  DBI[dbConnect],
  aws.s3,
  glue
)


#* create athena connection
connection <- function() {
  dbConnect(athena(), s3_staging_dir = "s3://kwizcomputingtechnologies/biodiversity_data/output_folder/")
}
