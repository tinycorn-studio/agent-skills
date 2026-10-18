---
name: studio-conventions
description: Quy ước chung của TinyCorn Studio cho mọi repo/tool (tạo dự án mới, khởi tạo repo, README, CHANGELOG, .gitignore, commit message, tài liệu, cấu trúc dự án). Use when starting a new project/tool, initializing a repository, writing docs, or when asked about commit/changelog/gitignore conventions. Also use to check existing repos against the standard.
---

# Studio conventions (TinyCorn Studio standard)

Áp dụng cho **mọi repo/tool** của studio, từ lúc khởi tạo đến bảo trì.

## Ngôn ngữ

- Trao đổi với user: **tiếng Việt**.
- Code, identifier, commit message, tên branch: **tiếng Anh**.
- README, CHANGELOG, release notes: **tiếng Việt**.

## Cấu trúc repo tối thiểu

```
<repo>/
├── README.md          # bắt buộc
├── CHANGELOG.md       # bắt buộc (Keep a Changelog)
├── LICENSE            # thường MIT
└── .gitignore         # bắt buộc
```

### README.md phải có các mục

1. Giới thiệu (1–2 câu, tool làm gì, cho ai)
2. Yêu cầu hệ thống
3. Build / chạy
4. Tính năng chính (theo nhóm)
5. Phím tắt (nếu có UI)
6. Kiến trúc / cấu trúc thư mục
7. Cấu hình (UserDefaults, env, config file...)
8. Giới hạn đã biết
9. Lịch sử phiên bản (tóm tắt, chi tiết trong CHANGELOG)
10. Tải về (link GitHub Releases mới nhất — không để file cài trong repo)

## Git

- `.gitignore` tối thiểu: `.build/`, `dist/`, `node_modules/`, `.DS_Store`, thư mục resources sinh tự động khi build.
- **Không commit**: file cài (DMG/ZIP), build output, secrets/token.
- Commit message: 1 dòng, thể mệnh lệnh, tiếng Anh, mô tả trọn vẹn feature/fix. Ví dụ: `Add folder view to Changes tab`.
- Commit theo **từng feature hoàn chỉnh**; chỉ commit khi user yêu cầu hoặc đã xác nhận xong feature.
- Branch: `main` luôn ở trạng thái phát hành được; feature làm trên nhánh riêng, merge `--ff-only` khi xong.
- Version: SemVer, khai báo ở **một nơi duy nhất** (vd `VERSION` trong `make-app.sh`), không rải rác nhiều file.

## Tài liệu

- README + CHANGELOG cập nhật **cùng lúc** với feature (không để sau).
- Mọi release đều có: tag annotated `vX.Y.Z` + GitHub Release với release notes tiếng Việt (xem skill `release-flow`).
- Ghi chú quyết định thiết kế phức tạp ngay trong code hoặc README mục "Kiến trúc".

## Chất lượng

- Trước khi báo hoàn thành: build/test lại, verify bằng dữ liệu thật hoặc sandbox.
- UI: preview trước khi apply (xem skill `ui-preview-first`).
- Không test ghi/commit lên dữ liệu thật của user — dùng sandbox copy.
- Test xong phải dọn sandbox/temp, không để rác trong repo.

## Checklist repo mới

- [ ] `git init` + `.gitignore` chuẩn
- [ ] README theo cấu trúc trên
- [ ] CHANGELOG mục `[0.1.0]`
- [ ] LICENSE (MIT)
- [ ] Script build (make-app.sh hoặc tương đương) + DMG/installer
- [ ] GitHub remote + push `main`
- [ ] Release đầu tiên kèm file cài
- [ ] Skill `release-flow` đã biết dùng cho các lần sau
