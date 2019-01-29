##We see that there is a drastic reduction in number of observations across all the variables in the AirLineData0003_notcancelled table.
##However we see a common number of observations missing in the not cancelled table. It is 25,635. 
##This number of observations are missing across ArrTime, ActualElapsedTime, AirTime and ArrDelay. 
##Extracting all these cases using hive -e and inspecting in excel to hopefully find a trend
hive -e "set hive.cli.print.header=true; 
select * 
from AirLineData0003_notcancelled 
where ArrTime is null 
and  ActualElapsedTime is null 
and  AirTime is null 
and ArrDelay is null;" | sed 's/[\t]/,/g' > /home/ankusha2/Stat480/RDataScience/AirlineDelays/missing_2.csv 