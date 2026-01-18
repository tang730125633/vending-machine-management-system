#!/bin/bash
# Docker 国内镜像源配置脚本
# 适用于 macOS

echo "======================================"
echo "  Docker 国内镜像源配置工具"
echo "======================================"
echo ""

# 检查 Docker 是否安装
if ! command -v docker &> /dev/null; then
    echo "❌ 错误：未检测到 Docker"
    echo "请先安装 Docker Desktop："
    echo "  Apple芯片: https://desktop.docker.com/mac/main/arm64/Docker.dmg"
    echo "  Intel芯片: https://desktop.docker.com/mac/main/amd64/Docker.dmg"
    exit 1
fi

# 检查 Docker 是否运行
if ! docker info &> /dev/null; then
    echo "❌ 错误：Docker 未运行"
    echo "请打开 Docker Desktop 应用，等待启动完成后重试"
    exit 1
fi

echo "✅ Docker 已安装并运行"
echo ""

# Docker Desktop 配置文件路径
DOCKER_CONFIG="$HOME/.docker/daemon.json"

echo "📝 配置 Docker 镜像加速器..."
echo ""

# 备份原配置
if [ -f "$DOCKER_CONFIG" ]; then
    echo "📦 备份原配置文件..."
    cp "$DOCKER_CONFIG" "$DOCKER_CONFIG.backup.$(date +%Y%m%d%H%M%S)"
fi

# 创建配置目录
mkdir -p "$HOME/.docker"

# 写入镜像源配置
cat > "$DOCKER_CONFIG" << 'EOF'
{
  "registry-mirrors": [
    "https://docker.mirrors.ustc.edu.cn",
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com"
  ],
  "insecure-registries": [],
  "debug": false,
  "experimental": false
}
EOF

echo "✅ 配置文件已写入：$DOCKER_CONFIG"
echo ""
echo "📋 已配置的镜像源："
echo "  - 中科大镜像：https://docker.mirrors.ustc.edu.cn"
echo "  - 网易镜像：https://hub-mirror.c.163.com"
echo "  - 百度镜像：https://mirror.baidubce.com"
echo ""

echo "⚠️  重要提示："
echo "1. 需要重启 Docker Desktop 才能生效"
echo "2. 打开 Docker Desktop 应用"
echo "3. 点击菜单栏的 Docker 图标 → Quit Docker Desktop"
echo "4. 重新打开 Docker Desktop"
echo ""

read -p "是否现在重启 Docker Desktop？(y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🔄 正在重启 Docker Desktop..."
    osascript -e 'quit app "Docker"'
    sleep 3
    open -a Docker
    echo "✅ Docker Desktop 正在重启，请等待启动完成（约30秒）"
    echo "启动完成后，可以运行 ./quick-start.sh 启动项目"
else
    echo "请手动重启 Docker Desktop 后再运行 ./quick-start.sh"
fi

echo ""
echo "======================================"
echo "  配置完成！"
echo "======================================"
