-- Chú ý: những câu query trong cặp dấu ------- sẽ đc thực hiện cùng nhau

----------------
select * into Sales.Customer_NoIndex
from Sales.Customer

select * into Sales.Customer_Index
from Sales.Customer
go
create index idx_customer_index_CustomerID on Sales.Customer_Index(CustomerID)
----------------

----------------
select CustomerID from Sales.Customer_NoIndex
where CustomerID = 11001;

select CustomerId from Sales.Customer_Index
where CustomerID = 11001;
----------------

---------------- Page Reads: 
-- Chính là số lượng trang dữ liệu được truy cập bởi SQL Server khi thực 
-- thi câu truy vấn. Sử dụng hàm: SET STATISTICS IO { ON | OFF }
use AdventureWorks2008;
go
set statistics io on;
go
select * from Production.ProductCostHistory
where StandardCost < 500.00;
go
set statistics io off;
go
----------------

---------------- Query Execution Time: 
-- Tiêu chí này cho ta biết thời gian thực thi câu truy vấn, và nó chịu tác động
-- của blocking(locks) và sự tranh giành tài nguyên của máy chủ . 
-- Sử dụng hàm: SET STATISTICS TIME { ON | OFF }	
USE AdventureWorks2008;
GO       
SET STATISTICS TIME ON
GO
SELECT *  FROM Production.ProductCostHistory
WHERE StandardCost < 500.00;
GO
SET STATISTICS TIME OFF;
GO
----------------