#!/bin/bash
# 配置 Docker 国内镜像源（双击运行）
# 适用于没有 VPN 的情况

# 获取脚本所在目录
cd "$(dirname "$0")"

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
    echo ""
    echo "按任意键退出..."
    read -n 1
    exit 1
fi

# 检查 Docker 是否运行
if ! docker info &> /dev/null; then
    echo "❌ 错误：Docker 未运行"
    echo "请打开 Docker Desktop 应用，等待启动完成后重试"
    echo ""
    echo "按任意键退出..."
    read -n 1
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
echo "需要重启 Docker Desktop 才能生效！"
echo ""
echo "请手动操作："
echo "1. 点击菜单栏的 Docker 图标🐳"
echo "2. 选择 Quit Docker Desktop"
echo "3. 重新打开 Docker Desktop"
echo "4. 等待启动完成（约30秒）"
echo "5. 双击「启动项目.command」启动项目"
echo ""

echo "======================================"
echo "  配置完成！"
echo "======================================"
echo ""
echo "窗口将在 15 秒后关闭，请记得重启 Docker Desktop"
echo "或按任意键立即关闭..."
read -t 15 -n 1

exit 0
