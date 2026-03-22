---
description: Display GUAN Framework status overview
allowed-tools: Read, Bash, Grep, Glob
---

GUAN Framework v1.3 — Status Report

## Steps

1. Count cards by type and status from indexes/card-index.yaml
2. List projects from core/projects-overview.md
3. Count pending proposals from proposals/
4. Read latest session log date
5. Check review_after dates for cards needing review

## Output

```
╔══════════════════════════════════════╗
║     GUAN Framework v1.3 Status      ║
╚══════════════════════════════════════╝

Cards:
  Heuristics:     [count]
  Anti-patterns:  [count]
  Communication:  [count]
  Domain:         [count]
  Uncertainty:    [count]
  Principle:      [count]
  ─────────────────────
  Total:          [count] (active: X | cooling: Y | archived: Z)

Reviews due:     [count] cards past review_after date
Proposals:       [count] pending

Projects:        [list with status]

Last session:    [date]
Last /save:      [date]
```
