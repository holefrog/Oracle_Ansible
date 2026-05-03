#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "--------------------------------------------------------"
echo "🚀 StockSentinel 部署系统"
echo "--------------------------------------------------------"
echo "1) Bootstrap  - 首次执行，初始化服务器"
echo "2) Apply      - 日常部署，更新应用"
echo "--------------------------------------------------------"
read -rp "请选择 [1/2，其他退出]: " choice

case "$choice" in
    1)
        MODE="bootstrap"
        INV="inventory_bootstrap.yml"
        PB="bootstrap.yml"
        KEY="ubuntu.key"
        BECOME_ARGS="--ask-become-pass"
        ;;
    2)
        MODE="apply"
        INV="inventory.yml"
        PB="site.yml"
        KEY="sentinel.key"
        BECOME_ARGS=""
        ;;
    *)
        echo "已退出。"
        exit 0
        ;;
esac

echo ">>> 已选择: ${MODE}"
echo ""

# 检查密钥
if [[ ! -f "$KEY" ]]; then
    echo "❌ 未找到 ${KEY}"
    [[ "$MODE" == "bootstrap" ]] && echo "请先将 远程主机提供的 ubuntu 用户的私钥名称改名为 ubuntu.key"
    [[ "$MODE" == "apply" ]] && echo "请先执行 bootstrap"
    exit 1
fi
chmod 400 "$KEY"

# 语法检查
echo ">>> [1/2] 正在执行语法校验..."
if ! ansible-playbook -i "$INV" "$PB" --syntax-check >/dev/null; then
    echo "❌ 语法错误"
    exit 1
fi
echo "✅ 语法正常"

# 连接测试
echo ">>> [2/2] 正在测试主机连通性..."
if ! ansible all -i "$INV" -m ping >/dev/null; then
    echo "❌ 无法连接到服务器"
    exit 1
fi
echo "✅ 连接成功"

echo "--------------------------------------------------------"
echo "🛠️  正在执行 ${MODE}..."
echo "--------------------------------------------------------"

if [[ "$MODE" == "bootstrap" ]]; then
    echo "💡 提示：需要输入服务器 sudo 密码。"
    echo "   如果 ubuntu 用户已配置 NOPASSWD sudo，直接回车即可。"
    echo ""
fi

ansible-playbook -i "$INV" "$PB" $BECOME_ARGS "$@"

echo ""
echo "🎉 ${MODE} 完成！"
