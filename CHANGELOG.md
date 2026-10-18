# Changelog

Mọi thay đổi đáng chú ý của repo này được ghi ở đây.
Định dạng theo [Keep a Changelog](https://keepachangelog.com/vi/1.1.0/), phiên bản theo [SemVer](https://semver.org/lang/vi/).

## [0.1.0] - 2026-10-18

### Added

- Skill `release-flow`: quy trình phát hành version mới (bump version → build installer → CHANGELOG → tag → GitHub Release kèm file cài).
- Skill `ui-preview-first`: render ảnh preview giao diện offscreen trước khi apply thay đổi UI.
- Skill `studio-conventions`: quy ước chung cho mọi repo (README, CHANGELOG, commit, .gitignore, tài liệu).
- `scripts/release.sh`: tự động hóa toàn bộ release flow cho tool macOS (make-app.sh + DMG).
- `scripts/install.sh`: symlink skills vào opencode / Claude Code / agents chung.
- Templates: `CHANGELOG.md`, `RELEASE_NOTES.md`.
