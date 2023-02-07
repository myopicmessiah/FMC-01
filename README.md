# FMC-01

Instructions:
1. Set working directory to the root of the project (containing main.R). Not needed if opening FMC-01.rProj (RStudio Project)
2. Run main.R (initial assignments and main())
	a. Reads input files from folder named 'rawdata'
	b. Writes output files to folder named 'output', containing:
		i.	Text file with column names for all tables read (useful for defining relevant columns).
		ii. Plots for the tables analyzed (one PDF file per table).
		iii. Descriptive stats/summary for tables analyzed (one TXT file per table).
3. Useful defaults used in main.R:
	a. Set PRINT_FLAG = TRUE. To get status messages while execution.
	b. Set COLORED_PLOTS = FALSE. To get B/W plots in the output PDFs.
		
Packages Used (Install if not present):
1. library(ggplot2)
2. library(ggpubr)
3. library(reshape2)
4. library(readxl)
5. library(dplyr)
6. library(stargazer)
