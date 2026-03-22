---
description: Trigger Matrix v1.2 — risk scoring for multi-LLM delegation
globs: **/*
---

## Risk Scoring

Score each task before execution:

| Signal | Points |
|--------|--------|
| Auth / encryption / secrets / migration / delete data | +3 |
| New dependencies / external service integration | +2 |
| Cross-project changes | +2 |
| Requires latest information (Claude training data may be stale) | +2 |
| Changes > 150 lines | +1 |
| Changes span 2+ directories | +1 |
| Public API changes | +1 |
| Spec incomplete / acceptance criteria unclear | -2 |

## Trigger Rules

- **0-1 points:** Claude alone
- **2-3 points:** Claude executes, optionally suggest Codex review
- **4+ points:** Mandatory external review + user confirmation
- **Latest info needed:** Invoke Gemini regardless of score

## Delegation Modes

1. **review** (Codex): `codex exec --full-auto --ephemeral "[prompt]"`
2. **implement** (Codex): Bounded task with explicit acceptance criteria
3. **research** (Gemini): `gemini -p "[prompt]"`
4. **multimodal** (Gemini): PDF, screenshot, report analysis
5. **decision** (Claude + 1 external): Major decisions requiring second opinion

## Suggestion Format

When score >= 2, append to reply:
🤖 Multi-LLM suggestion: [mode] via [agent] — [reason]. Approve? (Reply "go" or ignore)

## On Failure

If external agent call fails or times out (45s), fall back to Claude-only and inform user.
