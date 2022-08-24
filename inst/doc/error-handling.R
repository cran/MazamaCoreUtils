## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----stopOnError--------------------------------------------------------------
library(MazamaCoreUtils)
logger.setup()
logger.setLevel(TRACE) # force logs to be printed to the console

# Arbitrarily deep in the stack we might have:
myFunc <- function(x) {
  return(log(x))
}

# ----- Example 1:  good user input --------------------------------------------
try({
  
  userInput <- 10
  logger.trace("class(userInput) = %s", class(userInput))
  
  try({
    myFunc(x = userInput)
  }, silent = TRUE) %>%
    stopOnError()
  
  logger.trace("Continue processing ...")
  
}, silent = TRUE)

# ----- Example 2:  bad user input ---------------------------------------------
try({
  
  userInput <- "10"
  logger.trace("class(userInput) = %s", class(userInput))
  
  try({
    myFunc(x = userInput)
  }, silent = TRUE) %>%
    stopOnError()
  
  logger.trace("Continue processing ...") # we don't get here
  
}, silent = TRUE)

# ----- Example 3:  bad user input, custom error message -----------------------
try({
  
  try({
    logger.trace("class(userInput) = %s", class(userInput))
    myFunc(x = userInput)
  }, silent = TRUE) %>%
    stopOnError("Unable to process user input")
  
  logger.trace("Continue processing ...") # we don't get here
  
}, silent = TRUE)

