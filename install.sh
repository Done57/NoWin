#!/bin/bash
# NoWin 安装脚本

GREEN='\033[32m'
NC='\033[0m'

echo -e "${GREEN}安装 NoWin...${NC}"

PREFIX=${PREFIX:-/data/data/com.termux/files/usr}

cp src/nowin.sh $PREFIX/bin/nowin
chmod +x $PREFIX/bin/nowin

mkdir -p $PREFIX/share/nowin
cp src/config.conf $PREFIX/share/nowin/
cp assets/ascii_art.txt $PREFIX/share/nowin/ 2>/dev/null

if [ -f ~/.bashrc ]; then
    grep -q "alias exe=" ~/.bashrc || echo "alias exe='nowin'" >> ~/.bashrc
fi

if [ -f ~/.zshrc ]; then
    grep -q "alias exe=" ~/.zshrc || echo "alias exe='nowin'" >> ~/.zshrc
fi

echo -e "${GREEN}安装完成${NC}"
echo "命令："
echo "  exe    刷屏"
echo "  nowin -i   拉取随机图片"