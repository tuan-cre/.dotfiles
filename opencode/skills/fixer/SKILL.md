---
name: fixer
description: Bounded execution specialist for well-defined implementation, test files, and utility scripts. Delegate for parallelism and context isolation. Same model as orchestrator.
---

# Fixer Agent

## Overview

The fixer runs **the same model as the orchestrator** (`opencode/big-pickle`). Its value is not a different model — it's **parallelism and context isolation**. By delegating bounded work to fixer, the orchestrator keeps its working memory clean and both agents work simultaneously.

**Cost**: Same as orchestrator — free on this setup.

## When to Delegate to Fixer

All agents share capable models. Fixer's value is:
- **Parallelism** — runs alongside other agents
- **Context isolation** — keeps your orchestrator context uncluttered
- **Speed** — bounded tasks complete while you do other work

### Good Fit ✅

- **Bounded implementation** — single-file scripts, small functions, well-defined utilities
- **Test file changes** — creating/updating test files, fixtures, mocks, test helpers
- **Repetitive pattern code** — following an established pattern across multiple files
- **Single-responsibility files** — one clear task per file
- **Parallel work** — multiple independent files can be split across parallel fixer instances

### Bad Fit ❌

- **Multi-step reasoning** — architecture decisions, debugging, research (use orchestrator or @oracle)
- **Complex refactors** — touching many files with interdependent changes (use orchestrator)
- **Tasks needing broad project context** — orchestrator has the richest context

## How to Delegate Efficiently

### Do This

```
Write a Python script at scripts/health.py that:
1. Checks if localhost:8080 is responding
2. Prints VRAM usage via nvidia-smi
3. Returns exit code 0 if healthy, 1 if not
```

Give the fixer:
- Exact file paths
- Clear bullet-point requirements
- Reference files/patterns it should follow
- Context pre-digested (not raw logs)

### Don't Do This

```
Fix the server. It's broken somehow. Check the logs and figure out what's wrong.
```

The fixer is execution-focused — it doesn't do diagnosis.

### Parallel Execution

When work spans multiple folders, spawn one fixer per folder:

```
# Folder A: backend routes
@fixer Create the user CRUD routes in src/routes/users.ts...

# Folder B (parallel): tests
@fixer Create tests for the user routes in tests/routes/users.test.ts...
```
