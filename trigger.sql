use banhang;
go
create trigger capnhatkho_hoadon on chitiethoadon -- trigger nằm ở bảng chittiethoadon
after insert -- thời điểm kích hoạt 
as
begin
	update sanpham -- thay đổi dữ liệu 
	set soluong = sanpham.soluong - i.soluong
	from sanpham
	inner join inserted i on sanpham.masp=i.masp; -- khi thêm 1 dòng vào chitiethoadon, sql tạo ra 1 bảng ảo là inserted 
end;
create trigger nhapkho_giavon on chitietphieunhap
after insert
as
begin
	update sanpham
	set 
	-- tính lại giá vốn theo bình quân gia quyền
	giavon= case
				when (sanpham.soluong + i.soluong)=0 then i.dongia
				else ((sanpham.soluong * sanpham.giavon)+(i.soluong * i.dongia))/(sanpham.soluong +i.soluong)
			end,
	--cập nhật thêm số luọng vào kho
	soluong= sanpham.soluong+i.soluong
	from sanpham
	inner join inserted i on sanpham.masp=i.masp;
end;
create trigger kiemtratonkho on chitiethoadon
instead of insert -- dùng instead of để chặn trước khi dl vào bảng
as
begin
	if exists (
		select 1
		from inserted i
		join sanpham sp on i.masp=sp.masp
		where i.soluong>0 and i.soluong>sp.soluong -- chỉ kiểm tra khi bán, số lượng dương
		)
		begin
			raiserror ('Lỗi: Số lượng tồn kho không đủ!',16,1);
			rollback transaction;
		end
		else
		begin
			insert into chitiethoadon select*from inserted;
		end
end;
create trigger tinhtongtien on chitiethoadon
after insert, update, delete
as 
begin
	update hoadon
	set tongtien=(select sum(soluong*giaban) from chitiethoadon where mahd=hoadon.mahd)
	where mahd in (select mahd from inserted union select mahd from deleted);
end;
