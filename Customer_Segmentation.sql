use [Sales Analysis]
create or alter procedure CustomerSegmentationAnalysis
as 
begin 
set nocount on;

--- RFM Analysis (Recency,Frequency,Monetary)
with CustomerRFM as ( 
select 
City + ', '+State as CustomerLocation,
Segment,
Datediff(DAY,MAX(Order_Date),GETDATE()) as Recency,
count(distinct Order_Id) as Frequency,
SUM(List_price * Quantity * (1-(Discount_Percent/100))) as Monetary,
ntile(5) over (order by Datediff(day,max(Order_Date),getdate())desc) as R_Score,
ntile(5) over (order by count(distinct Order_Id)) as F_Score,
ntile(5) over (order by SUM(List_price * Quantity * (1-(Discount_Percent/100)))) as M_Score,
(ntile(5) over (order by datediff(day,max(Order_Date),Getdate()) desc) + ntile(5) over (order by count(distinct Order_Id))+ntile(5) over (order by SUM(List_price * Quantity * (1-(Discount_Percent/100)))))/3.0 as RFM_Score
from Order_Sales 
group by City , State , Segment
)
select 
CustomerLocation,
Segment,
Recency,
Frequency,
Monetary,
R_Score,
F_Score,
M_Score,
RFM_Score,
case
when RFM_Score >= 4.5 then 'Champions'
when RFM_Score >= 4.0 then 'Loyal Customers'
when RFM_Score >= 3.5 then 'Potenial Loyalits'
when RFM_Score >= 3.0 then 'New Customers'
when RFM_Score >= 2.5 then 'Promising'
when RFM_Score >= 2.0 then 'Needs Attention'
else 'At Risk'
end as CustomerSegment
from CustomerRFM
order by RFM_Score desc;
end