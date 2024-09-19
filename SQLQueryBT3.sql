--Query của 23521360 Phạm Nguyễn Thanh Sơn
--Sinh viên hoàn thành Phần I bài tập QuanLyGiaoVu từ câu 3 đến câu 8

--3. Thuộc tính GIOITINH chỉ có giá trị là “Nam” hoặc “Nu”.
ALTER TABLE GIAOVIEN
ADD CONSTRAINT CHK_GIOITINHGV CHECK (GIOITINH IN ('Nam', 'Nu'))
ALTER TABLE HOCVIEN
ADD CONSTRAINT CHK_GIOITINHHV CHECK (GIOITINH IN ('Nam', 'Nu'));

--4. Điểm số của một lần thi có giá trị từ 0 đến 10 và cần lưu đến 2 số lẽ (VD: 6.22).
ALTER TABLE KETQUATHI
ALTER COLUMN DIEM DECIMAL(4, 2); -- Đổi thành kiểu dữ liệu lưu đến 2 thập phân lẻ trước
ALTER TABLE KETQUATHI
ADD CONSTRAINT CHK_DIEM CHECK (DIEM >= 0 AND DIEM <= 10); --Ràng buộc điểm từ 0 đến 10 sau

--5. Kết quả thi là “Dat” nếu điểm từ 5 đến 10 và “Khong dat” nếu điểm nhỏ hơn 5.
ALTER TABLE KETQUATHI ADD CONSTRAINT CHK_KETQUA CHECK
(	
	(KQUA = 'Dat' AND DIEM >= 0 AND DIEM <= 10)
	OR (KQUA = 'Khong dat' AND DIEM < 5)
)

--6. Học viên thi một môn tối đa 3 lần
ALTER TABLE KETQUATHI
ADD CONSTRAINT CHK_LANTHI CHECK(LANTHI <= 3);

--7. Học kỳ chỉ có giá trị từ 1 đến 3.
ALTER TABLE GIANGDAY
ADD CONSTRAINT CHK_HOCKY CHECK (HOCKY >= 1 AND HOCKY <= 3);

--8. Học vị của giáo viên chỉ có thể là “CN”, “KS”, “Ths”, ”TS”, ”PTS”.
ALTER TABLE GIAOVIEN
ADD CONSTRAINT CHK_HOCVI CHECK (HOCVI IN ('CN', 'KS' , 'Ths' , 'TS', 'PTS'));
