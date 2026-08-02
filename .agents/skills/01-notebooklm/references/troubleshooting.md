# NotebookLM 連接故障分流

## `browser_did_not_open`

- 確認命令是在一般可見 PowerShell 執行，不是在 AntiGravity sandbox 或 headless terminal。
- 執行 `nlm config set auth.browser chrome` 後，只重試一次 `nlm login --profile default`。
- 仍未開啟就停止，記錄 CLI 原始錯誤；不要反覆換瀏覽器或要求使用者提供 Cookie。

## `stale_session_or_internal_api_error`

特徵：Cookie、CSRF 與 saved profile 存在，但 `nlm login --check` 回傳 `ClientAuthenticationError`、`network_error` 或認證失敗。

1. 請使用者直接在 Chrome 開啟 `https://notebooklm.google.com`，確認同一帳號可正常使用。
2. 若網站正常，只執行一次可視 `nlm login --profile default`。
3. 再次驗證仍失敗就停止。可能是第三方內部 API 暫時失效，不要改成索取筆記本資料。

## `windows_encoding_error`

特徵：`UnicodeDecodeError`、`cp950`、`result.stdout` 為 null，或 `nlm setup list` 崩潰。

在該 PowerShell session 先執行：

```powershell
$env:PYTHONUTF8 = '1'
```

再重跑原本的唯讀指令一次。不要因此重裝或清除登入資料。

## `mcp_status_false_negative`

`nlm doctor` 或 `nlm setup list` 顯示未設定，不代表一定缺少 MCP。檢查 workspace `.agents/mcp_config.json` 與全域 `~/.gemini/config/mcp_config.json`，只判斷任一 server 的 `command` 檔名是否為 `notebooklm-mcp` 或 `notebooklm-mcp.exe`。

如果已存在就不要再執行 `nlm setup add antigravity`，避免重複 server。

## `workspace_policy_or_account_block`

- 請使用者在一般瀏覽器直接登入 NotebookLM，確認帳號年齡、地區與 Workspace 管理政策允許使用。
- 管理員封鎖時停止並請管理員處理；Agent 不得繞過。

## 安全備援

只有自動瀏覽器登入持續失敗、使用者了解 Cookie 風險且主動同意時，才可使用本機 Cookie 檔：

```powershell
nlm login --manual --file <本機Cookie檔案>
```

Cookie 檔必須位於版控外，使用完畢後由使用者自行安全刪除。不得把內容顯示在 terminal log、對話或 repo。
