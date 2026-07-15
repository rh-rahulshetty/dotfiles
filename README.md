# dotfiles

Personal dotfiles and tool configuration.

## Install

```bash
./install.sh
```

### What it does

| Step | Description |
|------|-------------|
| `link_claude_commands` | Symlinks `.claude/commands/*` into `~/.claude/commands/` |
| `link_scripts` | Symlinks `scripts/*` into `~/.local/bin/` |

### Scripts

| Script | Description |
|--------|-------------|
| `gen_docx.py` | Converts markdown to professionally styled DOCX (requires `python-docx`) |

### Claude Code Skills

| Skill | Description |
|-------|-------------|
| `/gen-docx` | Convert a markdown file to styled DOCX — uses `gen_docx.py` |
| `/analyze-prs` | Static analysis of open PRs in a GitHub repo |
