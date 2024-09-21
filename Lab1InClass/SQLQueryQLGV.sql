﻿CREATE TABLE HOCVIEN (
    MAHV CHAR(5) PRIMARY KEY,
    HO VARCHAR(40),
    TEN VARCHAR(10),     
    NGSINH SMALLDATETIME,      
    GIOITINH VARCHAR(3),
    NOISINH VARCHAR(40),
    MALOP CHAR(3)
);
CREATE TABLE LOP (
    MALOP CHAR(3) PRIMARY KEY,
    TENLOP VARCHAR(40),
    TRGLOP CHAR(5),
    SISO TINYINT,
    MAGVCN CHAR(4),
);

CREATE TABLE KHOA (
    MAKHOA VARCHAR(4) PRIMARY KEY,
    TENKHOA VARCHAR(40),
    NGTLAP SMALLDATETIME,
    TRGKHOA CHAR(4),
);

CREATE TABLE MONHOC (
    MAMH VARCHAR(10) PRIMARY KEY,
    TENMH VARCHAR(40),
    TCLT TINYINT,
    TCTH TINYINT,
    MAKHOA VARCHAR(4),
    FOREIGN KEY (MAKHOA) REFERENCES KHOA(MAKHOA)
);

CREATE TABLE DIEUKIEN (
    MAMH VARCHAR(10),
    MAMH_TRUOC VARCHAR(10),
    PRIMARY KEY (MAMH, MAMH_TRUOC),
    FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH),
    FOREIGN KEY (MAMH_TRUOC) REFERENCES MONHOC(MAMH)
);

CREATE TABLE GIAOVIEN (
    MAGV CHAR(4) PRIMARY KEY,
    HOTEN VARCHAR(40),
    HOCVI VARCHAR(10),
    HOCHAM VARCHAR(10),
    GIOITINH VARCHAR(3),
    NGSINH SMALLDATETIME,
    NGVL SMALLDATETIME,
    HESO NUMERIC(4,2),
    MUCLUONG MONEY,
    MAKHOA VARCHAR(4),
    FOREIGN KEY (MAKHOA) REFERENCES KHOA(MAKHOA)
);

CREATE TABLE GIANGDAY (
    MALOP CHAR(3),
    MAMH VARCHAR(10),
    MAGV CHAR(4),
    HOCKY TINYINT,
    NAM SMALLINT,
    TUNGAY SMALLDATETIME,
    DENNGAY SMALLDATETIME,
    PRIMARY KEY (MALOP, MAMH, MAGV, HOCKY, NAM),
    FOREIGN KEY (MALOP) REFERENCES LOP(MALOP),
    FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH),
    FOREIGN KEY (MAGV) REFERENCES GIAOVIEN(MAGV)
);

CREATE TABLE KETQUATHI (
    MAHV CHAR(5),
    MAMH VARCHAR(10),
    LANTHI TINYINT,
    NGTHI SMALLDATETIME,
    DIEM NUMERIC(4,2),
    KQUA VARCHAR(10),
    PRIMARY KEY (MAHV, MAMH, LANTHI),
    FOREIGN KEY (MAHV) REFERENCES HOCVIEN(MAHV),
    FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH)
);

ALTER TABLE HOCVIEN
ADD CONSTRAINT FK_HOCVIEN_LOP
FOREIGN KEY (MALOP)
REFERENCES LOP(MALOP);

ALTER TABLE LOP
ADD CONSTRAINT FK_LOP_GIAOVIEN
FOREIGN KEY (MAGVCN)
REFERENCES GIAOVIEN(MAGV);

ALTER TABLE KHOA
ADD CONSTRAINT FK_KHOA_GIAOVIEN
FOREIGN KEY (TRGKHOA)
REFERENCES GIAOVIEN(MAGV);


