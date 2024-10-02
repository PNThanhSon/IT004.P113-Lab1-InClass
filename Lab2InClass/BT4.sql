--11. Học viên ít nhất là 18 tuổi.
ALTER TABLE HOCVIEN
ADD CONSTRAINT CHK_HV CHECK (YEAR(GETDATE()) - YEAR(NGSINH) >= 18);

--12. Giảng dạy một môn học ngày bắt đầu (TUNGAY) phải nhỏ hơn ngày kết thúc (DENNGAY).
ALTER TABLE GIANGDAY
ADD CONSTRAINT CHK_GIANGDAY CHECK (TUNGAY < DENNGAY);

--13. Giáo viên khi vào làm ít nhất là 22 tuổi.
ALTER TABLE GIAOVIEN
ADD CONSTRAINT CHECK_VAOLAM CHECK (YEAR(NGVL) - YEAR(NGSINH) > 22);

--14. Tất cả các môn học đều có số tín chỉ lý thuyết và tín chỉ thực hành chênh lệch nhau không quá 3.
ALTER TABLE MONHOC
ADD CONSTRAINT CHECK_TC CHECK (ABS(TCLT - TCTH) <= 3);