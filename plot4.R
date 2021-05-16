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
SCC <- readRDS("Source_Classification_Code.rds")

# Across the United States, how have emissions from coal combustion-related sources 
# changed from 1999–2008?
Coal.Comb.List <- SCC[grepl("coal", SCC$EI.Sector, ignore.case = TRUE),]
Emission.Data <- subset(NEI, NEI$SCC %in% Coal.Comb.List$SCC)
totalEmission <- merge(Emission.Data, Coal.Comb.List, by = "SCC") %>%
  group_by(year) %>% summarise(Total.Emission = sum(Emissions))

png("plot4.png", width = 720, height = 720)
g <- ggplot(totalEmission, aes(year, Total.Emission))
g <- g + geom_point(color = "green", size = 6)
g <- g + ggtitle("Emission trend due to Coal Combustion")

plot(g)
dev.off()




