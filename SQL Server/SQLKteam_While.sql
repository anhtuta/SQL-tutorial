declare @i int = 0
declare @n int = 1000
while(@i < @n)
begin
	print @i
	set @i += 1
end

-- generates a random number between 0 and 13 inclusive with a normalized distribution:
print ABS(CHECKSUM(NewId())) % 14

-- demo insert lots of random records using while
declare @j int = 16
declare @m int = 30
declare @ten varchar(50)
declare @diaChi varchar(50)
declare @luong int
declare @phongBan int

while(@j < @m)
begin
	-- set name
	set @ten = 'Anhtu'+CONVERT(varchar(10), @j)

	-- set random address
	if(@j % 5 = 0)	set @diaChi = 'Hanoi'
	else if(@j % 5 = 1) set @diaChi = 'HCM'
	else if(@j % 5 = 2) set @diaChi = 'Da Nang'
	else if(@j % 5 = 3) set @diaChi = 'Bac Giang'
	else if(@j % 5 = 4) set @diaChi = 'Nghe An'
	
	-- set random Salary
	set @luong = (ABS(CHECKSUM(NewId())) % 3000) + 1000

	-- set random dept
	set @phongBan = (ABS(CHECKSUM(NewId())) % 9) + 100

	insert into EMPLOYEE(id, name, address, salary, dept_id)
	values (@j, @ten, @diaChi, @luong, @phongBan)

	set @j += 1	-- NẾU KO CÓ LỆNH NÀY COI NHƯ TOI! LẶP VÔ HẠN!
end