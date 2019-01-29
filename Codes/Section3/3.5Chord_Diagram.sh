## Create file for the analysis on R
hive -e "set hive.cli.print.header=true;
set hive.resultset.use.unique.column.names=false;
select
     a.origin_Region,
     a.dest_region,
     count(*) as tot_flights
     from
         (select
         *,
         (case when origin_state in ('AK', 'CO', 'OR', 'WA', 'UT', 'WY', 'AZ',                                                                                                              'HI', 'MT', 'NV', 'CA', 'NM', 'ID') then 'West'
           when origin_state in ('GA', 'SC', 'WV', 'AL', 'LA', 'FL', 'MD', 'VA'                                                                                                             , 'KY', 'OK', 'MS', 'AR', 'TX', 'TN', 'NC') then 'South'
           when origin_state in ('VT', 'ME', 'NH', 'PA', 'CT', 'NJ', 'RI', 'MA'                                                                                                             , 'NY') then 'Northeast'
           when origin_state in ('ND', 'MN', 'NE', 'SD', 'MO', 'OH', 'IA', 'IL'                                                                                                             , 'MI', 'IN', 'WI', 'KS') then 'Midwest'
           when origin_state = 'VI' then 'United States Virgin Islands'
           when origin_state = 'PR' then 'Puerto Rico' end) as origin_region,
         (case when dest_state in ('AK', 'CO', 'OR', 'WA', 'UT', 'WY', 'AZ', 'H                                                                                                             I', 'MT', 'NV', 'CA', 'NM', 'ID') then 'West'
           when dest_state in ('GA', 'SC', 'WV', 'AL', 'LA', 'FL', 'MD', 'VA',                                                                                                              'KY', 'OK', 'MS', 'AR', 'TX', 'TN', 'NC') then 'South'
           when dest_state in ('VT', 'ME', 'NH', 'PA', 'CT', 'NJ', 'RI', 'MA',                                                                                                              'NY') then 'Northeast'
           when dest_state in ('ND', 'MN', 'NE', 'SD', 'MO', 'OH', 'IA', 'IL',                                                                                                              'MI', 'IN', 'WI', 'KS') then 'Midwest'
           when dest_state = 'VI' then 'United States Virgin Islands'
           when dest_state = 'PR' then 'Puerto Rico' end) as dest_region
         from airline_join_airport) as a
     where a.origin_Region not in ('United States Virgin Islands', 'Puerto Rico') and a.dest_region not in ('United States Virgin Islands', 'Puerto Rico')
     group by a.origin_Region, a.dest_region;"| sed 's/[\t]/,/g'  > /home/ankusha2/Stat480/RDataScience/AirlineDelays/chord_diagram.csv