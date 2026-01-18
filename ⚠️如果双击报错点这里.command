#!/bin/bash
# 修复换行符问题（如果双击其他.command文件报错，先双击这个）

cd "$(dirname "$0")"

echo "======================================"
echo "  修复脚本文件格式"
echo "======================================"
echo ""
echo "如果双击其他 .command 文件提示错误，"
echo "可能是换行符格式问题，正在修复..."
echo ""

# 修复所有 .command 文件
count=0
for file in *.command; do
    if [ -f "$file" ]; then
        sed -i '' 's/\r$//' "$file" 2>/dev/null
        chmod +x "$file" 2>/dev/null
        count=$((count+1))
        echo "✅ 已修复: $file"
    fi
done

# 修复所有 .sh 文件
for file in *.sh; do
    if [ -f "$file" ]; then
        sed -i '' 's/\r$//' "$file" 2>/dev/null
        chmod +x "$file" 2>/dev/null
        count=$((count+1))
        echo "✅ 已修复: $file"
    fi
done

echo ""
echo "======================================"
echo "  ✅ 修复完成！"
echo "======================================"
echo ""
echo "共修复 $count 个文件"
echo ""
echo "现在可以双击运行其他 .command 文件了！"
echo ""
echo "窗口将在 5 秒后关闭，或按任意键立即关闭..."
read -t 5 -n 1

exit 0
