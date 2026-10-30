# Changelog

Mọi thay đổi đáng chú ý của repo này được ghi ở đây.
Định dạng theo [Keep a Changelog](https://keepachangelog.com/vi/1.1.0/), phiên bản theo [SemVer](https://semver.org/lang/vi/).

## [0.2.0] - 2026-10-30

### Added

- Bộ 12 skills **Unity High-Performance Stack** (kết hợp tinh hoa từ `tjboudreaux/cc-plugin-unity-gamedev`, `creator-hian/claude-code-plugins` và biên soạn mới):
  - `unity-csharp-fundamentals`: Tiêu chuẩn code C# đặc thù trong Unity và quy tắc Null-safety.
  - `unity-unitask`: Lập trình bất đồng bộ Zero-Allocation với UniTask, quản lý `CancellationToken` và `TaskTracker`.
  - `unity-litmotion`: Quy chuẩn Tweening & Animation Zero-Allocation với LitMotion v2 (`LMotion`, `LSequence`, `Punch`, `Shake`, `.BindTo*()`, `.ToUniTask()`).
  - `unity-addressables`: Quản lý tài nguyên bất đồng bộ, Reference Counting và chống rò rỉ bộ nhớ với Addressables.
  - `unity-collection-pool`: Quản lý bộ nhớ tạm không rác (GC-free) với `ListPool`, `HashSetPool`, `DictionaryPool`.
  - `unity-object-pooling`: Tái sử dụng GameObject, Prefab, Component, AudioSource và cơ chế Pool Prewarming.
  - `unity-scriptable-objects`: Kiến trúc hướng dữ liệu (Data-Driven) và Event Channels với ScriptableObject.
  - `unity-vcontainer`: Dependency Injection với VContainer, quản lý vòng đời Scope và phòng tránh lỗi Disposal Crash.
  - `unity-r3`: Lập trình Reactive hiện đại với thư viện R3 (Cysharp).
  - `unity-memorypack`: Binary Serialization tốc độ cao Zero-Allocation với MemoryPack.
  - `unity-profiling`: Đo đạc hiệu năng với `ProfilerMarker`, `FrameTimingManager`, `HitchDetector` và Frame/Memory Budget.
  - `unity-mobile-optimization`: Tối ưu hóa cho iOS/Android, tự động phân tầng thiết bị (`DeviceClassifier`), chống quá nhiệt (`ThermalManager`) và cấu hình IL2CPP.
- `scripts/install.ps1`: Script cài đặt tự động (Directory Junction) trên Windows cho Google Antigravity, Claude Code, opencode và `.agents`.
- Cập nhật `scripts/install.sh` bổ sung đường dẫn `~/.gemini/config/skills` cho Google Antigravity.

## [0.1.0] - 2026-10-18

### Added

- Skill `release-flow`: quy trình phát hành version mới (bump version → build installer → CHANGELOG → tag → GitHub Release kèm file cài).
- Skill `ui-preview-first`: render ảnh preview giao diện offscreen trước khi apply thay đổi UI.
- Skill `studio-conventions`: quy ước chung cho mọi repo (README, CHANGELOG, commit, .gitignore, tài liệu).
- `scripts/release.sh`: tự động hóa toàn bộ release flow cho tool macOS (make-app.sh + DMG).
- `scripts/install.sh`: symlink skills vào opencode / Claude Code / agents chung.
- Templates: `CHANGELOG.md`, `RELEASE_NOTES.md`.
