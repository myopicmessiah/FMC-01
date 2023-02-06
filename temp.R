txt_connect <- file("./output/consolidated-colnames.txt")
writeLines(colnames(consolidated_data))
close(txt_connect)

a <- colnames(consolidated_data)

val <- paste(`#`, "Column Name", sep = "> ")
y <- c(val)
for(i in 1:length(a))
{
  val <- paste(i, a[i], sep = "> ")
  y <- c(y, val)  
}
writeLines(y, "out.txt")
temp <- function(analysis_all)
{
  library(stargazer)
  i <- 1
  # for(i in 1:length(analysis_all))
  while(i<=length(analysis_all))
  {
    subset_name <- analysis_all[[i]]
    table_name <- paste("Table ", ((i+2)/3), ": ", subset_name, sep = "")
    i <- i+1
    
    subset_summary <- analysis_all[[i]]
    i <- i+1
    
    subset_plot <- analysis_all[[i]]
    i <- i+1
    
    # subset_summary[-1] <- round(na.omit(subset_summary[-1]),2)
    subset_summary[-1] <- round(subset_summary[-1],2)
    stargazer(subset_summary, type="text", summary=FALSE, rownames=FALSE, 
              title = table_name)
  }
}

temp(analysis_all)


library(dplyr)
list_of_file <- list.files(path=".", pattern=".xls", all.files=TRUE, full.names=TRUE)  
i <- list_of_file[1]
unlist(gregexpr("Rev",i))
suffix <- substring(i,3,unlist(gregexpr("Rev", i))-2)
suffix
cn <- 'Total'
paste(cn,suffix, sep="_")

skiplines <- 2
i <- "State_Government_Expenditure_Revised_Estimates_Karnataka_Apr_70_Rs_million_1986_87_to_2021_22.xls"
inFile <- read.delim(i, skip = skiplines)
head(inFile)
inFile <- inFile %>% na.omit()
head(inFile)
if(inFile[1,1]=="")
{
  inFile <- inFile[-1,]
  print("NAY")
} else
{
  print("YAY")
}
inFile[1,1]

cleaned_data
class(cleaned_data$value)
for(x in cleaned_data$value)
  print(c(class(x), x))

mean(cleaned_data$value)

t <- cleaned_data %>% 
  group_by(variable) %>% 
  summarise(n = n(), mean=mean(value), median=median(value), 
            sd=sd(value), min=min(value), max=max(value)) 
View(t)  


subset_name = SUBSET_NAMES[2]
d1 <- get_clean_long_subset_data(get_subset_data(subset_name))



library(stargazer)
summ <- analysis_all[[2]]
summ[-1] <- round(summ[-1],2)
summ <- (round(analysis_all[[2]]$mean,1))
stargazer(summ, type="text", summary=FALSE, rownames=FALSE, title = )
