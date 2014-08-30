# Copyright statement: no copyright
# Author: Nick John (nick.john@computer.org)
# File description:
# 	Functions for assignment 3 in the "R Programming" coursera course.

best <- function(state, outcome) {
	# Reads the outcome-of-care-measures.csv ﬁle and returns a character vector
	#  with the name of the hospital that has the best (i.e. lowest) 30-day
	#  mortality for the speciﬁed outcome in that state.
	# The hospital name is the name provided in the Hospital.Name variable.
	# Hospitals that do not have data on a particular outcome are excluded from
	#  the set of hospitals when deciding the rankings.
	#
	# Arguments: 
	#   state - the 2-character abbreviated name of a state
	#   outcome - an outcome name. Can be one of “heart attack”, “heart failure”
	#            or “pneumonia” 
	# Returns:
	#	a character vector with the name of the hospital that has the best
	#    (i.e. lowest) 30-day mortality for the speciﬁed outcome in the
	#    specified state

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
		stop(" Argument outcome must be one of 'heart attack', 'heart failure' or 'pneumonia'")
	}

	# read outcome data from file
	outcome.data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")

	# Check that state is valid
	states <- split(outcome.data, outcome.data$State)
	state.data <- states[[state]]
	if (is.null(state.data)) {
		stop(" Argument state is invalid or there is no data for that state")
	}

	# Return hospital name in that state with lowest 30-day death rate
	outcome.col <- outcomes[match(outcome, outcomes[,"arg.input"]),"col.name"]
	state.outcome <- as.numeric(state.data[[outcome.col]])
	state.min.index <- which.min(state.outcome)
	state.min.row <- state.data[state.min.index,]
	state.min.row$Hospital.Name
}

