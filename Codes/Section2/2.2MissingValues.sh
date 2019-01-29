# Create a shell script to execute the code which counts number of missing values in each column
vi missingvalues.sh

#!/bin/bash
hive -e 'set hive.cli.print.header=true; select 
sum(case when Year  is null then 1 else 0 end) as missing_Year ,
sum(case when Month  is null then 1 else 0 end) as missing_Month ,
sum(case when DayofMonth  is null then 1 else 0 end) as missing_DayofMonth ,
sum(case when DayofWeek  is null then 1 else 0 end) as missing_DayofWeek ,
sum(case when DepTime  is null then 1 else 0 end) as missing_DepTime ,
sum(case when CRSDepTime  is null then 1 else 0 end) as missing_CRSDepTime ,
sum(case when ArrTime  is null then 1 else 0 end) as missing_ArrTime ,
sum(case when CRSArrTime  is null then 1 else 0 end) as missing_CRSArrTime ,
sum(case when UniqueCarrier  is null then 1 else 0 end) as missing_UniqueCarrier ,
sum(case when FlightNum  is null then 1 else 0 end) as missing_FlightNum ,
sum(case when TailNum  is null then 1 else 0 end) as missing_TailNum ,
sum(case when ActualElapsedTime  is null then 1 else 0 end) as missing_ActualElapsedTime ,
sum(case when CRSElapsedTime  is null then 1 else 0 end) as missing_CRSElapsedTime ,
sum(case when AirTime  is null then 1 else 0 end) as missing_AirTime ,
sum(case when ArrDelay  is null then 1 else 0 end) as missing_ArrDelay ,
sum(case when DepDelay  is null then 1 else 0 end) as missing_DepDelay ,
sum(case when Origin  is null then 1 else 0 end) as missing_Origin ,
sum(case when Dest  is null then 1 else 0 end) as missing_Dest ,
sum(case when Distance  is null then 1 else 0 end) as missing_Distance ,
sum(case when TaxiIn  is null then 1 else 0 end) as missing_TaxiIn ,
sum(case when TaxiOut  is null then 1 else 0 end) as missing_TaxiOut ,
sum(case when Cancelled  is null then 1 else 0 end) as missing_Cancelled ,
sum(case when CancellationCode  is null then 1 else 0 end) as missing_CancellationCode ,
sum(case when Diverted  is null then 1 else 0 end) as missing_Diverted ,
sum(case when CarrierDelay  is null then 1 else 0 end) as missing_CarrierDelay ,
sum(case when WeatherDelay  is null then 1 else 0 end) as missing_WeatherDelay ,
sum(case when NASDelay  is null then 1 else 0 end) as missing_NASDelay ,
sum(case when SecurityDelay  is null then 1 else 0 end) as missing_SecurityDelay ,
sum(case when LateAircraftDelay  is null then 1 else 0 end) as missing_LateAircraftDelay
from AirLineData0003;' | sed 's/[\t]/,/g'  > /home/ankusha2/Stat480/RDataScience/AirlineDelays/missing.csv

# Change permissions so the script can be run.
chmod u+x missingvalues.sh 

# Execute the script
./missingvalues.sh

# The values do not make sense as the readme file suggests that CancellationCode, CarrierDelay, WeatherDelay, NASDelay, SecurityDelay, LateAircraftDelay are missing
# This shows that the previous query is not robust against all types of missing values namely NA, blanks ('' or ' '). So we need to capture all of them and then make 
# a decision. Also there are few legitimate or genuine values within CancellationCode so it is not entirely missing. Let's hold on to that thought and come back to it later.
# Writing a text file variables.txt with all the columns
vi variables.txt

# Copy and pasting all the variables
Year
Month
DayofMonth
DayOfWeek
DepTime
CRSDepTime
ArrTime
CRSArrTime
UniqueCarrier
FlightNum
TailNum
ActualElapsedTime
CRSElapsedTime
AirTime
ArrDelay
DepDelay
Origin
Dest
Distance
TaxiIn
TaxiOut
Cancelled
CancellationCode
Diverted
CarrierDelay
WeatherDelay
NASDelay
SecurityDelay
LateAircraftDelay

# Writing a bash script to automate the null value process for all the columns. 
vi missing_roubst.sh

# Copy and paste the following code. The output will be appended for all columns, thanks to >>.
#!/bin/bash
for line in $(cat variables.txt);
do
echo $line
hive -e "select 
count(*) 
from AirlineDelays.AirLineData0003
where $line is null or $line='NA' or $line='' or $line=' ' or $line='N/A' or $line='.';" >> /home/ankusha2/Stat480/RDataScience/AirlineDelays/missing_robust.csv
done

# Change permissions so the script can be run.
chmod u+x missing_roubst.sh 

# Execute the script
./missing_roubst.sh
