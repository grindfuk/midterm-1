# Need to make requests and parse the JSON
#install.packages("httpRequest")
##install.packages("rjson")
library(httpRequest)
library(rjson)

twitterGET <- function (path) {
  
  # Required Globals for API
  apiKey <- "&apikey=09C43A9B270A470B8EB8F2946A9369F3"
  host <- "otter.topsy.com"
  
  pathWKey <- paste(path, apiKey, sep="")
  
  # Get a raw response 
  resp <- getToHost(host, pathWKey) 
  head(resp)
  
  # Return only the json body and parse it as an R object
  body <- sub("^[^{]+", "", resp)
  doc <- fromJSON(body)
  head(doc)
  return(doc)
}

# The paths are where the real magic happens

# Here, search for tweets within the utc timestamp interval
path1 <- "/search.js?q=paul%20bamberg&type=link&offset=0&perpage=10&window=d10&call_timestamp=1394652715030&_=1394652724755"
resp1 <- twitterGET(path1)
head(resp1)

# Use url=twitter page to find info about the author
path2 <- "/authorinfo.json?url=https://twitter.com/MathJokes"
resp2 <- twitterGET(path2)
head(resp2)

# Use query q=keyword and returns count of keyword over last 30 days
path3 <- "/searchhistogram.json?q=bamberg"
resp3 <- twitterGET(path3)
head(resp3)
plot(resp3$response$histogram, 
     xlab="days",
     main="Counts of Twitter Mentions of bamberg for the last 30 days")

# This one says find out what the experts (those with high twitter influence levels) are
# saying about the keyword that you query
path4 <- "/experts.json?q=sxsw"
resp4 <- twitterGET(path4)
head(resp4)

# This one says return a list of posts for the given url
path5 <- "/linkposts.json?url=http://twitter.com/MathJokes"
resp5 <- twitterGET(path5)
head(resp5)

# This one says return a count of the list of posts for the given url 
# This is faster if we only care about usage counts.
path6 <- "/linkpostcount.json?url=http://twitter.com/MathJokes"
resp6 <- twitterGET(path6)
head(resp6)

# This one says return a count for the searched keyword  
# This one is fast but it is also neat because it returns all public twitter mentions 
# since the beginning of twitter 
path7 <- "/searchcount.json?q=Paul+Bamberg"
resp7 <- twitterGET(path7)
head(resp7)

# This one gets all the basic stats for the twitter url. 
# Useful if we want to investigate the supernodes.
h# since the beginning of twitter 
path8 <- "/stats.json?url=http://twitter.com/MathJokes"
resp8 <- twitterGET(path8)
head(resp8)
