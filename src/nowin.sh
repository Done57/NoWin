#!/bin/bash
# NoWin 核心刷屏引擎

trap '' INT

PREFIX=${PREFIX:-/data/data/com.termux/files/usr}
CONFIG_FILE="$PREFIX/share/nowin/config.conf"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

SPEED=${SPEED:-0.01}
LINES=${LINES:-100}
COLOR=${COLOR:-32}
R18=${R18:-false}

show_image() {
    if ! command -v curl &> /dev/null; then
        echo "[错误] curl 未安装"
        return 1
    fi
    if ! command -v chafa &> /dev/null; then
        echo "[错误] chafa 未安装，请运行：pkg install chafa"
        return 1
    fi

    if [ "$R18" = "true" ]; then
        echo "[警告] 当前允许 18+ 内容"
        echo "[提示] 如需关闭，请在配置中设置 R18=false"
        echo "[提示] 5 秒后继续..."
        sleep 5
    else
        echo "[信息] 当前仅显示全年龄内容"
        echo "[提示] 如需开启 18+，请在配置中设置 R18=true"
        sleep 1
    fi

    echo "[信息] 正在拉取随机图片..."
    local tmp_img="$HOME/nowin_$(date +%s)_$RANDOM.jpg"
    
    if [ "$R18" = "true" ]; then
        local img_url=$(curl -s "https://api.lolicon.app/setu/v2?r18=1&num=1" | grep -o '"original":"[^"]*"' | cut -d'"' -f4)
    else
        local img_url=$(curl -s "https://api.lolicon.app/setu/v2?r18=0&num=1" | grep -o '"original":"[^"]*"' | cut -d'"' -f4)
    fi
    
    if [ -z "$img_url" ]; then
        echo "[错误] 无法获取图片链接"
        return 1
    fi

    curl -L -o "$tmp_img" "$img_url" -s --progress-bar

    if [ -f "$tmp_img" ] && [ -s "$tmp_img" ]; then
        echo "[成功] 图片已加载"
        chafa -s 50x20 "$tmp_img" 2>/dev/null
        rm -f "$tmp_img"
    else
        echo "[警告] 图片下载失败"
    fi
}

show_help() {
    echo "NoWin - Linux 防呆警示工具"
    echo ""
    echo "用法："
    echo "  nowin             刷屏"
    echo "  nowin -i          拉取随机图片"
    echo "  nowin -h          显示帮助"
    echo ""
    echo "配置："
    echo "  SPEED=${SPEED}    刷屏速度（秒）"
    echo "  LINES=${LINES}    刷屏行数"
    echo "  COLOR=${COLOR}    颜色（32=绿，33=黄，31=红，36=青）"
    echo "  R18=${R18}        是否允许 18+ 内容（true/false）"
}

case "$1" in
    -h|--help)
        show_help
        exit 0
        ;;
    -i|--image)
        show_image
        exit 0
        ;;
    *)
        ;;
esac

for ((i=0; i<$LINES; i++)); do
    echo -e "\033[${COLOR}mNo Windows, Yes Linux!\033[0m"
    sleep $SPEED
done

echo ""
if [ -f "$PREFIX/share/nowin/ascii_art.txt" ]; then
    cat "$PREFIX/share/nowin/ascii_art.txt"
else
    echo -e "\033[36m你已被 Linux 完全净化\033[0m"
fi