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
