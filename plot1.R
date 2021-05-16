library(dplyr)

# Downloading the Dataset
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

fileName <- "Emission_Data.zip"

if(!file.exists(fileName)) {
  download.file(fileUrl, destfile = fileName, method = "curl")
}

if(!file.exists("summarySCC_PM25.rds") & !file.exists("Source_Classification_Code.rds")) {
  unzip(fileName)
}

# Loading the Data into R
NEI <- readRDS("summarySCC_PM25.rds")

# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
totalEmission <- NEI %>% group_by(year) %>%
  summarise(Total.Emission = sum(Emissions))

png("plot1.png", width = 720, height = 720)
with(totalEmission, plot(year, Total.Emission, pch = 19, lwd = 4, xlab = "Year",
                         ylab = "Total Emission",
                         main = "Year Wise Trend of Total Emission"))
dev.off()

