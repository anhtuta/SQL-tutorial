/****** Script for SelectTopNRows command from SSMS  ******/
use QLBongDa;

-- some examples:
-- Tính tuổi trung bình, tuổi nhỏ nhất và lớn nhất của các cầu thủ
select min(year(getdate()) - year(ct.NGAYSINH)) AS MinAge,
	   max(year(getdate()) - year(ct.NGAYSINH)) AS MaxAge,
	   AVG(year(getdate()) - year(ct.NGAYSINH)) AS AvgAge
from CAUTHU ct;

-- Tìm ra những câu lạc bộ có số lượng cầu thủ nước ngoài lớn hơn 2.
select cl.TENCLB, count(ct.MACT) as [SL cẩu thủ nước ngoài]
from CAULACBO cl, CAUTHU ct
where ct.MACLB = cl.MACLB
and ct.MAQG <> 'VN'
group by cl.TENCLB
having count(ct.MACT) > 1;

-- Tìm câu lạc bộ có cầu thủ lớn tuổi nhất: 3 cách sau khá giống nhau
select cl.TENCLB, ct.HOTEN, year(getdate()) - year(ct.NGAYSINH) AS TUOI
from CAULACBO cl, CAUTHU ct
where cl.MACLB = ct.MACLB
and year(ct.NGAYSINH) <= ALL (Select year(ct2.NGAYSINH) from CAUTHU ct2);

select cl.TENCLB, ct.HOTEN, year(getdate()) - year(ct.NGAYSINH) AS TUOI
from CAULACBO cl, CAUTHU ct
where cl.MACLB = ct.MACLB
and year(ct.NGAYSINH) = (Select min(year(ct2.NGAYSINH)) from CAUTHU ct2);

select clb.TENCLB, ct.HOTEN, year(getdate()) - year(NGAYSINH) as [Tuổi]
from CAULACBO clb
inner join CAUTHU ct on clb.MACLB = ct.MACLB
where year(getdate()) - year(NGAYSINH) = (
	select max(year(getdate()) - year(NGAYSINH))
	from CAUTHU);

-- Tìm các câu lạc bộ không tham gia thi đấu trong trận đấu nào trong mùa giải năm 2009
select cl.TENCLB
from CAULACBO cl
where cl.MACLB not in (select td.MACLB1 from TRANDAU td where td.NAM = 2009)
and cl.MACLB not in (select td.MACLB2 from TRANDAU td where td.NAM = 2009);



-- BAI TAP
-- cau a.9
SELECT TOP 3 clb.TENCLB
FROM [dbo].[BANGXH] bxh, CAULACBO clb
where VONG = 3
and bxh.MACLB = clb.MACLB
order by DIEM DESC;

-- cau b.1. Thống kê số lượng cầu thủ của mỗi câu lạc bộ
SELECT ct.HOTEN, ct.MACLB, clb.TENCLB
FROM CAULACBO clb, CAUTHU ct
where clb.MACLB = ct.MACLB;
-- Từ lệnh truy vấn trên ta có lời giải cho câu b.1:
SELECT ct.MACLB, clb.TENCLB, count(ct.HOTEN) AS SoLuongCauThu
FROM CAULACBO clb, CAUTHU ct
where clb.MACLB = ct.MACLB
group by ct.MACLB, clb.TENCLB;

-- cau b.2. Thống kê số lượng cầu thủ nước ngoài của mỗi câu lạc bộ
SELECT clb.MACLB, count(ct.MACT) AS SoLuongCTNuocNgoai
FROM CAULACBO clb, CAUTHU ct
WHERE ct.MACLB = clb.MACLB
AND ct.MAQG NOT LIKE 'VN'
GROUP BY clb.MACLB;

-- cau b.3. Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, địa chỉ và số lượng cầu thủ
-- nước ngoài (có quốc tịch khác Việt Nam) tương ứng của các câu lạc bộ có nhiều hơn 2
-- cầu thủ nước ngoài.
SELECT clb.MACLB, clb.TENCLB, svd.TENSAN, clb.MATINH AS DiaChi, ct.MACT
FROM CAULACBO clb, CAUTHU ct, SANVD svd
WHERE ct.MACLB = clb.MACLB
AND svd.MASAN = clb.MASAN
AND ct.MAQG NOT LIKE 'VN';

