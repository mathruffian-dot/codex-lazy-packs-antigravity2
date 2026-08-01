# AntiGravity 2 懶人包

給教師與初學者使用的十五個專案層級 Skills。每個主題獨立、按需載入，不把 Codex、Claude 或 OpenCode 的專用設定帶進 AntiGravity 2。

## 使用

```powershell
git clone https://github.com/mathruffian-dot/codex-lazy-packs-antigravity2.git
Set-Location .\codex-lazy-packs-antigravity2
agy
```

輸入 `/skills` 應看到十五個技能。只選當下任務需要的技能，不要一次安裝所有外部服務。

## 主題

| 編號 | 技能 | 用途 |
|---|---|---|
| 00 | `00-env-setup` | 環境快篩 |
| 00A | `00-install-all` | 全包檢查清單，不自動大量安裝 |
| 01 | `01-notebooklm` | NotebookLM 連接規劃 |
| 02 | `02-essentials` | 新手必要工具 |
| 03 | `03-github` | GitHub CLI |
| 04 | `04-github-obsidian` | GitHub＋Obsidian |
| 05 | `05-obsidian` | Obsidian 專案筆記 |
| 06 | `06-second-brain` | 第二大腦結構 |
| 07 | `07-supabase` | Supabase 最小權限連接 |
| 08 | `08-firebase` | Firebase 專案連接 |
| 09 | `09-ollama` | 本機 Ollama |
| 10 | `10-gemini` | Gemini API 安全設定 |
| 11 | `11-workspace` | 專案初始化 |
| 12 | `12-draw` | 生圖工作流 |
| 13 | `13-chezmoi` | 安全同步設定 |

## 共通安全線

- Windows 指令使用 PowerShell。
- 先檢查版本與登入狀態，不直接重裝。
- API key、OAuth token、Cookie、學生資料不進 repo 或對話輸出。
- MCP、Browser、CLI 先唯讀驗證；寫入、公開、刪除前取得確認。
- 不使用 `--dangerously-skip-permissions`。

本 repo 由 `codex-lazy-packs` 衍生；舊版長篇文章保留在來源 repo，本版只收錄 AntiGravity 2 可執行的技能。

MIT License
