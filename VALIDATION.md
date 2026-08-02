# Validation

更新日期：2026-08-02

## NotebookLM Skill

- Skill Creator `quick_validate.py`：通過。
- 全部 15 個 Skill frontmatter：通過。
- 唯讀診斷實機狀態：正確分類為 `stale_session_or_internal_api_error`。
- 診斷腳本正確辨識：CLI 0.9.4、Chrome 已安裝、saved session 存在、NotebookLM 網站可連線、MCP 已設定。
- 模擬 CLI 缺少：正確分類為 `cli_missing`，未嘗試自動安裝。
- Windows CP950：所有 `nlm` 指令先設定 `PYTHONUTF8=1`，避免 `nlm setup list` 的 UnicodeDecodeError。

## AntiGravity CLI 1.1.9

以新專案與 sandbox 唯讀驗證兩個情境：

1. 「OAuth 打不開」：正確說明不是標準 OAuth，只要求使用者在可見 PowerShell 執行一次登入，不索取 Cookie 或筆記本資料。
2. 「完成一次登入但驗證仍失敗」：正確啟動防循環停止規則，回報 `stale_session_or_internal_api_error`，不要求第二次登入、不切換套件。

未執行互動登入、未顯示 Cookie、未列出私人筆記本、未修改現有 MCP 設定。
