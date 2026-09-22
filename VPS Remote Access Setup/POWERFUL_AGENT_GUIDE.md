# Powerful Claude Code Agent บน VPS
**ทำให้ Claude Code เก่งที่สุดสำหรับงาน Python / Data Analysis / Excel**

---

## สรุปสั้น: อะไรทำให้ Agent "เจ๋ง"

| ด้าน | ทำไมสำคัญ |
|------|-----------|
| 🛠️ **Tools ที่ดี** | Claude ค้นหา/แก้ code เร็วขึ้นมาก (ripgrep, fd, jq, gh) |
| 🔌 **MCP servers** | ต่อกับ filesystem, web, GitHub, database |
| 📄 **CLAUDE.md** | Claude เข้าใจโปรเจกต์คุณโดยไม่ต้องอธิบายซ้ำ |
| ⚡ **Permissions** | ทำงานลื่น ไม่ต้องกด approve ทุกคำสั่ง |
| 🧠 **Skills** | ความรู้เฉพาะทาง (Excel, roster, data ops) |

---

## Step 1: รัน Setup Script (ครั้งเดียว)

```bash
# บน VPS
wget https://raw.githubusercontent.com/ChakitJ/python-course-for-excel-users/claude/vps-remote-access-kbkdv0/VPS%20Remote%20Access%20Setup/setup_claude_agent.sh

bash setup_claude_agent.sh
source ~/.bashrc
```

Script จะติดตั้ง:
- **ripgrep, fd, jq** — ค้นหาเร็ว (Claude ใช้บ่อยมาก)
- **gh CLI** — จัดการ GitHub
- **Node.js** — สำหรับ MCP servers
- **Python data stack** — pandas, numpy, openpyxl, jupyter
- **tmux** — session ค้างไว้ได้แม้ปิด SSH
- **Claude Code settings** — permissions + model

---

## Step 2: สร้าง CLAUDE.md ในโปรเจกต์ (สำคัญที่สุด)

นี่คือสิ่งที่ทำให้ agent เข้าใจงานคุณ วางไฟล์ `CLAUDE.md` ที่ root ของโปรเจกต์:

```markdown
# Project Context

## เกี่ยวกับงาน
งาน Data Analysis สำหรับโรงพยาบาล — จัดการ roster, Excel reports, dashboard

## Tech Stack
- Python 3 (pandas, openpyxl)
- Excel / Power Query / Power Automate
- Virtual env อยู่ที่ ~/venv (source ~/venv/bin/activate)

## Coding Style
- โค้ดที่วางใช้ได้ทันที ไม่ต้องอธิบายเยอะ
- แยกความชัดเจน: ชัดเจน / น่าจะเป็น / ยังไม่ชัวร์
- ตอบภาษาไทย ยกเว้น code/formula/technical terms

## Commands ที่ใช้บ่อย
- รัน script: `python3 script.py`
- test: `pytest`
- activate env: `source ~/venv/bin/activate`

## กฎสำคัญ (Roster)
- coverage จริง, target hours, fairness
- Friday female coverage, off-day balance
- consecutive workdays limit
```

> 💡 **Tip:** รัน `/init` ใน Claude Code เพื่อให้มันสร้าง CLAUDE.md อัตโนมัติจากการสแกนโปรเจกต์

---

## Step 3: เพิ่ม MCP Servers (ขยายความสามารถ)

```bash
# Filesystem — เข้าถึงไฟล์ทั้ง VPS
claude mcp add filesystem -- npx -y @modelcontextprotocol/server-filesystem ~/

# Fetch — ดึงข้อมูลจากเว็บ
claude mcp add fetch -- npx -y @modelcontextprotocol/server-fetch

# GitHub — จัดการ repo, PR, issues
claude mcp add github --env GITHUB_TOKEN=ghp_xxx -- npx -y @modelcontextprotocol/server-github

# ดู MCP ที่ติดตั้ง
claude mcp list
```

**MCP servers อื่นที่มีประโยชน์:**
- `@modelcontextprotocol/server-sqlite` — query database
- `@modelcontextprotocol/server-postgres` — PostgreSQL
- `@modelcontextprotocol/server-memory` — จำ context ข้ามครั้ง

---

## Step 4: ใช้ Subagents (พลังคูณหลายเท่า)

Claude Code สร้าง subagents สำหรับงานที่ทำพร้อมกันได้ เช่น:

```bash
# ใน Claude Code session พิมพ์แบบนี้
"ค้นหาทุกไฟล์ที่ใช้ pandas พร้อมกับตรวจสอบ error handling — ใช้ subagent"
```

Claude จะ spawn agents หลายตัวทำงานขนานกัน — เร็วกว่ามาก

---

## Step 5: Skills เฉพาะทาง

Claude Code รองรับ Skills — ชุดความรู้/workflow เฉพาะทาง

**ที่มีประโยชน์กับงานคุณ:**
- Excel workbook builder (pandas/openpyxl)
- Roster planning engine
- Data ops (Power Query/Power Automate)
- Executive analytics/dashboards

Skills โหลดอัตโนมัติเมื่องานตรงกับ description ของมัน

---

## Best Practices ทำให้ Agent เก่งขึ้น

### 1. ใช้ tmux เพื่อไม่ให้ session หลุด
```bash
tmux new -s claude       # เริ่ม session
# ทำงานกับ claude...
# Ctrl+B แล้ว D เพื่อ detach
tmux attach -t claude    # กลับเข้ามา
```

### 2. ให้ context ชัดเจน
- ❌ "แก้ bug"
- ✅ "แก้ error ใน roster.py บรรทัด 45 ที่ coverage คำนวณผิดตอนวันศุกร์"

### 3. ใช้ Plan mode สำหรับงานซับซ้อน
Claude วางแผนก่อนทำ ลด error

### 4. เก็บ credentials ปลอดภัย
```bash
# ใช้ .env file (อย่า commit)
echo "GITHUB_TOKEN=ghp_xxx" >> ~/.env
echo ".env" >> .gitignore
```

### 5. Model เลือกให้เหมาะ
- **Opus** — งานซับซ้อน วางแผน architecture
- **Sonnet** — งานทั่วไป balance ดี
- **Haiku** — งานเร็วๆ ประหยัด

---

## เช็คลิสต์ Agent พร้อมใช้

- [ ] รัน `setup_claude_agent.sh` แล้ว
- [ ] `source ~/.bashrc`
- [ ] ทดสอบ tools: `rg --version`, `python3 --version`, `gh --version`
- [ ] สร้าง `CLAUDE.md` ในโปรเจกต์ (หรือ `/init`)
- [ ] เพิ่ม MCP servers ที่ต้องการ
- [ ] ตั้ง GitHub token (`gh auth login`)
- [ ] ทดสอบ: `cd ~/project && claude`

---

## Troubleshooting

| ปัญหา | วิธีแก้ |
|-------|---------|
| `rg: command not found` | `sudo apt install ripgrep` |
| `fd: command not found` | `ln -sf $(which fdfind) ~/.local/bin/fd` |
| MCP server ไม่ทำงาน | ตรวจ `node --version` (ต้อง >= 18) |
| Permission prompts เยอะ | เพิ่มใน `~/.claude/settings.json` |
| session หลุดตอนปิด SSH | ใช้ `tmux` |
