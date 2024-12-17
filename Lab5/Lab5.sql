-- Câu hỏi và ví dụ về Triggers (101-110)

-- 101. Tạo một trigger để tự động cập nhật trường NgayCapNhat trong bảng ChuyenGia mỗi khi có sự thay đổi thông tin.
CREATE TRIGGER TRG_Update_NgayCapNhat
ON ChuyenGia
AFTER UPDATE
AS
BEGIN
    UPDATE ChuyenGia
    SET NgayCapNhat = GETDATE()
    FROM ChuyenGia C
	JOIN inserted i ON C.MaChuyenGia = i.MaChuyenGia
END;

-- 102. Tạo một trigger để ghi log mỗi khi có sự thay đổi trong bảng DuAn.
CREATE TRIGGER TRG_Log_DuAn
ON DuAn
AFTER UPDATE
AS
BEGIN
	PRINT 'Có sự thay đổi trong bảng DuAn';
END;

-- 103. Tạo một trigger để đảm bảo rằng một chuyên gia không thể tham gia vào quá 5 dự án cùng một lúc.
CREATE TRIGGER TRG_CGIA_5DA
ON ChuyenGia_DuAn
AFTER INSERT
AS
BEGIN
	IF EXISTS (
		SELECT 1
		FROM inserted i
		WHERE i.MaChuyenGia IN (
			SELECT CGDA.MaChuyenGia
			FROM ChuyenGia_DuAn CGDA
			JOIN DuAn DA ON CGDA.MaDuAn = DA.MaDuAn
			WHERE DA.TrangThai = N'Đang thực hiện'
			GROUP BY CGDA.MaChuyenGia
			HAVING COUNT(CGDA.MaDuAn) >= 5
		)
	)
	BEGIN
		RAISERROR('Một chuyên gia không thể tham gia vào quá 5 dự án cùng một lúc.', 16, 1);
		ROLLBACK TRANSACTION;
	END
END;

-- 104. Tạo một trigger để tự động cập nhật số lượng nhân viên trong bảng CongTy mỗi khi có sự thay đổi trong bảng ChuyenGia.
SELECT * FROM CongTy
SELECT * FROM ChuyenGia
SELECT * FROM ChuyenGia_DuAn
SELECT * FROM DuAn

-- 105. Tạo một trigger để ngăn chặn việc xóa các dự án đã hoàn thành.
CREATE TRIGGER TRG_XOA_DA_HOANTHANH
ON DuAn
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON;
	IF EXISTS (
		SELECT 1
		FROM deleted d
		JOIN DuAn DA ON d.MaDuAn = DA.MaDuAn
		WHERE DA.TrangThai = N'Hoàn thành'
	)
	BEGIN
		RAISERROR('Không thể xóa dự án đã hoàn thành', 16, 1);
		ROLLBACK TRANSACTION;
	END
	ELSE
	BEGIN
		DELETE FROM DuAn
		WHERE MaDuAn IN (
			SELECT MaDuAn
			FROM deleted
		)
	END
END;

-- 106. Tạo một trigger để tự động cập nhật cấp độ kỹ năng của chuyên gia khi họ tham gia vào một dự án mới.
SELECT * FROM ChuyenGia_KyNang

-- 107. Tạo một trigger để ghi log mỗi khi có sự thay đổi cấp độ kỹ năng của chuyên gia.
CREATE TRIGGER TRG_LOG_CAPDO_KN_CG
ON ChuyenGia_KyNang
AFTER UPDATE
AS
BEGIN
	IF EXISTS (
		SELECT 1
		FROM inserted i
		JOIN deleted d 
		ON i.MaChuyenGia = d.MaChuyenGia AND i.MaKyNang = d.MaKyNang
		WHERE i.CapDo != d.CapDo
	)
	BEGIN
		PRINT 'Có sự thay đổi cấp độ kỹ năng của chuyên gia.';
	END
END;

-- 108. Tạo một trigger để đảm bảo rằng ngày kết thúc của dự án luôn lớn hơn ngày bắt đầu.
CREATE TRIGGER TRG_KTraNgayKetThucVaBatDau
ON DuAn
AFTER INSERT, UPDATE
AS
BEGIN
	IF EXISTS (
		SELECT 1
		FROM inserted
		WHERE NgayKetThuc <= NgayBatDau
	)
	BEGIN
		RAISERROR('Ngày kết thúc của dự án phải lớn hơn ngày bắt đầu', 16, 1);
		ROLLBACK TRANSACTION;
	END
END;
-- 109. Tạo một trigger để tự động xóa các bản ghi liên quan trong bảng ChuyenGia_KyNang khi một kỹ năng bị xóa.
CREATE TRIGGER TRG_XoaKyNangLienQuan
ON KyNang
INSTEAD OF DELETE
AS
BEGIN
	DELETE FROM ChuyenGia_KyNang
	WHERE MaKyNang IN (SELECT MaKyNang FROM deleted);
	DELETE FROM KyNang
	WHERE MaKyNang IN (SELECT MaKyNang FROM deleted);
END;

