use TestDB
go

-- function phải đi kèm với 1 câu truy vấn nào đó, chứ ko thể thực thi 1 mình
-- procedure thì thực thi 1 mình dùng lệnh exec và ko thể đi với 1 câu query
create function getEmpList()
returns table
as return select * from EMPLOYEE
go

select * from getEmpList()
go

create function getEmpSalary(@emID int)
returns int
as
begin
	declare @sala int
	select @sala = salary from EMPLOYEE where id = @emID
	return @sala
end
go

select dbo.getEmpSalary(5)
select dbo.getEmpSalary(id) from EMPLOYEE
GO

create function checkIsOdd(@num int)
returns nvarchar(20)
as
begin
	if(@num % 2 = 0) return N'Số chẵn'
	else return N'Số lẻ'

	return N'không xác định'
end
go

select dbo.checkIsOdd(20)
select dbo.checkIsOdd(21)
select dbo.checkIsOdd(-1)
select em.name, dbo.checkIsOdd(em.id) AS 'Is id odd?', em.salary, dbo.checkIsOdd(salary) AS 'Is salary odd?' from EMPLOYEE em
