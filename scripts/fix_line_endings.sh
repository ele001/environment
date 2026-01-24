#!/usr/bin/env bash
# 修复 WSL 中的行尾符问题（CRLF -> LF）
# 使用方法: ./fix_line_endings.sh [目录路径，默认为当前目录]

set -e

TARGET_DIR="${1:-.}"

echo "🔧 修复行尾符问题..."
echo "目标目录: $TARGET_DIR"
echo ""

# 需要修复的文件类型
EXTENSIONS=("sh" "bash" "py" "js" "ts" "jsx" "tsx" "lua" "vim" "md" "txt" "yml" "yaml" "json" "toml" "ini" "conf" "config")

# 统计修复的文件数
FIXED_COUNT=0

# 遍历所有需要修复的文件
for ext in "${EXTENSIONS[@]}"; do
    while IFS= read -r -d '' file; do
        # 检查文件是否包含 CRLF
        if grep -q $'\r' "$file" 2>/dev/null; then
            echo "修复: $file"
            sed -i 's/\r$//' "$file"
            ((FIXED_COUNT++))
        fi
    done < <(find "$TARGET_DIR" -type f -name "*.${ext}" -not -path "*/\.git/*" -print0 2>/dev/null || true)
done

# 也检查没有扩展名的脚本文件（如 install_tools.sh 可能被识别为其他类型）
while IFS= read -r -d '' file; do
    # 检查是否是脚本文件（有 shebang）
    if head -n 1 "$file" 2>/dev/null | grep -q "^#!"; then
        if grep -q $'\r' "$file" 2>/dev/null; then
            echo "修复: $file"
            sed -i 's/\r$//' "$file"
            ((FIXED_COUNT++))
        fi
    fi
done < <(find "$TARGET_DIR" -type f -not -name "*.*" -not -path "*/\.git/*" -print0 2>/dev/null || true)

echo ""
if [ $FIXED_COUNT -eq 0 ]; then
    echo "✅ 没有发现需要修复的文件"
else
    echo "✅ 已修复 $FIXED_COUNT 个文件"
fi
echo ""
echo "💡 提示: 建议在项目根目录创建 .gitattributes 文件以防止将来出现此问题"
