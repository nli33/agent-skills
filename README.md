# skills

Personal collection of Claude Code skills. One directory per skill, each with its own `SKILL.md`.

## Skills

| Skill | What it does |
|---|---|
| [project-notes](project-notes/SKILL.md) | Set up/migrate a repo's `notes/` into the centralized `~/notes` repo. |
| [explainer](explainer/SKILL.md) | Teach a system/codebase/concept precisely and incrementally, calibrated to the user's background. |

## Installing a skill locally

Claude Code loads a skill from `~/.claude/skills/<name>/SKILL.md`. Symlink the skill you want in
from a clone of this repo, rather than copying it (so it stays in sync with `git pull`):

```bash
git clone git@github.com:nli33/agent-skills.git ~/skills   # once
ln -s ~/agent-skills/<name> ~/.claude/agent-skills/<name>
```

