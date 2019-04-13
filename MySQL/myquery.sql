use qlsv_db;
-- lấy lịch giảng dạy của thầy hiepnd
SELECT Subject_id_c, dayOfWeek, course.time, week, room
FROM course
WHERE course.Teacher_id_c = 'hiepnd';

EXPLAIN SELECT course.dayOfWeek, course.time, sub.name, course.room, course.week
FROM timetable as tt, subject as sub, course
WHERE tt.Student_id_tt = 20134509 
AND course.term = 20171 
AND course.id = tt.Course_id_tt 
AND sub.id = course.Subject_id_c;

-- tra cuu bang diem: cách làm sai
SELECT sb.Student_id_sb, sb.term, sb.Subject_id_sb, sub.name, sub.credit, course.id, sb.processScore, sb.finalScore, sb.overall, sb.letterScore
FROM scoreboard AS sb, subject AS sub, course
WHERE sb.Student_id_sb = 20134509
AND sb.term = 20162
AND sub.id = sb.Subject_id_sb
AND course.Subject_id_c = sb.Subject_id_sb;

-- tra cứu bảng điểm: cách này OK (?)
SELECT sb.Student_id_sb, sb.term, sb.Subject_id_sb, sub.name, sub.credit, course.id, sb.processScore, sb.finalScore, sb.overall, sb.letterScore
FROM scoreboard AS sb
INNER JOIN subject AS sub	-- Join với thằng này để lấy tên học phần
	ON sb.Subject_id_sb = sub.id
INNER JOIN course
	ON sb.Subject_id_sb = course.Subject_id_c AND course.term = 20162	-- join với thằng này để lấy mã lớp học
WHERE sb.Student_id_sb = 20134509
AND sb.term = 20162;
-- Nhận xét: do thừa dữ liệu (Chưa ở dạng chuẩn 3NF) nên SQL lằng nhằng và ko khớp nhau về data

-- lịch thi
SELECT es.id, es.Course_id, sub.name, es.day, es.room, es.kip
FROM examschedule es, scoreboard sb, course c, subject sub
WHERE sb.Student_id = 20134509
AND es.Course_id = sb.Course_id
AND c.id = sb.Course_id
AND sub.id = c.Subject_id
AND c.term = 20171;

-- bảng điểm
SELECT sb.Student_id, c.term, c.Subject_id, sub.name, sub.credit, /*c.id*/ sb.Course_id, sb.processScore, sb.finalScore, sb.overall, sb.letterScore
FROM scoreboard AS sb, course AS c, subject AS sub
WHERE sb.Course_id = c.id
AND c.Subject_id = sub.id
AND sb.Student_id = 20134509
/*
trong lệnh trên: course ko phải là bảng đặc quyền (do thuộc tính c.id trên mệnh đề SELECT ko phải là PK)
scoreboard là bảng đặc quyền
course cũng ko với tới bảng đặc quyền scoreboard
do đó chắc chắn sẽ có bản ghi trùng lặp
tương tự, subject cũng ko với tới bảng đặc quyền scoreboard do đkiện join của nó là với bảng course
Do đó có thể nên tách riêng bảng course ra thành 2 bảng
course_info(Course_id, subjectID, term, courseType, note, status, maxNum, registeredNum, facultyName, teacherID)
course_time(Course_id, dayOfWeek, time, room, week)
Nhưng do time có hạn, ko làm đc nữa nên đành dùng từ khóa DISTINCT trong mệnh đề CLAUSE
CHÚ Ý: RẤT CẦN TÁCH THÀNH 2 BẢNG VÌ CỨ BẢNG NÀO JOIN VỚI course SẼ GÂY TRÙNG LẶP

*/