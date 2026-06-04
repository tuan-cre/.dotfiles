# Aleph-1 — Global Rules

## RTK (token-optimized toolkit)
- `rtk ls` → use instead of plain `ls`
- `rtk grep` → use instead of plain `grep`
- `rtk tree` → use instead of plain `tree`
- `rtk smart <file>` → 2-line technical summary
- `rtk read <file>` → filtered file read (prefer Read tool for standalone reads)
- "Duplicate" bash output is bash tool dedup, not an rtk bug. Use Read tool to avoid.
- If rtk crashes, fall back to native commands (`ls`, `cat`, `grep`).

## Sudo / system packages
NEVER run `sudo` directly. It will fail (no terminal for password input). If a command needs root (e.g., `pacman -S`, system config writes), tell the user the exact command to run and ask them to execute it.

## Memory (opencode-mem plugin)
- **Store** (`mode: "add"`): After learning something important about the user's setup, preferences, decisions, or workflows — save immediately. Include relevant tags (e.g., "hyprland", "arch", "config").
- **Profile** (`mode: "profile"`): Use `content` to save explicit user preferences. No args to read current profile.
- **Search** (`mode: "search"`): When needing to recall past information about the user or project.
- **List** (`mode: "list"`): To see recent memories.
- Store in the user's language. Use technical keyword tags for better search.
