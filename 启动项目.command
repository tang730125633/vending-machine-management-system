#!/bin/bash
# 双击即可运行的启动脚本（macOS 专用）
# .command 文件在 macOS 上可以直接双击运行

# 获取脚本所在目录
cd "$(dirname "$0")"

echo "======================================"
echo "  自动售货机管理系统 - 一键启动"
echo "======================================"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查 Docker 是否安装
echo "🔍 步骤 1/6: 检查 Docker 环境..."
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ 错误：未检测到 Docker${NC}"
    echo ""
    echo "请先安装 Docker Desktop："
    echo "  Apple芯片(M1/M2/M3): https://desktop.docker.com/mac/main/arm64/Docker.dmg"
    echo "  Intel芯片: https://desktop.docker.com/mac/main/amd64/Docker.dmg"
    echo ""
    echo "按任意键退出..."
    read -n 1
    exit 1
fi

# 检查 Docker 是否运行
if ! docker info &> /dev/null; then
    echo -e "${RED}❌ 错误：Docker 未运行${NC}"
    echo ""
    echo "请先打开 Docker Desktop 应用"
    echo "等待菜单栏出现小鲸鱼图标后，再双击此脚本"
    echo ""
    echo "按任意键退出..."
    read -n 1
    exit 1
fi

echo -e "${GREEN}✅ Docker 已就绪${NC}"
echo ""

# 检查端口占用
echo "🔍 步骤 2/6: 检查端口占用..."
if lsof -Pi :8080 -sTCP:LISTEN -t >/dev/null 2>&1 ; then
    echo -e "${YELLOW}⚠️  警告：端口 8080 已被占用${NC}"
    read -p "是否停止现有服务并重新启动？(y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🛑 正在停止现有服务..."
        docker-compose -p vending down 2>/dev/null
    else
        echo "❌ 取消启动"
        echo "按任意键退出..."
        read -n 1
        exit 1
    fi
fi

if lsof -Pi :3306 -sTCP:LISTEN -t >/dev/null 2>&1 ; then
    echo -e "${YELLOW}⚠️  警告：端口 3306 已被占用（MySQL端口）${NC}"
    echo "请关闭本地的 MySQL 服务，或者修改配置文件"
    read -p "是否继续？可能会导致启动失败 (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "按任意键退出..."
        read -n 1
        exit 1
    fi
fi

echo -e "${GREEN}✅ 端口检查完成${NC}"
echo ""

# 启动服务
echo "🚀 步骤 3/6: 启动服务（这可能需要几分钟，首次运行会下载镜像）..."
echo ""

# 如果是首次运行，提示可能需要等待
if ! docker images | grep -q mysql; then
    echo -e "${YELLOW}⏳ 检测到首次运行，需要下载 MySQL 镜像（约 500MB）${NC}"
    echo -e "${YELLOW}⏳ 请确保已开启 VPN 或配置了镜像源${NC}"
    echo ""
    echo "如果下载很慢，建议："
    echo "1. 按 Ctrl+C 取消"
    echo "2. 双击运行「配置Docker镜像源.command」"
    echo "3. 重启 Docker Desktop 后再试"
    echo ""
    read -p "按回车键继续，或按 Ctrl+C 取消... "
fi

docker-compose -p vending up -d

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ 启动失败${NC}"
    echo ""
    echo "常见问题排查："
    echo "1. 如果提示网络错误，可能是 Docker Hub 访问慢"
    echo "   解决方案：双击运行「配置Docker镜像源.command」"
    echo ""
    echo "2. 如果提示端口占用，请停止占用端口的程序"
    echo ""
    echo "3. 查看详细日志："
    echo "   打开终端，输入：docker-compose -p vending logs"
    echo ""
    echo "按任意键退出..."
    read -n 1
    exit 1
fi

echo -e "${GREEN}✅ 容器已启动${NC}"
echo ""

# 等待服务启动
echo "⏳ 步骤 4/6: 等待服务启动（约 30-60 秒）..."
echo ""

# 等待 MySQL 健康检查通过
echo "  ⏳ 等待 MySQL 数据库启动..."
RETRY=0
MAX_RETRY=60
while [ $RETRY -lt $MAX_RETRY ]; do
    if docker ps | grep vending-mysql | grep -q "healthy"; then
        echo -e "  ${GREEN}✅ MySQL 已就绪${NC}"
        break
    fi
    sleep 2
    RETRY=$((RETRY+1))
    if [ $((RETRY % 5)) -eq 0 ]; then
        echo "  ⏳ 仍在等待... (${RETRY}/${MAX_RETRY})"
    fi
done

if [ $RETRY -eq $MAX_RETRY ]; then
    echo -e "${RED}❌ MySQL 启动超时${NC}"
    echo "打开终端查看日志：docker logs vending-mysql"
    echo ""
    echo "按任意键退出..."
    read -n 1
    exit 1
fi

# 等待应用启动
echo "  ⏳ 等待应用服务启动..."
sleep 15

echo ""

# 验证服务
echo "🔍 步骤 5/6: 验证服务状态..."
RETRY=0
MAX_RETRY=30
while [ $RETRY -lt $MAX_RETRY ]; do
    HEALTH_CHECK=$(curl -s http://localhost:8080/api/auth/health 2>/dev/null)
    if echo "$HEALTH_CHECK" | grep -q "ok"; then
        echo -e "${GREEN}✅ 后端服务正常运行${NC}"
        echo "   响应: $HEALTH_CHECK"
        break
    fi
    sleep 2
    RETRY=$((RETRY+1))
    if [ $((RETRY % 5)) -eq 0 ]; then
        echo "  ⏳ 仍在等待应用启动... (${RETRY}/${MAX_RETRY})"
    fi
done

if [ $RETRY -eq $MAX_RETRY ]; then
    echo -e "${RED}❌ 应用启动超时或失败${NC}"
    echo ""
    echo "打开终端查看应用日志："
    echo "  docker logs vending-app"
    echo ""
    echo "按任意键退出..."
    read -n 1
    exit 1
fi

echo ""

# 打开前端
echo "🌐 步骤 6/6: 打开管理后台..."
if [ -f "frontend/admin.html" ]; then
    open frontend/admin.html
    echo -e "${GREEN}✅ 前端页面已打开${NC}"
else
    echo -e "${RED}❌ 未找到前端文件 frontend/admin.html${NC}"
fi

echo ""
echo "======================================"
echo -e "${GREEN}  🎉 启动成功！${NC}"
echo "======================================"
echo ""
echo "📱 访问信息："
echo "  - 管理后台：已自动打开浏览器"
echo "  - 后端API：http://localhost:8080/api"
echo ""
echo "👤 测试账号："
echo "  - 用户名：admin"
echo "  - 密码：admin123"
echo ""
echo "📊 容器状态："
docker ps --filter "name=vending" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""
echo "💡 如需停止服务："
echo "  双击运行「停止服务.command」"
echo ""
echo "======================================"
echo ""
echo "窗口将在 10 秒后自动关闭，或按任意键立即关闭..."
read -t 10 -n 1

exit 0
