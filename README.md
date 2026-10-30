# TinyCorn Studio — Agent Skills

Bộ skill chuẩn hóa quy trình phát triển phần mềm và làm game Unity hiệu năng cao, dùng được cho **mọi dự án về sau**. Viết theo chuẩn mở [Agent Skills](https://agentskills.io) (`SKILL.md`) — chạy được với **Google Antigravity**, **Claude Code**, **opencode**, **Cursor**, **Copilot**, **Codex**...

---

## Danh sách Skills (15 Skills)

### 1. Quy trình Studio (Core Studio Workflows)

| Skill | Dùng khi nào |
|---|---|
| **`release-flow`** | Phát hành version mới: bump version → build installer (DMG/…) → cập nhật CHANGELOG → tag → GitHub Release kèm file cài |
| **`ui-preview-first`** | Trước khi thay đổi giao diện: render ảnh preview/mockup cho user duyệt rồi mới apply |
| **`studio-conventions`** | Quy ước chung khi tạo/bảo trì repo: README, CHANGELOG, commit message, `.gitignore`, tài liệu |

### 2. Đội hình Unity Hiệu năng cao (Unity High-Performance Stack)

| Skill | Dùng khi nào |
|---|---|
| **`unity-csharp-fundamentals`** | Chuẩn code C# trong Unity: Null-safety trên `UnityEngine.Object`, `TryGetComponent`, `[SerializeField]`, Lifecycle |
| **`unity-unitask`** | Lập trình bất đồng bộ Zero-Allocation với **UniTask**: `CancellationToken` (`destroyCancellationToken`), `PlayerLoopTiming`, `TaskTracker`, thay thế Coroutine |
| **`unity-litmotion`** | Tweening & Animation hiệu năng cao với **LitMotion**: `LMotion`, `LSequence`, `Punch`, `Shake`, `.BindTo*()`, `.AddTo(this)`, tích hợp `.ToUniTask(ct)` |
| **`unity-addressables`** | Quản lý tài nguyên với **Addressables**: Tải/khởi tạo bất đồng bộ kết hợp UniTask, đếm tham chiếu (Reference Counting) và giải phóng bộ nhớ chống leak |
| **`unity-collection-pool`** | Tối ưu bộ nhớ RAM với `UnityEngine.Pool` (`ListPool`, `HashSetPool`, `DictionaryPool`) dùng cú pháp `using` thay thế LINQ (0 byte GC) |
| **`unity-object-pooling`** | Tái sử dụng GameObject, Prefab, Projectile, UI Damage Number và AudioSource kèm cơ chế Prewarm qua nhiều frame |
| **`unity-scriptable-objects`** | Kiến trúc hướng dữ liệu (Data-Driven), cấu hình tĩnh và hệ thống **Event Channels** giúp tách rời (decouple) các hệ thống |
| **`unity-vcontainer`** | Dependency Injection (DI) với **VContainer**: Quản lý `LifetimeScope`, Constructor Injection, EntryPoints (`IAsyncStartable`) và phòng tránh lỗi Disposal Crash |
| **`unity-r3`** | Lập trình Reactive hiện đại với **R3** (Cysharp): `ReactiveProperty`, `Observable` streams và kiến trúc MVVM/MVP |
| **`unity-memorypack`** | Lưu/đọc dữ liệu nhị phân siêu tốc Zero-Allocation với **MemoryPack** cho hệ thống Save/Load game |
| **`unity-profiling`** | Đo đạc & tối ưu hiệu năng: `ProfilerMarker`, `FrameTimingManager`, theo dõi GC Allocation, phát hiện giật khung hình (`HitchDetector`) và Frame/Memory Budget |
| **`unity-mobile-optimization`** | Tối ưu chuyên biệt cho iOS/Android: Tự động phân tầng cấu hình máy (`DeviceClassifier`), chống quá nhiệt (`ThermalManager`), tiết kiệm pin và cấu hình IL2CPP |

---

## Cài đặt

### Cách 1 — Chạy Script Liên kết Tự động (Khuyên dùng)

Clone repo rồi chạy script tương ứng với hệ điều hành để liên kết (Symlink / Junction) vào các AI Agent:

**Trên Windows (PowerShell):**
```powershell
git clone https://github.com/tinycorn-studio/agent-skills.git
cd agent-skills
powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1
```

**Trên macOS / Linux (Bash):**
```bash
git clone https://github.com/tinycorn-studio/agent-skills.git
cd agent-skills
./scripts/install.sh
```

Script sẽ tự động gắn toàn bộ skills vào:
- `~/.gemini/config/skills/` (**Google Antigravity**)
- `~/.claude/skills/` (**Claude Code**)
- `~/.config/opencode/skills/` (**opencode**)
- `~/.agents/skills/` (Chuẩn chung `agentskills.io`)

Vì dùng Symlink / Directory Junction, sau này bạn chỉ cần `git pull` hoặc chỉnh sửa tại repo này là mọi công cụ AI tự động nhận bản mới ngay lập tức.

### Cách 2 — Trỏ trực tiếp trong opencode config

Thêm vào `opencode.json` (project) hoặc `~/.config/opencode/opencode.json` (global):

```json
{
  "skills": {
    "paths": ["/path/to/agent-skills/skills"]
  }
}
```

---

## Templates & Scripts

| File | Mô tả |
|---|---|
| `templates/CHANGELOG.md` | Khung CHANGELOG theo [Keep a Changelog](https://keepachangelog.com) |
| `templates/RELEASE_NOTES.md` | Khung release notes cho GitHub Release |
| `scripts/install.ps1` | Liên kết (Junction) toàn bộ skills vào Antigravity / Claude Code / opencode trên Windows |
| `scripts/install.sh` | Symlink toàn bộ skills vào Antigravity / Claude Code / opencode trên macOS & Linux |
| `scripts/release.sh` | Tự động hóa flow release cho tool macOS (`make-app.sh` + `CHANGELOG.md`) |

---

## Cấu trúc thư mục

```text
agent-skills/
├── skills/
│   ├── release-flow/SKILL.md
│   ├── studio-conventions/SKILL.md
│   ├── ui-preview-first/SKILL.md
│   ├── unity-addressables/SKILL.md
│   ├── unity-collection-pool/       # SKILL.md + references/
│   ├── unity-csharp-fundamentals/   # SKILL.md + references/
│   ├── unity-litmotion/SKILL.md
│   ├── unity-memorypack/SKILL.md
│   ├── unity-mobile-optimization/   # SKILL.md + references/
│   ├── unity-object-pooling/SKILL.md
│   ├── unity-profiling/             # SKILL.md + references/
│   ├── unity-r3/                    # SKILL.md + references/
│   ├── unity-scriptable-objects/SKILL.md
│   ├── unity-unitask/               # SKILL.md + references/
│   └── unity-vcontainer/            # SKILL.md + references/
├── templates/
│   ├── CHANGELOG.md
│   └── RELEASE_NOTES.md
├── scripts/
│   ├── install.ps1
│   ├── install.sh
│   └── release.sh
├── CHANGELOG.md
└── README.md
```

## License

MIT — xem [LICENSE](LICENSE).
