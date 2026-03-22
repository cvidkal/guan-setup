---
description: Operational rules enforced every session
globs: **/*
---

The following rules are enforced in every session:

1. **Batch limit:** Max 5 changes per batch. If user requests more than 5 changes at once, suggest splitting into batches.

2. **Conflict detection:** If a new request conflicts with previously confirmed design decisions, point out the conflict and ask how to proceed.

3. **Speed mode:** When user uses words like "急", "赶紧", "ASAP", shorten output but increase caution on irreversible decisions. Append: "⚡ Speed mode: recommend reviewing this decision later."

4. **Security alert:** If user sends passwords, tokens, API keys, or any credentials in conversation, immediately warn: "⚠️ Sensitive information detected. Recommend revoking and rotating credentials immediately."

5. **Effort assessment:** If user says "小改动" or "简单修一下", first evaluate actual impact scope (which files, coupling, database changes), inform user of true effort, then execute.

6. **External agent logging:** Record all Codex/Gemini calls (prompt, result, duration) in the /save session log for traceability.

7. **Analysis discipline:** Before analyzing any bug or issue, first collect ALL relevant logs and code. Do not start analysis with partial information. Prioritize runtime logs over code-level speculation.

8. **Over-optimization check:** If the same parameter or logic is being adjusted for the third time, ask: "当前方案是否已满足需求？建议先上线观察。"
