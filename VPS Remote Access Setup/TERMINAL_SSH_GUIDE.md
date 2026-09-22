# Terminal SSH + Claude CLI - คู่มือเบาๆ
**สำหรับ Hostinger VPS + Claude CLI บน SSH Terminal**

---

## ขั้นตอนแรก: SSH Key Setup (ครั้งแรกครั้งเดียว)

### 1. สร้าง SSH Key บนเครื่องตัวเอง

**Windows (PowerShell):**
```powershell
ssh-keygen -t ed25519 -C "your-email@gmail.com"
# กด Enter 3 ครั้ง (default path, ไม่มี passphrase)
```

**Mac/Linux (Terminal):**
```bash
ssh-keygen -t ed25519 -C "your-email@gmail.com"
# กด Enter 3 ครั้ง
```

### 2. ส่ง Public Key ไปยัง VPS

```bash
ssh-copy-id root@YOUR_VPS_IP
# พิมพ์ password Hostinger ที่ได้
```

### 3. ทดสอบ SSH (ไม่ต้องพิมพ์ password)

```bash
ssh root@YOUR_VPS_IP
# ควรเข้าได้เลยโดยไม่ต้องพิมพ์ password
```

---

## ขั้นตอนที่สอง: ตั้งค่า SSH Config (ง่ายขึ้น)

สร้างไฟล์ `~/.ssh/config` บนเครื่องตัวเอง:

**Windows (PowerShell):**
```powershell
Add-Content $env:USERPROFILE\.ssh\config @"
Host vps
    HostName YOUR_VPS_IP
    User root
    IdentityFile $env:USERPROFILE\.ssh\id_ed25519
"@
```

**Mac/Linux:**
```bash
cat >> ~/.ssh/config << 'EOF'
Host vps
    HostName YOUR_VPS_IP
    User root
    IdentityFile ~/.ssh/id_ed25519
EOF
```

หลังจากนี้พิมพ์แค่:
```bash
ssh vps
```

---

## ใช้ Claude CLI บน VPS

### เข้า VPS
```bash
ssh vps
```

### ใช้ Claude CLI
```bash
claude
```

**ตัวอย่างการใช้:**
```bash
# ถามคำถาม
claude "แปลข้อความนี้เป็นไทย: Hello world"

# ดูไฟล์และขอให้อ่าน
claude -f script.py "อธิบายฟังก์ชั่นนี้"

# ได้รับโค้ด Python
claude "เขียน script pandas ที่อ่าน CSV และแสดง summary"
```

---

## Workflow ปกติ

```bash
# 1. เข้า VPS
ssh vps

# 2. ไปยัง project folder
cd /path/to/your/project

# 3. ใช้ Claude CLI
claude "สร้าง function ที่..."

# 4. นำโค้ดที่ได้ไปแก้ไขไฟล์
nano script.py  # หรือ vim

# 5. รัน script
python3 script.py

# 6. ถ้าต้องการ Claude ช่วยแก้ error
claude "แก้ error นี้: [paste error message]"
```

---

## คำสั่งที่ใช้บ่อย

| คำสั่ง | ความหมาย |
|--------|-----------|
| `ssh vps` | เข้า VPS |
| `exit` | ออกจาก VPS |
| `pwd` | ดู path ปัจจุบัน |
| `ls` | ดูไฟล์ในโฟลเดอร์ |
| `cd folder/` | เปลี่ยน folder |
| `python3 script.py` | รัน Python script |
| `nano file.py` | แก้ไขไฟล์ |
| `claude "prompt"` | ใช้ Claude CLI |

---

## Tips ให้ทำงานสะดวก

### 1. ใช้ `screen` หรือ `tmux` (เปิดหลาย session)
```bash
# เปิด session ใหม่
screen -S work

# ออกจาก session (background)
Ctrl+A แล้ว D

# กลับเข้า session เดิม
screen -r work
```

### 2. Upload/Download File
```bash
# Download ไฟล์จาก VPS ไป local
scp root@YOUR_VPS_IP:/path/file.csv ~/Downloads/

# Upload ไฟล์จาก local ไปยัง VPS
scp ~/file.py root@YOUR_VPS_IP:~/
```

### 3. สร้าง Alias เพื่อใช้สั้นลง
```bash
# Add to ~/.bash_profile หรือ ~/.zshrc
alias svps='ssh vps'
alias cvps='ssh vps && cd /your/project/path'
```

แล้วใช้:
```bash
svps    # ไป VPS
cvps    # ไป VPS + project folder
```

---

## Troubleshooting

| ปัญหา | วิธีแก้ |
|-------|---------|
| `Permission denied (publickey)` | รัน `ssh-copy-id root@YOUR_VPS_IP` อีกครั้ง |
| `Could not resolve hostname` | ตรวจสอบ IP ของ VPS |
| `Claude CLI not found` | ตรวจสอบว่า Claude CLI ลงบน VPS แล้ว (`which claude`) |
| `Connection timeout` | ตรวจสอบ Hostinger Firewall ว่าเปิด port 22 |

---

## IP ของ VPS
ดูได้ที่: **Hostinger hPanel → VPS → Overview → IP Address**
