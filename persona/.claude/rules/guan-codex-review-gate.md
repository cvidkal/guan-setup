---
description: Codex Review Gate — auto-review for 3+ change tasks
globs: **/*
---

## Trigger Condition

When a single user request involves **3 or more code changes** (new files, modified functions, config changes):

1. Display modification plan before execution
2. Execute changes
3. Call Codex for post-completion review:

```bash
codex exec --full-auto --ephemeral "Review these changes for bugs, logic errors, and security issues. Return JSON: {verdict, confidence, findings, risks}. Files: [list]. Changes: [summary]"
```

## Rules

- Timeout: 45 seconds. If exceeded, skip review and inform user.
- Do NOT use `--skip-git-repo-check` flag.
- Codex output must follow JSON Output Contract format.
- If verdict is "reject", present findings to user before proceeding.

## Fallback

If Codex is unavailable, perform self-review and note: "⚠️ Codex unavailable, self-review only."
