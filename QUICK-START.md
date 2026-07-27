# AI Terminal Pro - 快速開始指南

## 📋 前置需求

在開始編譯前，請確保你的 macOS 系統具備以下條件：

### 硬體需求
- **Mac 電腦**: Intel 或 Apple Silicon (M1/M2/M3+)
- **內存**: 至少 8GB RAM (16GB 推薦)
- **存儲**: 至少 10GB 可用空間 (Xcode + build artifacts)

### 軟體需求
- **macOS**: 12.0 或更新版本
- **Xcode**: 15.4 或更新版本
- **Swift**: 5.9 或更新版本
- **iOS SDK**: iOS 17.0+

## 🚀 快速開始

### 步驟 1: 安裝 Xcode 命令行工具
```bash
xcode-select --install
```

### 步驟 2: 克隆或下載項目
```bash
git clone <your-repo-url>
cd AITerminalPro
```

### 步驟 3: 授予構建腳本執行權限
```bash
chmod +x build-ipa.sh
```

### 步驟 4: 執行構建
```bash
./build-ipa.sh
```

構建將耗時 5-15 分鐘，取決於您的機器性能。

### 步驟 5: 驗證 .ipa 檔案
```bash
ls -lh AI-Terminal-Pro-Release.ipa
file AI-Terminal-Pro-Release.ipa
```

---

## 📱 將 .ipa 側載到 iPhone

### 方法 1: 使用 Xcode (推薦)

1. **連接 iPhone**
   - 用 USB 線連接 iPhone 到 Mac
   - 解鎖 iPhone 並點擊"信任"

2. **打開 Devices and Simulators**
   ```
   Xcode → Window → Devices and Simulators
   ```

3. **拖放 .ipa 文件**
   - 在左側選擇你的 iPhone
   - 將 `AI-Terminal-Pro-Release.ipa` 拖放到應用列表

4. **等待安裝完成**
   - 安裝通常需要 1-3 分鐘

### 方法 2: 使用 Finder (macOS 10.15+)

1. **打開 Finder 並連接 iPhone**
2. **前往 Locations > 你的 iPhone**
3. **點擊 "Files" 標籤**
4. **拖放 .ipa 文件**

### 方法 3: 使用 Apple Configurator 2

1. **下載 Apple Configurator 2**
   ```
   App Store 搜尋 "Apple Configurator 2"
   ```

2. **啟動應用並連接 iPhone**

3. **選擇設備並點擊 "Add"**

4. **選擇 .ipa 文件並確認**

### 方法 4: 使用 iTunes (較舊的 macOS)

1. **打開 iTunes**
2. **連接 iPhone**
3. **選擇設備並前往 "Apps" 標籤**
4. **拖放 .ipa 文件**
5. **點擊 "Sync"**

---

## 🔧 進階編譯選項

### 自訂編譯設置

編輯 `build-ipa.sh` 中的以下變量：

```bash
# 變更應用名稱
PROJECT_NAME="YourAppName"

# 變更輸出 IPA 名稱
IPA_NAME="Your-App-Name.ipa"

# 其他 xcodebuild 參數
# CODE_SIGN_IDENTITY="" # 移除代碼簽名
```

### 為模擬器編譯

編譯供 iPhone 模擬器運行：

```bash
xcodebuild -scheme AITerminalPro \
           -sdk iphonesimulator \
           -configuration Release \
           -derivedDataPath build \
           build
```

### 清除構建快取

```bash
# 清除 Xcode 快取
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# 清除項目構建文件夾
./build-ipa.sh  # 自動清除
rm -rf build/ Payload/
```

---

## 🐛 常見問題和故障排除

### 問題 1: "xcodebuild: command not found"
**解決方案**:
```bash
xcode-select --install
xcode-select --reset
```

### 問題 2: "No such file or directory: build/Build/Products/..."
**解決方案**:
- 確認編譯成功 (檢查是否有編譯錯誤)
- 清除快取並重新編譯: `rm -rf ~/Library/Developer/Xcode/DerivedData/*`
- 更新到最新的 Xcode: `xcode-select --install`

### 問題 3: iPhone 無法識別 "AI Terminal Pro" 應用
**解決方案**:
- 強制重新啟動 iPhone: 按住音量 + 按鈕，然後按住側面按鈕直到關閉
- 斷開連接並重新連接 USB
- 在 Xcode 中選擇 "Clear Folder" (Cmd+Shift+K)

### 問題 4: "Code signing is required for product type 'Application'..."
**解決方案**:
確保你使用了正確的編譯命令 (無代碼簽名):
```bash
CODE_SIGN_IDENTITY="" \
CODE_SIGNING_REQUIRED=NO \
CODE_SIGNING_ALLOWED=NO
```

### 問題 5: .ipa 文件損壞或無法安裝
**解決方案**:
- 驗證 ZIP 完整性: `unzip -t AI-Terminal-Pro-Release.ipa`
- 刪除並重新生成: `rm -rf Payload AI-Terminal-Pro-Release.ipa && ./build-ipa.sh`
- 檢查 Info.plist 配置

---

## 📊 編譯效能優化

### 並行編譯
編譯腳本已設置使用所有可用核心:
```bash
-jobs $(sysctl -n hw.ncpu)
```

### 快速編譯提示
1. **使用 SSD**: 比傳統硬碟快 3-5 倍
2. **增加 RAM**: 使用 16GB+ 內存
3. **關閉不必要的應用**: 釋放系統資源
4. **避免在外接硬碟編譯**: 使用本機存儲

---

## 🚢 持續集成 (GitHub Actions)

每當你推送到 `main` 分支時，GitHub Actions 會自動編譯:

```bash
git add .
git commit -m "feat: Update AI Terminal Pro"
git push origin main
```

檢查編譯狀態:
1. 前往 GitHub 倉庫
2. 點擊 "Actions" 標籤
3. 查看最新的工作流程執行

編譯完成後:
1. 點擊工作流程
2. 向下滾動到 "Artifacts"
3. 下載 "AI-Terminal-Pro-IPA"

---

## 📚 更多資源

- [Apple Xcode 文檔](https://developer.apple.com/xcode/)
- [Swift Package Manager 指南](https://swift.org/package-manager/)
- [SwiftUI 官方文檔](https://developer.apple.com/swiftui/)
- [Metal 程式設計指南](https://developer.apple.com/metal/)

---

## ✅ 檢查清單

在提交編譯之前，請驗證：

- [ ] 已安裝 Xcode 15.4+
- [ ] 已安裝 iOS 17.0 SDK
- [ ] iPhone 已連接並信任
- [ ] 項目文件夾包含所有必要文件
- [ ] `build-ipa.sh` 有執行權限
- [ ] 沒有編譯錯誤或警告 (重要)

---

**祝你編譯順利! 🎉**

如有問題，請提交 GitHub Issue 或聯繫開發者。
