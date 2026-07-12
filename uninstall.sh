#!/bin/bash
# NoWin 卸载脚本

GREEN='\033[32m'
NC='\033[0m'

echo -e "${GREEN}🧹 卸载 NoWin...${NC}"

# 移除别名
sed -i '/alias exe=/d' ~/.bashrc ~/.zshrc 2>/dev/null

# 删除文件
rm -f /usr/local/bin/nowin
rm -rf /usr/local/share/nowin

echo -e "${GREEN}✅ 已移除，世界清净了${NC}"