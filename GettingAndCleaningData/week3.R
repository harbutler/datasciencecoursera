set.seed(13435)
X <- data.frame("var1"=sample(1:5), "var2"=sample(6:10), "var3"=sample(11:15))

# Randomly sort
X <- X[sample(1:5),]

# Make a couple of entries NA
X$var2[c(1,3)] = NA

# First col
X[,1]

# By name
X[,"var1"]


# First two rows of second col
X[1:2,"var2"]

# Rows where 1st col is less than 3 and third col is greater than 11.
X[(X$var1 <= 3) & (X$var3 > 11),]


# Rows where 2nd col is greater than 8....includes NAs
X[X$var2 > 8,]

# Rows where 2nd col is greater than 8....excludes NAs
X[which(X$var2 > 8),]


# Can sort lists
sort(X$var2)

# Include NAs but put them at the end
sort(X$var2, na.last=TRUE)


# Sort a data frame by a 1st col
X[order(X$var1),]

# sort by 1st col and then 3rd col
X[order(X$var1, X$var3),]

# Order using the plyr library
library(plyr)
arrange(X,var1)

# Arrange by descreasing order
arrange(X,desc(var1))

# Add a col to data frame
X$var4 <- rnorm(5)

# Another way is using cbind
Y <- cbind(X, rnorm(5))

# Add col at the start
Y <- cbind(rnorm(5), X)

# rbind does equiv for rows

if (!file.exists(".\\data")) { dir.create(".\\data")}
fileUrl <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl, destfile=".\\data\\Restaurants.csv")
restData <- read.csv(".\\data\\Restaurants.csv")



# Question 3
setwd("\\Users\\nick\\git\\dst\\GettingAndCleaningData")
fedstats <- read.csv("data\\getdata-data-EDSTATS_Country.CSV")
gdp.raw <- read.csv("data\\getdata-data-GDP.csv", skip=5, nrows=231, header=FALSE, col.names=c("Code","Ranking","c","Economy","GDP","f","g","h","i","j"))
gdp.cols <- gdp[,c("Code", "Ranking", "Economy", "GDP")]
# Remove rows with no ranking
gdp.rankings <- gdp.cols[!is.na(gdp.cols$Ranking), ]
# Sort by descending rank
gdp.clean <- gdp.rankings[order(gdp.rankings$Ranking, decreasing=TRUE), ]
# Row 13
gdp.clean[13,]


