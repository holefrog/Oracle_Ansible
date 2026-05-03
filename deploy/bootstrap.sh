#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

INV="inventory_bootstrap.yml"
PB="bootstrap.yml"
KEY="ubuntu.key"

echo "--------------------------------------------------------"
echo "🚀 StockSentinel - Bootstrap（仅首次执行）"
echo "--------------------------------------------------------"

# 检查密钥
if [[ ! -f "$KEY" ]]; then
    echo "❌ 未找到 ubuntu.key，请先将 ssh-key-2026-04-30.key 改名为 ubuntu.key"
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
echo "🛠️  正在执行 Bootstrap..."
echo "--------------------------------------------------------"

ansible-playbook -i "$INV" "$PB" --ask-become-pass "$@"

echo ""
echo "🎉 Bootstrap 完成！sentinel.key 已生成，之后请使用 apply.sh 部署。"
