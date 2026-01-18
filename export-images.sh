#!/bin/bash
# 导出 Docker 镜像到文件
# 可以把这些文件和项目一起发给对方，避免网络问题

echo "======================================"
echo "  导出 Docker 镜像到文件"
echo "======================================"
echo ""

OUTPUT_DIR="docker-images"
mkdir -p "$OUTPUT_DIR"

echo "📦 开始导出镜像..."
echo ""

# 检查镜像是否存在
if ! docker images | grep -q mysql; then
    echo "⚠️  警告：未找到 mysql 镜像，跳过"
else
    echo "1/2 导出 mysql:8.0 镜像..."
    docker save mysql:8.0 -o "$OUTPUT_DIR/mysql-8.0.tar"
    echo "✅ 已保存到: $OUTPUT_DIR/mysql-8.0.tar"
    ls -lh "$OUTPUT_DIR/mysql-8.0.tar"
fi

echo ""

# 导出应用镜像（如果已构建）
if docker images | grep -q vending-app; then
    echo "2/2 导出 vending-app 镜像..."
    docker save vending-app:latest -o "$OUTPUT_DIR/vending-app.tar"
    echo "✅ 已保存到: $OUTPUT_DIR/vending-app.tar"
    ls -lh "$OUTPUT_DIR/vending-app.tar"
else
    echo "⚠️  vending-app 镜像未构建，将导出构建所需的基础镜像..."

    # 先构建一次以拉取所有镜像
    echo "正在构建应用（首次构建会拉取所有镜像）..."
    docker-compose -p vending build

    echo ""
    echo "导出构建镜像..."
    docker save maven:3.9-eclipse-temurin-17 -o "$OUTPUT_DIR/maven.tar"
    docker save eclipse-temurin:17-jre -o "$OUTPUT_DIR/temurin-jre.tar"
    docker save vending-app:latest -o "$OUTPUT_DIR/vending-app.tar"

    echo "✅ 所有镜像已导出"
fi

echo ""
echo "======================================"
echo "  导出完成！"
echo "======================================"
echo ""
echo "📁 镜像文件位置：$OUTPUT_DIR/"
ls -lh "$OUTPUT_DIR/"
echo ""
echo "📦 总大小："
du -sh "$OUTPUT_DIR/"
echo ""
echo "💡 使用说明："
echo "1. 将 $OUTPUT_DIR 文件夹和项目一起发给对方"
echo "2. 对方收到后，运行 ./import-images.sh 导入镜像"
echo "3. 然后再运行 ./quick-start.sh 启动项目"
echo ""
echo "⚠️  注意：镜像文件较大（约1-2GB），建议使用U盘传输"
