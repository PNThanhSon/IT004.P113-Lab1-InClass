--23521360 Phạm Nguyễn Thanh Sơn
-- 8. Hiển thị tên và cấp độ của tất cả các kỹ năng của chuyên gia có MaChuyenGia là 1.
SELECT ChuyenGia.HoTen, KyNang.TenKyNang, ChuyenGia_KyNang.CapDo
FROM ChuyenGia
INNER JOIN ChuyenGia_KyNang ON ChuyenGia.MaChuyenGia = ChuyenGia_KyNang.MaChuyenGia
INNER JOIN KyNang ON KyNang.MaKyNang = ChuyenGia_KyNang.MaKyNang
WHERE ChuyenGia.MaChuyenGia = 1;

-- 9. Liệt kê tên các chuyên gia tham gia dự án có MaDuAn là 2.
SELECT ChuyenGia.HoTen
FROM ChuyenGia
INNER JOIN ChuyenGia_DuAn ON ChuyenGia.MaChuyenGia = ChuyenGia_DuAn.MaChuyenGia
WHERE ChuyenGia_DuAn.MaDuAn = 2;
-- 10. Hiển thị tên công ty và tên dự án của tất cả các dự án.
SELECT CongTy.TenCongTy, DuAn.TenDuAn
FROM DuAn
INNER JOIN CongTy ON CongTy.MaCongTy = DuAn.MaCongTy;

-- 11. Đếm số lượng chuyên gia trong mỗi chuyên ngành.
SELECT ChuyenNganh, COUNT(*) AS 'SoChuyenGia'
FROM ChuyenGia
GROUP BY ChuyenNganh;
-- 12. Tìm chuyên gia có số năm kinh nghiệm cao nhất.
SELECT TOP 1 *
FROM ChuyenGia
ORDER BY NamKinhNghiem DESC;

-- 13. Liệt kê tên các chuyên gia và số lượng dự án họ tham gia.
SELECT ChuyenGia.HoTen, COUNT(MaDuAn) AS 'SoDuAn'
FROM ChuyenGia_DuAn
INNER JOIN ChuyenGia ON ChuyenGia.MaChuyenGia = ChuyenGia_DuAn.MaChuyenGia
GROUP BY ChuyenGia.HoTen;

-- 14. Hiển thị tên công ty và số lượng dự án của mỗi công ty.
SELECT CongTy.TenCongTy, COUNT(*) AS 'SoDuAn'
FROM DuAn
INNER JOIN CongTy ON CongTy.MaCongTy = DuAn.MaCongTy
GROUP BY CongTy.TenCongTy;

-- 15. Tìm kỹ năng được sở hữu bởi nhiều chuyên gia nhất.
SELECT TOP 1 KyNang.TenKyNang, COUNT(MaChuyenGia) AS 'SoChuyenGia'
FROM ChuyenGia_KyNang
INNER JOIN KyNang ON KyNang.MaKyNang = ChuyenGia_KyNang.MaKyNang
GROUP BY KyNang.TenKyNang
ORDER BY SoChuyenGia DESC;

-- 16. Liệt kê tên các chuyên gia có kỹ năng 'Python' với cấp độ từ 4 trở lên.
SELECT ChuyenGia.HoTen
FROM ChuyenGia
INNER JOIN ChuyenGia_KyNang ON ChuyenGia.MaChuyenGia = ChuyenGia_KyNang.MaChuyenGia
INNER JOIN KyNang ON KyNang.MaKyNang = ChuyenGia_KyNang.MaKyNang
WHERE KyNang.TenKyNang = 'Python' AND ChuyenGia_KyNang.CapDo >= 4;

-- 17. Tìm dự án có nhiều chuyên gia tham gia nhất.
SELECT TOP 1 DuAn.TenDuAn, COUNT(ChuyenGia_DuAn.MaChuyenGia) AS 'SoChuyenGia'
FROM DuAn
INNER JOIN ChuyenGia_DuAn ON DuAn.MaDuAn = ChuyenGia_DuAn.MaDuAn
GROUP BY DuAn.TenDuAn
ORDER BY COUNT(ChuyenGia_DuAn.MaChuyenGia) DESC;

-- 18. Hiển thị tên và số lượng kỹ năng của mỗi chuyên gia.
SELECT ChuyenGia.HoTen, COUNT(ChuyenGia_KyNang.MaKyNang) AS 'SoKyNang'
FROM ChuyenGia
INNER JOIN ChuyenGia_KyNang ON ChuyenGia.MaChuyenGia = ChuyenGia_KyNang.MaChuyenGia
GROUP BY ChuyenGia.HoTen;

-- 19. Tìm các cặp chuyên gia làm việc cùng dự án.
SELECT A.MaDuAn, 
       ChuyenGia1.HoTen AS 'ChuyenGia1', 
       ChuyenGia2.HoTen AS 'ChuyenGia2'
FROM ChuyenGia_DuAn A
INNER JOIN ChuyenGia_DuAn B ON A.MaDuAn = B.MaDuAn
INNER JOIN ChuyenGia ChuyenGia1 ON A.MaChuyenGia = ChuyenGia1.MaChuyenGia
INNER JOIN ChuyenGia ChuyenGia2 ON B.MaChuyenGia = ChuyenGia2.MaChuyenGia
WHERE A.MaChuyenGia < B.MaChuyenGia
ORDER BY MaDuAn;

