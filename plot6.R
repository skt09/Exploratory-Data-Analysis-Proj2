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

# Compare emissions from motor vehicle sources in Baltimore City with emissions 
# from motor vehicle sources in Los Angeles County, California (fips == "06037").
# Which city has seen greater changes over time in motor vehicle emissions?
NEIsub <- subset(NEI, fips == "24510" | fips == "06037")
SCCsub <- SCC[grepl("Vehicle", SCC$EI.Sector, ignore.case = TRUE), c(1, 4)]

NEIsub <-  subset(NEIsub, NEIsub$SCC %in% SCCsub$SCC)
NEIsub <- mutate(NEIsub, City = ifelse(fips == "24510", "Baltimore", "LA"))

Emission.Data <- merge(NEIsub, SCCsub, by = "SCC")

Emission.Data <- Emission.Data %>% group_by(City, year) %>%
  summarise(Total.Emission = sum(Emissions))

png("plot6.png", width = 480, height = 480)
g <- ggplot(Emission.Data, aes(year, Total.Emission, col = City))
g <- g + geom_point(size = 2)
g <- g + ggtitle("Comparision between Baltimore and LA with Vehicle Emission")
plot(g)
dev.off()

