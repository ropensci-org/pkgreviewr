context("test-rev_args.R")

## viridisLite has to be installed
installed <- require("viridisLite")
if(!installed){
    install.packages('viridisLite')
}

test_that("extract information for the arguments used in functions", {
    arg_info <- rev_args(system.file('viridisLite', package = 'pkgreviewr', mustWork = TRUE))
    arg_info_exported <- rev_args(system.file('viridisLite', package = 'pkgreviewr', mustWork = TRUE), exported_only = TRUE)
    expect_equivalent(colSums(arg_info$arg_map), arg_info$arg_df$n_functions)
    expect_equivalent(colSums(arg_info_exported$arg_map), arg_info_exported$arg_df$n_functions)
    degree_df <- rev_calls(system.file('viridisLite', package = 'pkgreviewr', mustWork = TRUE))
    expect_equal(rownames(arg_info_exported$arg_map), degree_df$f_name[degree_df$exported])
    expect_false(arg_info$arg_df$default_consistent[arg_info$arg_df$arg_name == 'n'])
})

