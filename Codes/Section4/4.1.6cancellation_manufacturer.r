library(dplyr)
library(treemap)
#Cancellation rate by manufacturer
cancellationrate_manufacturer <- read.csv("Cancellationrate_Manufacturer.csv", header = TRUE)

# Treating the data for multiple names of MCDONNELL DOUGLAS and Airbus in the data
cancellationrate_manufacturer[(cancellationrate_manufacturer$manufacturer=="MCDONNELL DOUGLAS CORPORATION" |cancellationrate_manufacturer$manufacturer=="MCDONNELL DOUGLAS AIRCRAFT CO" | cancellationrate_manufacturer$manufacturer=="DOUGLAS"), "manufacturer"] <- "MCDONNELL DOUGLAS"
cancellationrate_manufacturer[(cancellationrate_manufacturer$manufacturer=="AIRBUS INDUSTRIE"),"manufacturer"] <- "AIRBUS"
cancellationrate_manufacturer[(cancellationrate_manufacturer$manufacturer=="AEROSPATIALE/ALENIA"),"manufacturer"] <- "AEROSPATIALE"

# Aggregating the data at a yearly level
cancellationrate_manufacturer %>% group_by(year,manufacturer) %>% summarise(tot_cancelled_flights = sum(cancelled_flights), overall_tot_flights = sum(tot_flights), cancellation_rate = tot_cancelled_flights/overall_tot_flights) %>% select(year, manufacturer, cancellation_rate, overall_tot_flights) -> cancellation_manufacturer

manufacturer_2000 <- treemap(cancellation_manufacturer[cancellation_manufacturer$year==2000,],
        index=c("manufacturer"),
        vSize="overall_tot_flights",
        vColor="cancellation_rate",
        title="Flight Manufacturers with Total Flights and Cancellation Rate (2000)",
        type="value")

treemap(cancellation_manufacturer[cancellation_manufacturer$year==2003,],
        index=c("manufacturer"),
        vSize="overall_tot_flights",
        vColor="cancellation_rate",
        title="Flight Manufacturers with Total Flights and Cancellation Rate (2003)",
        type="value")