use [Sales Analysis]
create or alter view ProductPerformance as
select 
Product_Id, 
Category,
Sub_Category,
sum(Quantity) as TotalQuantitySold,
SUM(List_price * Quantity * (1-(Discount_Percent/100))) as TotalSales,
sum(cost_price) as TotalCost,
sum((List_price*(1-(Discount_Percent/100)))-cost_price) as TotalProfit,
sum((List_price*(1-(Discount_Percent/100)))-cost_price) / nullif(sum(List_price * Quantity * (1-(Discount_Percent/100))),0) as ProfitMargin,
avg(Discount_percent/100) as AvgDiscount
from Order_Sales
group by Product_Id , Category, Sub_Category;
select * from ProductPerformance