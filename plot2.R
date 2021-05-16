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

#Have total emissions from PM2.5 decreased in the Baltimore City, 
#Maryland (fips == "24510") from 1999 toto 2008?
totalEmission <- NEI %>% subset(fips == "24510") %>%
  group_by(year) %>% summarise(Total.Emission = sum(Emissions))

png("plot2.png", width = 720, height = 720)
with(totalEmission, plot(year, Total.Emission, pch = 8, xlab = "Year",
                         ylab = "Total Emission", col = "red",
                         main = "Year Wise Trend of Total Emission in Baltimore, Maryland"))
dev.off()




