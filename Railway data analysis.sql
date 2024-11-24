select *
from railway_data

---What was the total revenue generated from all ticket purchases?
select sum(Price) as Total_revenue
from railway_data;

---How many transactions were made with each payment method?
select Payment_Method, count(*) transactions_made
from railway_data
group by Payment_Method;

----How many tickets were purchased by each railcard type?
select Railcard, count(*) as tickets_purchashed
from railway_data
Group by Railcard
order by tickets_purchashed DESC;

---How much revenue is generated from customers using railcards compared to those without?
SELECT  Railcard, SUM(Price) Revenue_generated
from railway_data
group by Railcard
order by Revenue_generated DESC;

---What is the average journey duration between 
--each departure station and arrival destination?

SELECT Departure_Station, Arrival_Destination,
AVG(DATEDIFF(MINUTE, Departure_Time, Arrival_Time)) AS average_journey_duration
FROM railway_data
GROUP BY Departure_Station, Arrival_Destination;

-----How many journeys arrived late, and what is the average delay time?

SELECT COUNT(*) AS Late_Journeys,
    AVG(DATEDIFF(MINUTE, Arrival_Time, Actual_Arrival_Time)) AS Average_Delay_Time_Minutes
FROM railway_data
WHERE Actual_Arrival_Time > Arrival_Time;

-----What is the busiest time of day for ticket purchases based on "Time of Purchase"?

SELECT DATEPART(HOUR, Time_of_Purchase) AS Hour_of_Purchase, COUNT(*) AS Ticket_Purchases
FROM railway_data
GROUP BY DATEPART(HOUR, Time_of_Purchase)
ORDER BY Ticket_Purchases DESC;

----How much revenue was generated from each ticket class (e.g., First Class vs. Standard)?
SELECT Ticket_Class, SUM(Price) as Revenue_each_ticket_Class
from railway_data
group by ticket_class;

----Which ticket type is most popular?
SELECT Ticket_Type, count(*) as Most_popular_ticket_type
from railway_data
GROUP BY ticket_type
ORDER BY Most_popular_ticket_type DESC;

--- What is the average price for each ticket class and ticket type?
Select Ticket_class, Ticket_Type, AVG(Price) AS Avg_price_ticket_class_ticket_type
from railway_data
group by ticket_class, Ticket_Type;

-----How many refunds were requested, and what percentage of the total transactions do they represent?
SELECT COUNT(CASE WHEN Refund_Request = 1 THEN 'YES' END) AS Refund_Requests,
(COUNT(CASE WHEN Refund_Request = 1 THEN 'YES' END) * 100.0 / COUNT(*)) AS Refund_Percentage
from railway_data;

---What is the average refund amount for delayed journeys?
SELECT AVG(Price) AS Average_refund_amount
from railway_data
where Journey_Status= 'delayed'
AND
Refund_Request=1;

---What are the top reasons for delays, and how often does each occur?
SELECT Reason_for_delay, count(*) AS Delay_occurence
from railway_data
where Journey_Status= 'delayed'
GROUP BY Reason_for_delay
ORDER BY Delay_occurence DESC;

----Which departure stations have the most delayed journeys?
Select TOP 5 Departure_station, count(*) most_delayed_journeys
from railway_data
where Journey_Status= 'delayed'
group by Departure_station
ORDER BY most_delayed_journeys DESC;

---What percentage of journeys are completed on time?
SELECT (COUNT(CASE WHEN Journey_status='On Time' THEN 'YES' END)* 100.0 / COUNT(*))  AS percentage_journey_completed_ontime
from railway_data;

----What is the distribution of purchases across different days of the week?

SELECT DATENAME(WEEKDAY, Date_of_Purchase) AS Day_of_Week, COUNT(*) AS Purchase_Count
FROM railway_data
GROUP BY DATENAME(WEEKDAY, Date_of_Purchase)
ORDER BY Purchase_Count DESC;

---Which routes (Departure Station to Arrival Destination) are the most and least popular?
SELECT TOP 3 Departure_Station, Arrival_Destination, COUNT(*) AS Route_Count
FROM railway_data
GROUP BY Departure_Station, Arrival_Destination
ORDER BY Route_Count ASC;

----What is the average delay for each route?
SELECT Departure_Station, Arrival_Destination, 
    AVG(DATEDIFF(MINUTE, Arrival_Time, Actual_Arrival_Time)) AS Average_Delay_Minutes
FROM railway_data
WHERE Journey_Status = 'Delayed'  
GROUP BY Departure_Station, Arrival_Destination
ORDER BY Average_Delay_Minutes DESC;

---For each route, what percentage of journeys have a delay?

SELECT Departure_Station, Arrival_Destination,  COUNT(*) AS Total_Journeys,
    COUNT(CASE WHEN Journey_Status = 'Delayed' THEN 1 END) AS Delayed_Journeys,
    (COUNT(CASE WHEN Journey_Status = 'Delayed' THEN 1 END) * 100.0 / COUNT(*)) AS Delay_Percentage 
from railway_data
GROUP BY Departure_Station, Arrival_Destination
ORDER BY Delay_Percentage  DESC;
