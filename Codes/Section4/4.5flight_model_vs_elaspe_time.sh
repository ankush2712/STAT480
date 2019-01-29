# Remove header from csv
tail -n +2 plane_data.csv > plane_data_rh.csv

# in hive
DROP TABLE IF EXISTS plane_data;

-- Create a hive table for plane_data_rh.csv
CREATE TABLE plane_data (tailnum_p STRING, type STRING, manufacturer STRING, issue_date STRING, model STRING, status STRING, aircraft_type STRING, engine_type STRING, year int) 
ROW FORMAT DELIMITED
  FIELDS TERMINATED BY ',';

-- Populate table with data from plane-data.csv file
LOAD DATA LOCAL INPATH '/home/cwu78/STAT480/RDataScience/group_project/plane_data_rh.csv'
OVERWRITE INTO TABLE plane_data;

-- There are 4480 rows of valid data
SELECT count(*) FROM plane_data WHERE type != 'NULL';

-- Create a table with clean data
DROP TABLE IF EXISTS plane_data_clean;

CREATE TABLE plane_data_clean AS SELECT * FROM plane_data WHERE type != 'NULL';

-- Check that the number of rows is the same (4480)
SELECT count(*) FROM plane_data_clean;

-- Create a table with combined data
DROP TABLE IF EXISTS air_plane_combine;

CREATE TABLE air_plane_combine AS SELECT airlinedata0003_treated.Year, airlinedata0003_treated.TailNum, airlinedata0003_treated.distance, airlinedata0003_treated.CRSElapsedTime, plane_data_clean.tailnum_p, plane_data_clean.manufacturer, plane_data_clean.model 
FROM airlinedata0003_treated, plane_data_clean 
WHERE airlinedata0003_treated.TailNum = plane_data_clean.tailnum_p;

-- Create a table with combined data and needed variables
DROP TABLE IF EXISTS air_plane_clean;

CREATE TABLE air_plane_clean AS SELECT Year, CRSElapsedTime, manufacturer, model FROM air_plane_combine;

-- Create table with data aggregated by model of the airplane, with an average CRSElapsedTime and number of flights flown by the model
DROP TABLE IF EXISTS model_elapse_total;

CREATE TABLE model_elapse_total AS SELECT model, AVG(CRSElapsedTime) as AVGElapse, count(*) as count FROM air_plane_clean GROUP BY model;

# Populate to csv file for R programming
hive -e "select * from model_elapse_total;" | sed 's/[\t]/,/g'  > /home/cwu78/STAT480/RDataScience/group_project/model_elapse_total.csv

-- Create table with data aggregated by model and year of the airplane, with an average CRSElapsedTime and number of flights flown by the model
DROP TABLE IF EXISTS model_elapse;

CREATE TABLE model_elapse AS SELECT model, Year, AVG(CRSElapsedTime) as AVGElapse, count(*) as count FROM air_plane_clean GROUP BY model, Year;

# Populate to csv file for R programming
hive -e "select * from model_elapse;" | sed 's/[\t]/,/g'  > /home/cwu78/STAT480/RDataScience/group_project/model_elapse.csv

DROP TABLE IF EXISTS air_plane_clean_dist;

-- Create a table with combined data and needed variables
CREATE TABLE air_plane_clean_dist AS SELECT Year, distance, manufacturer, model FROM air_plane_combine;

-- Create table with data aggregated by model of the airplane, with an average distance and number of flights flown by the model
DROP TABLE IF EXISTS model_elapse_total_dist;

CREATE TABLE model_elapse_total_dist AS SELECT model, AVG(distance) as AVGDistance, count(*) as count FROM air_plane_clean_dist GROUP BY model;

# Populate to csv file for R programming
hive -e "select * from model_elapse_total_dist;" | sed 's/[\t]/,/g'  > /home/cwu78/STAT480/RDataScience/group_project/model_elapse_total_dist.csv

-- Create table with data aggregated by model and year of the airplane, with an average distance and number of flights flown by the model
DROP TABLE IF EXISTS model_elapse_dist;

CREATE TABLE model_elapse_dist AS SELECT model, Year, AVG(distance) as AVGDistance, count(*) as count FROM air_plane_clean_dist GROUP BY model, Year;

# Populate to csv file for R programming
hive -e "select * from model_elapse_dist;" | sed 's/[\t]/,/g'  > /home/cwu78/STAT480/RDataScience/group_project/model_elapse_dist.csv
