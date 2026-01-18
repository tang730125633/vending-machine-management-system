#!/bin/bash
# 检查数据库是否正确初始化

cd "$(dirname "$0")"

echo "======================================"
echo "  检查数据库初始化状态"
echo "======================================"
echo ""

# 检查容器是否运行
if ! docker ps | grep -q vending-mysql; then
    echo "❌ MySQL 容器未运行"
    echo "请先启动项目"
    echo ""
    echo "按任意键退出..."
    read -n 1
    exit 1
fi

echo "🔍 检查数据库中的用户数据..."
echo ""

# 查询用户表
docker exec vending-mysql mysql -uroot -p123456 -e "USE vending_machine_db; SELECT id, username, email, role FROM users;" 2>/dev/null

if [ $? -eq 0 ]; then
    echo ""
    echo "======================================"
    echo "  ✅ 数据库查询成功"
    echo "======================================"
    echo ""
    echo "如果上面显示了用户数据，说明数据库初始化正常"
    echo ""
    echo "测试账号："
    echo "  用户名：admin"
    echo "  密码：admin123"
    echo ""
    echo "⚠️  请注意："
    echo "  - 用户名全部小写"
    echo "  - 密码没有空格"
else
    echo ""
    echo "======================================"
    echo "  ❌ 数据库查询失败"
    echo "======================================"
    echo ""
    echo "可能需要重新初始化数据库"
fi

echo ""
echo "窗口将在 10 秒后关闭，或按任意键立即关闭..."
read -t 10 -n 1

exit 0
