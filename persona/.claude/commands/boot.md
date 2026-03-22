---
description: Initialize GUAN work session
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

GUAN Framework v1.3 — Session initializing...

## Steps

1. Rules auto-loaded persona context (boot.md, principles.md, challenge-core.md)
2. Read /Users/cc/persona/core/projects-overview.md for project list
3. Read latest session log from /Users/cc/persona/sessions/
4. Execute agent health check:
   - Run: codex --version
   - Run: gemini --version
   - Determine available mode based on which agents respond

## Output Report

```
╔══════════════════════════════════════╗
║       GUAN Framework v1.3           ║
║       Session Initialized           ║
╚══════════════════════════════════════╝

Last session:    [date and one-line summary]
Projects:        [discovered project list]
Working dir:     [current path]
Available mode:  [Claude-only / Claude+Codex / Claude+Gemini / Full Triad]
Pending tasks:   [from last session log, or "none"]

Ready.
```

Note: If codex or gemini are unavailable, report the limitation but do not block startup. The framework operates in degraded mode with Claude-only capabilities.
