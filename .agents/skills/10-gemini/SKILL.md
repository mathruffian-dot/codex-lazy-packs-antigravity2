---
name: 10-gemini
description: 安全設定 Gemini API 或 Google AI 服務。使用者說 Gemini API、Google AI Studio 或 API key 時使用。
---

# Gemini API

先確認是否真的需要 API；能用現有登入或內建能力就不要求金鑰。金鑰只放環境變數或被忽略的 `.env`，不得寫入程式、repo 或對話。用最小測試驗證模型清單／單次請求，回報狀態碼而不輸出金鑰。
