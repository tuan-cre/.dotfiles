---
name: memory
description: Memory curation — knowing when and what to remember, forget, and organize. Use for explicit memory management requests ("remember this", "forget that", "clean up my memory", "what do you know about me"). Also use proactively at session milestones.
---

# Memory Curation

## Overview

Memory is only useful if it's **relevant, fresh, and findable**. This skill is about curation discipline — knowing when to store, when to skip, when to prune, and how to organize for fast retrieval.

The tool: `memory` with modes `add`, `search`, `list`, `forget`, `profile`.

---

## When to Store

Store proactively when you learn something that will be useful **in a future session**:

### ✅ Store Worthy

| Category | Examples | Tags |
|----------|----------|------|
| **User profile** | Distro, WM, shell, editor, terminal, preferred tools | `profile`, `env` |
| **Architecture decisions** | "I chose X because Y", explicit trade-offs | `arch`, `decision` |
| **Workflow patterns** | "I deploy with X", "my dotfiles are at Y", commit style | `workflow`, `config` |
| **Constraints** | "no root on this machine", "limited disk", "must use HTTPS" | `constraint` |
| **Project facts** | Repo location, key paths, build commands, test setup | `project` |
| **Terminal facts** | Shell aliases, custom scripts, PATH modifications | `terminal` |
| **Personal preferences** | Coding style, editor keybinds, naming conventions | `preference` |

### ❌ Skip Storing

- **Session-only context** — what we're currently debugging, one-off file paths
- **Obvious facts** — "Python files end in .py", "git tracks changes"
- **Transient state** — "currently I'm working on task X" (tilts next session)
- **Large verbatim content** — don't dump file contents or logs into memory
- **Stuff I can re-derive** — "your username is in ~/.config" (I can check)

### One-shot rule

Store once per fact. If you'd store it again, **update it** instead — search first, then add with the same tag and updated content.

---

## When to Prune (`list` + `forget`)

Do a curation pass when:

1. **User asks directly** ("clean up my memory", "forget that")
2. **After 5+ new memories** in a session — check for stale or redundant entries
3. **You encounter contradictory info** — the old memory is wrong, forget it
4. **When memory list output feels bloated** — lots of signal is being drowned

### What to prune

- **Stale workflow** — user switched tools, the old fact is misleading
- **Overly granular** — "session X had file Y with bug Z" (that belongs in project docs, not user memory)
- **Redundant** — multiple entries saying the same thing, keep the best one
- **Self-evident** — "user has a computer" level obviousness
- **Irrelevant** — old project context the user no longer works on

---

## How to Organize

### Tags

Tags are your primary retrieval mechanism. Be consistent:

| Domain | Tag |
|--------|-----|
| OS / Distro | `arch`, `ubuntu`, `nixos`, `macos` |
| Window manager / Desktop | `hyprland`, `kde`, `gnome`, `i3` |
| Shell | `zsh`, `bash`, `fish` |
| Editor | `nvim`, `vscode`, `helix` |
| Dotfiles | `dotfiles` |
| Project specific | repo name or `project:<name>` |
| Decision record | `decision` |
| Constraint | `constraint` |

Combine tags: `["arch", "hyprland", "workflow"]`

### Content format

Be concise but precise. One or two sentences max.

```
User runs Arch with Hyprland + KDE apps. Shell: zsh. Editor: neovim.
Dotfiles at ~/dotfiles/ via GNU Stow, repo: github.com/user/dotfiles
```

- Use consistent tense (present tense for current state)
- Avoid time-sensitive language ("recently", "currently")
- Lead with the most important fact

### Profile

Use `memory profile` for preferences that define how the user wants me to act:

```
Be concise, don't explain code unless asked, prefer AUR over manual builds
```

---

## Curation Cadence

| Trigger | Action |
|---------|--------|
| End of productive session | Quick scan: any new long-term facts? Store them. |
| User says "remember this" | Store immediately with appropriate tags |
| User says "forget that" | `list` or `search`, find entry, `forget` it |
| User says "clean up" | `list` all entries, prune stale/redundant/granular |
| 5+ entries without review | Do a `list` pass, prune if needed |
| Contradiction detected | Forget old, store corrected version |

---

## Process

### Step 1: Is this worth storing?

Run the filter:
- Will I (the AI) care about this in a future session?
- Is it a durable fact about the user or project?
- Am I confident it's correct?
- Can I express it in 1-2 sentences?

If yes to all → store.

### Step 2: Choose tags

Pick 2-4 tags. Prefer existing tags (check with `search`) to avoid tag proliferation.

### Step 3: Search before duplicating

When in doubt, search: `memory search` with relevant tags to check if this fact already exists. If it does, skip or update.

### Step 4: Store with precision

Write the content as if it'll be the only reference. Include distinguishing details but nothing transient.

### Step 5: Periodic curation

Every few sessions (or on request), run `memory list` and clean up:
- Remove entries that are no longer true
- Merge related entries with better tags
- Drop entries that don't pass the "will I care next session?" test

---

## Verification

- After storing: the entry exists and is findable with its tags
- After pruning: no stale entries remain that could mislead
- After a session: the memory profile reflects current user setup
- The memory list is short enough to be useful — quality over quantity
