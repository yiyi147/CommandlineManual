# macOS 命令行大全

一个 macOS 原生 SwiftUI 应用，收录常用命令行工具的完整参考手册。

## 功能

- **分类浏览** — 25+ 分类，覆盖文件系统、文本处理、网络、进程管理、Shell 环境等
- **快速搜索** — 支持命令名、语法、描述全文搜索
- **一键复制** — 点击即可复制命令到剪贴板
- **Ghostty 集成** — 点击 run 直接在 Ghostty 终端中执行命令
- **键盘导航** — 上下方向键切换分类，左右切换命令
- **分类导航面板** — `⌘Z` 唤出全局命令网格，环形滚动，方向键快速定位

## 快捷键

| 按键 | 功能 |
|------|------|
| `⌘Z` | 打开/关闭分类导航面板 |
| `↑` `↓` | 上下切换分类 |
| `←` `→` | 左右切换命令 |
| `Enter` | 跳转到选中命令 |
| `Esc` | 关闭导航面板 |

## 运行

```bash
# 需要 Xcode 15+
xcodebuild -scheme CommandlineManual -sdk macosx build
open Build/Products/Debug/CommandlineManual.app
```

## 环境要求

- macOS 14.0+
- Xcode 15.0+
- [Ghostty](https://ghostty.org/)（用于 run 功能）

## 截图

<img width="891" alt="Screenshot" src="https://github.com/yiyi147/CommandlineManual/assets/placeholder.png">

## License

MIT
