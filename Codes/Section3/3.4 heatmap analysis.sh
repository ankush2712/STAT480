##the following part create table for heatmap (camparison between different states)
-- make airport info table
DROP TABLE IF EXISTS heatmap_states;

-- Create table for airport data
CREATE TABLE airports (iata STRING, airport  STRING, city STRING, state STRING,
country STRING, lat DOUBLE, long DOUBLE) 
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES 
(
    "separatorChar" = ",",
    "quoteChar"     = "\""
)  
STORED AS TEXTFILE; 

-- populate table
LOAD DATA LOCAL INPATH '/home/xshen22/groupproject/airports.csv'
OVERWRITE INTO TABLE airports;

--create heatmap_table (joining)
Create table state_attribute as
SELECT airlinedata0003_treated.Year,
airlinedata0003_treated.ArrDelay,
airlinedata0003_treated.Dest,
airlinedata0003_treated.Cancelled,
airlinedata0003_treated.Diverted,
airports.airport,
airports.state
FROM airlinedata0003_treated LEFT OUTER JOIN airports ON (airlinedata0003_treated.Dest =airports.iata);


--aggregating by state
create table heatmap_states  AS
SELECT  
Year as Year,
state AS state, 
COUNT(*) as num_of_flight,
sum(case when (ArrDelay)>0 then 1 else 0 end)/COUNT(*) as Arrdelay_rate,
sum(Cancelled)/COUNT(*) as Cancelled_rate,
sum(Diverted)/COUNT(*) as Diverted_rate
FROM state_attribute
group by Year, state
Order by Year;

hive -e "select * from state_attribute;" | sed 's/[\t]/,/g'  > state_attribute.csv