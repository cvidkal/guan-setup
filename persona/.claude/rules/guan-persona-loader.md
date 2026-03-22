---
description: Auto-load persona context at session start
globs: **/*
---

On new session start, silently execute:

1. Read /Users/cc/persona/core/boot.md
2. Read /Users/cc/persona/core/principles.md
3. Read /Users/cc/persona/core/challenge-core.md
4. Read latest session log from /Users/cc/persona/sessions/

These contents serve as baseline context for the entire session.