-- 20. Liệt kê tên các chuyên gia và số lượng kỹ năng cấp độ 5 của họ.
SELECT ChuyenGia.HoTen, COUNT(ChuyenGia_KyNang.MaChuyenGia) AS 'SoKyNang'
FROM ChuyenGia
INNER JOIN ChuyenGia_KyNang ON ChuyenGia.MaChuyenGia = ChuyenGia_KyNang.MaChuyenGia
WHERE ChuyenGia_KyNang.CapDo = 5
GROUP BY ChuyenGia.HoTen;

-- 21. Tìm các công ty không có dự án nào.
SELECT *
FROM CongTy
WHERE MaCongTy NOT IN (	SELECT MaCongTy
						FROM DuAn);
-- 22. Hiển thị tên chuyên gia và tên dự án họ tham gia, bao gồm cả chuyên gia không tham gia dự án nào.
SELECT ChuyenGia.HoTen, DuAn.TenDuAn
FROM ChuyenGia
LEFT JOIN ChuyenGia_DuAn
ON ChuyenGia.MaChuyenGia = ChuyenGia_DuAn.MaChuyenGia
LEFT JOIN DuAn
ON ChuyenGia_DuAn.MaDuAn = DuAn.MaDuAn;

-- 23. Tìm các chuyên gia có ít nhất 3 kỹ năng.
SELECT ChuyenGia.HoTen, COUNT(*) AS 'SoKyNang'
FROM ChuyenGia
INNER JOIN ChuyenGia_KyNang ON ChuyenGia.MaChuyenGia = ChuyenGia_KyNang.MaChuyenGia
GROUP BY ChuyenGia.HoTen
HAVING COUNT(*) >= 3;

-- 24. Hiển thị tên công ty và tổng số năm kinh nghiệm của tất cả chuyên gia trong các dự án của công ty đó.
SELECT CongTy.TenCongTy, SUM(ChuyenGia.NamKinhNghiem) AS 'TongNamKinhNghiem'
FROM ChuyenGia
INNER JOIN ChuyenGia_DuAn ON ChuyenGia.MaChuyenGia = ChuyenGia_DuAn.MaChuyenGia
INNER JOIN DuAn ON ChuyenGia_DuAn.MaDuAn = DuAn.MaDuAn
INNER JOIN CongTy ON DuAn.MaCongTy = CongTy.MaCongTy
GROUP BY CongTy.TenCongTy;

-- 25. Tìm các chuyên gia có kỹ năng 'Java' nhưng không có kỹ năng 'Python'.
SELECT *
FROM ChuyenGia
INNER JOIN ChuyenGia_KyNang ON ChuyenGia.MaChuyenGia = ChuyenGia_KyNang.MaChuyenGia
INNER JOIN KyNang ON ChuyenGia_KyNang.MaKyNang = KyNang.MaKyNang
WHERE KyNang.TenKyNang = 'Java' AND NOT EXISTS (
	SELECT *
	FROM ChuyenGia
	INNER JOIN ChuyenGia_KyNang ON ChuyenGia.MaChuyenGia = ChuyenGia_KyNang.MaChuyenGia
	INNER JOIN KyNang ON ChuyenGia_KyNang.MaKyNang = KyNang.MaKyNang
	WHERE KyNang.TenKyNang = 'Python'
);

-- 76. Tìm chuyên gia có số lượng kỹ năng nhiều nhất.
SELECT TOP 1 ChuyenGia.HoTen, COUNT(*) AS 'SoKyNang'
FROM ChuyenGia
INNER JOIN ChuyenGia_KyNang ON ChuyenGia.MaChuyenGia = ChuyenGia_KyNang.MaChuyenGia
GROUP BY ChuyenGia.HoTen
ORDER BY SoKyNang DESC;

-- 77. Liệt kê các cặp chuyên gia có cùng chuyên ngành.
SELECT A.HoTen AS ChuyenGia1, B.HoTen AS ChuyenGia2, A.ChuyenNganh
FROM ChuyenGia A
INNER JOIN ChuyenGia B ON A.ChuyenNganh = B.ChuyenNganh AND A.MaChuyenGia <> B.MaChuyenGia;

-- 78. Tìm công ty có tổng số năm kinh nghiệm của các chuyên gia trong dự án cao nhất.
SELECT TOP 1 CongTy.TenCongTy, SUM(ChuyenGia.NamKinhNghiem) AS 'TongNamKinhNghiem'
FROM ChuyenGia
INNER JOIN ChuyenGia_DuAn ON ChuyenGia.MaChuyenGia = ChuyenGia_DuAn.MaChuyenGia
INNER JOIN DuAn ON ChuyenGia_DuAn.MaDuAn = DuAn.MaDuAn
INNER JOIN CongTy ON DuAn.MaCongTy = CongTy.MaCongTy
GROUP BY CongTy.TenCongTy
ORDER BY TongNamKinhNghiem DESC;

-- 79. Tìm kỹ năng được sở hữu bởi tất cả các chuyên gia.
SELECT KyNang.TenKyNang
FROM ChuyenGia_KyNang
INNER JOIN KyNang ON ChuyenGia_KyNang.MaKyNang = KyNang.MaKyNang
GROUP BY KyNang.TenKyNang
HAVING COUNT(DISTINCT ChuyenGia_KyNang.MaChuyenGia) = (SELECT COUNT(*) FROM ChuyenGia);
