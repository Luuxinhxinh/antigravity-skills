#!/bin/bash
set -e

echo "🚀 Đang cài đặt kho Antigravity Skills..."

USER_HOME="$HOME"
TARGET_LOCATIONS=(
    "$USER_HOME/.gemini/config/skills"
    "$USER_HOME/.gemini/antigravity/skills"
    "$USER_HOME/.gemini/antigravity-ide/skills"
)
RULE_LOCATION="$USER_HOME/.gemini/config/rules"

TEMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'antigravity-skills')

echo "📦 Đang tải dữ liệu từ GitHub (Luuxinhxinh/antigravity-skills)..."
git clone --depth 1 https://github.com/Luuxinhxinh/antigravity-skills.git "$TEMP_DIR"

for loc in "${TARGET_LOCATIONS[@]}"; do
    mkdir -p "$loc"
    echo "📂 Cài đặt vào: $loc"
    find "$TEMP_DIR" -mindepth 1 -maxdepth 1 -type d ! -name ".git" -exec cp -r {} "$loc/" \;
done

mkdir -p "$RULE_LOCATION"
if [ -f "$TEMP_DIR/skill-router.md" ]; then
    cp "$TEMP_DIR/skill-router.md" "$RULE_LOCATION/skill-router.md"
    echo "🧠 Đã kích hoạt Bộ điều phối kỹ năng: $RULE_LOCATION/skill-router.md"
fi

rm -rf "$TEMP_DIR"
echo "✅ Cài đặt thành công toàn bộ kho Antigravity Skills!"
