library(ggplot2)
library(ggpubr)
library(reshape2)

source("libs/multifilereader.R")
source("libs/public_constants.R")

# This file (analyzer.R) is for...
# TODO: Write File Summary
# FLOW OF EVENTS:
# # -> READ: filereader::multi_delim_reader()
# # -> FILTER: filter_data()
# # -> WITHIN THE FILTERED DATA:
# # # -> GET A SUBSET: get_subset_data()
# # # -> CLEAN SUBSET: get_clean_long_subset_data()
# # # -> ANALYZE SUBSET: getAnalysis(.) (uses getPlot() & getSummary())
# # # -> REPEAT


# 1. 
# ad hoc function to filter data read in the consolidated data frame.
# also renames two columns with invalid names
# Stores the filtered data in a Global Variable 'filtered_data'
# NOTE: ad hoc, all hard-coded. created for manageability not re-usability.
# Args: dataframe, has column 'Year' (fmt: 1988-89) and other measure columns.
# Returns: Nothing.
filter_data <- function(consolidated_data)
{
  filtered_data <- subset(consolidated_data, select=COLS_TO_KEEP)
  colnames(filtered_data)[which(names(filtered_data)=="Rs..million")] <- 
    "Gross.Fiscal.Deficit"
  colnames(filtered_data)[which(names(filtered_data)=="Rs..million.1")] <- 
    "Gross.Revenue.Deficit"
  # Do more?
  assign("filtered_data", filtered_data, envir=.GlobalEnv)
}


# 2.1 Returns the dataframe with the subset of the data (by subset_name)
# TODO: Add Totals where missing.
# Args: subset_name: name of the subset for which the data has to be retrieved
# Returns: dataframe containing the cleaned data subset
get_subset_data <- function(subset_name)
{
  if(subset_name=="State Government Receipts") 
  {
    return(filtered_data[,STATE_GOVERNMENT_RECEIPTS])
  }
  else if (subset_name=="State Government Expenditure")
  {
    return(filtered_data[,STATE_GOVERNMENT_EXPENDITURE])
  }
  else if (subset_name=="State Government Deficit")
  {
    return(filtered_data[,STATE_GOVERNMENT_DEFICIT])
  }
  else if (subset_name=="Capital Outlay")
  {
    return(filtered_data[,CAPITAL_OUTLAY])
  }
  else if (subset_name=="Capital Receipts")
  {
    return(filtered_data[,CAPITAL_RECEIPTS])
  }

    return (NULL)
}


# # 2.2 
# Function to clean the data to be used. 
# Converts to numeric, numbers stored as strings (digits separated by comma).
# Creates additional column beginYr (Year = 1987-88 => beginYr = 1987)
# Standardizes column names, for use in ggplot legend
# 'Longify' the data (using reshape2::melt. 
# Uses a subset of the filtered data (not all columns) => Parallelize?
# TODO: Parallel execution of this function for all subsets?
# TODO: use different function to 'Longify'. write?)
# Args:  data frame. subset_data
# Returns: data frame. cleaned_data, longified.
get_clean_long_subset_data <- function(subset_data)
{
  # TODO: handle observations with NA (Currently throws warnings)
  # Either: set NAs to some average value (of all/ of previous & next)
  # Or: Delete observations across all variables for the year with an NA value
  for(a in 2:ncol(subset_data))
  {
    subset_data[,a] <- as.numeric(gsub(",","",subset_data[,a]))
  }
    
  subset_data <- subset_data %>%
    dplyr::mutate(beginYr=strtoi(substring(Year,1,4)))

  subset_data <- melt(subset_data[,-1], id.vars = "beginYr")
  
  subset_data$variable <- gsub("_",".",subset_data$variable)
  subset_data$variable <- gsub("\\."," ",subset_data$variable)
  
  return(subset_data)
}

