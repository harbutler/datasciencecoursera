library(datasets)
data(iris)
?iris

#mean of Sepal.Length for species virginca
s <- split(iris, iris$Species)
mean(s$virginica$Sepal.Length)
lapply(s$virginica,mean, na.rm = TRUE)

#vector of the means of the variables 'Sepal.Length', 'Sepal.Width', 'Petal.Length', and 'Petal.Width'
apply(iris[,1:4], 2, mean)


library(datasets)
data(mtcars)
?mtcars

# average miles per gallon (mpg) by number of cylinders in the car (cyl)?
sapply(split(mtcars$mpg, mtcars$cyl), mean)

# average horsepower (hp) by number of cylinders in the car (cyl)?
avghp <- sapply(split(mtcars$hp, mtcars$cyl), mean)

# absolute difference between the average horsepower of 4-cylinder cars and the
# average horsepower of 8-cylinder cars?
avghp[["8"]] - avghp[["4"]]