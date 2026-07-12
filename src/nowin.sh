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
SPEED=${SPEED:-0.01}
LINES=${LINES:-10000}
COLOR=${COLOR:-32}

# 刷屏
for ((i=0; i<$LINES; i++)); do
    echo -e "\033[${COLOR}mNo Windows, Yes Linux!\033[0m"
    # 随机彩蛋（10% 概率）
    if [ $((RANDOM % 10)) -eq 0 ]; then
        echo -e "\033[31m【净化】检测到 .exe 异端，启动清除程序...\033[0m"
    fi
    sleep $SPEED
done

# 结尾显示 ASCII 梗图
echo ""
if [ -f /usr/local/share/nowin/ascii_art.txt ]; then
    cat /usr/local/share/nowin/ascii_art.txt
else
    echo -e "\033[36m🐧 你已被 Linux 完全净化！\033[0m"
fi