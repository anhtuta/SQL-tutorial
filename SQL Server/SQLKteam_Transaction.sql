begin transaction
delete from EMPLOYEE where name = 'Anhtu29'
rollback -- cancel transaction

begin transaction
delete from EMPLOYEE where name = 'anhtu@j'
commit -- accept transaction

declare @tran1 varchar(50) = 'This is a name'
begin transaction @tran1
delete from EMPLOYEE where name = 'anhtu@j'
commit transaction @tran1 -- accept transaction

-- thiet lap moc thoi gian de quay lai
begin transaction
save transaction tran2
delete from EMPLOYEE where id = 35

save transaction tran3
delete from EMPLOYEE where id = 36

-- commit
rollback transaction tran3