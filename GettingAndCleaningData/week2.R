# Get MySQl working
# Had to download and install the MySQL Connector called "C (libmysqlclient)"
#  from here: 
#       http://dev.mysql.com/downloads/connector/
# Had to then copy the libmysql.dll and libmysql.lib from $MYSQL_HOME\lib to $MYSQL_HOME\bin

Sys.setenv(MYSQL_HOME = "C:/PROGRA~1/MySQL/MYSQLC~1.1")
#install.packages('RMySQL',type='source')
library('RMySQL')

ucscDb <- dbConnect(MySQL(), user="genome", host="genome-mysql.cse.ucsc.edu")
result <- dbGetQuery(ucscDb, "show databases;")
dbDisconnect(ucscDb)

hg19 <- dbConnect(MySQL(), user="genome", db="hg19", host="genome-mysql.cse.ucsc.edu")
allTables <- dbListTables(hg19)
length(allTables)
allTables[1:5]

# Fields (i.e. column names) in table affyU133Plus2
dbListFields(hg19, "affyU133Plus2")

# The number of rows in the table
dbGetQuery(hg19, "select count(*) from affyU133Plus2")

# Read the whole table
affyData <- dbReadTable(hg19, "affyU133Plus2")
head(affyData)

# Can batch up the gets
query <- dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches between 1 and 3")
affyMis <- fetch(query)
quantile(affyMis$misMatches)

# Just fetch 10 rows.
affyMisSmall <- fetch(query, n=10);
dim(affyMisSmall)

# Free up space on the server
# MUST DO after every dbSendQuery
dbClearResult(query)

# ALWAYS CLOSE THE CONNECTION
dbDisconnect(hg19)

# Install packages from Bioconductor (http://buiconductor.org) primary used for genomics
#  but also has good "big data" package
# See also rhdf5 tutorial here:
# http://www.bioconductor.org/packages/release/bioc/vignette/rhdf5/inst/doc/rhdf5.pdf
source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")
library(rhdf5)
# Returns a bool
created <- h5createFile("example.h5")
created

created <- h5createGroup("example.h5", "foo")
created <- h5createGroup("example.h5","baa")
created <- h5createGroup("example.h5", "foo/foobaa")
h5ls("example.h5")

# Write to groups
A = matrix(1:10, nr=5, nc=2)
h5write(A, "example.h5", "foo/A")
h5ls("example.h5")

B= array(seq(0.1, 2.0, by=0.1), dim=c(5,2,2))
attr(B, "scale") <- "litre"
h5write(B, "example.h5", "foo/foobaa/B")
h5ls("example.h5")

# Write a data set
df = data.frame(1L:5L, seq(0,1, length.out=5),
	c("ab", "cde", "fghi","a", "s"), stringsAsFactors = FALSE)
h5write(df, "example.h5", "df")
h5ls("example.h5")

# Reading data
readA = h5read("example.h5", "foo/A")
readB = h5read("example.h5", "foo/foobaa/B")
readdf = h5read("example.h5", "df")
readA

# Read and write in chunks
# I.e. write to first col in the first three rows.
h5write(c(12,13,14), "example.h5", "foo/A", index=list(1:3,1))
h4read("example.h5", "foo/A")

# Reading from the web...web scraping
theUrl <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
con <- url(theUrl)
rawHtml <- readLines(con)
# MUST CLOSE THE CONNECTION when use url()
close(con)
rawHtml

# Or use the httr package
library(httr)
htmlObj <- GET(theUrl)
rawHtml <- content(htmlObj, as="text")
parsedHtml <- htmlParse(rawHtml, asText=TRUE)
xpathSApply(parsedHtml, "//title", xmlValue)

# Basic Auth - 401
pg1 <- GET("http://httpbin.org/basic-auth/user/passwd")
pg1

# With username and password get a 200
pg2 <- GET("http://httpbin.org/basic-auth/user/passwd", authenticate("user", "passwd"))
pg2

# To keep session cookie use a "handle"
google = handle("http://google.com")
pg1 = GET(handle=google, path="/")
pg2 = GET(handle=google, path="search")


# QUIZ - Question 1
# Register an application with the Github API here https://github.com/settings/applications.

# Access the API to get information on your instructors repositories (hint:
#  this is the url you want "https://api.github.com/users/jtleek/repos"). Use
#  this data to find the time that the datasharing repo was created. What time
#  was it created?
# This tutorial may be useful (
	# https://github.com/hadley/httr/blob/master/demo/oauth2-github.r). You may
# also need to run the code in the base R package and not R studio.
#2014-03-05T16:11:46Z
#2013-11-07T13:25:07Z
#2013-08-28T18:18:50Z
#2012-06-20T18:39:06Z

# When registering
#    Use any URL you would like for the homepage URL (http://github.com is fine)
#    and http://localhost:1410 as the callback url

# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
library(httr)
endpoints <- oauth_endpoints("github")

# my app
myApp <- oauth_app(appname="myapp", key="de0eb060b5603406dfc7", secret="4cce495480f6b00e6eda9402fba3706608138f45")

# get oauth creds
install.packages("httpuv")
library(httpuv)
github_token <- oauth2.0_token(endpoints, myApp)

# Use creds to call API
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)

# Pick out the datasharing repo
isDataSharingRepo <- sapply(content(req), function(x) x$name == "datasharing")
dataSharingRepos <- content(req)[isDataSharingRepo]
dataSharingRepos[[1]]$created_at

# Question 2
# Load getdata-data-ss06pid.csv into a dataframe called Access
#Which of the following commands will select only the data for the probability weights pwgtp1 with ages less than 50?
#sqldf("select * from acs")
#sqldf("select pwgtp1 from acs where AGEP < 50")
#sqldf("select * from acs where AGEP < 50 and pwgtp1")
#sqldf("select * from acs where AGEP < 50")

install.packages("sqldf")
library(sqldf)
acs <- read.csv("getdata-data-ss06pid.csv")
sqldf("select * from acs")
sqldf("select pwgtp1 from acs where AGEP < 50")
sqldf("select * from acs where AGEP < 50 and pwgtp1")
sqldf("select * from acs where AGEP < 50")

#Question 4
#How many characters are in the 10th, 20th, 30th and 100th lines of HTML from this page: 
#
#  http://biostat.jhsph.edu/~jleek/contact.html 
#
#  (Hint: the nchar() function in R may be helpful)
theUrl <- "http://biostat.jhsph.edu/~jleek/contact.html"
con <- url(theUrl)
rawHtml <- readLines(con, n=101)
close(con)
numChars <- sapply(rawHtml, function(x) nchar(x))
numChars[c(10,20,30,100)]

# Question 5
#Read this data set into R and report the sum of the numbers in the fourth column. 
#
#https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for
#
# Original source of the data: http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for 
#
# (Hint this is a fixed width file format)
#28893.3
#36.5
#32426.7
#35824.9
#101.83
#222243.1

# Can't just do a read.table
#rawData <- read.table("getdata-wksst8110.for", skip=4)
data.raw <- readLines("getdata-wksst8110.for")
data.count <- length(data.raw)
data.striped <- data.raw[5:data.count]
data.spaced <- sapply(data.striped, function(x) gsub("-", " -", x))
data.frame <- sapply(data.spaced, function(x) strsplit(x, " +"))
df <- data.frame(t(sapply(data.frame,c)), stringsAsFactors=FALSE)
sum(as.numeric(df[,9]))