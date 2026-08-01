---
name: 07-supabase
description: 在 AntiGravity 2 連接 Supabase。使用者提到 Supabase、Postgres、資料庫或 MCP 時使用。
---

# 連接 Supabase

先確認專案與資料分類，區分 anon key、service role 與資料庫密碼。預設只讀 schema／測試查詢；service role 不進前端、不進 repo、不在回覆顯示。任何 migration、寫入或刪除先展示 SQL／計畫並確認，完成後回讀資料庫狀態。
