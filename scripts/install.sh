#!/usr/bin/env bash
# install.sh — symlink toàn bộ skills vào các agent host đã hỗ trợ
#
# Sau khi chạy, mọi project mở bằng Antigravity / opencode / Claude Code / agent chuẩn
# agentskills.io đều tự nhận các skill này. `git pull` là cập nhật luôn.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

targets=(
  "$HOME/.gemini/config/skills"     # Google Antigravity
  "$HOME/.config/opencode/skills"   # opencode
  "$HOME/.claude/skills"            # Claude Code
  "$HOME/.agents/skills"            # Agent Skills spec chung
)

for target in "${targets[@]}"; do
  mkdir -p "$target"
  for skill in "$DIR"/skills/*/; do
    name="$(basename "$skill")"
    ln -sfn "$skill" "$target/$name"
    echo "linked $name -> $target"
  done
done

echo "OK — restart agent để load skills."
