SELECT sb.Student_id, c.term, c.Subject_id, sub.name, sub.credit, c.id, sb.processScore, sb.finalScore, sb.overall, sb.letterScore
FROM scoreboard AS sb
INNER JOIN course AS c
	ON sb.Course_id = c.id
INNER JOIN subject AS sub
	ON c.Subject_id = sub.id
WHERE sb.Student_id = 20134509 AND c.term = 20162 AND sb.processScore > -1
group by c.id;	-- Loại bỏ các bản ghi trùng nhau

-- dùng WHERE thay cho từ khóa JOIN, dù bản chất vẫn là JOIN
SELECT sb.Student_id, c.term, c.Subject_id, sub.name, sub.credit, c.id, sb.processScore, sb.finalScore, sb.overall, sb.letterScore
FROM scoreboard AS sb, course AS c, subject AS sub
WHERE sb.Course_id = c.id
AND c.Subject_id = sub.id
AND sb.Student_id = 20134509 AND c.term = 20161
AND sb.processScore > -1
group by c.id;	-- Loại bỏ các bản ghi trùng nhau

-- lấy giảng viên
SELECT tc.id, tc.name, tc.password, tc.birthday, tc.sex, tc.email,
tc.phone, dept.name, fac.name, tc.workplace, tc.website
FROM teacher AS tc, department AS dept, faculty AS fac
WHERE tc.id = "cuongvl"
AND tc.password = "123"
AND tc.Department_id = dept.id
AND dept.Faculty_id = fac.id;
