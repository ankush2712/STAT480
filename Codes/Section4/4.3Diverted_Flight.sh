## Extracting all diverted flights
hive -e "set hive.cli.print.header=true;
set hive.resultset.use.unique.column.names=false;
select
*
from airlinedata0003_treated
where diverted =1;"| sed 's/[\t]/,/g'  > /home/ankusha2/Stat480/RDataScience/AirlineDelays/diverted_flights.csv