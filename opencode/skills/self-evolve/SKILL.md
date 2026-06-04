---
name: self-evolve
description: Audits and updates the orchestrator's own config files when they become stale or incorrect. Use when the user says "evolve", "update your config", "fix your instructions", or after major setup changes that might make your config files wrong.
---

# Self-Evolve

## Overview

Your behavior is defined by files on disk: agent append prompts, skill files, global AGENTS.md, and the opencode config. When these files contain stale or incorrect information about your model lineup, capabilities, or workflow, you need to fix them yourself.

This skill defines **when** to audit, **what** to check, and **how** to update your own instructions.

---

## When to Self-Audit

Trigger a self-evolution pass when:

1. **User requests it** — "evolve yourself", "update your config", "fix your instructions"
2. **After major setup changes** — model switch, new provider, new plugin
3. **After you identify stale info** — e.g., the system prompt says something different from your append files
4. **Periodic heartbeat** — every ~10 sessions, do a quick audit
5. **When your memory list includes config paths** — cross-reference them for freshness
6. **After memory reconstruction** — updating/removing memory entries may reveal stale configs or skills that need updates too
7. **After a new pattern crystallizes** — you used the same approach 2+ times and it's not yet codified in any skill

---

## Audit Checklist

Open each file and check for these specific issues:

### 1. Agent Append Files (`*/oh-my-opencode-slim/*/*_append.md`)

| Check | What to Look For |
|-------|------------------|
| **Model name match** | Does the file say you run Model X, but system prompt says Model Y? |
| **Agent lineup** | Are specialist agents listed with correct model names? |
| **Active preset** | Does the file match the active preset in your oh-my-opencode-slim.jsonc? |
| **Tool references** | Does it mention tools you no longer have access to? |
| **Outdated comparisons** | "Fixer is weaker than orchestrator" when they share the same model |
| **Version numbers** | Any pinned version numbers that have changed |

### 2. Skill Files (`*/skills/<name>/SKILL.md`)

| Check | What to Look For |
|-------|------------------|
| **Model backend** | Does the skill describe a specific model that no longer matches config? |
| **Description accuracy** | Does the `description:` frontmatter match what the skill actually does? |
| **Dead tool refs** | Does the skill reference tools or APIs that are no longer available? |
| **Wrong assumptions** | "This costs money" when it's free, "runs locally" when it's cloud, etc. |
| **Missing patterns** | Does a session reveal a recurring workflow that should be codified into the skill? |
| **Incomplete guidance** | Did the skill's instructions prove insufficient during real use? (e.g., missing edge cases, unclear steps) |

**When to update a skill** (beyond stale-info fixes):
- **New pattern discovered**: A workflow repeated 2+ times across sessions should be codified
- **Incomplete coverage**: The skill exists but didn't cover a case you encountered — add it
- **Tool evolution**: A tool the skill references changed its API, flags, or behavior
- **Usage mismatch**: The skill is being used for something its description doesn't advertise, or vice versa
- **Memory evidence**: Memory entries about the skill conflict with what the SKILL.md says
- **After self-evolve**: If you just updated your own instructions, check dependent skills for ripple effects

When adding new patterns to a skill, store a memory record:
```
Self-evolve: updated skills/<name>/SKILL.md — added <section> covering <pattern>
```

### 3. opencode.jsonc

| Check | What to Look For |
|-------|------------------|
| **Comment accuracy** | Do comments still match reality? |
| **Disabled providers** | Are disabled providers actually not needed? |
| **Plugin references** | Do all plugins still exist? |
| **Preset alignment** | Does the active preset actually exist in the presets block? |

### 4. AGENTS.md (`~/.config/opencode/AGENTS.md` and project-local `**/AGENTS.md`)

