library(readxl)
library(dplyr)

# Utility to print status/log messages on console
# Prints a separator to separate sections *********
# Call with $doPrint$=TRUE to print (default FALSE)
printSEP <- function(doPrint=FALSE)
{
  if(!doPrint) {
    return(NULL)
  }
  print("---------------------------------------------------------------------")
}

# Utility to print status/log messages on console
# Prints the message passed in $msg
# Call with $doPrint$=TRUE to print (default FALSE)
printMSG <- function(msg, doPrint=FALSE) 
{
  if(!doPrint) {
    return(NULL)
  }
  print(msg)
}


# Reads multiple time series files to return a single data frame
# All the files stored in a single (common) directory 
# Merges the files on the variable named Year
# Returns dataframe
# Default Settings (files downloaded from cmie website):
### File Extension: '.xls'
### File Type: delimited
### Lines to Skip (metadata): 2
### File Path: current working directory '.'
### Flag to print status messages: FALSE

multi_delim_reader <- function(filepath=".", extn=".xls", skiplines=2, 
                               printFlag=FALSE)
{
  printMSG("------------------------BEGIN READING FILES------------------------"
           , printFlag)
  list_of_files <- list.files(path=filepath, pattern=extn, all.files=TRUE,
                              full.names=TRUE)
  combined_data <- data.frame()
  
  for(a in 1:length(list_of_files))
  {
    i <- list_of_files[a]
    inFile <- read.delim(i, skip = skiplines)
    file_name <- substring(i, first=nchar(filepath)+2) #strip directory name
    msg <- paste(a, ": Read File named: ", file_name)
    printMSG(msg, printFlag)
    
    # Basic data cleaning, replace NA with missing
    # Remove the row below the header if it contains descriptive data/metadata
    # First row below the header for Year column should be non-blank
    # If column name is 'Total', add table name as suffix (merge conflicts)
    # inFile[is.na(inFile)] <- ""
    # inFile <- inFile %>% na.omit()
    if(inFile[1,1]=="")
    {
      inFile <- inFile[-1,]
    }
    if(colnames(inFile)[2]=='Total') {
      # NOTE: Presence of word "Revised" in filename is used to get table-name
      suffix <- substring(file_name,1,unlist(gregexpr("Revised", i))-2)
      colnames(inFile)[2] <- paste('Total', suffix, sep="_")
    }
    msg <- paste("*** Read File with dimensions: ", toString(dim(inFile)))
    printMSG(msg, printFlag)

    # Add the read dataframe to the consolidated dataframe
    if(dim(combined_data)[1]==0 & dim(combined_data)[2]==0){
      combined_data <- inFile
      msg <-paste("*** Created consolidated dataframe. Dimensions: "
                  , toString(dim(combined_data))) 
      printMSG(msg, printFlag)
    }else{
      combined_data = merge(x=combined_data, y=inFile, by='Year')
      msg <- paste("*** Merged to consolidated dataframe. Updated Dimensions: "
                   , toString(dim(combined_data)))
      printMSG(msg, printFlag)
    }
    printSEP(printFlag)
    # invisible(readline(prompt="Press [enter] to continue"))
    # View(inFile)
  }
  printMSG(paste("------------------------FINISHED READING FILES. READ", 
                 a, "FILES------------------------"), printFlag)
  return (combined_data)
}
