use qlkh_csdl;
/*
-- 1.	Đưa ra thông tin giảng viên có địa chỉ ở quận “Hai Bà Trưng”, sắp xếp theo thứ tự giảm dần của họ tên.
SELECT * FROM giangvien
WHERE addr LIKE "%hai ba trung%"
order by name DESC;
*/

/*
-- 2.	Đưa ra danh sách gồm họ tên, địa chỉ, ngày sinh của giảng viên có tham gia vào đề tài “Tính toán lưới”.
SELECT gv.name, addr, birth
FROM giangvien gv, detai dt, thamgia tg
WHERE dt.name = "tinh toan luoi"
and tg.dtid = dt.dtid
and gv.gvid = tg.gvid;

SELECT gv.name, addr, birth
FROM giangvien gv, thamgia tg, detai dt
WHERE gv.gvid = tg.gvid
and tg.dtid = dt.dtid
and dt.name = "tinh toan luoi";

SELECT gv.name, addr, birth
FROM giangvien gv
join thamgia tg
	on gv.gvid = tg.gvid
join detai dt
	on tg.dtid = dt.dtid
WHERE dt.name = "tinh toan luoi";
*/

/*
-- 3.	Đưa ra danh sách gồm họ tên, địa chỉ, ngày sinh của giảng viên có tham gia vào đề tài “Phân loại văn bản” hoặc “Dịch tự động Anh Việt”.
SELECT gv.name, addr, birth
FROM giangvien AS gv, thamgia AS tg, detai AS dt
WHERE gv.gvid = tg.gvid
AND dt.dtid = tg.dtid
AND dt.name in ("Phan loai vb", "Dich tu dong Anh Viet");

-- 4.	Cho biết thông tin giảng viên tham gia ít nhất 2 đề tài.
SELECT gv.name, addr, birth
FROM giangvien AS gv
join thamgia tg
	on gv.gvid = tg.gvid
group by tg.gvid
having count(DISTINCT tg.dtid) >= 2;

SELECT gv.name, addr, birth
FROM giangvien gv
NATURAL JOIN thamgia
GROUP BY gvid
HAVING COUNT(DISTINCT dtid) >=2;

-- cach khac: nên tránh truy vấn lồng!
SELECT * FROM giangvien
WHERE gvid IN(SELECT gvid FROM thamgia group by (gvid) having count(dtid) > 1);

-- 5.	Cho biết tên giảng viên tham gia nhiều đề tài nhất.
SELECT gv.name
FROM giangvien gv
WHERE gv.gvid IN (
				select gvid
				from thamgia
				group by gvid
				having count(dtid) >= ALL(
										select count(dtid)
                                        from thamgia
                                        group by gvid
									  )
			  );

-- viet gon lai:
SELECT gv.name
FROM giangvien gv
WHERE gv.gvid IN(
	select gvid from thamgia group by gvid HAVING COUNT(dtid) >= ALL(	-- DEM SỐ LƯỢNG ĐỀ TÀI LỚN NHẤT trong số bọn ở dưới
		SELECT COUNT(dtid) FROM thamgia group by gvid)	-- lấy tất cả số lượng các đề tài
);

-- cách sau có vẻ dễ hiểu hơn
select gv.name, count(dtid)
from giangvien gv, thamgia tg
where gv.gvid = tg.gvid		-- JOIN
group by gv.gvid
having count(dtid) >= ALL(select count(dtid) from thamgia group by gvid)

-- 6.	Đề tài nào tốn ít kinh phí nhất?
select * from detai dt
where cost = (select min(cost) from detai);

-- cach khac, có vẻ ko tối ưu bằng cách trên (?)
select * from detai dt
where cost <= all(select cost from detai);

-- bonus: Đề tài nào tốn nhiều kinh phý nhất
select * from detai
where cost >= all(select cost from detai);

select * from detai
where cost = (select max(cost) from detai);

-- 7.	Cho biết tên và ngày sinh của giảng viên sống ở quận Tây Hồ và tên các đề tài mà giảng viên này tham gia.
select gv.name, gv.birth, dt.name
from giangvien gv
inner join thamgia tg
	on gv.gvid = tg.gvid
inner join detai dt
	on dt.dtid = tg.dtid
where gv.addr LIKE "%tay ho%";

-- join bằng lệnh where:
select gv.name, gv.birth, dt.name
from giangvien gv, thamgia tg, detai dt		-- Có cần đúng thứ tự như vậy (?)
where gv.gvid = tg.gvid
and dt.dtid = tg.dtid
and gv.addr like "%tay ho%";

SELECT gv.name, gv.addr, birth, dt.name
FROM giangvien gv, thamgia tg, detai dt
where gv.gvid = tg.gvid
and tg.dtid = dt.dtid
having gv.addr like "%tay ho%";		-- dùng having thì cột gv.addr bắt buộc phải đc select, vì select xong mới lọc kq = having

-- 8.	Cho biết tên những giảng viên sinh trước năm 1980 và có tham gia đề tài “phan loai vb”
select gv.name, gv.birth, dt.name
from giangvien gv, thamgia tg, detai dt		-- Có cần đúng thứ tự như vậy (?)
where gv.gvid = tg.gvid
and dt.dtid = tg.dtid
and extract(year from birth) < 1980 and dt.name like "%phan loai vb";
*/

