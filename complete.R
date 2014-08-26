readfile <- function(id) {
        ## 'id' is an integer indicating the monitor ID number
        ext <- ".csv"
        filename <- paste(formatC(id, width=3, flag="0"), ext, sep="")
        # show(filename)
        read.csv(filename)
}

numnobs <- function(id) {
        ## 'pollutant' is a character vector of length 1 indicating
        ## the name of the pollutant for which we will calculate the
        ## mean; either "sulfate" or "nitrate".

        ## 'id' is an integer indicating the monitor ID number
        all <- readfile(id)
        sum(complete.cases(all))
}

complete <- function(directory, id = 1:332) {
        ## 'directory' is a character vector of length 1 indicating
        ## the location of the CSV files

        ## 'id' is an integer vector indicating the monitor ID numbers
        ## to be used
        
        ## Return a data frame of the form:
        ## id nobs
        ## 1  117
        ## 2  1041
        ## ...
        ## where 'id' is the monitor ID number and 'nobs' is the
        ## number of complete cases
        currentDir <- getwd()
        setwd(directory)

        nobs <- numeric(length(id))
        for (i in id) {
                index <- which(id == i)
                nobs[index] <- numnobs(i)
        }

        setwd(currentDir)
        data.frame(id, nobs, stringsAsFactors=FALSE)
}