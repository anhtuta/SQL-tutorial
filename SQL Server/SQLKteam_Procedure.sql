use TestDB
go

-- procedure dùng để tái sử dụng các câu truy vấn, Nếu có rất nhiều câu query đc dùng ở nhiều nơi thì nên dùng procedure
create PROCEDURE emp_proc @emName nvarchar(50), @emSala int
as
begin
	select * from EMPLOYEE where name like @emName and salary > @emSala
end
go

-- delete procedure
drop PROCEDURE emp_proc
go

-- execute pro
exec emp_proc @emName = 'Anhtu%', @emSala = 2700
exec emp_proc 'Anhtu%', 2000
execute emp_proc 'Anhtu%', 1000

-- ko the chay dc! Phải dùng function mới dùng đc trong lệnh select
select * from emp_proc
