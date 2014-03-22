# Using the GoogleMaps API
require(methods)
library(rjson)
library(httpRequest)

setClass("googleAPI", 
  representation(
    host="character",
    apiTail="character"
  ),
  prototype = prototype(
    host="maps.googleapis.com",
    apiTail="/maps/api/geocode/json?sensor=false&"
  )
)

setGeneric(
  name="reverseGeoLocate", 
  def=function(object, lat, lng) {return(lat)}
)

setGeneric(
  name="GeoLocate", 
  def=function(object, address) {return(address)}
)


setMethod(
  f="reverseGeoLocate", 
  signature="googleAPI", 
  definition = function (object, lat, lng) {
    latlngStr <- paste(lat, lng, sep=",")
    path <- paste(object@apiTail, "latlng=", latlngStr, sep="")
    resp <- getToHost(object@host, path) 
    
    # Return only the json body and parse it as an R object
    body <- sub("^[^{]+", "", resp)
    doc <- fromJSON(body)
    return(doc)
  }
)  

setMethod(
  f="GeoLocate", 
  signature="googleAPI", 
  definition = function (object, address) {
    # The address must be of the form: 62+south+st+boston+ma
    address <- gsub("\\s+", "+", address)
    path <- paste("/maps/api/geocode/json?sensor=false&",
                  "address=", address, sep="")
    resp <- getToHost(object@host, path) 
    body <- sub("^[^{]+", "", resp)
    return(fromJSON(body))
  }
)

# Test our new class

Google <- new("googleAPI")

# Search Google for an address based on the lat, lng
response1 <- reverseGeoLocate(Google, 42.351944, -71.055278)

# Google returns a JSON with a list of suggested results, the closest of which is 
# ordered at the top.  
topResult <- response1$results[[1]]
# Google conveniently gives us a nice result, possibly too accurate result
print(topResult$formatted_address)

# For completeness sake, we can do the reverse

response2 <- GeoLocate(Google, "700 Atlantic Avenue Boston, MA 02110")

# Google gives us a nice address
print(response2$results[[1]]$formatted_address)
# And of course, the lat, lng
LatLng <- c(response2$results[[1]]$geometry$location)
# Lat
print(LatLng[1])
# Lng
print(LatLng[2])
