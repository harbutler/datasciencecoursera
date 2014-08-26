
# One
cube <- function(x, n) {
        x^3
}
cube(3)
# What do you get? - Lazy evaluation...n is not used so not evaluated so no error.  

# Two
x <- 1:10
if(x > 5) {
        x <- 0
}
# Why get warning?

# Three
f <- function(x) {
        g <- function(y) {
                y + z
        }
        z <- 4
        x + g(x)
}
z <- 10
f(3)
# What is the result?  (Lexical scoping)

#Four
x <- 5
y <- if(x < 3) {
        NA
} else {
        10
}
# What is the value of y?

# Five
h <- function(x, y = NULL, d = 3L) {
        z <- cbind(x, d)
        if(!is.null(y))
                z <- z + y
        else
                z <- z + f
        g <- x + y / z
        if(d == 3L)
                return(g)
        g <- g + 10
        g
}
# Which symbol in the above function is a "free variable"?

