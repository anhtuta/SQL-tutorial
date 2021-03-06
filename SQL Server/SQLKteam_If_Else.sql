use TestDB
/*
select em.id, em.name, em.address, em.salary, de.name as 'dept_name' from EMPLOYEE em, DEPARTMENT de
where em.dept_id = de.id
*/

-- demo declare variable
declare @AvgSalary int
declare @EmpQuantity int

select @EmpQuantity = count(*) from EMPLOYEE
select @AvgSalary = sum(salary)/@EmpQuantity from EMPLOYEE

print @EmpQuantity
print @AvgSalary

declare @EmpID int = 7
declare @EmpSal int
select @EmpSal = salary from EMPLOYEE where id = @EmpID
if @EmpSal > @AvgSalary
	print N'Lương lớn hơn'	-- chữ N nghĩa là in ra kiểu Unicode
else 
	begin
		print N'Lương bé hơn'
		-- update lương cho thằng nhân viên này
		-- update EMPLOYEE set salary = salary + 100 where id = @EmpID
	end
