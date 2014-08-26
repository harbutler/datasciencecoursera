pollutantvals <- function(pollutant, id) {
        ## 'pollutant' is a character vector of length 1 indicating
        ## the name of the pollutant for which we will calculate the
        ## mean; either "sulfate" or "nitrate".

        ## 'id' is an integer indicating the monitor ID number
        ext <- ".csv"
        filename <- paste(formatC(id, width=3, flag="0"), ext, sep="")
        all <- read.csv(filename)
        vals <- all[,pollutant]
        vals[!is.na(vals)]
}

pollutantmean <- function(directory, pollutant, id = 1:332) {
        ## 'directory' is a character vector of length 1 indicating
        ## the location of the CSV files

        ## 'pollutant' is a character vector of length 1 indicating
        ## the name of the pollutant for which we will calculate the
        ## mean; either "sulfate" or "nitrate".

        ## 'id' is an integer vector indicating the monitor ID numbers
        ## to be used

        ## Return the mean of the pollutant across all monitors list
        ## in the 'id' vector (ignoring NA values)

        currentDir <- getwd()
        setwd(directory)
        values <- numeric()
        for (i in id) {
        	values <- c(values, pollutantvals(pollutant, i))
        }
        setwd(currentDir)
        mean(values)
}