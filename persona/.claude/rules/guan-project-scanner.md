---
description: Auto-load project context when entering project directories
globs: /Users/cc/Codes/**/*
---

When user enters a project directory under /Users/cc/Codes:

1. Read ai/source/project-baseline.md (if exists)
2. Read ai/source/coding-rules.md (if exists)
3. Read ai/source/glossary.md (if exists)
4. Read CLAUDE.md

If user is in their home directory, scan /Users/cc/Codes/ and list all project folder names.
