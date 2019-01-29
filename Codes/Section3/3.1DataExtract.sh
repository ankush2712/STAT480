# Extracting data in local system
hive -e "set hive.cli.print.header=true;
set hive.resultset.use.unique.column.names=false;
select * from airlinedata0003_treated;" | sed 's/[\t]/,/g'  > /home/ankusha2/Stat480/RDataScience/AirlineDelays/airline_treated.csv