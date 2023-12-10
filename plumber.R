box::use(
  plumber
)

#* create API from file
filter_root = plumber::pr(file = "functions/fun_data_filter.R")
filter_root |> plumber::pr_run()