# # # 2.3.1
# Takes the cleaned subset of data to return a dataframe object
# Summarizes all the different values factor-wise by various measures
# Also includes, linear regression fitted line with R2 value(s) & equation(s)
# Args: dataframe cleaned subset of data
# Args: boolean to use linear model 
# Returns: dataframe object
# getSummary <- function(cleaned_data, subset_name, useLinear=TRUE, useLogScale=TRUE)
getSummary <- function(clean_long_subset_data)
{
  data_summary <- clean_long_subset_data %>% 
    group_by(variable) %>% 
    summarise(n = n(), mean=mean(value), median=median(value), 
              sd=sd(value), min=min(value), max=max(value))
  return(data_summary)
}


# # # 2.3.2 
# Takes the cleaned subset of data and plot title to return a ggplot object
# Plots all the different values factor-wise as a scatter-plot
# Also includes, linear regression fitted line with R2 value(s) & equation(s)
# Args: dataframe cleaned subset of data
# Args: String Title for the Plot (Default: Plot Title)
# Args: boolean to use linear model 
# Returns: ggplot object
# TODO: Implement useLinear & useLogScale flag handling.
getPlot <- function(clean_long_subset_data, plot_title="Plot Title", useLinear=TRUE, 
                    useLogScale=TRUE)
{
  if(COLORED_PLOTS)
  {
    plot <- ggplot(data=clean_long_subset_data, mapping = 
                     aes(x=beginYr, y=log(value*CURRENCY_SCALE), col=variable,
                         shape=variable))
  }
  else
  {
    plot <- ggplot(data=clean_long_subset_data, mapping = 
                     aes(x=beginYr, y=log(value*CURRENCY_SCALE), shape=variable))
  }
  
  # Adding data points, trend line.
  plot <- plot + geom_point(size=2) +
    scale_y_continuous(name = "Natural Log (Absolute Rupee Amount)", 
                       n.breaks = 10) +
    scale_x_continuous(name = "Year", n.breaks = 10)
    

  if(COLORED_PLOTS)
  {
    plot <- plot + geom_smooth(method='lm')
  }
  else
  {
    plot <- plot + geom_smooth(method='lm', color="black")
  }
  
  # Adding Equations, R2
  # TODO: Dynamically set location of equations/R2
  # TODO: Set Labels for equations/R2 (needed for B/W plots)
  plot <- plot + 
    stat_cor(aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~")),
             label.x.npc = 0, label.y.npc = 1) + 
    stat_regline_equation(label.x.npc = 0, label.y.npc=0.75, 
                          show.legend = FALSE) +
    
    # Setting Labels/Titles/Theme etc.
    ggtitle(plot_title) 
    
  if(!COLORED_PLOTS)
  {
    plot <- plot + theme_bw()
  }
  
  plot <- plot +
    # theme(plot.title = element_text(hjust = 0.5, vjust=-8), #hjust:%, vjust:abs
    theme(plot.title = element_text(hjust = 0.5, face = "bold", size = rel(1.8)),
          axis.title = element_text(face = "bold", size = rel(1.5)),
          # axis.
          legend.position = "bottom",
          legend.title = element_blank()) #Remove Legend Title

  return(plot)
}


# 2.3
# Analyzes and Summarizes a particular subset of the time-series data
# Note: Requires cleaned data (using clean_data(.)) to be passed
# Args: subset_name
# Args: useLinear: use a linear model (versus). Default: TRUE
# Args: useLogScale: transform the raw values using natural log. Default: TRUE

getAnalysis <- function(clean_long_subset_data, subset_name, 
                        useLinear=TRUE, useLogScale=TRUE)
{
  # analysis <- new(list())
  # summary <- getSummary(cleaned_data, subset_name, useLinear, useLogScale)
  summary <- getSummary(clean_long_subset_data)
  plot <- getPlot(clean_long_subset_data, subset_name, useLinear, useLogScale)
  if(PRINT_FLAG){
    printSEP(PRINT_FLAG)
    mess <- paste(COUNTER, ": Finished Summarizing  Data for:", subset_name)
    printMSG(mess, PRINT_FLAG)
    mess <- paste(COUNTER, ": Finished Plotting the Data for:", subset_name)
    printMSG(mess, PRINT_FLAG)
    # printSEP(PRINT_FLAG)
  }
  # return (c(summary,plot))
  return(list(subset_name, summary, plot))
}