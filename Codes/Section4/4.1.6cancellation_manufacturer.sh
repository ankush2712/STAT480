# Cancellation Rate by plane manufacturer
hive -e "set hive.cli.print.header=true;
set hive.resultset.use.unique.column.names=false;
select
year,
manufacturer,
sum(cancelled) as cancelled_flights,
count(*) as tot_flights
from airline_join_plane
where manufacturer is not null and manufacturer<>' ' and manufacturer<>'NA' 
group by year, manufacturer;" | sed 's/[\t]/,/g'  > /home/ankusha2/Stat480/RDataScience/AirlineDelays/Cancellationrate_Manufacturer.csv