# Deploy MenuGoBE lên Fly.io

## 1. Tạo tài khoản Fly.io
- Vào https://fly.io
- Sign up (cần thẻ tín dụng để xác minh, KHÔNG bị charge trên free tier)

## 2. Cài Fly CLI (Windows PowerShell)
```powershell
powershell -Command "iwr https://fly.io/install.ps1 -useb | iex"
```

## 3. Login
```powershell
fly auth login
```

## 4. Khởi tạo app (CHẠY 1 LẦN trong thư mục be/)
```powershell
cd c:\Users\hoang\Downloads\be
fly launch --no-deploy
```
- Khi hỏi tên app → nhập `menugo-be` (hoặc tên khác)
- Chọn region: **Singapore (sin)**
- Chọn KHÔNG setup Postgres (Postgres có sẵn rồi)

## 5. Set environment variables (DATABASE_URL)
```powershell
fly secrets set DATABASE_URL="Host=...;Port=5432;Database=...;Username=...;Password=...;Include Error Detail=true"
```
Lấy connection string từ Railway Postgres hoặc Neon/Supabase.

Các secrets cần thiết:
- `DATABASE_URL` - PostgreSQL connection string
- `JWT_SECRET` - secret key cho JWT (nếu có)
- `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET` - nếu dùng Google OAuth
- `CLOUDINARY_*` - nếu dùng upload ảnh

## 6. Deploy lần đầu
```powershell
fly deploy
```

## 7. Mở app
```powershell
fly open
```

## 8. Update lần sau
Sau khi sửa code:
```powershell
fly deploy
```

## Các lệnh hữu ích
```powershell
fly status              # Trạng thái app
fly logs                # Xem logs
fly ssh console         # SSH vào container
fly secrets list        # Xem secrets
fly scale count 1       # Số lượng máy (giữ 1 cho free)
```

## Lưu ý về Performance
- Fly.io Singapore ping VN ~30-50ms (rất nhanh)
- Cold start ~5-10s cho app .NET
- Free tier: 3 shared VMs, 256MB RAM mỗi cái
- Auto stop/start khi không có traffic (giữ nguyên khi có 1 instance)

## Troubleshooting
- App bị 502 → check `fly logs`
- DB không connect → check DATABASE_URL đúng chưa
- SignalR không work → Fly.io hỗ trợ WebSocket tốt
