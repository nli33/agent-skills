---
name: project-notes
description: Set up or use the centralized ~/notes project-notes repo for a code project — links a project's tangential research/debugging notes into it via a gitignored symlink, kept out of the host repo's own git history. Use when the user asks to "set up notes"/"link notes" for a repo, when starting a new notes/ folder for exploratory work, or when a project's notes have grown large and need splitting.
---

# project-notes

A personal, separate git repo (`~/notes`, remote `git@github.com:nli33/notes.git`) holding
per-project research/debugging notes that are tangential to what each host repo is actually for
(so they don't pollute that repo's history for other collaborators). One subdirectory per project,
symlinked into that project's checkout as `notes/`.

## What to write

The point of this repo: let future-you (or an agent) retrospectively reconstruct *why* the code
looks the way it does, without re-deriving it from a diff. Prioritize, roughly in this order:

- **Design decisions and tradeoffs** — why this approach over the alternatives considered, what
  was traded away, what would make you revisit the choice.
- **Research/investigation results** — what was tried, what was found, especially negative
  results (a dead end not recorded gets re-tried later).
- **Bugs and debugging** — root cause, the fixes attempted that *didn't* work and why (not just
  the one that did), and how the bug was actually diagnosed.
- **Development process/history** — the sequence major work happened in, when a plan changed
  mid-stream and why.
- **Anything not obvious from reading the code** — a hidden constraint, a workaround for a
  specific issue, a decision that would look arbitrary out of context.

Don't log routine/mechanical changes (a rename, a formatting pass) — only what carries real
context. Full conventions (file structure, splitting large files, git workflow) live in
`~/notes/README.md` — read it before writing content.

## Setting up notes for a project

Determine `<Project>` — the directory name to use under `~/notes`. If the user supplied one, use
it. Otherwise default to the project's identity rather than the local checkout path: the repo name
from `git remote get-url origin`, or failing that the package/manifest name. If that disagrees
with the checkout dirname and neither is clearly authoritative, ask — awkward to rename later.

Then:

1. `mkdir -p ~/notes/<Project>` (don't re-init `~/notes` if `~/notes/.git` already exists).
2. If `~/notes/<Project>/README.md` doesn't exist, create a short index (purpose + a
   `file — what it covers` table once there are files); match an existing project dir's style.
3. Symlink it in, computing the real relative path rather than assuming siblings:
   ```bash
   cd <repo> && ln -s "$(python3 -c "import os; print(os.path.relpath(os.path.expanduser('~/notes/<Project>'), '.'))")" notes
   ```
   Verify with `readlink notes` / `ls notes`.
4. Add `notes` (no trailing slash — `notes/` won't match a symlink) to `<repo>/.gitignore`.
5. Don't commit/push the symlink itself, and don't add a "read notes first" pointer to the user's
   global `CLAUDE.md` — the user points agents to `notes/` explicitly when relevant.
6. `git add`/`commit`/`push` inside `~/notes` (not `<repo>`) after content changes.

## Using notes in an existing project

If `<repo>/notes` already exists as a symlink, just read/write through it normally.
