use TestDB
-- chú ý: ko nên dùng con trỏ vì tốn time!
-- Lấy ra danh sách NV có tên là 'Anhtu%' và lưu vào 1 con trỏ
Declare EmpCursor cursor for select em.id, em.salary from EMPLOYEE em where name like 'Anhtu%'

-- sửa lương cho từng thằng trong con trỏ trên
-- nếu lương > 3000 thì cho = 3500
-- else nếu lương > 2500 thì cho = 3000
-- else làm tròn lên hàng trăm, VD: 1612 = 1600

open EmpCursor

declare @emID int
declare @salary int

fetch next from EmpCursor into @emID, @salary
while @@FETCH_STATUS = 0
begin
	if(@salary > 3000) update EMPLOYEE set salary = 3500 where id = @emID
	else if(@salary > 2500) update EMPLOYEE set salary = 3000 where id = @emID
	else update	EMPLOYEE set salary = (salary/100) * 100 where id = @emID

	print 'updated salary'
	fetch next from EmpCursor into @emID, @salary
end

close EmpCursor
Deallocate EmpCursor

