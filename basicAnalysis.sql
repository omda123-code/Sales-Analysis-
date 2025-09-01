-------over all sales summary
select 
count(distinct Order_Id) as TotalOrders,
sum(Quantity) as TotalItemsSold,
SUM(List_price * Quantity * (1-(Discount_Percent/100))) as TotalRevenue,
sum(cost_price) as TotalCost,
sum((List_price*(1-(Discount_Percent/100)))-cost_price) as TotalProfit,
sum((List_price*(1-(Discount_Percent/100)))-cost_price)/nullif(SUM(List_price * Quantity * (1-(Discount_Percent/100))),0) as ProfitMargin
from Order_Sales

-----sales by category and subcategory
select 
Category,
Sub_Category,
count(distinct Order_Id) as OrderCount,
sum(Quantity) as TotalQuantity,
SUM(List_price * Quantity * (1-(Discount_Percent/100))) as TotalSales,
sum((List_price*(1-(Discount_Percent/100)))-cost_price) as TotalProfit 
from Order_Sales
group by Category, Sub_Category 
order by TotalSales desc;

-----Top 10 Products by Revenue 
select top 10
Product_Id,
Category,
Sub_Category,
sum(Quantity) as TotalQuantity,
SUM(List_price * Quantity * (1-(Discount_Percent/100))) as TotalSales,
sum((List_price*(1-(Discount_Percent/100)))-cost_price) as TotalProfit
from Order_Sales 
group by Product_Id,Category, Sub_Category
order by TotalSales desc;

------ Sales by Region 
select 
Region,
count(distinct Order_Id) as OrderCount,
sum(Quantity) as TotalQuantity,
SUM(List_price * Quantity * (1-(Discount_Percent/100))) as TotalSales,
sum((List_price*(1-(Discount_Percent/100)))-cost_price) as TotalProfit
from Order_Sales
group by Region 
Order by TotalSales desc;

----- Monthly Sales Trend 
select 
Year(Order_Date) as Year,
Month(Order_Date) as Month,
datename(month,Order_Date) as MonthName,
count(distinct Order_Id) as OrderCount,
SUM(List_price * Quantity * (1-(Discount_Percent/100))) as TotalSales,
sum((List_price*(1-(Discount_Percent/100)))-cost_price) as TotalProfit,
sum((List_price*(1-(Discount_Percent/100)))-cost_price)/nullif(SUM(List_price * Quantity * (1-(Discount_Percent/100))),0) as ProfitMargin 
from Order_Sales
group by Year(Order_Date),Month(Order_Date),datename(month,Order_Date)
order by Year,Month;

----- Year_over_Year Gorwth 
with MonthlySales as (
select 
Year(Order_Date) as Year,
Month(Order_Date) as Month,
SUM(List_price * Quantity * (1-(Discount_Percent/100))) as MonthlySales
from Order_Sales 
group by Year(Order_Date),Month(Order_Date)
)
select 
a.Year,
a.Month,
a.MonthlySales as CurrentSales,
b.MonthlySales as PerviousSales,
(a.MonthlySales - b.MonthlySales)/b.MonthlySales*100 as GrowthPercent
from MonthlySales a
left join MonthlySales b on a.Month=b.Month and a.Year=b.Year +1
order by a.Year , a.Month;

------ Quarterly Sales Analysis 
select 
Year(Order_Date) as Year,
Datepart(Quarter , Order_Date) as Quarter,
count(distinct Order_Id) as OrderCount,
SUM(List_price * Quantity * (1-(Discount_Percent/100))) as TotalSales,
sum((List_price*(1-(Discount_Percent/100)))-cost_price) as TotalProfit
from Order_Sales 
group by Year(Order_Date), Datepart(Quarter, Order_Date)
order by Year,Quarter;