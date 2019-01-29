# Cancellation rate analysis
# The code to generate Cancellationrate_region.csv is provided in a separate bash script
library(ggplot2)
library(dplyr)
library(streamgraph)
cancellationrate_region <- read.csv("Cancellationrate_region.csv", header = TRUE)
cancellationrate_region$Date <- as.Date(with(cancellationrate_region, paste(year, month, dayofmonth,sep="-")), "%Y-%m-%d")


# Remove data for Puerto rico and US Virgin Islans
cancellationrate_region$region <- as.character(cancellationrate_region$region)
cancellationrate_region$cancellation_rate <- cancellationrate_region$cancelled_flights/cancellationrate_region$tot_flights


# No of cancelled flights for every month across both years
cancellationrate_region %>% group_by(month, year) %>% summarise(mon_cancelled_flights=sum(cancelled_flights), mon_tot_flights = sum(tot_flights), mon_cancellation_rate = mon_cancelled_flights/mon_tot_flights) %>% select(month, year, mon_cancellation_rate) -> mon_cancellation_overall
mon_cancellation_overall$year <- as.factor(mon_cancellation_overall$year)

cancel <- 
  ggplot(data=mon_cancellation_overall, mapping = aes(x=month, y=mon_cancellation_rate, color = year)) +  
  geom_line() +
    geom_point() +
   scale_x_discrete(limits=c(1:12)) 

# Cancellation rate for every region at a daily level in the year 2000
cancellationrate_region %>% filter(year==2000) %>% 
  select(region, cancellation_rate, Date)  -> data_2000_daily

streamgraph(data_2000_daily, "region", "cancellation_rate", "Date") %>%
  sg_fill_brewer("Spectral") %>%
  sg_axis_x(tick_units = "Date", tick_interval = 1) %>%
  sg_title("Daily Cancellation Rate by Region (2000)")

# Extracting the top dates for cancellation rate and the region
data_2000_daily <- data_2000_daily[with(data_2000_daily, order(-cancellation_rate)), ]
x <- data_2000_daily[1:10,]

# Cancellation rate for every region at a monthly level in the year 2000
cancellationrate_region %>% filter(year==2000) %>% group_by(region, month, year) %>% summarise(mon_cancelled_flights = sum(cancelled_flights), mon_tot_flights = sum(tot_flights), mon_cancellation_rate = mon_cancelled_flights/mon_tot_flights) %>% 
  select(month, year, region, mon_cancellation_rate, mon_cancelled_flights, mon_tot_flights )  -> data_2000_monthly
data_2000_monthly$Date <- as.Date(with(data_2000_monthly, paste(year, month, 1,sep="-")), "%Y-%m-%d") 
 
# Streamgraph for monthly cancellation rate by region in 2000
 streamgraph(data_2000_monthly, "region", "mon_cancellation_rate", "Date") %>%
  sg_fill_brewer("Spectral") %>%
  sg_axis_x(tick_units = "Date", tick_interval = 1, tick_format = "%m") %>%
  sg_title("Monthly Cancellation Rate by Region (2000)")

# Cancellation rate for every region at a daily level in the year 2000
cancellationrate_region %>% filter(year==2003) %>% 
  select(region, cancellation_rate, Date)  -> data_2003_daily

streamgraph(data_2003_daily, "region", "cancellation_rate", "Date") %>%
  sg_fill_brewer("Spectral") %>%
  sg_axis_x(tick_units = "Date", tick_interval = 1) %>%
  sg_title("Daily Cancellation Rate by Region (2003)")

# Cancellation rate for every region at a monthly level in the year 2003
cancellationrate_region %>% filter(year==2003) %>% group_by(region, month, year) %>% summarise(mon_cancelled_flights = sum(cancelled_flights), mon_tot_flights = sum(tot_flights), mon_cancellation_rate = mon_cancelled_flights/mon_tot_flights) %>% 
  select(month, year, region, mon_cancellation_rate, mon_cancelled_flights, mon_tot_flights )  -> data_2003_monthly
data_2003_monthly$Date <- as.Date(with(data_2003_monthly, paste(year, month, 1,sep="-")), "%Y-%m-%d") 

# Streamgraph for monthly cancellation rate by region in 2003
 streamgraph(data_2003_monthly, "region", "mon_cancellation_rate", "Date") %>%
  sg_fill_brewer("Spectral") %>%
  sg_axis_x(tick_units = "Date", tick_interval = 1, tick_format = "%m") %>%
  sg_title("Monthly Cancellation Rate by Region (2003)")
