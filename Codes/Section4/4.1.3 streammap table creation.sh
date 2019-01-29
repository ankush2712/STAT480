##the following code create table for streammap
--Creating table for streammap(cancellation rate for carrier)
create table carrier_monthly  AS
SELECT  
Year as Year,
Month as Month,
UniqueCarrier AS carrier, 
sum(Cancelled) as Cancelled,
COUNT(*) as num_of_flight,
sum(Cancelled)/COUNT(*) as Cancelled_rate
FROM airlinedata0003_treated
group by Year,Month,UniqueCarrier
Order by Year,Month;

--create carrier_monthly_Descript (joining)
Create table carrier_monthly_Descript as
SELECT carrier_monthly.*,carrier.Description
FROM carrier_monthly, carrier 
WHERE carrier_monthly.carrier = carrier.Code;