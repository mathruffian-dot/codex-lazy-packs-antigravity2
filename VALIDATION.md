# Validation

更新日期：2026-08-02

## NotebookLM Skill

- Skill Creator `quick_validate.py`：通過。
- 全部 15 個 Skill frontmatter：通過。
- 登入前唯讀診斷正確分類為 `stale_session_or_internal_api_error`。
- 診斷腳本正確辨識：CLI 0.9.4、Chrome 已安裝、saved session 存在、NotebookLM 網站可連線、MCP 已設定。
- 模擬 CLI 缺少：正確分類為 `cli_missing`，未嘗試自動安裝。
- Windows CP950：所有 `nlm` 指令先設定 `PYTHONUTF8=1`，避免 `nlm setup list` 的 UnicodeDecodeError。

## 可視登入實測

依新版流程只執行一次可視 PowerShell 登入：

```powershell
$env:PYTHONUTF8 = '1'
nlm config set auth.browser chrome
nlm login --profile default
```

結果：

- `nlm` 成功啟動獨立 Chrome 並完成登入。
- 登入後只執行一次 `nlm login --check`，結果為 `Authentication valid`。
- 唯讀驗證成功辨識非空的筆記本集合；公開紀錄不保存帳號、數量或標題。
- 認證資料只保存在本機 `nlm` profile，未寫入 repo。
- 未重新執行 `nlm setup add antigravity`，避免建立重複 MCP server。

## AntiGravity CLI 1.1.9

以新專案與 sandbox 唯讀驗證兩個情境：

1. 「OAuth 打不開」：正確說明不是標準 OAuth，只要求使用者在可見 PowerShell 執行一次登入，不索取 Cookie 或筆記本資料。
2. 「完成一次登入但驗證仍失敗」：正確啟動防循環停止規則，回報 `stale_session_or_internal_api_error`，不要求第二次登入、不切換套件。

`nlm doctor` 可能因 MCP server 名稱不同而誤報未設定；新版診斷腳本改以 server 的 `command` 是否指向 `notebooklm-mcp` 判斷。全程未顯示或提交 Cookie、token、帳號、筆記本數量與私人標題。
