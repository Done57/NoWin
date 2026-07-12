#!/bin/bash
# Bash 劫持钩子

# 劫持 exe 命令
exe() {
    /usr/local/bin/nowin
}

# 额外劫持（连 win 都防）
win() {
    echo -e "\033[31m❌ 这里没有 Windows！\033[0m"
    /usr/local/bin/nowin
}