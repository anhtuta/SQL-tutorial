/*
CREATE DATABASE IF NOT EXISTS QLKH;
USE QLKH;
CREATE TABLE IF NOT EXISTS giangvien(
	`GV#` VARCHAR(5) NOT NULL,
    `HoTen` VARCHAR(30) NOT NULL,
    `DiaChi` VARCHAR(40),
    `NgaySinh` DATE,
    CONSTRAINT KhoaChinh PRIMARY KEY(`GV#`)
);

CREATE TABLE IF NOT EXISTS detai(
	`DT#` VARCHAR(5) NOT NULL,
    `TenDT` VARCHAR(30) NOT NULL,
    `Cap` VARCHAR(20),
    `KinhPhi` INT,
    CONSTRAINT KhoaChinh PRIMARY KEY(`DT#`)
);
CREATE TABLE IF NOT EXISTS thamgia(
	`GV#` VARCHAR(5) NOT NULL,
    `DT#` VARCHAR(5) NOT NULL,
    `SoGio` INT,
    CONSTRAINT KhoaChinh PRIMARY KEY(`GV#`, `DT#`),
    FOREIGN KEY(`GV#`) REFERENCES giangvien(`GV#`),
    FOREIGN KEY(`DT#`) REFERENCES detai(`DT#`)
);
*/
--
USE qlkh;
/*
SELECT HoTen, DiaChi, NgaySinh
FROM giangvien AS gv, thamgia AS tg, detai AS dt
WHERE gv.`GV#` = tg.`GV#`
AND dt.`DT#` = tg.`DT#`
AND dt.`TenDT` in (`Phan loai vb`, `Dich tu dong Anh Viet`);
*/

-- cau 4
/*
SELECT * FROM giangvien
NATURAL JOIN thamgia
GROUP BY `GV#`
HAVING COUNT(DISTINCT `DT#`) >=2;

-- cach khac
SELECT * FROM giangvien
WHERE `GV#` IN(SELECT `GV#` FROM thamgia group by (`GV#`) having count(`DT#`) > 1);

-- cau 5
-- lam nhu sau la sai
SELECT gv.HoTen, count(`DT#`)
FROM giangvien gv, thamgia tg
WHERE gv.`GV#` = tg.`GV#`
group by tg.`GV#`
having count(`DT#`) = (SELECT MAX(count(`DT#`)) FROM thamgia)

-- PHAI LAM NHU SAU:
SELECT gv.HoTen, count(`DT#`)
FROM giangvien gv, thamgia tg
WHERE gv.`GV#` = tg.`GV#`	-- join
group by gv.`GV#`
having count(`DT#`) >= ALL(SELECT count(`DT#`) FROM thamgia group by `GV#`);

-- CACH khac
SELECT gv.HoTen
FROM giangvien gv
WHERE gv.`GV#` IN(
	select `GV#` from thamgia group by `GV#` HAVING COUNT(`DT#`) >= ALL(	-- DEM SỐ LƯỢNG ĐỀ TÀI LỚN NHẤT trong số bọn ở dưới
		SELECT COUNT(`DT#`) FROM thamgia group by `GV#`)	-- lấy tất cả số lượng các đề tài
);

-- cach khác
SELECT HoTen
FROM giangvien gv, thamgia tg
WHERE gv.`GV#` = tg.`GV#`
GROUP BY HoTen, tg.`GV#`
having count(tg.`DT#`) >= all(SELECT COUNT(tg.`DT#`) FROM thamgia tg group by tg.`GV#`);

-- cau 6
SELECT TenDT
FROM detai
WHERE KinhPhi <= ALL(
	SELECT KinhPhi FROM detai);

-- cau 6
SELECT * FROM detai
where KinhPhi = (select min(KinhPhi) from detai);

-- cach khac
select * from detai
where KinhPhi <= ALL(SELECT KinhPhi FROM detai);


-- cau 7 (I did it)
SELECT HoTen, NgaySinh, TenDT
FROM giangvien gv
INNER JOIN thamgia tg
	ON gv.`GV#` = tg.`GV#`
INNER JOIN detai dt
	ON tg.`DT#` = dt.`DT#`
where gv.DiaChi LIKE "tay ho%";

-- cau 8 (I did it)
SELECT * FROM giangvien
where NgaySinh < `1980\01\01`;


-- cau 9 (I did it)
select gv.`GV#`, HoTen, SoGio
from giangvien gv
INNER join thamgia tg
	on gv.`GV#` = tg.`GV#`;
*/
-- cau 7 (?)
/*
SELECT HoTen, NgaySinh, TenDT
FROM giangvien gv, thamgia tg, detai dt
where gv.`GV#` = dt.`GV#`
and gv.`DT#` = dt.`DT#`
and gv.DiaChi like "%tayho%";
*/

/*
-- cau 8
select HoTen
from giangvien
natural join thamgia natural join detai
where extract(year from NgaySinh) < 1980 and TenDT like "%phan loai vb";
*/

-- cau 9
select `GV#`, HoTen, sum(SoGio)
from giangvien natural join thamgia
group by `GV#`, HoTen;







