USE TestDB
go

create function printEmployee(@name varchar(50))
returns int
as
begin
	print @name
	return 1	
end
go

-- trong trigger có 2 bảng:
-- inserted: chứa những field đã insert vào bảng, hoặc update vào bảng
-- deleted: chứa những field đã bị xóa khỏi bảng
alter trigger triggerInsertEmployee on EMPLOYEE for insert, update
AS
begin
	-- Nếu 1 employee nào có lương < 1000 thì ko cho insert vào DB
	print 'Trigger on inserting Employee'
	declare @count int = 0;
	select @count = count(*) from inserted where salary < 1000
	if(@count > 0) 
	begin
		print 'nhan vien co luong < 1000'
		rollback tran
	end
	else print 'nhan vien co luong >= 1000 nen TMDK'
end
go

insert into EMPLOYEE values(36, 'Quynh', 'Hanoi', 2390, 100);
