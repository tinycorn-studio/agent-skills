---
name: ui-preview-first
description: Render ảnh preview/mockup giao diện TRƯỚC khi sửa code UI (preview, mockup, xem trước giao diện, design, phác thảo, demo ảnh, duyệt thiết kế). Use when the user wants to see or approve a UI design before implementation, or when proposing UI changes - render offscreen to PNG, open for approval, then apply. Use this whenever a change touches views/layout/colors.
---

# UI preview first (TinyCorn Studio standard)

**Quy tắc:** mọi thay đổi giao diện phải có ảnh preview được user duyệt **trước khi** apply vào code.

## Workflow

1. **Viết script render offscreen** trong `tools/preview_<tên>.swift` — không cần chạy app, render trực tiếp ra PNG 2x.
2. **Chạy** và mở ảnh cho user:

   ```bash
   swift tools/preview_<tên>.swift ~/Desktop/<App>-<Tên>-Preview.png
   open ~/Desktop/<App>-<Tên>-Preview.png
   ```

3. **Hỏi duyệt** — nếu có nhiều lựa chọn thiết kế, render 2–4 phương án cạnh nhau và hỏi user chọn (A/B/C/D).
4. **Chỉ apply sau khi user OK.** Commit script preview kèm feature.
5. Nếu user yêu cầu chỉnh: sửa script, render lại, lặp đến khi duyệt.

## Code skeleton (SwiftUI, macOS)

```swift
import AppKit
import SwiftUI

struct PreviewRoot: View {
    var body: some View {
        // Dựng UI giả lập bằng đúng component/màu của app
        VStack { /* ... */ }
            .frame(width: 900, height: 600)
            .background(Color(nsColor: .windowBackgroundColor))
    }
}

let host = NSHostingView(rootView: PreviewRoot())
host.frame = NSRect(x: 0, y: 0, width: 900, height: 600)
host.layoutSubtreeIfNeeded()

let rep = host.bitmapImageRepForCachingDisplay(in: host.bounds)!
host.cacheDisplay(in: host.bounds, to: rep)

let png = rep.representation(using: .png, properties: [:])!
let out = CommandLine.arguments.count > 1
    ? CommandLine.arguments[1]
    : "preview.png"
try! png.write(to: URL(fileURLWithPath: out))
print("Wrote \(out)")
```

## Pitfalls (đã gặp thật)

- **Không đặt tên biến toàn cục trùng modifier/view SwiftUI** (vd `border`) → lỗi overload. Dùng `borderColor`.
- Header dùng chung giữa các method nên **không khai báo trùng** ở nơi khác trong cùng file.
- Render 2x: set `rep.size` hoặc dùng `bitmapImageRepForCachingDisplay` + `cacheDisplay` như trên; đừng quên `layoutSubtreeIfNeeded()` trước khi cache.
- Không dùng `screencapture`/AppleScript để chụp app — máy thường thiếu quyền Screen Recording (`-1743`). Offscreen render là cách duy nhất chắc chắn.
- App tối theme: dùng cùng `Color(nsColor:)` và asset của app để preview khớp thực tế.
- Lưu ảnh ra `~/Desktop/` cho user dễ tìm, tên dạng `<App>-<Feature>-Preview.png`.

## Ngoài SwiftUI

- Web: mở HTML mockup bằng trình duyệt rồi chụp, hoặc Playwright screenshot.
- CLI/TUI: render bằng ANSI trong terminal hoặc mô tả text có màu.

Nguyên tắc chung không đổi: **ảnh trước, code sau, user duyệt mới apply.**
