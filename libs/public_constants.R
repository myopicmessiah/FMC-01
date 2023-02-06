# This file stores all the constants that are used throughout the program
# Can replace this with a function that reads constants from an external file

# Global Assignment, store all the filtered data and analysis results here.
assign("filtered_data", NULL, envir=.GlobalEnv)
assign("analysis_all", NULL, envir=.GlobalEnv)
assign("TABLE_NOTE", "Note: Values given in Millions of Rupees.")


# Global Assignment, hard-coded list of column indices, scale of $-values.
# Temporary, inefficient, hard-to-manage. Has columns that are redundant.
# TODO: Improve; store these externally? or populate dynamically by context?
# TODO: Read txt file with indices of relevant columns, subset table names, etc.
assign("COLS_TO_KEEP", 
       c(1,2,3,5,6,7,18:32, 46, 47, 51, 55, 56, 60, 65, 72, 73, 74),
       envir = .GlobalEnv)
assign("STATE_GOVERNMENT_RECEIPTS", c(1,29:31), envir = .GlobalEnv)
# assign("STATE_GOVERNMENT_EXPENDITURE", c(1,28:30), envir=.GlobalEnv)
assign("CAPITAL_RECEIPTS", c(1,4,5,6,7), envir=.GlobalEnv)
assign("CAPITAL_OUTLAY", c(1:3), envir=.GlobalEnv)
assign("STATE_GOVERNMENT_DEFICIT", c(1,25, 26), envir=.GlobalEnv)
assign("CURRENCY_SCALE", 1000000, envir = .GlobalEnv) # Values are stored in Millions
assign("SUBSET_NAMES", c("State Government Receipts", 
                         # "State Government Expenditure", 
                         "Capital Receipts", 
                         "Capital Outlay", 
                         "State Government Deficit" ), 
       envir=.GlobalEnv)
assign("COUNTER", 1, envir = .GlobalEnv)
