#!/bin/bash
# ============================================================
# VPS Remote Access Setup Script
# สำหรับ Ubuntu/Debian - Hostinger VPS
# รันด้วย: bash setup_vps.sh
# ============================================================

set -e  # หยุดถ้า error

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  VPS Python Dev Environment Setup     ${NC}"
echo -e "${GREEN}========================================${NC}"

# ---- 1. อัปเดต system ----
echo -e "\n${YELLOW}[1/6] อัปเดต system packages...${NC}"
sudo apt update -y && sudo apt upgrade -y

# ---- 2. ติดตั้ง Python + pip ----
echo -e "\n${YELLOW}[2/6] ติดตั้ง Python 3 และ pip...${NC}"
sudo apt install -y python3 python3-pip python3-venv git curl wget

# ---- 3. สร้าง virtual environment ----
echo -e "\n${YELLOW}[3/6] สร้าง virtual environment...${NC}"
python3 -m venv ~/pyenv
source ~/pyenv/bin/activate

# ---- 4. ติดตั้ง Python packages ----
echo -e "\n${YELLOW}[4/6] ติดตั้ง Python packages (pandas, jupyter, openpyxl...)${NC}"
pip install --upgrade pip
pip install \
    jupyter \
    jupyterlab \
    pandas \
    numpy \
    openpyxl \
    xlrd \
    xlwt \
    matplotlib \
    seaborn \
    requests \
    beautifulsoup4 \
    lxml \
    ipywidgets

# ---- 5. ตั้งค่า Jupyter Notebook สำหรับ remote access ----
echo -e "\n${YELLOW}[5/6] ตั้งค่า Jupyter สำหรับ remote access...${NC}"

# สร้าง config file
jupyter notebook --generate-config

JUPYTER_CONFIG=~/.jupyter/jupyter_notebook_config.py

# ตั้งค่า: อนุญาตทุก IP, ปิด browser auto-open, กำหนด port
cat >> "$JUPYTER_CONFIG" << 'EOF'

# === Remote Access Settings ===
c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.port = 8888
c.NotebookApp.open_browser = False
c.NotebookApp.allow_remote_access = True
EOF

echo -e "${GREEN}Jupyter config เสร็จแล้ว${NC}"

# ---- 6. ตั้งค่า systemd service (auto-start) ----
echo -e "\n${YELLOW}[6/6] สร้าง systemd service สำหรับ Jupyter...${NC}"

VENV_PATH="$HOME/pyenv"
USERNAME=$(whoami)

sudo tee /etc/systemd/system/jupyter.service > /dev/null << EOF
[Unit]
Description=Jupyter Notebook Server
After=network.target

[Service]
Type=simple
User=${USERNAME}
ExecStart=${VENV_PATH}/bin/jupyter notebook --config=/home/${USERNAME}/.jupyter/jupyter_notebook_config.py
WorkingDirectory=/home/${USERNAME}
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable jupyter
sudo systemctl start jupyter

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}  Setup เสร็จแล้ว!                     ${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "เปิด Jupyter ได้ที่: ${YELLOW}http://YOUR_VPS_IP:8888${NC}"
echo ""
echo -e "ดู token ด้วยคำสั่ง:"
echo -e "  ${YELLOW}jupyter notebook list${NC}"
echo ""
echo -e "ดู service status:"
echo -e "  ${YELLOW}sudo systemctl status jupyter${NC}"
echo ""
echo -e "${RED}อย่าลืมเปิด port 8888 ใน Hostinger firewall!${NC}"
