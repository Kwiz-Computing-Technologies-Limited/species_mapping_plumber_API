box::use(
  promises[future_promise, `%...>%`],
  here[here],
  future[plan, multisession],
  RAthena[athena],
  DBI[dbConnect],
  aws.s3,
  glue
)

#* Set environment variables
define_env <- function() {
  Sys.setenv(
    AWS_ACCESS_KEY_ID = "AKIAYHNLKK7CPEECBD64",
    AWS_SECRET_ACCESS_KEY = "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",
    AWS_DEFAULT_REGION = "us-east-1"
  )
}

#* create athena connection
connection <- function() {
  dbConnect(athena(), s3_staging_dir = "s3://kwizcomputingtechnologies/biodiversity_data/output_folder/")
}
