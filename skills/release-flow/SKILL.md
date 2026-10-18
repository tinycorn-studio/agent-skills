---
name: release-flow
description: Quy trình phát hành phiên bản mới lên GitHub Releases (release, phát hành, publish, tag, changelog, version mới, DMG, installer, file cài). Use when preparing or publishing a release of a tool/app - bump version, build installer, update CHANGELOG, tag, push, gh release create with asset, verify. Do NOT use for regular feature commits without a release.
---

# Release flow (TinyCorn Studio standard)

Áp dụng khi user nói: "release", "phát hành vX.Y.Z", "đẩy bản mới lên git", "build file cài + release".
Chạy toàn bộ flow, **không hỏi lại từng bước** trừ khi phát hiện bất thường.

## Điều kiện tiên quyết

- Repo có `CHANGELOG.md` (Keep a Changelog) với mục `## [<version>] - <date>` cho version sắp phát hành.
- Repo có script build file cài (thường `make-app.sh` với biến `VERSION`).
- `gh` đã đăng nhập với quyền `repo`.
- Working tree sạch (mọi feature đã commit).

## Các bước

### 1. Bump version (một nguồn duy nhất)

```bash
sed -i '' -E 's/^(VERSION=).*/\1"0.5.0"/' make-app.sh
```

### 2. Build file cài

```bash
./make-app.sh
ls -lh dist/
```

### 3. Cập nhật CHANGELOG.md

Thêm mục mới lên đầu (theo [Keep a Changelog](https://keepachangelog.com)):

```markdown
## [0.5.0] - 2026-10-18

### Added
- ...

### Fixed
- ...
```

### 4. Commit

```bash
git add -A
git commit -m "Release v0.5.0"
```

### 5. Merge về main (nếu đang ở feature branch)

```bash
git checkout main && git merge --ff-only <feature-branch>
```

### 6. Tag annotated + push

```bash
git tag -a v0.5.0 -m "v0.5.0"
git push origin main --tags
```

### 7. Tạo GitHub Release kèm file cài

Viết release notes tiếng Việt (tóm tắt + mục "Có gì mới" + "Cài đặt"), lưu file tạm, rồi:

```bash
gh release create v0.5.0 dist/<App>-0.5.0.dmg \
  --title "v0.5.0 — <tóm tắt>" \
  --notes-file /tmp/release_notes_v0.5.0.md
```

### 8. Verify

```bash
gh release view v0.5.0
```

Kiểm tra: tag đúng commit, asset đã upload, notes hiển thị đúng.

## Script tự động hóa

Repo này có `scripts/release.sh` làm bước 1→7 cho tool macOS dùng `make-app.sh`:

```bash
./scripts/release.sh 0.5.0
```

## Quy tắc

- **KHÔNG commit file cài** (DMG, ZIP) vào repo — chỉ gắn vào GitHub Releases. `dist/` phải nằm trong `.gitignore`.
- CHANGELOG và README phải được cập nhật **trong cùng release**.
- Tag luôn là annotated tag, format `vX.Y.Z` (SemVer).
- Release notes tiếng Việt, có mục hướng dẫn mở app nếu app chưa ký (chuột phải → Open).
- Nếu push bị 403: kiểm tra `gh auth status`, chạy `gh auth setup-git`, xác nhận token có quyền với org.
