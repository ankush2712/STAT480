# Changing into the directory for airlines
cd ~/Stat480/RDataScience/AirlineDelays

# Get the compressed data file.
wget http://rdatasciencecases.org/Data/Airline/AirlineDelays.tar.bz2

# Extract the files here.
tar xvfj AirlineDelays.tar.bz2 

# Remove the headers from the csv files for 2000 and 2003 and combine/append the data into a single csv file
tail -n +2 2000.csv > 2000new.csv
tail -n +2 2003.csv > 2003new.csv
cat 2000new.csv 2003new.csv > AirLineData0003.csv

# Remove csv files for individual years to clear up space (Excpet 2000 to 2003, can come in handy later)
rm 19**.csv
rm 20**.csv



