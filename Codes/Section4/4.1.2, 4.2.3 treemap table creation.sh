##the following code create tables for treemap
-- Create a hive carrier table
CREATE TABLE carrier(Code STRING, Description STRING) 
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES 
(
    "separatorChar" = ",",
    "quoteChar"     = "\""
)  
STORED AS TEXTFILE;  
 
--populate table with data from carrier.csv file
LOAD DATA LOCAL INPATH '/home/xshen22/groupproject/carriers.csv'
OVERWRITE INTO TABLE carrier;

hive -e "select * from airline_carrier;" | sed 's/[\t]/,/g'  > airline_carrier.csv



--DROP TABLE IF EXISTS carrier_count_descrip_00;



--creating carrier_count table 
create table carrier_count_00 AS
SELECT  UniqueCarrier AS carrier, 
COUNT(*) as num_of_flight,
sum(Cancelled)/COUNT(*)  as cancellation_rate,
sum(Diverted)/COUNT(*) as diverted_rate,
sum(case when (ArrDelay)> 0 then 1 else 0 end)/COUNT(*) as arrival_delay_rate FROM airlinedata0003_treated
where Year=2000
group by UniqueCarrier;


create table carrier_count_03 AS
SELECT  UniqueCarrier AS carrier, 
COUNT(*) as num_of_flight,
sum(Cancelled)/COUNT(*)  as cancellation_rate,
sum(Diverted)/COUNT(*) as diverted_rate,
sum(case when (ArrDelay)> 0 then 1 else 0 end)/COUNT(*) as arrival_delay_rate FROM airlinedata0003_treated
where Year=2003
group by UniqueCarrier;


--create airline_carrier (joining Description)
--year 2000
Create table carrier_count_descrip_00 as
SELECT carrier_count_00.*,carrier.Description
FROM carrier_count_00, carrier 
WHERE carrier_count_00.carrier = carrier.Code;


--year 2003
Create table carrier_count_descrip_03 as
SELECT carrier_count_03.*,carrier.Description
FROM carrier_count_03, carrier 
WHERE carrier_count_03.carrier = carrier.Code;