| Check | What to Look For |
|-------|------------------|
| **Path accuracy** | Are file paths referenced in AGENTS.md still valid? |
| **Tool commands** | Do tool commands (rtk, etc.) still match installed versions? |
| **Plugin instructions** | Do plugin usage instructions (memory, etc.) still match current plugin config? |
| **Environment rules** | Do sudo/pkg restrictions still match current system setup? |
| **Stale sections** | Are there instructions for plugins or tools that are no longer installed? |
| **Consistency** | Does AGENTS.md duplicate or contradict info in append files or opencode.jsonc? |

AGENTS.md is read from two locations: the closest parent directory of the current working directory (project-level), and `~/.config/opencode/AGENTS.md` (global). Both can be active simultaneously.

### 5. Memory (Memory Plugin)

Memory stores accumulate over sessions. Reconstruct when:

| Check | What to Look For |
|-------|------------------|
| **Conflicts** | Two entries contradict each other (e.g., old and new config state for the same file) |
| **Duplication** | Multiple partial entries covering the same topic — merge into one authoritative entry |
| **Staleness** | Entry references old tool names, file paths, or config values that have since changed |
| **Volatility** | Transient data stored as memory (system stats, timestamps, ephemeral state) — forget it |
| **Skill references** | Memory entries about a skill — cross-reference with the actual SKILL.md on disk |
| **Tag hygiene** | Entries tagged inconsistently (typos, synonyms) making search unreliable |

Reconstruction workflow:
1. Search for all entries on a topic: `memory search <topic>`
2. Identify conflicts, duplicates, stale entries
3. Forget stale/volatile entries: `memory forget <id>`
4. Merge keepers into one comprehensive entry: forget old partials, add consolidated replacement
5. Normalize tags — use consistent, searchable keywords

---

## Update Workflow

### Step 1: Read Before You Change

Read the full file before editing. Understand:
- What is the file supposed to do?
- What exact claims does it make?
- Do those claims match reality?
- Can you verify the correct info (from system prompt, other config files, memory)?

### Step 2: Make Focused Edits

- Change only what's wrong. Don't reformat, restructure, or "improve" the file.
- Preserve the file's original style and structure.
- For frontmatter (`---`), only change `description:` if needed.
- Keep version/appearance headers intact (they're from third-party plugins).

### Step 3: Update Memory

After any change, store a fact to memory:
```
Self-evolve: updated <file> — changed <what> from <old> to <new>
```

This prevents repeated audit of the same issue and provides a change log.

### Step 4: Verify

- Re-read the edited file to confirm correctness.
- If the change was more than cosmetic, consider if a restart is needed (opencode loads config/agents/skills at startup; append files are read per-session).
- Report to user what changed and whether a restart is needed.

---

## Hard Rules

- **Do not delete files** — only edit them. If something seems redundant, ask the user.
- **Do not change third-party plugin files** outside of what the user explicitly asked. The oh-my-opencode-slim append files are fair game since they define your behavior.
- **Do not reformat** — match the existing style precisely.
- **Do not add your own opinions** — only correct facts. If you're unsure whether information is wrong, leave it and note the uncertainty.
- **When in doubt, ask the user** — "I found X in Y file, should I update it to Z?"
- **Changes that need restart** — config changes need a restart. Append file changes and skill changes need a restart for the new session.

---

## Quick Audit Command

When the user says "evolve yourself", run this sequence:

1. `memory search self-evolve` — check what was already updated
2. Read all agent append files in `~/.config/opencode/oh-my-opencode-slim/`
3. Cross-reference model names and agent lineup with the system prompt
4. Read skill descriptions from `~/.config/opencode/skills/*/SKILL.md` (first 4 lines for frontmatter)
5. Read global AGENTS.md at `~/.config/opencode/AGENTS.md` — check paths, tool refs, plugin instructions
6. Check for project-local AGENTS.md in current working directory or parent dirs
7. Compare to current reality
8. **Audit memory**: search for entries that conflict with current config, are duplicated, or contain volatile/transient data. Reconstruct if needed.
9. **Check for new patterns**: Did recent sessions reveal workflows that should be codified into a skill?
10. Fix stale info following the Update Workflow
11. Store changes to memory (include memory reconstruction in the log)
