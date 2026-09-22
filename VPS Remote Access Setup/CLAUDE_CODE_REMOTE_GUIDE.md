# Claude Code Remote - ทำงาน Code บน VPS
**Hostinger VPS + Claude Code Remote Session**

---

## ข้อดี Claude Code Remote

✅ IDE เต็มแบบ (file explorer, terminal, editor)
✅ Claude ทำงานตรงบน VPS
✅ Fast mode + prompt caching ใช้ได้
✅ Run tests/scripts ตรงบน VPS
✅ Easy version control (git push ตรง)

---

## ขั้นตอนเตรียมตัว (VPS)

### 1. ตั้งค่า SSH สำหรับ Claude Code

ให้ Claude Code Remote สามารถเข้า VPS ได้ ต้องมี public key authentication

```bash
# บน VPS - ดูว่า SSH configured แล้ว
ssh-keygen -A  # สร้าง host keys ถ้ายังไม่มี

# ตรวจสอบ SSH service ทำงาน
sudo systemctl status ssh

# ถ้ายังไม่เปิด ให้เปิด
sudo systemctl start ssh
sudo systemctl enable ssh
```

### 2. Hostinger Firewall - เปิด Port 22 (SSH)

1. เข้า **Hostinger hPanel** → **VPS** → **Firewall**
2. เพิ่ม Rule:
   - **Port:** `22`
   - **Protocol:** `TCP`
   - **Source:** `0.0.0.0/0` (or IP ที่ทำงาน)
3. Save

---

## วิธี 1: SSH Key Setup (แนะนำ)

### บนเครื่องตัวเอง สร้าง SSH Key

```bash
ssh-keygen -t ed25519 -C "your-email@gmail.com"
# ใช้ default path ~/.ssh/id_ed25519
# ไม่ต้อง passphrase
```

### ส่ง Public Key ไปยัง VPS

```bash
ssh-copy-id root@YOUR_VPS_IP
# พิมพ์ password ตัวเดียวครั้งเดียว
```

### ทดสอบ
```bash
ssh root@YOUR_VPS_IP  # ต้องเข้าได้โดยไม่ต้องพิมพ์ password
exit
```

---

## วิธี 2: ใช้ Password (ง่ายกว่า แต่ต่ำกว่า security)

ถ้าไม่อยากตั้ง SSH key ใหม่ ใช้ password ของ VPS ได้

---

## สร้าง Claude Code Remote Session

### ใน Claude Code CLI บนเครื่องตัวเอง

```bash
# ตั้ง environment สำหรับ VPS
claude code \
  --remote \
  --source-url ssh://root@YOUR_VPS_IP:/root \
  --title "My VPS Project"
```

### หรือจาก Web (claude.ai/code)

1. ไป **claude.ai/code**
2. คลิก **+ New Session**
3. เลือก **Remote execution**
4. กรอก SSH connection:
   ```
   SSH: root@YOUR_VPS_IP
   Port: 22
   ```
5. ใส่ Private Key หรือ Password

---

## หลังเข้า Claude Code Remote Session

### Terminal ของคุณคือ VPS Terminal
```bash
# ทำงานบน VPS โดยตรง
python3 script.py
pip install pandas
git clone https://github.com/your-repo.git
```

### Claude CLI ทำงาน บน VPS
```bash
claude "อ่านไฟล์นี้และอธิบาย" -f script.py
```

---

## ตั้งค่า Project Repository บน VPS

### Option A: Clone Repository มา
```bash
cd ~
git clone https://github.com/ChakitJ/python-course-for-excel-users.git
cd python-course-for-excel-users
```

### Option B: Initialize Git Repository ใหม่
```bash
cd ~/my-project
git init
git config user.name "Your Name"
git config user.email "your-email@gmail.com"
```

---

## Workflow ทั่วไป

```
1. เข้า Claude Code Remote session
   ↓
2. Terminal: cd /your/project
   ↓
3. สร้าง/แก้ไขไฟล์บน IDE
   ↓
4. Terminal: python3 script.py (รัน test)
   ↓
5. Claude ช่วยแก้ error/improve code
   ↓
6. Terminal: git add . && git commit -m "message" && git push
```

---

## Tips

### 1. SSH Config เพื่อใช้ง่าย

สร้าง `~/.ssh/config`:
```
Host vps
    HostName YOUR_VPS_IP
    User root
    IdentityFile ~/.ssh/id_ed25519
```

ใช้ `ssh vps` แทนพิมพ์ IP ทั้งหมด

### 2. ตั้ง Git User บน VPS
```bash
git config --global user.name "Your Name"
git config --global user.email "your-email@gmail.com"
git config --global credential.helper store
```

### 3. ทำให้ Python ใช้งาน
```bash
python3 -m venv ~/venv
source ~/venv/bin/activate
pip install pandas numpy openpyxl jupyter
```

---

## Troubleshooting

| ปัญหา | วิธีแก้ |
|-------|---------|
| `Connection refused` | ตรวจสอบ SSH service: `sudo systemctl status ssh` |
| `Permission denied` | ตรวจสอบ public key: `cat ~/.ssh/id_ed25519.pub` ส่งไป VPS |
| `Port 22 closed` | เปิด port 22 ใน Hostinger Firewall |
| `Authentication failed` | ใช้ password แทน หรือ setup SSH key ใหม่ |
| `Slow connection` | ตรวจสอบ VPS network speed |

---

## Links

- Hostinger hPanel: https://hpanel.hostinger.com/
- Claude Code Docs: https://claude.ai/code
- SSH Setup Guide: `VPS Remote Access Setup/TERMINAL_SSH_GUIDE.md`