-- 9.	Đưa ra mã giảng viên, tên giảng viên và tổng số giờ tham gia nghiên cứu khoa học của từng giảng viên.
select gv.gvid, gv.name, sum(tg.hours)
from giangvien gv, thamgia tg, detai dt		-- Có cần đúng thứ tự như vậy (?)
where gv.gvid = tg.gvid
and dt.dtid = tg.dtid
group by (gv.gvid);

+------+--------------------+---------------+
| gvid | name               | sum(tg.hours) |
+------+--------------------+---------------+
| 1    | Vu tuyet trinh     |           260 |
| 2    | nguyen nhat quang  |           260 |
| 3    | tran duc khanh     |           150 |
| 4    | nguyen hong phuong |           180 |
+------+--------------------+---------------+

-- so sanh với các lệnh sau
select gv.gvid, gv.name, dt.name, tg.hours
from giangvien gv, thamgia tg, detai dt
where gv.gvid = tg.gvid
and dt.dtid = tg.dtid;

+------+--------------------+-----------------------+-------+
| gvid | name               | name                  | hours |
+------+--------------------+-----------------------+-------+
| 1    | Vu tuyet trinh     | tinh toan luoi        |   100 |
| 1    | Vu tuyet trinh     | phat hien tri thuc    |    80 |
| 1    | Vu tuyet trinh     | phan loai vb          |    80 |
| 2    | nguyen nhat quang  | tinh toan luoi        |   120 |
| 2    | nguyen nhat quang  | phan loai vb          |   140 |
| 3    | tran duc khanh     | phan loai vb          |   150 |
| 4    | nguyen hong phuong | dich tu dong Anh Viet |   180 |
+------+--------------------+-----------------------+-------+

select gv.gvid, gv.name, dt.name, tg.hours
from giangvien gv, thamgia tg, detai dt
where gv.gvid = tg.gvid
and dt.dtid = tg.dtid
group by (gv.gvid);

+------+--------------------+-----------------------+-------+
| gvid | name               | name                  | hours |
+------+--------------------+-----------------------+-------+
| 1    | Vu tuyet trinh     | tinh toan luoi        |   100 |
| 2    | nguyen nhat quang  | tinh toan luoi        |   120 |
| 3    | tran duc khanh     | phan loai vb          |   150 |
| 4    | nguyen hong phuong | dich tu dong Anh Viet |   180 |
+------+--------------------+-----------------------+-------+

select gv.gvid, gv.name, dt.name, sum(tg.hours)
from giangvien gv, thamgia tg, detai dt
where gv.gvid = tg.gvid
and dt.dtid = tg.dtid;

+------+----------------+----------------+---------------+
| gvid | name           | name           | sum(tg.hours) |
+------+----------------+----------------+---------------+
| 1    | Vu tuyet trinh | tinh toan luoi |           850 |
+------+----------------+----------------+---------------+

/*
10.	Giảng viên Ngô Tuấn Phong sinh ngày 08/09/1986 địa chỉ Đống Đa, Hà Nội mới tham gia nghiên cứu đề tài khoa học. Hãy thêm thông tin giảng viên này vào bảng GiangVien.
11.	Giảng viên Vũ Tuyết Trinh mới chuyển về sống tại quận Tây Hồ, Hà Nội. Hãy cập nhật thông tin này.
12.	Giảng viên có mã GV02 không tham gia bất kỳ đề tài nào nữa. Hãy xóa tất cả thông tin liên quan đến giảng viên này trong CSDL.
*/