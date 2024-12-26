-- Câu hỏi SQL từ cơ bản đến nâng cao, bao gồm trigger

-- Cơ bản:
--1. Liệt kê tất cả chuyên gia trong cơ sở dữ liệu.
SELECT *
FROM ChuyenGia;

--2. Hiển thị tên và email của các chuyên gia nữ.
SELECT	HoTen, Email
FROM ChuyenGia
WHERE GioiTinh = N'Nữ';

--3. Liệt kê các công ty có trên 100 nhân viên.
SELECT *
FROM CongTy
WHERE SoNhanVien > 100;

--4. Hiển thị tên và ngày bắt đầu của các dự án trong năm 2023.
SELECT TenDuAn, NgayBatDau
FROM DuAn
WHERE YEAR(NgayBatDau) = 2023;

-- Trung cấp:
--6. Liệt kê tên chuyên gia và số lượng dự án họ tham gia.
SELECT CG.HoTen, COUNT(CGDA.MaDuAn) 'SoDuAn'
FROM ChuyenGia_DuAn CGDA
JOIN ChuyenGia CG ON CGDA.MaChuyenGia = CG.MaChuyenGia
GROUP BY CG.HoTen;

--7. Tìm các dự án có sự tham gia của chuyên gia có kỹ năng 'Python' cấp độ 4 trở lên.
SELECT DISTINCT DA.TenDuAn
FROM DuAn DA
JOIN ChuyenGia_DuAn CGDA ON DA.MaDuAn = CGDA.MaDuAn
WHERE MaChuyenGia IN (
	SELECT MaChuyenGia
	FROM ChuyenGia_KyNang CGKN
	JOIN KyNang KN ON CGKN.MaKyNang = KN.MaKyNang
	WHERE TenKyNang = 'Python' AND CapDo >= 4
);

--8. Hiển thị tên công ty và số lượng dự án đang thực hiện.
SELECT CT.TenCongTy, COUNT(MaDuAn) 'SoDuAn'
FROM DuAN DA
JOIN CongTy CT ON DA.MaCongTy = CT.MaCongTy
GROUP BY CT.TenCongTy;

--9. Tìm chuyên gia có số năm kinh nghiệm cao nhất trong mỗi chuyên ngành.
WITH MaxKinhNghiemChuyenNganh AS (
	SELECT ChuyenNganh, MAX(NamKinhNghiem) 'KinhNghiem'
	FROM ChuyenGia
	GROUP BY ChuyenNganh
)
SELECT HoTen
FROM ChuyenGia CG
JOIN MaxKinhNghiemChuyenNganh MKN
ON CG.NamKinhNghiem = MKN.KinhNghiem AND CG.ChuyenNganh = MKN.ChuyenNganh;

--10. Liệt kê các cặp chuyên gia đã từng làm việc cùng nhau trong ít nhất một dự án.
SELECT DISTINCT
	CG1.Hoten 'ChuyenGia1',
	CG2.HoTen 'ChuyenGia2',
	DA.TenDuAn
FROM ChuyenGia_DuAN CGDA1
JOIN ChuyenGia_DuAn CGDA2 ON CGDA1.MaDuAn = CGDA2.MaDuAN AND CGDA1.MaChuyenGia < CGDA2.MaChuyenGia
JOIN ChuyenGia CG1 ON CGDA1.MaChuyenGia = CG1.MaChuyenGia
JOIN ChuyenGia CG2 ON CGDA2.MaChuyenGia = CG2.MaChuyenGia
JOIN DuAN DA ON CGDA1.MaDuAn = DA.MaDuAn

-- Nâng cao:
--11. Tính tổng thời gian (theo ngày) mà mỗi chuyên gia đã tham gia vào các dự án.
SELECT CG.HoTen, SUM(DATEDIFF(DAY, CGDA.NgayThamGia, DA.NgayKetThuc)) AS TongThoiGian
FROM ChuyenGia CG
JOIN ChuyenGia_DuAn CGDA ON CG.MaChuyenGia = CGDA.MaChuyenGia
JOIN DuAn DA ON CGDA.MaDuAn = DA.MaDuAn
GROUP BY CG.HoTen

