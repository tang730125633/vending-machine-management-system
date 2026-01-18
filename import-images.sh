#!/bin/bash
# 从文件导入 Docker 镜像
# 避免从网络下载，适合网络不好的情况

echo "======================================"
echo "  从文件导入 Docker 镜像"
echo "======================================"
echo ""

# 检查 Docker 是否运行
if ! docker info &> /dev/null; then
    echo "❌ 错误：Docker 未运行"
    echo "请先打开 Docker Desktop，等待启动完成后重试"
    exit 1
fi

IMAGE_DIR="docker-images"

if [ ! -d "$IMAGE_DIR" ]; then
    echo "❌ 错误：未找到 $IMAGE_DIR 目录"
    echo ""
    echo "请确保："
    echo "1. docker-images 文件夹在当前目录"
    echo "2. 该文件夹包含镜像文件（.tar）"
    exit 1
fi

echo "📦 开始导入镜像..."
echo ""

# 导入所有 .tar 文件
COUNT=0
for tar_file in "$IMAGE_DIR"/*.tar; do
    if [ -f "$tar_file" ]; then
        COUNT=$((COUNT+1))
        echo "[$COUNT] 导入: $(basename $tar_file)"
        docker load -i "$tar_file"
        if [ $? -eq 0 ]; then
            echo "✅ 导入成功"
        else
            echo "❌ 导入失败"
        fi
        echo ""
    fi
done

if [ $COUNT -eq 0 ]; then
    echo "⚠️  未找到任何 .tar 文件"
    exit 1
fi

echo "======================================"
echo "  导入完成！"
echo "======================================"
echo ""
echo "📋 已导入的镜像："
docker images | grep -E "mysql|maven|temurin|vending"
echo ""
echo "✅ 现在可以运行 ./quick-start.sh 启动项目了"
