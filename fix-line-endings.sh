#!/bin/bash
# 修复换行符问题（如果双击.command文件报错，运行这个）

cd "$(dirname "$0")"

echo "正在修复换行符格式..."

# 修复所有 .command 文件
for file in *.command; do
    if [ -f "$file" ]; then
        sed -i '' 's/\r$//' "$file"
        echo "✅ 已修复: $file"
    fi
done

# 修复所有 .sh 文件
for file in *.sh; do
    if [ -f "$file" ]; then
        sed -i '' 's/\r$//' "$file"
        echo "✅ 已修复: $file"
    fi
done

# 确保执行权限
chmod +x *.command *.sh 2>/dev/null

echo ""
echo "======================================"
echo "  ✅ 修复完成！"
echo "======================================"
echo ""
echo "现在可以双击运行 .command 文件了"
