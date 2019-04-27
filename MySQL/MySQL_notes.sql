Tên của các foreign key phải KHÁC NHAU trong cùng 1 bảng và giữa các bảng!
Tên của foreign key, tên index KHÔNG NÊN viết tiếng việt
Tên của các index phải KHÁC NHAU

=== Trigger

CREATE TRIGGER Student_AFTER_INSERT AFTER INSERT ON `Student` FOR EACH ROW
BEGIN
    UPDATE SVClass SET numOfStudent = numOfStudent + 1 WHERE id = NEW.SVClass_id;
END;

//mặc định mysql tạo ra:
CREATE DEFINER = CURRENT_USER TRIGGER `QLSV_db`.`Student_AFTER_INSERT` AFTER INSERT ON `Student` FOR EACH ROW
BEGIN
    UPDATE SVClass SET numOfStudent = numOfStudent + 1 WHERE id = NEW.SVClass_id;
END;
-- có thể viết ngắn hơn:
CREATE TRIGGER Student_AFTER_DELETE AFTER DELETE ON `Student` FOR EACH ROW
BEGIN
	UPDATE SVClass SET numOfStudent = numOfStudent - 1 WHERE id = OLD.SVClass_id;
END;

-- thử cái này xem. Cái này là sau khi nhập lệnh tạo trigger giống ở trên thì MySQL nó thay đổi ntnay::
CREATE DEFINER=`root`@`localhost` TRIGGER ScoreBoard_AFTER_INSERT AFTER INSERT ON `scoreboard` FOR EACH ROW
BEGIN
	UPDATE course SET registeredNum = registeredNum + 1 WHERE id = NEW.Course_id;
END
=== thêm trigger trong 1 table:
USE `qlsv_db`;

DELIMITER $$

DROP TRIGGER IF EXISTS qlsv_db.Student_AFTER_UPDATE$$
USE `qlsv_db`$$
CREATE TRIGGER Student_AFTER_UPDATE AFTER UPDATE ON `Student` FOR EACH ROW
BEGIN
	UPDATE SVClass SET numOfStudent = numOfStudent + 1 WHERE id = NEW.SVClass_id_st;
END;$$
DELIMITER ;

==== 
khi thêm 1 column vào bảng, sau đó cho column đó có kiểu unique, thì sẽ xảy ra lỗi
VD: thêm cột email và thêm unique key như sau:
ALTER TABLE `user` 
ADD UNIQUE INDEX `email_UNIQUE` (`email` ASC);

chắc chắn sẽ lỗi:
ERROR 1062: Duplicate entry '' for key 'email_UNIQUE'
Lý do là vì: cột email vừa thêm vào nên các record ko có giá trị
gì trên cột này, nghĩa là các record có giá trị email trùng nhau!
Đó chính là lỗi duplicate!
Do đó cần thêm các giá trị email cho từng record trước, sau đó mới
thêm đc unique key