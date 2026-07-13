#!/bin/bash
# NoWin 核心引擎 - 超详细日志版 v2.2.1

trap '' INT

# ========== 日志配置 ==========
SCRIPT_DIR="$HOME/NoWin/src"
LOG_DIR="$SCRIPT_DIR/log"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/nowin_$(date +%Y%m%d_%H%M%S).log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S.%3N')] $1" >> "$LOG_FILE"
}

log_section() {
    echo "" >> "$LOG_FILE"
    echo "========================================" >> "$LOG_FILE"
    echo "[$(date '+%Y-%m-%d %H:%M:%S.%3N')] $1" >> "$LOG_FILE"
    echo "========================================" >> "$LOG_FILE"
}

log_var() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S.%3N')] 变量: $1 = ${!1}" >> "$LOG_FILE"
}

# ========== 加载配置 ==========
PREFIX=${PREFIX:-/data/data/com.termux/files/usr}
CONFIG_FILE="$PREFIX/share/nowin/config.conf"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

SPEED=${SPEED:-0.01}
LINES=${LINES:-100}
COLOR=${COLOR:-32}
R18=${R18:-false}

# ========== 系统信息 ==========
log_section "系统环境信息"
log "系统: $(uname -a)"
log "内核: $(uname -r)"
log "架构: $(uname -m)"
log "系统版本: $(cat /etc/os-release 2>/dev/null | grep PRETTY_NAME | cut -d= -f2 | tr -d '"' || echo '未知')"
log "终端: $(tty)"
log "用户: $(whoami) (UID: $(id -u))"
log "当前目录: $(pwd)"
log "脚本路径: $0"
log "Shell: $SHELL (版本: $BASH_VERSION)"
log_var "HOME"
log_var "PREFIX"
log_var "PATH"

# ========== 依赖信息 ==========
log_section "依赖检查"
for dep in curl chafa; do
    if command -v $dep &> /dev/null; then
        ver=$($dep --version 2>/dev/null | head -n1)
        log "✅ $dep: $ver"
    else
        log "❌ $dep: 未安装"
    fi
done

# ========== 配置信息 ==========
log_section "配置参数"
log_var "SPEED"
log_var "LINES"
log_var "COLOR"
log_var "R18"

# ========== 调用信息 ==========
log_section "调用信息"
log "命令: $0 $@"
log "参数个数: $#"
for i in $(seq 1 $#); do
    log "参数 $i: ${!i}"
done

# ========== 显示图片 ==========
show_image() {
    log_section "开始执行: show_image()"
    log "时间戳: $(date +%s)"
    
    if ! command -v curl &> /dev/null; then
        log "❌ curl 未安装"
        echo "[错误] curl 未安装"
        return 1
    fi
    
    if ! command -v chafa &> /dev/null; then
        log "❌ chafa 未安装"
        echo "[错误] chafa 未安装，请运行：pkg install chafa"
        return 1
    fi

    echo "[信息] 正在拉取随机图片..."
    log "开始拉取随机图片"
    
    local tmp_img="$HOME/nowin_$(date +%s)_$RANDOM.jpg"
    log_var "tmp_img"
    
    if [ "$R18" = "true" ]; then
        local img_url="https://api.lolicon.app/setu/v2?r18=1&num=1"
    else
        local img_url="https://api.lolicon.app/setu/v2?r18=0&num=1"
    fi
    log_var "img_url"
    
    log "请求 API: $img_url"
    local start_time=$(date +%s%N)
    
    local response=$(curl -s "$img_url" 2>&1)
    local curl_exit=$?
    local end_time=$(date +%s%N)
    local elapsed=$(( (end_time - start_time) / 1000000 ))
    
    log "curl 退出码: $curl_exit"
    log "请求耗时: ${elapsed}ms"
    
    if [ $curl_exit -ne 0 ]; then
        log "❌ API 请求失败: $response"
        echo "[错误] API 请求失败"
        return 1
    fi
    
    log "提取图片链接..."
    local img_url_final=$(echo "$response" | grep -o '"original":"[^"]*"' | cut -d'"' -f4)
    log_var "img_url_final"
    
    if [ -z "$img_url_final" ]; then
        log "❌ 无法提取图片链接"
        echo "[错误] 无法获取图片链接"
        return 1
    fi
    
    log "下载图片: $img_url_final"
    local start_time=$(date +%s%N)
    
    curl -L -o "$tmp_img" "$img_url_final" -s --progress-bar
    local curl_exit=$?
    local end_time=$(date +%s%N)
    local elapsed=$(( (end_time - start_time) / 1000000 ))
    
    log "下载退出码: $curl_exit"
    log "下载耗时: ${elapsed}ms"
    
    if [ -f "$tmp_img" ]; then
        local file_size=$(ls -lh "$tmp_img" | awk '{print $5}')
        log "文件大小: $file_size"
    fi
    
    if [ $curl_exit -eq 0 ] && [ -f "$tmp_img" ] && [ -s "$tmp_img" ]; then
        echo "[成功] 图片已加载"
        log "✅ 图片加载成功"
        
        log "执行 chafa -s 50x20 $tmp_img"
        chafa -s 50x20 "$tmp_img" 2>/dev/null
        local chafa_exit=$?
        log "chafa 退出码: $chafa_exit"
        
        log "清理临时文件: $tmp_img"
        rm -f "$tmp_img"
    else
        log "❌ 图片下载失败"
        echo "[警告] 图片下载失败"
    fi
    
    log_section "show_image() 执行完毕"
}

# ========== 显示帮助 ==========
show_help() {
    echo "NoWin - Linux 防呆警示工具 v2.2.1"
    echo ""
    echo "用法："
    echo "  nowin             刷屏"
    echo "  nowin -i          拉取随机图片"
    echo "  nowin -h          显示帮助"
    echo "  nowin -v          显示版本信息"
    echo ""
    echo "配置："
    echo "  SPEED=${SPEED}    刷屏速度（秒）"
    echo "  LINES=${LINES}    刷屏行数"
    echo "  COLOR=${COLOR}    颜色（32=绿，33=黄，31=红，36=青）"
    echo "  R18=${R18}        是否允许 18+ 内容（true/false）"
}

# ========== 显示版本 ==========
show_version() {
    echo "NoWin v2.2.1 (超详细日志版)"
    echo "日志文件: $LOG_FILE"
    echo "架构: $(uname -m)"
    echo "系统: $(uname -s)"
}

# ========== 参数解析 ==========
case "$1" in
    -h|--help)
        show_help
        exit 0
        ;;
    -v|--version)
        show_version
        exit 0
        ;;
    -i|--image)
        show_image
        log_section "NoWin 退出"
        exit 0
        ;;
        *)
        ;;
esac

# ========== 刷屏主逻辑 ==========
log_section "开始刷屏"
log "行数: $LINES, 速度: $SPEED, 颜色: $COLOR"

for ((i=0; i<$LINES; i++)); do
    echo -e "\033[${COLOR}mNo Windows, Yes Linux!\033[0m"
    sleep $SPEED
done

log "刷屏完成"

# ========== 结尾 ==========
echo ""
if [ -f "$PREFIX/share/nowin/ascii_art.txt" ]; then
    cat "$PREFIX/share/nowin/ascii_art.txt"
else
    echo -e "\033[36m你已被 Linux 完全净化\033[0m"
fi

log_section "NoWin 退出"