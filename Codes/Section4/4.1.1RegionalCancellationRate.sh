# Output the Cancellation rate for every region (Remove data for Puerto rico and US Virgin Islands)
hive -e "set hive.cli.print.header=true;
set hive.resultset.use.unique.column.names=false;
select
a.Year,
a.Month,
a.DayofMonth,
a.region,
sum(a.cancelled) as cancelled_flights,
count(*) as tot_flights
from
    (select
    *,
    (case when origin_state in ('AK', 'CO', 'OR', 'WA', 'UT', 'WY', 'AZ', 'HI', 'MT', 'NV', 'CA', 'NM', 'ID') then 'West'
          when origin_state in ('GA', 'SC', 'WV', 'AL', 'LA', 'FL', 'MD', 'VA', 'KY', 'OK', 'MS', 'AR', 'TX', 'TN', 'NC') then 'South'
          when origin_state in ('VT', 'ME', 'NH', 'PA', 'CT', 'NJ', 'RI', 'MA', 'NY') then 'Northeast'
          when origin_state in ('ND', 'MN', 'NE', 'SD', 'MO', 'OH', 'IA', 'IL', 'MI', 'IN', 'WI', 'KS') then 'Midwest'
          when origin_state = 'VI' then 'United States Virgin Islands'
          when origin_state = 'PR' then 'Puerto Rico' end) as region
    from airline_join_airport) as a
where a.region not in ('United States Virgin Islands', 'Puerto Rico')
group by
a.Year,
a.Month,
a.DayofMonth,
a.region;" | sed 's/[\t]/,/g'  > /home/ankusha2/Stat480/RDataScience/AirlineDelays/Cancellationrate_region.csv