-- 110. Tạo một trigger để đảm bảo rằng một công ty không thể có quá 10 dự án đang thực hiện cùng một lúc.
CREATE TRIGGER TRG_CTY_10_DA
ON DuAn
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT MaCongTy
        FROM (
            SELECT MaCongTy, COUNT(*) AS SoDuAn
            FROM DuAn
            WHERE TrangThai = N'Đang thực hiện'
            GROUP BY MaCongTy
            HAVING COUNT(*) > 10
        ) AS DuAnQua10
        WHERE MaCongTy IN (SELECT MaCongTy FROM INSERTED)
    )
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR ('Một công ty không được phép có quá 10 dự án đang thực hiện.', 16, 1);
    END
END;

-- Câu hỏi và ví dụ về Triggers bổ sung (123-135)

-- 123. Tạo một trigger để tự động cập nhật lương của chuyên gia dựa trên cấp độ kỹ năng và số năm kinh nghiệm.


-- 124. Tạo một trigger để tự động gửi thông báo khi một dự án sắp đến hạn (còn 7 ngày).

-- Tạo bảng ThongBao nếu chưa có


-- 125. Tạo một trigger để ngăn chặn việc xóa hoặc cập nhật thông tin của chuyên gia đang tham gia dự án.
CREATE TRIGGER TRG_CG_DA_THAMGIA
ON ChuyenGia
AFTER DELETE, UPDATE
AS
BEGIN
	IF EXISTS (
		SELECT MaChuyenGia 
		FROM (
			SELECT d.MaChuyenGia
			FROM deleted d
			UNION
			SELECT i.MaChuyenGia
			FROM inserted i
		) AS KetHop
		WHERE MaChuyenGia IN (
			SELECT MaChuyenGia
			FROM ChuyenGia_DuAn CGDA
			JOIN DuAn DA ON CGDA.MaDuAn = DA.MaDuAn
			WHERE DA.TrangThai = N'Đang thực hiện'
		)
	)
	BEGIN
		RAISERROR('Không thể xóa hoặc cập nhật thông tin của chuyên gia đang tham gia dự án', 16, 1);
		ROLLBACK TRANSACTION;
	END
END;

-- 126. Tạo một trigger để tự động cập nhật số lượng chuyên gia trong mỗi chuyên ngành.

-- Tạo bảng ThongKeChuyenNganh nếu chưa có

-- 127. Tạo một trigger để tự động tạo bản sao lưu của dự án khi nó được đánh dấu là hoàn thành.

-- Tạo bảng DuAnHoanThanh nếu chưa có


-- 128. Tạo một trigger để tự động cập nhật điểm đánh giá trung bình của công ty dựa trên điểm đánh giá của các dự án.



-- 129. Tạo một trigger để tự động phân công chuyên gia vào dự án dựa trên kỹ năng và kinh nghiệm.



-- 130. Tạo một trigger để tự động cập nhật trạng thái "bận" của chuyên gia khi họ được phân công vào dự án mới.



-- 131. Tạo một trigger để ngăn chặn việc thêm kỹ năng trùng lặp cho một chuyên gia.
CREATE TRIGGER TRG_KN_TRUNG_CG
ON ChuyenGia_KyNang
AFTER INSERT
AS
BEGIN
	IF EXISTS (
		SELECT 1
		FROM inserted i
		JOIN ChuyenGia_KyNang CGKN
		ON i.MaChuyenGia = CGKN.MaChuyenGia
		AND i.MaKyNang = CGKN.MaKyNang
	)
	BEGIN
		RAISERROR('Không thể thêm kỹ năng trùng lặp cho một chuyên gia.', 16, 1);
		ROLLBACK TRANSACTION;
	END
END;

-- 132. Tạo một trigger để tự động tạo báo cáo tổng kết khi một dự án kết thúc.


-- 133. Tạo một trigger để tự động cập nhật thứ hạng của công ty dựa trên số lượng dự án hoàn thành và điểm đánh giá.



-- 133. (tiếp tục) Tạo một trigger để tự động cập nhật thứ hạng của công ty dựa trên số lượng dự án hoàn thành và điểm đánh giá.


-- 134. Tạo một trigger để tự động gửi thông báo khi một chuyên gia được thăng cấp (dựa trên số năm kinh nghiệm).


-- 135. Tạo một trigger để tự động cập nhật trạng thái "khẩn cấp" cho dự án khi thời gian còn lại ít hơn 10% tổng thời gian dự án.


-- 136. Tạo một trigger để tự động cập nhật số lượng dự án đang thực hiện của mỗi chuyên gia.


-- 137. Tạo một trigger để tự động tính toán và cập nhật tỷ lệ thành công của công ty dựa trên số dự án hoàn thành và tổng số dự án.

-- 138. Tạo một trigger để tự động ghi log mỗi khi có thay đổi trong bảng lương của chuyên gia.

-- 139. Tạo một trigger để tự động cập nhật số lượng chuyên gia cấp cao trong mỗi công ty.


-- 140. Tạo một trigger để tự động cập nhật trạng thái "cần bổ sung nhân lực" cho dự án khi số lượng chuyên gia tham gia ít hơn yêu cầu.


