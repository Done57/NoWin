#!/bin/bash
# NoWin 卸载脚本

GREEN='\033[32m'
NC='\033[0m'

echo -e "${GREEN}卸载 NoWin...${NC}"

# 移除别名（只删 exe）
sed -i '/alias exe=/d' ~/.bashrc ~/.zshrc 2>/dev/null

# 删除文件
PREFIX=${PREFIX:-/data/data/com.termux/files/usr}
rm -f $PREFIX/bin/nowin
rm -rf $PREFIX/share/nowin

echo -e "${GREEN}已移除${NC}"