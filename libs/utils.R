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