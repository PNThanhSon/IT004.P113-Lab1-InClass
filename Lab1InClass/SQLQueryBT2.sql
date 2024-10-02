--Query của 23521360 Phạm Nguyễn Thanh Sơn
--Sinh viên hoàn thành Phần I bài tập QuanLyBanHang từ câu 2 đến câu 10

--2. Thêm vào thuộc tính GHICHU có kiểu dữ liệu varchar(20) cho quan hệ SANPHAM.
ALTER TABLE SANPHAM ADD GHICHU VARCHAR(20);

--3. Thêm vào thuộc tính LOAIKH có kiểu dữ liệu là tinyint cho quan hệ KHACHHANG
ALTER TABLE KHACHHANG ADD LOAIKH TINYINT;

--4. Sửa kiểu dữ liệu của thuộc tính GHICHU trong quan hệ SANPHAM thành varchar(100)
ALTER TABLE SANPHAM
ALTER COLUMN GHICHU VARCHAR(100);

--5. Xóa thuộc tính GHICHU trong quan hệ SANPHAM
ALTER TABLE SANPHAM DROP COLUMN GHICHU;

/*6. Làm thế nào để thuộc tính LOAIKH trong quan hệ KHACHHANG
có thể lưu các giá trị là: “Vang lai”, “Thuong xuyen”, “Vip”…

Em sử dụng kiểu dữ liệu varchar(20)
*/
ALTER TABLE KHACHHANG
ALTER COLUMN LOAIKH VARCHAR(20);
ALTER TABLE KHACHHANG
ADD CONSTRAINT CHECK_LOAIKH CHECK(LOAIKH IN('Vang
lai', 'Thuong xuyen', 'Vip');

--7. Đơn vị tính của sản phẩm chỉ có thể là (“cay”,”hop”,”cai”,”quyen”,”chuc”)
ALTER TABLE SANPHAM
ADD CONSTRAINT CHK_DVT CHECK (DVT IN ('cay', 'hop', 'cai', 'quyen', 'chuc'));

--8. Giá bán của sản phẩm từ 500 đồng trở lên.
ALTER TABLE SANPHAM
ADD CONSTRAINT CHK_GIA CHECK (GIA >= 500);

--9. Mỗi lần mua hàng, khách hàng phải mua ít nhất 1 sản phẩm.
ALTER TABLE CTHD
ADD CONSTRAINT CHK_SL CHECK (SL >= 1);

--10. Ngày khách hàng đăng ký là khách hàng thành viên phải lớn hơn ngày sinh của người đó
ALTER TABLE KHACHHANG
ADD CONSTRAINT CHK_NGDK CHECK (NGDK > NGSINH);
