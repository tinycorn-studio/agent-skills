#!/usr/bin/env bash
# release.sh — tự động hóa release flow cho tool macOS dùng make-app.sh
#
# Usage: ./scripts/release.sh <version> [notes-file]
#   <version>    vd: 0.5.0 (không kèm chữ v)
#   notes-file   tùy chọn; mặc định trích mục [<version>] từ CHANGELOG.md
#
# Yêu cầu: chạy trong repo có make-app.sh (biến VERSION) + CHANGELOG.md,
#          working tree sạch, gh đã đăng nhập.
set -euo pipefail

VERSION="${1:?Usage: release.sh <version> [notes-file]}"
NOTES="${2:-}"
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

echo "==> Release v${VERSION} ($ROOT)"

# 0. Kiểm tra
[[ -z "$(git status --porcelain)" ]] || { echo "LỖI: working tree chưa sạch — commit trước đã."; exit 1; }
[[ -f CHANGELOG.md ]] || { echo "LỖI: thiếu CHANGELOG.md"; exit 1; }
grep -q "\[${VERSION}\]" CHANGELOG.md || { echo "LỖI: CHANGELOG.md thiếu mục [${VERSION}]"; exit 1; }

# 1. Bump VERSION trong make-app.sh (nguồn version duy nhất)
if [[ -f make-app.sh ]]; then
  sed -i '' -E "s/^(VERSION=).*/\1\"${VERSION}\"/" make-app.sh
fi

# 2. Build app + file cài
[[ -f make-app.sh ]] && ./make-app.sh
DMG="$(ls -t dist/*.dmg 2>/dev/null | head -1 || true)"

# 3. Commit (version bump hoặc fix lặt vặt)
git add -A
git diff --cached --quiet || git commit -m "Release v${VERSION}"

# 4. Tag + push
git tag -a "v${VERSION}" -m "v${VERSION}"
git push origin HEAD --tags

# 5. Release notes
if [[ -z "$NOTES" ]]; then
  NOTES="$(mktemp -t release-notes-XXXXXX).md"
  awk -v ver="$VERSION" '
    /^## \[/ {
      if (found) exit
      if (index($0, "[" ver "]")) { found = 1; next }
    }
    found
  ' CHANGELOG.md > "$NOTES"
  [[ -s "$NOTES" ]] || { echo "LỖI: không trích được notes từ CHANGELOG"; exit 1; }
fi

# 6. GitHub Release
if [[ -n "$DMG" && -f "$DMG" ]]; then
  echo "==> gh release create v${VERSION} ($DMG)"
  gh release create "v${VERSION}" "$DMG" --title "v${VERSION}" --notes-file "$NOTES"
else
  echo "==> gh release create v${VERSION} (không có file cài)"
  gh release create "v${VERSION}" --title "v${VERSION}" --notes-file "$NOTES"
fi

echo "==> Xong. Verify: gh release view v${VERSION}"
