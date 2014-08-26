# creates a special "vector", which is really a list containing a function to
# 1. set the value of the vector
# 2. get the value of the vector
# 3. set the value of the mean
# 4. get the value of the mean
# NOTE: The <<- operator in the set function.
makeVector <- function(x = numeric()) {
        m <- NULL
        set <- function(y) {
                x <<- y
                m <<- NULL
        }
        get <- function() x
        setmean <- function(mean) m <<- mean
        getmean <- function() m
        list(set = set, get = get,
             setmean = setmean,
             getmean = getmean)
}

# Calculates the mean of the special "vector" created with the makeVector
#  function. However, it first checks to see if the mean has already been
#  calculated. If so, it gets the mean from the cache and skips the computation. Otherwise, it calculates the mean of the data and sets the value of the mean in the cache via the setmean function.
cachemean <- function(x, ...) {
        m <- x$getmean()
        if(!is.null(m)) {
                message("getting cached data")
                return(m)
        }
        data <- x$get()
        m <- mean(data, ...)
        x$setmean(m)
        m
}

