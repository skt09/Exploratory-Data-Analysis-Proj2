library(dplyr)
library(ggplot2)

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

# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad)
# variable, which of these four sources have seen decreases in emissions from 1999–2008
# for Baltimore City?
totalEmission <- NEI %>% subset(fips == "24510") %>% group_by(year, type) %>%
  summarise(Total.Emission = sum(Emissions))

png("plot3.png", width = 720, height = 720)
g <- ggplot(totalEmission, aes(year, Total.Emission))
g <- g + geom_point(color = "red")
g <- g + facet_grid(.~type)
g <- g + ggtitle("Total Emission Trend for Four Types of Emission")

plot(g)
dev.off()





