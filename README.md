# Agent Skills

Personal collection of agent skills.

## Skills

| Skill | What it does |
|---|---|
| [project-notes](project-notes/SKILL.md) | Maintain a centralized notes repo documenting development process, design decisions, and research. |
| [explainer](explainer/SKILL.md) | Teach a system/codebase/concept precisely and incrementally, calibrated to the user's background. |
| [ai-writing](ai-writing/SKILL.md) | Reference list of surface patterns correlated with AI-generated vs human-written text. |
| [overnight](overnight/SKILL.md) | Run Claude Code autonomously overnight on a VM via a fresh-process-per-iteration loop, with state on disk. |

## Installing skills locally

Claude Code loads a skill from `~/.claude/skills/<name>/SKILL.md`. Run `sync.sh` from a clone of
this repo to symlink every skill here into `~/.claude/skills` (skipping any that already exist and
aren't already one of these symlinks), so `git pull` keeps them in sync without re-linking by hand:

```bash
./sync.sh
```

To link in just one skill by hand instead:

```bash
ln -s "$(pwd)/<name>" ~/.claude/skills/<name>
```

