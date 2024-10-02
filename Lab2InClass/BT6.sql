--1. In ra danh sách (mã học viên, họ tên, ngày sinh, mã lớp) lớp trưởng của các lớp.
SELECT HOCVIEN.MAHV, HOCVIEN.HO, HOCVIEN.TEN, HOCVIEN.MALOP
FROM HOCVIEN, LOP
WHERE LOP.TRGLOP = HOCVIEN.MAHV;

--2. In ra bảng điểm khi thi (mã học viên, họ tên, lần thi, điểm số) môn CTRR của lớp “K12”, sắp xếp theo tên, họ học viên.
SELECT HOCVIEN.MAHV, HOCVIEN.HO, HOCVIEN.TEN, KETQUATHI.LANTHI, KETQUATHI.DIEM
FROM HOCVIEN, KETQUATHI
WHERE KETQUATHI.MAHV = HOCVIEN.MAHV
AND HOCVIEN.MALOP = 'K12'
AND KETQUATHI.MAMH = 'CTRR'
ORDER BY HOCVIEN.TEN, HOCVIEN.HO;

--3. In ra danh sách những học viên (mã học viên, họ tên) và những môn học mà học viên đó thi lần thứ nhất đã đạt.
SELECT HOCVIEN.MAHV, HOCVIEN.HO, HOCVIEN.TEN, MONHOC.TENMH
FROM HOCVIEN, KETQUATHI, MONHOC
WHERE KETQUATHI.MAHV = HOCVIEN.MAHV
AND KETQUATHI.MAMH = MONHOC.MAMH
AND LANTHI = 1 AND KQUA = 'Dat';

--4. In ra danh sách học viên (mã học viên, họ tên) của lớp “K11” thi môn CTRR không đạt (ở lần thi 1).
SELECT HOCVIEN.MAHV, HOCVIEN.HO, HOCVIEN.TEN
FROM HOCVIEN, KETQUATHI
WHERE KETQUATHI.MAHV = HOCVIEN.MAHV
AND HOCVIEN.MALOP = 'K11'
AND KETQUATHI.MAMH = 'CTRR'
AND KETQUATHI.LANTHI = 1 AND KQUA = 'Khong Dat';

--5. * Danh sách học viên (mã học viên, họ tên) của lớp “K” thi môn CTRR không đạt (ở tất cả các lần thi).
SELECT DISTINCT HOCVIEN.MAHV, HOCVIEN.HO, HOCVIEN.TEN
FROM HOCVIEN, KETQUATHI
WHERE KETQUATHI.MAHV = HOCVIEN.MAHV
AND HOCVIEN.MALOP LIKE 'K%'
AND KETQUATHI.MAMH = 'CTRR'
AND HOCVIEN.MAHV NOT IN (
    SELECT MAHV
    FROM KETQUATHI
    WHERE MAMH = 'CTRR'
    AND KQUA = 'Dat'
);