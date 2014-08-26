myfunction <- function() {
	x <- rnorm(100)
	mean(x)
}

second <- function(x) {
	x + rnorm(length(x))
}

# Assign x to 1.0
# x is actually a numeric vector with 1 value
x <- 5
print(x)
# Will output [1] 5 ... i.e. a vector with 1 value and the first element is value 5

# Assign x to 1
x <- 1L

# Assign x to vector of integers
x <- 4:10

x <- c(0.5, 0.6) # numeric
x <- c(TRUE, FALSE) # logical
x <- c(T, F) # logical
x <- c("a", "b", "c") # character
x <- 9:29 # integers
x <- c(1+0i, 2+4i) # complex

x <- vector("numeric", length = 10)

y <- c(1.7, "a") # coerced to character vector
y <- c()

#explicit coercion
x <- 0:6
class(x)
as.numeric(x)
as.logical(x)
as.character(x)

m <- matrix(nrow = 2, ncol = 3)
m
dim(m)
attributes(m)

# Matrix initialised col by col
m <- matrix(1:6, nrow=2, ncol=3)


m <- 1:10 # vector
dim(m) <- c(2,5) # convert to a matrix with 2 rows and 5 cols.

# Column binding 3 x 2
x <- 1:3
y <- 10:12
m <- cbind(x,y)
m
dim(m)
attributes(m)

# Row binding 2 x 3
m <- rbind(x,y)
m
dim(m)
attributes(m)

# Lists - note double brackets in dump
l <- list(1, "a", TRUE, 1 + 4i)
l

# Factors
x <- factor(c("yes", "no", "yes", "yes"))
x
# Frequency count
table(x)
# encoded as integers
unclass(x)

# Can test for NA
x <- c(1, 2, NA, 10, 3)
is.na(x)

# NaN is an NA
is.na(NaN)

 
 # Data frames
x <- data.frame(foo = 1:4, bar=c(T,F,F,F))
x
nrow(x)
ncol(x)

# name attributes
x <- 1:3
x
names(x)
names(x) <- c("a", "b", "c")
x
names(x)

# subsetting
x <- c("a", "b", "c", "d", "e", "f")
x[1]
x[2]
x[2:4]

# filter
x[x > "a"]

# apply
u <- x > "a"
u

# Use u to extract the elements from x!!!
x[u]

# partial matching
x <- list(aardvark = 1:5)
x$a
x[["a"]]
x[["a", exact=FALSE]]

# E.g. filter out bad values
x <- c(1, 2, NA, 4, NA, 5)
bad <- is.na(x)
x[!bad]
x[bad]

# dput and dget
y <- data.frame(a=1, b="a")
dput(y)
dput(y, file = "y.R")
new.y <- dget("y.R")
new.y

# Set all elements of this vector that are less than 6 to be 0
x <- c(3, 5, 1, 10, 12, 6)
x[x < 6] <- 0


# Average across the rows...i.e. the col dimension 2 
x <- matrix(rnorm(200), 20,10)
apply(x,2,mean)

# Calculate the 25th percentile and the 75th percentile across each row of a matrix
x <- matrix(rnorm(200), 20, 10)
apply(x, 1, quantile, probs = c(0.25, 0.75))

# tapply
x <- c(rnorm(10), 1:10, rnorm(10,1))
f <- gl(3,10)
split(x,f)
tapply(x,f, mean)
tapply(x,f, range)
lapply(split(x,f), mean)


# airquality$Month is coerced to a factor by split
all <- read.csv("hw1_data.csv")
head(all)
s <- split(airquality, airquality$Month)
# Get a list
lapply(s, function(x) colMeans(x[, c("Ozone", "Solar.R", "Wind")]))
# Get a matrix
sapply(s, function(x) colMeans(x[, c("Ozone", "Solar.R", "Wind")]))
# Can't mean if there are NAs so can pass the na.rm arg to colMeans
sapply(s, function(x) colMeans(x[, c("Ozone", "Solar.R", "Wind")], na.rm = TRUE))
