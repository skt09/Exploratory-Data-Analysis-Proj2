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

# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
Emission.Data.Veh <- subset(NEI, fips == "24510")
SCCsub <- SCC[grepl("vehicle", SCC$EI.Sector, ignore.case = TRUE),]
Emission.Data.Veh <- subset(Emission.Data.Veh, Emission.Data.Veh$SCC %in% SCCsub$SCC)

Emission.Data.Veh <- merge(Emission.Data.Veh, SCCsub, by = "SCC")

totalEmission <- Emission.Data.Veh %>% group_by(year) %>%
  summarise(Total.Emission = sum(Emissions))

png("plot5.png", width = 480, height = 480)
g <- ggplot(totalEmission, aes(year, Total.Emission))
g <- g + geom_point(color = "yellow", size = 4)
g <- g + ggtitle("Emission trend due to Vehicles")
plot(g)
dev.off()
