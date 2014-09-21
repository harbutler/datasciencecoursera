if (!file.exists("data")) {
	dir.create("data")
}
fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl, destfile = ".\\data\\cameras.csv", method="internal")
list.files("data")

dateDownloaded <- date()
str(dateDownloaded)


# Exactly the same as cameraData <- read.csv(".\\data\\cameras.csv")
cameraData <- read.table(".\\data\\cameras.csv", sep=",", header = TRUE)

#Quiz - question 1
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, destfile = ".\\data\\acsMicrodataSurvey2006.csv", method="internal")
dateDownloaded <- date()
str(dateDownloaded)
list.files("data")

data <- read.csv("data\\acsMicrodataSurvey2006.csv")
propertyValues <- data$VAL
bad <- is.na(propertyValues)
propertyValues.clean <- propertyValues[!bad]
# Number of houses worth over a million
sum(propertyValues.clean == 24)

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
download.file(fileUrl, destfile = ".\\data\\naturalGasAcquisitionProgram.xlsx", method="internal")
dateDownloaded <- date()

library(xlsx)
colIndex <- 7:15
rowIndex <- 18:23
dat <- read.xlsx("data\\getdata-data-DATA.gov_NGAP.xlsx",
	sheetIndex = 1, colIndex = colIndex, rowIndex = rowIndex)

 sum(dat$Zip*dat$Ext,na.rm=T) 

#Question 4
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
library(XML)
doc <- xmlTreeParse(fileUrl, useInternal=TRUE)
doc <- xmlTreeParse("data\\getdata-data-restaurants.xml", useInternalNodes = TRUE)
rootNode <- xmlRoot(doc)
zipcodes <- xpathSApply(rootNode[[1]], "//zipcode", xmlValue)
sum(as.numeric(zipcodes) == 21231)

# Question 5
library(data.table)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileUrl, destfile = ".\\data\\acsMicrodataSurvey2006.csv", method="internal")
dateDownloaded <- date()
str(dateDownloaded)
list.files("data")
DT <- fread("data\\acsMicrodataSurvey2006.csv")

system.time({mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)})
system.time(mean(DT$pwgtp15,by=DT$SEX))
system.time(tapply(DT$pwgtp15,DT$SEX,mean))
system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))
system.time(DT[,mean(pwgtp15),by=SEX])
system.time(rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]))