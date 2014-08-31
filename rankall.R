# Copyright statement: no copyright
# Author: Nick John (nick.john@computer.org)
# File description:
# 	Functions for assignment 3 in the "R Programming" coursera course.

rankhospital <- function(state.data, outcome, num) {
	# Validate outcome argument
	outcomes <- matrix(
		c("heart attack", "heart failure", "pneumonia",
			"Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack",
			"Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure",
			"Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"),
		nrow = 3,
		ncol = 2,
		dimnames = list(c(), c("arg.input", "col.name")))
  	if (!is.character(outcome)) {
		stop(" outcome argument must be character (string).")
	}
	if (!(outcome %in% outcomes[,"arg.input"])) {
		stop("invalid outcome")
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

	# The name of the hospital with that rank
	outcome.data.sorted[rank,"Name"]

}


rankall <- function(outcome, num = "best") {
	# Reads the outcome-of-care-measures.csv ﬁle and returns a 2-column data frame
	#  containing the hospital in each state that has the ranking speciﬁed in num.
	# For example the function call rankall("heart attack", "best") would return a
	#  data frame containing the names of the hospitals that are the best in their
	#  respective states for 30-day heart attack death rates.
	# Returns a value for every state (some may be NA).
	# The ﬁrst column in the data frame is named hospital, which contains the
	#  hospital name, and the second column is named state, which contains the
	#  2-character abbreviation for the state name. Hospitals that do not have
	#  data on a particular outcome are excluded from the set of hospitals when
	#  deciding the rankings.
	#
	# Arguments: 
	#   outcome - an outcome name. Can be one of “heart attack”, “heart failure”
	#            or “pneumonia” 
	#   num - the ranking of a hospital in that state for that outcome. Can
	#       take values "best", "worst", or an integer indicating the ranking
	#       (smaller numbers are better).
	# Returns:
	# 	A 2-column data frame containing the hospital in each state that has
	#   the ranking speciﬁed in num.


	# read outcome data from file
	outcome.data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")

	# Get the data for each state
	states.data <- split(outcome.data, outcome.data$State)

	# Get the hospital ranking for each state
	hospitals <- lapply(states.data, rankhospital, outcome, num)

	# Convert to a data frame
	data.frame(hospital = unlist(hospitals), state = names(hospitals), stringsAsFactors = FALSE)
}
