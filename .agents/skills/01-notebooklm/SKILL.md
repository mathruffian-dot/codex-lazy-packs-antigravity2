---
name: 01-notebooklm
description: 在 AntiGravity 2 安裝、登入、診斷與驗證第三方 NotebookLM CLI/MCP。當使用者提到 NotebookLM 登入失敗、OAuth 打不開、nlm、notebooklm-mcp、MCP 未連線、筆記本或資料來源自動化時使用。
---

# 連接 NotebookLM

## 先說明連接方式

- `notebooklm-mcp-cli` 是第三方工具，透過獨立 Chromium 瀏覽器取得 NotebookLM session Cookie；這不是標準 Google OAuth。
- 不要引導使用者到 AntiGravity 的 MCP OAuth 按鈕，也不要要求貼上 Cookie、token、Notebook ID 或筆記本內容。
- 一般版 NotebookLM 使用內部 API，可能因 Google 改版失效。企業版官方 API 是另一套服務。

## 固定狀態流程

一次只執行一個階段。記住目前階段，不要回到已完成階段。

### 1. 唯讀診斷

在所有 `nlm` 指令前設定 Windows UTF-8，避免 CP950 讓診斷程式本身崩潰：

```powershell
$env:PYTHONUTF8 = '1'
```

優先執行：

```powershell
pwsh -NoProfile -File .\.agents\skills\01-notebooklm\scripts\Test-NotebookLMConnection.ps1 -Json
```

若腳本不可用，才依序執行 `nlm --version`、`nlm login --check`、`nlm doctor`。只摘要狀態，不輸出帳號、Cookie、token 或筆記本名稱。

### 2. 安裝或更新

只有 CLI 缺少或使用者要求更新時才提議安裝。先取得確認，再執行：

```powershell
uv tool install --force notebooklm-mcp-cli
```

不要因登入失敗反覆重裝。

### 3. 可視登入交接

若 `authValid` 為 false，禁止在 AntiGravity 背景、headless 或 sandbox terminal 中反覆執行 `nlm login`。請使用者在一般、可見的 PowerShell 視窗親自執行：

```powershell
$env:PYTHONUTF8 = '1'
nlm config set auth.browser chrome
nlm login --profile default
```

說明會開啟一個由 `nlm` 管理的獨立 Chrome 視窗。要求使用者完成登入後只回答「登入完成」；不要索取任何登入資訊。

### 4. 一次驗證

使用者回覆「登入完成」後，只驗證一次：

```powershell
$env:PYTHONUTF8 = '1'
nlm login --check
nlm doctor
```

成功才進入 MCP 設定。若仍失敗，立即停止並依 [troubleshooting.md](references/troubleshooting.md) 回報分類，不再要求使用者提供資料或重做同一步。

### 5. MCP 設定

診斷腳本以 `command` 是否指向 `notebooklm-mcp` 判定設定，不依 server 名稱；`nlm doctor` 或 `nlm setup list` 可能因名稱不同誤報未設定。

若確實未設定，先預告會修改 AntiGravity MCP 設定並取得確認，再執行：

```powershell
$env:PYTHONUTF8 = '1'
nlm setup add antigravity
```

不要建立重複的 `notebooklm`／`notebooklm-mcp` server。設定後要求使用者重新啟動 AntiGravity，或用 `/mcp` 重新載入。

### 6. 唯讀驗證

重新載入後只列出筆記本，先回報連線成功與數量；除非使用者要求，不顯示私人筆記本標題。建立、上傳、分享、下載或刪除前另行說明影響並取得確認。

## 防循環規則

- 互動登入最多一次，登入後驗證最多一次。
- 第二次驗證仍失敗時必須停止，不猜測、不改用其他套件、不要求使用者搬運 NotebookLM 資訊。
- 只回報：失敗階段、錯誤分類、已完成檢查、單一下一步。
- `nlm login --manual --file <path>` 只作進階最後備援；不得要求把 Cookie 貼到對話，且必須先說明風險並取得同意。
