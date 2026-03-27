create database banhang;
go 
USE banhang;
GO
CREATE TABLE khachhang (
	makh INT PRIMARY KEY IDENTITY (1,1),
	hoten NVARCHAR(100) NOT NULL,
	sdt VARCHAR(15),
	diachi NVARCHAR(200)
);
CREATE TABLE nhanvien(
	manv INT PRIMARY KEY IDENTITY (1,1),
	hoten NVARCHAR (100) NOT NULL,
	cccd VARCHAR(15),
	sdt varchar (15),
	diachi nvarchar (100)
);
create table sanpham(
	masp int primary key identity (1,1),
	tensp nvarchar(100) not null,
	mausac nvarchar(100),
	size varchar(10),
	soluong int,
	giaban decimal (18,2),
	giavon decimal (18,2)
);
CREATE TABLE hoadon (
	mahd INT PRIMARY KEY IDENTITY (1,1),
	makh INT,
	manv INT,
	thoigian DATETIME DEFAULT GETDATE(),
	tongtien DECIMAL (18,2) DEFAULT 0,
	CONSTRAINT fk_hoadon_khachhang FOREIGN KEY (makh)
	REFERENCES khachhang(makh),
	CONSTRAINT fk_hoadon_nhanvien FOREIGN KEY (manv) 
	REFERENCES nhanvien(manv)
);
create table chitiethoadon (
	mahd int,
	masp int,
	soluong int, -- -1 là bán, +1 là trả hàng 
	giaban decimal (18,2),
	giavon decimal (18,2),
	primary key (mahd, masp),
	constraint fk_cthd_hoadon foreign key (mahd) references hoadon (mahd),
	constraint fk_cthd_sanpham foreign key (masp) references sanpham (masp)
);
create table thanhtoan (
	matt int primary key identity (1,1),
	mahd int,
	sotien decimal (18,2),
	thoigian datetime default getdate(),
	constraint fk_thanhtoan_hoadon foreign key (mahd) references hoadon(mahd)
);
create table phieunhapkho (
	mapn int primary key identity (1,1),
	thoigian datetime default getdate(),
	tongtien decimal (18,2) default 0,
	manv int,
	constraint fk_phieunhapkho_nhanvien foreign key (manv) references nhanvien (manv)
);
create table chitietphieunhap (
	mapn int,
	masp int,
	soluong int,
	dongia decimal (18,2),
	primary key (mapn, masp),
	constraint fk_ctpn_phieunhapkho foreign key (mapn) references phieunhapkho (mapn),
	constraint fk_ctpn_sanpham foreign key (masp) references sanpham (masp)
);