--12. Tìm các công ty có tỷ lệ dự án hoàn thành cao nhất (trên 90%).
SELECT CT.TenCongTy
FROM CongTy CT
JOIN DuAn DA ON CT.MaCongTy = DA.MaDuAn
GROUP BY CT.TenCongTy
HAVING CAST(SUM(CASE WHEN DA.TrangThai = N'Hoàn thành' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) > 0.9;

--13. Liệt kê top 3 kỹ năng được yêu cầu nhiều nhất trong các dự án.
WITH KyNangYeuCau AS (
    SELECT KN.MaKyNang, KN.TenKyNang, COUNT(DISTINCT DA.MaDuAn) AS SoLanYeuCau
    FROM KyNang KN
    JOIN ChuyenGia_KyNang CGKN ON KN.MaKyNang = CGKN.MaKyNang
    JOIN ChuyenGia_DuAn CGDA ON CGKN.MaChuyenGia = CGDA.MaChuyenGia
    JOIN DuAn DA ON CGDA.MaDuAn = DA.MaDuAn
    GROUP BY KN.MaKyNang, KN.TenKyNang
)
SELECT TOP 3 TenKyNang, SoLanYeuCau
FROM KyNangYeuCau
ORDER BY SoLanYeuCau DESC;

--14. Tính lương trung bình của chuyên gia theo từng cấp độ kinh nghiệm (Junior: 0-2 năm, Middle: 3-5 năm, Senior: >5 năm).
SELECT 
    CASE 
        WHEN NamKinhNghiem <= 2 THEN 'Junior'
        WHEN NamKinhNghiem <= 5 THEN 'Middle'
        ELSE 'Senior'
    END AS CapDo,
    AVG(Luong) AS LuongTrungBinh
FROM ChuyenGia
GROUP BY 
    CASE 
        WHEN NamKinhNghiem <= 2 THEN 'Junior'
        WHEN NamKinhNghiem <= 5 THEN 'Middle'
        ELSE 'Senior'
    END;

--15. Tìm các dự án có sự tham gia của chuyên gia từ tất cả các chuyên ngành.
WITH SoChuyenNganh AS (
	SELECT (COUNT(DISTINCT ChuyenNganh)) AS SoLuongChuyenNganh
	FROM ChuyenGia
), ChuyenNganhDuAn AS (
	SELECT DA.TenDuAn, COUNT(DISTINCT CG.ChuyenNganh) AS SoChuyenNganhDuAn
	FROM DuAn DA
	JOIN ChuyenGia_DuAn CGDA ON DA.MaDuAn = CGDA.MaDuAn
	JOIN ChuyenGia CG ON CGDA.MaChuyenGia = CG.MaChuyenGia
	GROUP BY DA.TenDuAn
)
SELECT TenDuAn
FROM ChuyenNganhDuAn
WHERE SoChuyenNganhDuAn = (
	SELECT SoLuongChuyenNganh
	FROM SoChuyenNganh
)

-- Trigger:
--16. Tạo một trigger để tự động cập nhật số lượng dự án của công ty khi thêm hoặc xóa dự án.
GO
CREATE TRIGGER TRG_SoLuongDuAnCongTy
ON DuAn
AFTER INSERT, DELETE
AS
BEGIN
	IF EXISTS (
		SELECT 1
		FROM inserted
	)
	BEGIN
		UPDATE CT
		SET CT.SoLuong = CT.SoLuong + T.TotalCount
		FROM CongTy CT
		JOIN (
			SELECT MaCongTy, COUNT(*) AS TotalCount
			FROM inserted
			GROUP BY MaCongTy
		) T ON CT.MaCongTy = T.MaCongTy;
	END
	IF EXISTS (
		SELECT 1
		FROM deleted
	)
	BEGIN
		UPDATE CT
		SET CT.SoLuong = CT.SoLuong - T.TotalCount
		FROM CongTy CT
		JOIN (
			SELECT MaCongTy, COUNT(*) AS TotalCount
			FROM deleted
			GROUP BY MaCongTy
		) T ON CT.MaCongTy = T.MaCongTy;
	END
END;

--17. Tạo một trigger để ghi log mỗi khi có sự thay đổi trong bảng ChuyenGia.
CREATE TABLE ChuyenGiaLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    MaChuyenGia INT,
    HanhDong NVARCHAR(10),
    NgayThayDoi DATETIME DEFAULT GETDATE()
);
GO
CREATE TRIGGER TRG_LogChuyenGia
ON ChuyenGia
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	DECLARE @HANHDONG NVARCHAR(10);

	IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
		SET @HANHDONG = 'UPDATE';
	IF EXISTS (SELECT * FROM inserted)
		SET @HANHDONG = 'INSERT';
	IF EXISTS (SELECT * FROM deleted)
		SET @HANHDONG = 'DELETE';
	INSERT INTO ChuyenGiaLog (MaChuyenGia, HanhDong)
	SELECT MaChuyenGia, @HANHDONG
	FROM inserted
	UNION ALL
	SELECT MaChuyenGia, @HANHDONG
	FROM deleted;
END;

--18. Tạo một trigger để đảm bảo rằng một chuyên gia không thể tham gia vào quá 5 dự án cùng một lúc.
GO
CREATE TRIGGER TRG_ChuyenGia5DuAn
ON ChuyenGia_DuAn
AFTER INSERT
AS
BEGIN
	IF EXISTS (
		SELECT 1
		FROM inserted 
		WHERE MaChuyenGia IN (
			SELECT MaChuyenGia
			FROM ChuyenGia_DuAn
			GROUP BY MaChuyenGia
			HAVING COUNT(MaDuAn) > 5
		)
	)
	BEGIN 
		RAISERROR('Một chuyên gia không thể tham gia vào quá 5 dự án cùng một lúc!', 16, 1);
		ROLLBACK TRANSACTION;
	END
END;

--19. Tạo một trigger để tự động cập nhật trạng thái của dự án thành 'Hoàn thành' khi tất cả chuyên gia đã kết thúc công việc.
GO
CREATE TRIGGER TRG_CapNhatTrangThaiDuAn
ON ChuyenGia_DuAn
AFTER UPDATE
AS
BEGIN
    UPDATE DuAn
    SET TrangThai = N'Hoàn thành'
    WHERE MaDuAn IN (
        SELECT MaDuAn
        FROM ChuyenGia_DuAn
        GROUP BY MaDuAn
        HAVING COUNT(*) = SUM(CASE WHEN NgayKetThuc IS NOT NULL THEN 1 ELSE 0 END)
    )
    AND TrangThai != N'Hoàn thành';
END;

--20. Tạo một trigger để tự động tính toán và cập nhật điểm đánh giá trung bình của công ty dựa trên điểm đánh giá của các dự án.
GO
CREATE TRIGGER trg_CapNhatDiemDanhGiaCongTy
ON DuAn
AFTER UPDATE
AS
BEGIN
    IF UPDATE(DiemDanhGia)
    BEGIN
        UPDATE CongTy
        SET DiemDanhGia = (
            SELECT AVG(DiemDanhGia)
            FROM DuAn
            WHERE MaCongTy = CongTy.MaCongTy AND DiemDanhGia IS NOT NULL
        )
        FROM CongTy
        INNER JOIN inserted ON CongTy.MaCongTy = inserted.MaCongTy;
    END
END;
