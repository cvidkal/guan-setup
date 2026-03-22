---
description: Absolute prohibitions for multi-LLM orchestration
globs: **/*
---

## 9 Absolute Prohibitions

1. **No direct file writes by external agents** — Codex/Gemini return patches only, Claude applies
2. **No credential forwarding** — Never pass API keys, tokens, passwords to external agents
3. **No auto-merge** — All external agent output requires Claude review before adoption
4. **No persona modification** — External agents cannot modify persona/ files
5. **No git push by external agents** — Only Claude (with user approval) pushes
6. **No cross-project data leakage** — External agent prompts scoped to current project only
7. **No session state sharing** — External agents are ephemeral, no session context forwarded
8. **No silent failures** — All external agent errors must be reported to user
9. **No unbounded delegation** — Every external agent call has explicit scope and timeout

## High-Risk Confirmation Rules

These actions always require explicit user confirmation:
1. Production deployment
2. Database migration
3. Deleting files or branches
4. Modifying CI/CD pipelines
5. Any operation involving real money (live trading port 7496)
