library(plyr)
library(rvest)
library(dplyr)

#set directory:
setwd("~/R/USA Inmigration")

#load url from the USA Homeland Security website:

url <- 'https://www.dhs.gov/immigration-statistics/yearbook/2017/table28'

usa <- read_html(url)

#select html tables:
tables <- html_nodes(usa, "table")

inmigration <- usa %>%
  html_nodes("table") %>%
  .[2] %>%
  html_table(fill = TRUE)

#save as data frame:
df <- ldply (inmigration, data.frame)

#clean data:
df <- df[2:197,]

df[df=="X"] <- 0

colnames(df) <- c("country", "total", "tourists_waiver", "tourists_other", "students", 
                  "temp_workers", "diplomats", "other", "unknown")

df$tourists_waiver <-gsub( ',', '', df$tourists_waiver)
df$tourists_waiver <- as.numeric(as.character(df$tourists_waiver))


df$tourists_other <-gsub( ',', '', df$tourists_other)
df$tourists_other[df$tourists_other=="D"] <- 0
df$tourists_other <- as.numeric(as.character(df$tourists_other))

#compute total number of tourists:
df$tourists <- df$tourists_waiver + df$tourists_other

#create final data frame with tourist arrivals and country of citizenship:
tourists <- df%>%select(country, tourists)
tourists$country <- gsub('[1234567890]', '', tourists$country)

#export as .csv file
write.csv(tourists, 'tourists.csv')

