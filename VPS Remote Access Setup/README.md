# VPS Remote Access - คู่มือฉบับสมบูรณ์
**Hostinger VPS (Ubuntu) + Jupyter Notebook + VS Code Remote SSH**

---

## ขั้นตอนทั้งหมด

### ส่วน A: เชื่อมต่อ VPS ครั้งแรก (SSH)

#### 1. หา IP ของ VPS
- เข้า Hostinger hPanel → VPS → ดู **IP Address**

#### 2. เชื่อมต่อผ่าน SSH (จาก Windows/Mac)

**Windows** — เปิด PowerShell หรือ Terminal:
```bash
ssh root@YOUR_VPS_IP
```

**Mac/Linux** — เปิด Terminal:
```bash
ssh root@YOUR_VPS_IP
```

ใส่ password ที่ได้จาก Hostinger

---

### ส่วน B: Setup SSH Key (ไม่ต้องพิมพ์ password ทุกครั้ง)

**บนเครื่องตัวเอง** (ไม่ใช่ VPS):
```bash
# สร้าง SSH key
ssh-keygen -t ed25519 -C "your-email@example.com"

# ส่ง key ไปยัง VPS
ssh-copy-id root@YOUR_VPS_IP
```

ทดสอบ:
```bash
ssh root@YOUR_VPS_IP  # ควรเข้าได้เลยไม่ต้องพิมพ์ password
```

---

### ส่วน C: รัน Setup Script บน VPS

**1. Upload script ไปยัง VPS:**
```bash
scp setup_vps.sh root@YOUR_VPS_IP:~/
```

**2. รัน script บน VPS:**
```bash
ssh root@YOUR_VPS_IP
bash ~/setup_vps.sh
```

รอประมาณ 5-10 นาที

---

### ส่วน D: เปิด Port บน Hostinger Firewall

1. เข้า **Hostinger hPanel** → **VPS** → **Firewall**
2. เพิ่ม rule:
   - Port: `8888`
   - Protocol: `TCP`
   - Source: `0.0.0.0/0` (ทุก IP) หรือ IP ที่ทำงาน
3. Save

---

### ส่วน E: เข้าใช้ Jupyter Notebook

**ดู token สำหรับ login:**
```bash
ssh root@YOUR_VPS_IP
jupyter notebook list
```

จะเห็นบางอย่างแบบนี้:
```
http://0.0.0.0:8888/?token=abc123def456...
```

**เปิด browser บนเครื่องตัวเอง:**
```
http://YOUR_VPS_IP:8888/?token=abc123def456...
```

---

### ส่วน F: VS Code Remote SSH (ทางเลือก - แนะนำ)

1. ติดตั้ง VS Code extension: **Remote - SSH**
2. กด `Ctrl+Shift+P` → พิมพ์ `Remote-SSH: Connect to Host`
3. ใส่: `root@YOUR_VPS_IP`
4. เปิด folder บน VPS ได้เลย

---

## คำสั่งที่ใช้บ่อย

| คำสั่ง | ความหมาย |
|--------|-----------|
| `sudo systemctl status jupyter` | ดู status Jupyter service |
| `sudo systemctl start jupyter` | เริ่ม Jupyter |
| `sudo systemctl stop jupyter` | หยุด Jupyter |
| `sudo systemctl restart jupyter` | restart Jupyter |
| `jupyter notebook list` | ดู token |
| `source ~/pyenv/bin/activate` | เปิด virtual environment |

---

## SSH Tunnel (ทางเลือกที่ปลอดภัยกว่า)

แทนที่จะเปิด port 8888 สาธารณะ ใช้ SSH tunnel แทน:

```bash
# รันบนเครื่องตัวเอง
ssh -L 8888:localhost:8888 root@YOUR_VPS_IP
```

แล้วเปิด browser: `http://localhost:8888`

---

## Troubleshooting

| ปัญหา | วิธีแก้ |
|-------|---------|
| เชื่อมต่อไม่ได้ | ตรวจ IP และ Hostinger firewall |
| Jupyter ไม่เริ่ม | `sudo systemctl restart jupyter` |
| token หาย | `jupyter notebook list` |
| port ไม่เปิด | ตรวจ Hostinger hPanel → Firewall |