SELECT clb.MACLB, clb.TENCLB, svd.TENSAN, clb.MATINH AS DiaChi, count(ct.MACT) AS SoLuongCTNuocNgoai
FROM CAULACBO clb, CAUTHU ct, SANVD svd
WHERE ct.MACLB = clb.MACLB
AND svd.MASAN = clb.MASAN
AND ct.MAQG NOT LIKE 'VN'
GROUP BY clb.MACLB, clb.TENCLB, svd.TENSAN, clb.MATINH
having count(ct.MACT) > 1;

-- b.4. Cho biết tên tỉnh, số lượng cầu thủ đang thi đấu ở vị trí tiền đạo trong các câu lạc bộ
-- thuộc địa bàn tỉnh đó quản lý
select t.TENTINH, ct.MACT, ct.VITRI
from CAULACBO clb, TINH t, CAUTHU ct
where clb.MATINH = t.MATINH
and ct.MACLB = clb.MACLB
and ct.VITRI LIKE '%n%';

select t.TENTINH, count(ct.MACT) AS SLTienDao
from CAULACBO clb, TINH t, CAUTHU ct
where ct.VITRI = 'Tiền Đạo'
and clb.MATINH = t.MATINH
and ct.MACLB = clb.MACLB
group by t.TENTINH;

-- b.5. Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng nằm ở vị trí cao nhất của bảng xếp
-- hạng vòng 3, năm 2009

-- Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng ở vòng 3 của bảng xếp hạng:
select cl.TENCLB, t.TENTINH, b.DIEM
from CAULACBO cl, TINH t, BANGXH b
where cl.MATINH = t.MATINH
and b.VONG = 3
and b.MACLB = cl.MACLB;

-- Do đó đáp án cho câu này:
select cl.TENCLB, t.TENTINH, b.DIEM
from CAULACBO cl, TINH t, BANGXH b
where cl.MATINH = t.MATINH
and b.VONG = 3
and b.MACLB = cl.MACLB
and b.DIEM >= ALL (select b2.DIEM from BANGXH b2 where b2.VONG = 3);

-- c.1. Cho biết tên huấn luyện viên đang nắm giữ một vị trí trong một câu lạc bộ mà chưa
-- có số điện thoại
-- Thường thì 1 HLV sẽ ở 1 CLB, mà (MaHlv, MaClb) là khóa, do đó mỗi HLV chỉ có 1 vai trò duy nhất
-- vậy có thể đơn giản hóa thành:
-- Cho biết tên huấn luyện viên mà chưa
-- có số điện thoại
select * from HUANLUYENVIEN
where DIENTHOAI is null;

-- c.2. Liệt kê các huấn luyện viên thuộc quốc gia Việt Nam chưa làm công tác huấn luyện tại
-- bất kỳ một câu lạc bộ nào
select TENHLV
from HUANLUYENVIEN
where MAHLV NOT IN (select hc.MAHLV from HLV_CLB hc);

-- c.3. Liệt kê các cầu thủ đang thi đấu trong các câu lạc bộ có thứ hạng ở vòng 3 năm 2009 lớn
-- hơn 4 hoặc nhỏ hơn 3
select ct.HOTEN, cl.MACLB
from CAUTHU ct, CAULACBO cl
where ct.MACLB = cl.MACLB
and cl.MACLB IN (select bx.MACLB
				 from BANGXH bx
				 where bx.VONG = 3
				 and (bx.HANG <= 2 or bx.HANG >= 5));

-- Cho biết danh sách các trận đấu (NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) của
-- câu lạc bộ (CLB) đang xếp hạng cao nhất tính đến hết vòng 3 năm 2009 .
use QLBongDa;
select * from TRANDAU
where MACLB1 = (select MACLB from BANGXH where VONG = 3 and HANG = 1)
or MACLB2 = (select MACLB from BANGXH where VONG = 3 and HANG = 1);
-- Nên tạo bảng tạm ở phần này (?)

--- create new type
EXEC sp_addtype 'MyNameType', 'nvarchar(50)', 'NOT NULL'
--- delete new type
EXEC sp_droptype 'MyNameType';

---- Variable examples
DECLARE @i INT
declare @j int = 5
set @i = 10
set @i = @i + 1
set @i += 5
declare @MaGV char(10) = '007'

declare @MinCauThu int
declare @TenCT nvarchar(50)

select @MinCauThu = MIN(ct.MACT) From CAUTHU ct
select @TenCT = ct.HOTEN from CAUTHU ct where MACT = @MinCauThu

print @MinCauThu
print @TenCT