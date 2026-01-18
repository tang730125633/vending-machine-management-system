#!/bin/bash
# 停止自动售货机管理系统（双击运行）

# 获取脚本所在目录
cd "$(dirname "$0")"

echo "======================================"
echo "  停止自动售货机管理系统"
echo "======================================"
echo ""

# 检查 Docker 是否运行
if ! docker info &> /dev/null; then
    echo "⚠️  Docker 未运行，无需停止"
    echo ""
    echo "按任意键退出..."
    read -n 1
    exit 0
fi

# 检查容器是否运行
if ! docker ps | grep -q vending; then
    echo "⚠️  未发现运行中的容器"
    echo ""
    echo "按任意键退出..."
    read -n 1
    exit 0
fi

echo "🛑 正在停止服务..."
echo ""

# 停止并删除容器
docker-compose -p vending down

if [ $? -eq 0 ]; then
    echo ""
    echo "======================================"
    echo "  ✅ 服务已停止"
    echo "======================================"
    echo ""
    echo "容器已删除，数据已保留"
    echo ""
    echo "如需重新启动，双击「启动项目.command」"
else
    echo ""
    echo "======================================"
    echo "  ❌ 停止失败"
    echo "======================================"
    echo ""
    echo "可能原因："
    echo "  - Docker 权限问题"
    echo "  - 容器名称不匹配"
    echo ""
    echo "请打开终端，手动运行："
    echo "  docker-compose -p vending down"
fi

echo ""
echo "窗口将在 5 秒后关闭，或按任意键立即关闭..."
read -t 5 -n 1

exit 0
