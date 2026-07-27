# AI Terminal Pro - iOS/macOS App

## 項目概述
AI Terminal Pro 是一個功能強大的跨平台應用，結合虛擬終端、代碼編輯器和 AI 助手功能。

## 技術棧
- **語言**: Swift 5.9+
- **UI Framework**: SwiftUI
- **Graphics**: Metal (GPU 加速, Liquid Glass 效果)
- **平台**: iOS 17+, macOS 14+

## 項目結構
```
AITerminalPro/
├── Sources/
│   ├── App/
│   │   └── MainApp.swift          # 主應用入口
│   ├── FileSystem/
│   │   └── VirtualFileSystem.swift  # 虛擬文件系統
│   ├── Terminal/
│   │   ├── TerminalEngine.swift    # 終端引擎
│   │   └── ANSIParser.swift        # ANSI 色彩解析
│   ├── AI/
│   │   └── AIEngine.swift          # AI API 集成
│   └── Metal/
│       ├── MetalRenderer.swift     # Metal 渲染器
│       └── Shaders.metal           # GPU Shader 代碼
├── .github/workflows/
│   └── build-ipa.yml               # GitHub Actions CI/CD
├── Package.swift                   # Swift Package 配置
└── README.md
```

## 核心功能

### 1. 虛擬終端 (TerminalEngine)
- 支援基本 Shell 命令 (pwd, ls, cd, mkdir)
- ANSI 色彩代碼解析
- 實時命令執行和輸出

### 2. 虛擬文件系統
- 沙箱隔離的文件操作
- 相對路徑和絕對路徑支援
- 防越界安全檢查

### 3. Metal Liquid Glass 效果
- 高斯模糊 (Gaussian Blur)
- 高光和反射計算
- 120Hz ProMotion 流暢渲染
- Alpha Blending 混合模式

### 4. AI 助手集成
- OpenAI GPT-4o-mini 集成
- 錯誤日誌分析和解釋
- 異步 API 調用

## 編譯和打包指南

### 本地編譯 (macOS)

1. **克隆項目**
   ```bash
   git clone <repo-url>
   cd AITerminalPro
   ```

2. **安裝依賴**
   ```bash
   swift build
   ```

3. **為 iPhone 編譯**
   ```bash
   xcodebuild -scheme AITerminalPro \
              -sdk iphoneos \
              -configuration Release \
              -derivedDataPath build \
              CODE_SIGN_IDENTITY="" \
              CODE_SIGNING_REQUIRED=NO \
              build
   ```

4. **打包 .ipa 文件**
   ```bash
   mkdir -p Payload
   cp -R build/Build/Products/Release-iphoneos/AITerminalPro.app Payload/
   zip -r AI-Terminal-Pro.ipa Payload
   ```

### 自動化編譯 (GitHub Actions)

1. **推送到主分支觸發編譯**
   ```bash
   git push origin main
   ```

2. **下載編譯產物**
   - 前往 GitHub Actions 工作流頁面
   - 點擊最近的編譯任務
   - 下載 "AI-Terminal-Pro-IPA" 工件

### 側載到 iPhone

1. **使用 iTunes/Finder**
   - 用 USB 連接 iPhone
   - 打開 Finder (macOS 10.15+) 或 iTunes
   - 選擇裝置，點擊應用程式標籤
   - 拖放 .ipa 文件進去

2. **使用 Xcode**
   - 打開 Xcode
   - 前往 Window > Devices and Simulators
   - 選擇你的 iPhone
   - 拖放 .ipa 文件

3. **使用 Apple Configurator 2**
   - 下載並安裝 Apple Configurator 2
   - 連接 iPhone
   - 選擇你的設備
   - 拖放 .ipa 文件安裝

## 環境變量配置

### AI API Key
在編譯前，在項目根目錄創建 `.env` 文件：
```
OPENAI_API_KEY=your_api_key_here
```

## 依賴項
- **Swift**: 5.9 或更新版本
- **Xcode**: 15.4 或更新版本
- **iOS SDK**: 17.0+
- **macOS SDK**: 14.0+

## 已知限制
- 虛擬文件系統的文件大小限制為應用沙箱限制
- AI 功能需要有效的 OpenAI API Key
- Metal 渲染需要支援 Metal 的 iOS/macOS 設備

## 后续改進計劃
- [ ] 添加更多 Shell 命令支援
- [ ] 實現文件上傳/下載
- [ ] 支持多個 AI 模型選擇
- [ ] 黑暗/亮色主題切換
- [ ] 代碼語法高亮
- [ ] 集成 Python/JavaScript 運行時

## 許可證
MIT License

## 貢獻
歡迎提交 Pull Request 和 Issue！

## 支援
如有問題，請提交 GitHub Issue 或聯繫開發者。

---

**最後編譯日期**: 2026-07-27
**版本**: 1.0.0
