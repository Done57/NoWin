#!/bin/bash
# NoWin 安装脚本 - Termux 版

GREEN='\033[32m'
RED='\033[31m'
NC='\033[0m'

echo -e "${GREEN}🔧 安装 NoWin 整蛊插件...${NC}"

# Termux 的 bin 目录
PREFIX=${PREFIX:-/data/data/com.termux/files/usr}

# 复制核心脚本
cp src/nowin.sh $PREFIX/bin/nowin
chmod +x $PREFIX/bin/nowin

# 复制配置
mkdir -p $PREFIX/share/nowin
cp src/config.conf $PREFIX/share/nowin/
cp assets/ascii_art.txt $PREFIX/share/nowin/ 2>/dev/null

# 注入 shell
if [ -f ~/.bashrc ]; then
    grep -q "alias exe=" ~/.bashrc || echo "alias exe='nowin'" >> ~/.bashrc
    echo -e "${GREEN}✅ Bash 劫持成功${NC}"
fi
if [ -f ~/.zshrc ]; then
    grep -q "alias exe=" ~/.zshrc || echo "alias exe='nowin'" >> ~/.zshrc
    echo -e "${GREEN}✅ Zsh 劫持成功${NC}"
fi

echo -e "${GREEN}🎉 安装完成！输入 exe 触发快乐${NC}"
echo -e "${RED}⚠️ 警告：Ctrl+C 可能无效${NC}"