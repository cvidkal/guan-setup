---
description: Save GUAN session — 7-phase protocol
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

GUAN Framework v1.3 — /save executing...

## Phase 1: Session Log

Create session log at /Users/cc/persona/sessions/YYYY-MM/session-YYYY-MM-DD-HHMM.md with:
- Session date, duration estimate
- Work summary (what was done)
- Decisions made (with reasoning)
- External agent calls (Codex/Gemini invocations, prompts, results)
- Open questions / pending items for next session

## Phase 2: Cognitive Quality Filter

Review conversation for cognitive value signals. For each candidate:
- Is it genuinely new? (not already captured in an existing card)
- Is it specific enough to be actionable?
- Does it have evidence from this session?

Score each candidate: HIGH (save) / MEDIUM (propose) / LOW (discard).

## Phase 3: Dedup Check

For HIGH/MEDIUM candidates:
1. Read /Users/cc/persona/indexes/lexicon.yaml for synonym matches
2. Read /Users/cc/persona/indexes/card-index.yaml for existing cards
3. If merge_key or alias matches an existing card → update existing card instead of creating new
4. If no match → proceed to write

## Phase 4: Write

For HIGH candidates:
- Write new card or update existing card
- Follow GUAN Card Format v1.1 spec
- Respect write_policy: max 1 new card, max 2 updates per /save

For MEDIUM candidates:
- Write proposal to /Users/cc/persona/proposals/ for user review later

## Phase 5: Index Update

- Update indexes/card-index.yaml with new/modified cards
- Update indexes/card-search-index.md
- Update indexes/lexicon.yaml with new aliases

## Phase 6: Git Commit

```bash
cd /Users/cc/persona
git add -A
git commit -m "/save: [one-line session summary]"
```

## Phase 7: Report

```
╔══════════════════════════════════════╗
║       GUAN /save Complete           ║
╚══════════════════════════════════════╝

Session log:     [path]
New cards:       [count] ([list ids])
Updated cards:   [count] ([list ids])
Proposals:       [count]
Total cards:     [count] (active: X, cooling: Y, archived: Z)
Git commit:      [hash]

Next session pickup: [pending items summary]
```
