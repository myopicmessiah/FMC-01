# Global Assignment, store all the filtered data and analysis results here.
assign("filtered_data", NULL, envir=.GlobalEnv)
assign("analysis_all", NULL, envir=.GlobalEnv)


# Global Assignment, hard-coded list of column indices, scale of $-values.
# Temporary, inefficient, hard-to-manage. Has columns that are redundant.
# TODO: Improve; store these externally? or populate dynamically by context?
# TODO: Read txt file with indices of relevant columns, subset table names, etc.
assign("COLS_TO_KEEP", 
       c(1,2,3,5,6,7,18:32, 46, 47, 51, 55, 56, 60, 65, 72, 73, 74),
       envir = .GlobalEnv)
assign("STATE_GOVERNMENT_RECEIPTS", c(1,29:31), envir = .GlobalEnv)
# assign("STATE_GOVERNMENT_EXPENDITURE", c(1,28:30), envir=.GlobalEnv)
assign("CAPITAL_RECEIPTS", c(1,5,6,7,18), envir=.GlobalEnv)
assign("CAPITAL_OUTLAY", c(1:3), envir=.GlobalEnv)
assign("STATE_GOVERNMENT_DEFICIT", c(1,25, 26), envir=.GlobalEnv)
assign("scale", 1000000, envir = .GlobalEnv) # Values are stored in Millions
assign("subset_names", c("State Government Receipts", 
                         "State Government Expenditure", 
                         "Capital Receipts", 
                         "Capital Outlay", 
                         "State Government Deficit" ), 
       envir=.GlobalEnv)
