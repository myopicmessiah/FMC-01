rm(list=ls())
shell("cls")

options(warn = 0) #Useful for debugging, prints messages as they occur. 

source("./libs/analyzer.R")

main <- function()
{
  shell("cls")
  results_temp <- NULL
  consolidated_data <- multi_delim_reader(filepath = "rawdata", 
                                          printFlag = PRINT_FLAG)
  filter_data(consolidated_data)
  rm(consolidated_data)
  

  # TODO: verify return values are non-null before using them in next function
  # specially for case of get_subset_data()
  
  printMSG("",PRINT_FLAG)
  printSEP(PRINT_FLAG)
  printMSG("BEGIN ANALYZING SUBSETS", PRINT_FLAG)
  printSEP(PRINT_FLAG)
  
  
  for(i in 1:length(SUBSET_NAMES))
  {
    assign("COUNTER", i, envir = .GlobalEnv)
    
    subset_name <- SUBSET_NAMES[i]
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
    
  }
  
  printSEP(PRINT_FLAG)
  printMSG(
    paste("FINISHED ANALYZING SUBSETS. PLOT/SUMMARY PAIRS CREATED:", COUNTER), 
    PRINT_FLAG)
  printSEP(PRINT_FLAG)
  
  assign("analysis_all", results_temp, envir = .GlobalEnv)
  assign("COUNTER", 1, envir = .GlobalEnv)
  
  printSEP(PRINT_FLAG)
  printMSG("PRINTING RESULTS TO FILES", PRINT_FLAG)
  printSEP(PRINT_FLAG)
  
  print_analysis(analysis_all)

  printMSG("PRINTED RESULTS TO FILES", PRINT_FLAG)
  printSEP(PRINT_FLAG)
}

# Prints the results of the analyses (tables & plots) to external files.
# TODO: Write Analysis Results to PDF (1 summary & 1 Plot per page)
# TODO: Move to analyzer.R?
print_analysis <- function(analysis_all)
{
  library(stargazer)
  i <- 1
  # for(i in 1:length(analysis_all))
  # pdf(file="results.pdf")
  while(i<length(analysis_all))
  {
    subset_name <- analysis_all[[i]]
    table_name <- paste("Table ", ((i+2)/3), ": ", subset_name, sep = "")
    i <- i+1

    subset_summary <- analysis_all[[i]]
    i <- i+1
    
    subset_plot <- analysis_all[[i]]
    i <- i+1
    
    plot_file <- paste("./output/", subset_name, ".pdf", sep="")
    ggexport(subset_plot, filename = plot_file)
    printMSG(paste("Saved Plot:", plot_file), PRINT_FLAG)
    
    # subset_summary[-1] <- round(na.omit(subset_summary[-1]),2)
    sum_file <- paste("./output/", subset_name, ".txt", sep="")
    subset_summary[-1] <- round(subset_summary[-1],2)
    stargazer(subset_summary, type="text", summary=FALSE, rownames=FALSE, 
              title = table_name, notes = TABLE_NOTE, align = TRUE, digits = 2,
              out=sum_file)
    printMSG(paste("Saved Summary:", sum_file), PRINT_FLAG)
  }
  # dev.off()
}

# Deprecated
# main_old <- function()
# {
#   consolidated_data <- multi_delim_reader(filepath = "./rawdata/", 
#                                           printFlag = PRINT_FLAG)
#   filtered_data <- filter_data(consolidated_data)
#   rm(consolidated_data)
#   
#   subset_name <- "State Government Receipts"
#   subset_data <- filtered_data[,STATE_GOVERNMENT_RECEIPTS]
#   cleaned_data <- get_clean_long_subset_data(subset_data)
#   plot <- getPlot(cleaned_data, subset_name)
#   plot
# }
