rm(list=ls())
shell("cls")
options(warn = 1) #Useful for debugging, prints messages as they occur. 
source("./libs/analyzer.R")

# TODO: Deprecate
main <- function()
{
  consolidated_data <- multi_delim_reader(filepath = "./rawdata/", 
                                          printFlag = printFlag)
  filtered_data <- filter_data(consolidated_data)
  rm(consolidated_data)
  
  subset_name <- "State Government Receipts"
  subset_data <- filtered_data[,STATE_GOVERNMENT_RECEIPTS]
  cleaned_data <- get_clean_long_subset_data(subset_data)
  plot <- getPlot(cleaned_data, subset_name)
  plot
}


# TODO: Update, replace main()
# TODO: Write Analysis Results to PDF (1 summary & 1 Plot per page)
main_new <- function()
{
  results_temp <- NULL
  consolidated_data <- multi_delim_reader(filepath = "rawdata", 
                                          printFlag = printFlag)
  filter_data(consolidated_data)
  rm(consolidated_data)
  
  subsets <- c("State Government Receipts", 
               # "State Government Expenditure", 
               "Capital Receipts", 
               "Capital Outlay", 
               "State Government Deficit" )
  
  # TODO: verify return values are non-null before using them in next function
  # specially for case of get_subset_data()
  for(i in subsets)
  {
    subset_name <- i
    subset_data <- get_subset_data(subset_name)
    clean_long_subset_data <- get_clean_long_subset_data(subset_data)
    subset_analysis <- getAnalysis(clean_long_subset_data, subset_name)
    if(is.null(results_temp))
    {
      results_temp <- c(subset_analysis)
      
    }
    else
    {
      results_temp <- c(results_temp, subset_analysis)
    }
    
    summary <- subset_analysis[[1]]
    plot <- subset_analysis[[2]]
    plot_file <- paste("./output/", i, ".png", sep="")
    
    ggexport(plot, filename = plot_file)
  }
  assign("analysis_all", results_temp, envir = .GlobalEnv)
}
