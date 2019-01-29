#import data
airlinedata0003 <- read.csv("airline_treated.csv",header = TRUE)

# Function to apply to a CSV file to convert a list of columns to integer index values.
# 
convertCSVColumns <- function(file, collist){
  fulldata<-read.csv(file)
  for (i in collist) {
    fulldata[,i]<-convertColumn(fulldata[,i])
  }
  write.csv(fulldata, file, row.names=FALSE)
}

# The following function is called by convertCSVColumns. It converts a single column to integer indices.
convertColumn <- function(values){
  allvals<-as.character(values)
  valslist<-sort(unique(allvals))
  xx<-factor(allvals, valslist, labels=1:length(valslist))
  rm(allvals)
  rm(valslist)
  gc()
  as.numeric(levels(xx))[xx]
}

# Now use the function on the 2007-2008 data. This will take several minutes.
convertCSVColumns("airline_treated.csv", c(9,11,17,18))


library(biganalytics)
# Now that the data is processed, we can create a big matrix.
x <- read.big.matrix("airline_treated.csv", header = TRUE, 
                     backingfile = "airline_treated.bin",
                     descriptorfile = "airline_treated.desc",
                     type = "integer")


# Total number of flights per month,year
FlightCount_Monthly <- foreach(i = c(2000,2003), .combine = rbind) %do% {
                                foreach(j = 1:12, .combine = rbind) %do% { 
                                   c(i, j, sum(y[which(y[,"year"]==i),"month"]==j))
                                }
                              }
FlightCount_Monthly <- data.frame(FlightCount_Monthly)
colnames(FlightCount_Monthly) <- c("Year", "Month", "Total_Flights")
rownames(FlightCount_Monthly) <- NULL
FlightCount_Monthly$Year <- as.factor(FlightCount_Monthly$Year)

# Create plot
library(ggplot2)
p <- ggplot(data=FlightCount_Monthly, mapping = aes(x=Month, y=Total_Flights, group=Year, color = Year)) +
    geom_line() +
    geom_point() +
   scale_x_discrete(limits=c(1:12)) 
p

# Total number of flights for every day of the week for both years
FlightCount_DOW <- foreach(i = c(2000,2003), .combine = rbind) %do% {
                                foreach(j = 1:7, .combine = rbind) %do% { 
                                   c(i, j, sum(y[which(y[,"year"]==i),"dayofweek"]==j))
                                }
                              }
FlightCount_DOW <- data.frame(FlightCount_DOW)
colnames(FlightCount_DOW) <- c("Year", "DOW", "Total_Flights")
rownames(FlightCount_DOW) <- NULL
FlightCount_DOW$Year <- as.factor(FlightCount_DOW$Year)

# Trends across day of the week
library(ggplot2)
q <- ggplot(data=FlightCount_DOW, mapping = aes(x=DOW, y=Total_Flights, group=Year, color = Year)) +
    geom_line() +
    geom_point() +
   scale_x_discrete(name = "Day of Week" , limits=c(1:7)) 
q
