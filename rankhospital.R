# Copyright statement: no copyright
# Author: Nick John (nick.john@computer.org)
# File description:
# 	Functions for assignment 3 in the "R Programming" coursera course.

rankhospital <- function(state, outcome, num = "best") {
	# Reads the outcome-of-care-measures.csv ﬁle and returns a character vector
	#  with the name of the hospital that has the ranking specified by the num
	#  argument.
	# For example the call
	#    rankhospital("MD", "heart failure", 5)
	#  would return a character vector containing the name of the hospital with
	#  the 5th lowest 30-day death rate for heart failure.
	# Hospitals that do not have data on the specified outcome are ignored.
	#
	# Arguments: 
	#   state - the 2-character abbreviated name of a state
	#   outcome - an outcome name. Can be one of “heart attack”, “heart failure”
	#            or “pneumonia” 
	#   num - the ranking of a hospital in that state for that outcome. Can
	#       take values "best", "worst", or an integer indicating the ranking
	#       (smaller numbers are better).
	# Returns:
	#	a character vector with the name of the hospital that has the ranking
	#   specified by the num argument. If the number given by num is larger than
	#   the number of hospitals in that state then will return NA.


	# Validate arguments
  	if (is.na(state) || is.na(outcome)) {
		stop(" Arguments state and outcome must not have missing values.")
	}
  	if (!is.character(state) || nchar(state) != 2) {
		stop(" state argument must be a 2 character string.")
	}
  	if (!is.character(outcome)) {
		stop(" outcome argument must be character (string).")
	}
	outcomes <- matrix(
		c("heart attack", "heart failure", "pneumonia",
			"Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack",
			"Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure",
			"Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"),
		nrow = 3,
		ncol = 2,
		dimnames = list(c(), c("arg.input", "col.name")))
	if (!(outcome %in% outcomes[,"arg.input"])) {
		stop("invalid outcome")
	}
	if (!(outcome %in% outcomes[,"arg.input"])) {
		stop("invalid outcome")
	}

	# read outcome data from file
	outcome.data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")

	# Check that state is valid
	states <- split(outcome.data, outcome.data$State)
	state.data <- states[[state]]
	if (is.null(state.data)) {
		stop("invalid state")
	}

	# Column name for specified outcome
	outcome.col <- outcomes[match(outcome, outcomes[,"arg.input"]),"col.name"]

	# Outcome and hospital name
	outcome.data.raw <- state.data[c("Hospital.Name", outcome.col)]

	# Convert to numeric values
	outcome.data.raw[,outcome.col] <- sapply(outcome.data.raw[, outcome.col], as.numeric)

	# Ignore NAs
 	outcome.data.clean <- outcome.data.raw[complete.cases(outcome.data.raw),]

 	# Change column names
 	colnames(outcome.data.clean) <- c("Name","Outcome")

 	# Sort by outcome and then by Name
	outcome.data.sorted <- outcome.data.clean[with(outcome.data.clean,order(Outcome,Name)),]

	# Which rank
	if (num == "best") {
		rank <- 1
	}
	else if (num == "worst") {
		rank <- nrow(outcome.data.sorted)
	}
	else if (is.numeric(num)) {
		rank <- as.integer(num)
		if (is.na(rank)) {
			stop("invalid num")
		}
	}
	else {
		stop("invalid num")
	}

	outcome.data.sorted[rank,"Name"]
}
