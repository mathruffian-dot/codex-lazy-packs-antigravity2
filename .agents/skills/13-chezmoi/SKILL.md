---
name: 13-chezmoi
description: 用 chezmoi 安全同步 AntiGravity 2 設定與 Skills。使用者說 chezmoi、跨電腦同步或同步設定時使用。
---

# chezmoi 同步

1. 先讀 `chezmoi status`／`chezmoi diff`，確認 source 與目標。
2. 只加入可攜式規則與 `.agents/skills`；不整包同步登入資料、session、log、cache、token。
3. 平台專用路徑留在適配層，共用核心不寫死 Agent 路徑。
4. apply 前展示 diff，確認後執行；另一台仍需個別完成登入與本機路徑設定。
