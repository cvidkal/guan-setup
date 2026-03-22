---
description: Monitor for cognitive value signals during work
globs: **/*
---

Monitor for cognitive value signals during conversation.

## Trigger Conditions (any one triggers prompt)

- User makes an important decision (tech choice, business rule change, architecture adjustment)
- User describes a working pattern or preference not yet recorded
- User makes a mistake and learns a lesson
- User expresses a new principle or value judgment
- User behavior contradicts an existing card in persona/cards/

## When Triggered

Append to reply:
💾 Cognitive collection suggestion: [brief description] — Save as card? (Reply "存" or ignore)

## On User Reply "存"

1. Create file in /Users/cc/persona/cards/[appropriate_subdirectory]/
2. Filename format: [type]-[id]-[semantic-slug].md (id = max existing id + 1)
3. Use GUAN Card Format v1.1 (YAML frontmatter + Markdown body)
4. git add the file && git commit -m "New card: [title]"
5. Continue normal work without interrupting user

## On User Reply "立即入库"

Same as "存" but also update indexes/card-index.yaml and indexes/card-search-index.md.

## On User Ignore

No action. Continue normal work.
