#!/bin/bash
# NoWin 核心刷屏引擎

# 屏蔽 Ctrl+C
trap '' INT

# 加载配置
CONFIG_FILE="/usr/local/share/nowin/config.conf"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

# 默认参数
SPEED=${SPEED:-0.00000001}
LINES=${LINES:-100000000000}
COLOR=${COLOR:-32}

# 刷屏
for ((i=0; i<$LINES; i++)); do
    echo -e "\033[${COLOR}mNo Windows, Yes Linux!\033[0m"
    sleep $SPEED
done

# 结尾显示 ASCII 梗图
echo ""
if [ -f /usr/local/share/nowin/ascii_art.txt ]; then
    cat /usr/local/share/nowin/ascii_art.txt
else
    echo -e "\033[36m🐧 你已被 Linux 完全净化！\033[0m"
fi