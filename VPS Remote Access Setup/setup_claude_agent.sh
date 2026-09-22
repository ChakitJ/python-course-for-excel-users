#!/bin/bash
# ============================================================
# Powerful Claude Code Agent - VPS Setup
# ทำให้ Claude Code บน VPS เก่งที่สุด (Ubuntu/Debian)
# รันด้วย: bash setup_claude_agent.sh
# ============================================================

set -e

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
echo -e "${GREEN}=== Powerful Claude Code Agent Setup ===${NC}"

# ---- 1. System tools ที่ Claude Code ใช้ได้ดี ----
echo -e "\n${YELLOW}[1/6] ติดตั้ง system tools (ripgrep, fd, jq, gh...)${NC}"
sudo apt update -y
sudo apt install -y \
    git curl wget unzip build-essential \
    ripgrep fd-find jq \
    python3 python3-pip python3-venv \
    tmux htop tree

# gh CLI (GitHub)
if ! command -v gh &> /dev/null; then
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update -y && sudo apt install -y gh
fi

# fd-find เรียกเป็น fdfind บน Ubuntu -> สร้าง alias fd
mkdir -p ~/.local/bin
ln -sf $(which fdfind) ~/.local/bin/fd 2>/dev/null || true

# ---- 2. Node.js (สำหรับ Claude Code + MCP servers) ----
echo -e "\n${YELLOW}[2/6] ติดตั้ง Node.js LTS...${NC}"
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs
fi

# ---- 3. Python data stack ----
echo -e "\n${YELLOW}[3/6] ติดตั้ง Python data stack...${NC}"
python3 -m venv ~/venv
source ~/venv/bin/activate
pip install --upgrade pip
pip install pandas numpy openpyxl xlrd matplotlib seaborn \
    requests beautifulsoup4 lxml jupyter python-dotenv

# ---- 4. Claude Code config directory ----
echo -e "\n${YELLOW}[4/6] ตั้งค่า Claude Code config...${NC}"
mkdir -p ~/.claude

# settings.json - permissions ให้ทำงานลื่น + model
cat > ~/.claude/settings.json << 'EOF'
{
  "model": "claude-opus-4-8",
  "permissions": {
    "allow": [
      "Bash(ls:*)",
      "Bash(cat:*)",
      "Bash(cd:*)",
      "Bash(pwd)",
      "Bash(python3:*)",
      "Bash(pip:*)",
      "Bash(pytest:*)",
      "Bash(git status)",
      "Bash(git diff:*)",
      "Bash(git log:*)",
      "Bash(git add:*)",
      "Bash(rg:*)",
      "Bash(fd:*)",
      "Bash(jq:*)",
      "Bash(tree:*)",
      "Read(*)",
      "Grep(*)",
      "Glob(*)"
    ]
  }
}
EOF

# ---- 5. MCP servers (filesystem + fetch) ----
echo -e "\n${YELLOW}[5/6] ตั้งค่า MCP servers...${NC}"
cat > ~/.claude/mcp_note.txt << 'EOF'
เพิ่ม MCP servers ด้วยคำสั่ง (รันในโปรเจกต์):

# Filesystem access
claude mcp add filesystem -- npx -y @modelcontextprotocol/server-filesystem ~/

# Fetch (ดึงข้อมูลเว็บ)
claude mcp add fetch -- npx -y @modelcontextprotocol/server-fetch

# GitHub (ต้องมี token)
claude mcp add github --env GITHUB_TOKEN=your_token -- npx -y @modelcontextprotocol/server-github

ดู MCP ที่มี: claude mcp list
EOF

# ---- 6. เพิ่ม PATH ----
echo -e "\n${YELLOW}[6/6] ตั้งค่า shell...${NC}"
if ! grep -q 'venv/bin/activate' ~/.bashrc; then
cat >> ~/.bashrc << 'EOF'

# === Claude Agent Setup ===
export PATH="$HOME/.local/bin:$PATH"
source ~/venv/bin/activate 2>/dev/null || true
alias claude-work='cd ~/projects && claude'
EOF
fi

echo -e "\n${GREEN}=== Setup เสร็จแล้ว! ===${NC}"
echo ""
echo -e "${YELLOW}ขั้นตอนถัดไป:${NC}"
echo "  1. source ~/.bashrc"
echo "  2. cd ~/your-project"
echo "  3. อ่าน ~/.claude/mcp_note.txt เพื่อเพิ่ม MCP servers"
echo "  4. สร้าง CLAUDE.md ในโปรเจกต์ (ดูตัวอย่างใน guide)"
echo "  5. รัน: claude"
echo ""
echo -e "${GREEN}Tools พร้อมใช้: python3, pandas, rg, fd, jq, gh, node, tmux${NC}"
