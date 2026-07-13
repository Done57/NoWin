#!/bin/bash
# NoWin 核心刷屏引擎

trap '' INT

# ========== 日志配置（独立文件版） ==========
SCRIPT_DIR="$HOME/NoWin/src"
LOG_DIR="$SCRIPT_DIR/log"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/nowin_$(date +%Y%m%d_%H%M%S).log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# ========== 加载配置 ==========
PREFIX=${PREFIX:-/data/data/com.termux/files/usr}
CONFIG_FILE="$PREFIX/share/nowin/config.conf"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

# ========== 默认参数 ==========
SPEED=${SPEED:-0.01}
LINES=${LINES:-100}
COLOR=${COLOR:-32}
R18=${R18:-false}

log "========== NoWin 启动 =========="
log "命令: $0 $@"
log "用户: $(whoami)"
log "终端: $(tty)"
log "日志文件: $LOG_FILE"

# ========== 显示图片 ==========
show_image() {
    log "开始拉图"
    if ! command -v curl &> /dev/null; then
        echo "[错误] curl 未安装"
        log "错误: curl 未安装"
        return 1
    fi
    if ! command -v chafa &> /dev/null; then
        echo "[错误] chafa 未安装，请运行：pkg install chafa"
        log "错误: chafa 未安装"
        return 1
    fi

    echo "[信息] 正在拉取随机图片..."
    log "拉取随机图片"
    local tmp_img="$HOME/nowin_$(date +%s)_$RANDOM.jpg"
    
    if [ "$R18" = "true" ]; then
        local img_url=$(curl -s "https://api.lolicon.app/setu/v2?r18=1&num=1" | grep -o '"original":"[^"]*"' | cut -d'"' -f4)
    else
        local img_url=$(curl -s "https://api.lolicon.app/setu/v2?r18=0&num=1" | grep -o '"original":"[^"]*"' | cut -d'"' -f4)
    fi
    
    if [ -z "$img_url" ]; then
        echo "[错误] 无法获取图片链接"
        log "错误: 无法获取图片链接"
        return 1
    fi

    curl -L -o "$tmp_img" "$img_url" -s --progress-bar

    if [ -f "$tmp_img" ] && [ -s "$tmp_img" ]; then
        echo "[成功] 图片已加载"
        log "图片加载成功: $tmp_img"
        chafa -s 50x20 "$tmp_img" 2>/dev/null
        rm -f "$tmp_img"
    else
        echo "[警告] 图片下载失败"
        log "错误: 图片下载失败"
    fi
}

# ========== 显示帮助 ==========
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

# ========== 参数解析 ==========
case "$1" in
    -h|--help)
        show_help
        log "显示帮助"
        exit 0
        ;;
    -i|--image)
        show_image
        log "拉图结束"
        exit 0
        ;;
    *)
        ;;
esac

# ========== 刷屏主逻辑 ==========
log "开始刷屏 - 行数: $LINES, 速度: $SPEED, 颜色: $COLOR"
for ((i=0; i<$LINES; i++)); do
    echo -e "\033[${COLOR}mNo Windows, Yes Linux!\033[0m"
    sleep $SPEED
done
log "刷屏结束"

# ========== 结尾 ==========
echo ""
if [ -f "$PREFIX/share/nowin/ascii_art.txt" ]; then
    cat "$PREFIX/share/nowin/ascii_art.txt"
else
    echo -e "\033[36m你已被 Linux 完全净化\033[0m"
fi
log "========== NoWin 退出 =========="