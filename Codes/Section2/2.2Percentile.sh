# Calculate min, max, and percentile distribution of continuous variables
vi percentile.sh

#!/bin/bash
for line in $(cat continuous_variables.txt);
do
echo $line
hive -e "select 
min($line) as min,
percentile($line, array(0.01,0.05,0.1,0.5,0.9,0.95,0.98,0.99,0.995,0.999)) as percentile,
max($line) as max
from airlinedata0003_nondiverted_noncancelled
where $line is not null;" | sed 's/[\t]/,/g' >> /home/ankusha2/Stat480/RDataScience/AirlineDelays/percentile.csv
done

# checking cases where ActualElapsedTime, CRSElapsedTime, AirTime are negative
hive -e "select 
* from airlinedata0003_nondiverted_noncancelled 
where ActualElapsedTime<0 or  CRSElapsedTime<0 or AirTime<0;" | sed 's/[\t]/,/g' >> /home/ankusha2/Stat480/RDataScience/AirlineDelays/negative_overall.csv

hive -e "select 
* from airlinedata0003_nondiverted_noncancelled 
where ActualElapsedTime<0;" | sed 's/[\t]/,/g' >> /home/ankusha2/Stat480/RDataScience/AirlineDelays/negative_ActualElapsedTime.csv

hive -e "select 
* from airlinedata0003_nondiverted_noncancelled 
where CRSElapsedTime<0;" | sed 's/[\t]/,/g' >> /home/ankusha2/Stat480/RDataScience/AirlineDelays/negative_CRSElapsedTime.csv

hive -e "select 
* from airlinedata0003_nondiverted_noncancelled 
where AirTime<0;" | sed 's/[\t]/,/g' >> /home/ankusha2/Stat480/RDataScience/AirlineDelays/negative_AirTime.csv