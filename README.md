# TinyCorn Studio — Agent Skills

Bộ skill chuẩn hóa quy trình phát triển phần mềm của TinyCorn Studio, dùng được cho **mọi tool/repo về sau**. Viết theo chuẩn mở [Agent Skills](https://agentskills.io) (`SKILL.md`) — chạy được với opencode, Claude Code, Cursor, Copilot, Codex...

## Skills

| Skill | Dùng khi nào |
|---|---|
| **release-flow** | Phát hành version mới: bump version → build installer (DMG/…) → cập nhật CHANGELOG → tag → GitHub Release kèm file cài |
| **ui-preview-first** | Trước khi thay đổi giao diện: render ảnh preview/mockup cho user duyệt rồi mới apply |
| **studio-conventions** | Quy ước chung khi tạo/bảo trì repo: README, CHANGELOG, commit message, .gitignore, tài liệu |

## Cài đặt

### Cách 1 — Script (khuyên dùng)

Clone repo rồi chạy script symlink vào các agent host:

```bash
git clone https://github.com/tinycorn-studio/agent-skills.git
cd agent-skills
./scripts/install.sh
```

Script sẽ symlink toàn bộ skills vào:
- `~/.config/opencode/skills/` (opencode)
- `~/.claude/skills/` (Claude Code)
- `~/.agents/skills/` (chuẩn chung agentskills.io)

Vì dùng symlink, sau này `git pull` là mọi tool tự nhận bản mới.

### Cách 2 — Trỏ trực tiếp trong opencode config

Thêm vào `opencode.json` (project) hoặc `~/.config/opencode/opencode.json` (global):

```json
{
  "skills": {
    "paths": ["/Users/<ban>/path/to/agent-skills/skills"]
  }
}
```

### Cách 3 — Dùng ngay không cần cài

Đọc skill khi cần, hoặc dùng trực tiếp các script:

```bash
./scripts/release.sh 1.2.0        # tự động hóa toàn bộ release flow (xem bên dưới)
```

## Templates & scripts

| File | Mô tả |
|---|---|
| `templates/CHANGELOG.md` | Khung CHANGELOG theo [Keep a Changelog](https://keepachangelog.com) |
| `templates/RELEASE_NOTES.md` | Khung release notes cho GitHub Release |
| `scripts/release.sh` | Tự động hóa flow release cho tool macOS (make-app.sh + CHANGELOG.md) |
| `scripts/install.sh` | Symlink skills vào opencode / Claude Code / agents chung |

### scripts/release.sh làm gì?

```bash
./scripts/release.sh <version> [notes-file]
```

1. Kiểm tra working tree sạch + CHANGELOG có mục `[<version>]`
2. Bump `VERSION` trong `make-app.sh`
3. Build app + DMG (`./make-app.sh`)
4. Commit, tag `v<version>`, push `main` + tags
5. Trích mục changelog làm release notes (hoặc dùng notes-file riêng)
6. `gh release create` kèm file DMG

## Cấu trúc

```
agent-skills/
├── skills/
│   ├── release-flow/SKILL.md
│   ├── ui-preview-first/SKILL.md
│   └── studio-conventions/SKILL.md
├── templates/
│   ├── CHANGELOG.md
│   └── RELEASE_NOTES.md
├── scripts/
│   ├── release.sh
│   └── install.sh
├── CHANGELOG.md
└── README.md
```

## License

MIT — xem [LICENSE](LICENSE).
