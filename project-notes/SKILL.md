---
name: project-notes
description: Set up or use the centralized ~/notes project-notes repo for a code project — links a project's tangential research/debugging notes into it via a gitignored symlink, kept out of the host repo's own git history. Use when the user asks to "set up notes"/"link notes" for a repo, when starting a new notes/ folder for exploratory work, or when a project's notes have grown large and need splitting.
---

# project-notes

A personal, separate git repo (`~/notes`, remote `git@github.com:nli33/notes.git`) holding
per-project research/debugging notes that are tangential to what each host repo is actually for
(so they don't pollute that repo's history for other collaborators). One subdirectory per project,
symlinked into that project's checkout as `notes/`.

Full conventions (structure, when to write, splitting large files, git workflow) live in
`~/notes/README.md` — read it before writing content. This skill covers the mechanical setup.

## Setting up notes for a project

Determine `<Project>` — the directory name to use under `~/notes`. If the user supplied one, use
it. Otherwise default to the project's identity rather than the local checkout path (checkout
dirnames are often local/arbitrary): the repo name from `git remote get-url origin`, or failing
that the package/manifest name (`pyproject.toml`, `package.json`, `Cargo.toml`, etc.). If that
disagrees with the checkout dirname and neither is clearly authoritative, ask — it's awkward to
rename later once committed.

Then:

1. Ensure `~/notes` exists as a git repo (don't re-init if `~/notes/.git` is already present).
2. `mkdir -p ~/notes/<Project>` if missing.
3. If `~/notes/<Project>/README.md` doesn't exist, create one: a short index describing the
   directory's purpose, and (once there are files) a `file — what it covers` table. Match an
   existing project dir's style as a template if one exists.
4. Compute the actual relative path from `<repo>` to `~/notes/<Project>` and symlink it — don't
   assume they're siblings:
   ```bash
   cd <repo> && ln -s "$(python3 -c "import os; print(os.path.relpath(os.path.expanduser('~/notes/<Project>'), '.'))")" notes
   ```
   Verify with `readlink notes` and `ls notes`.
5. Add a `notes` line to `<repo>/.gitignore` (**no trailing slash** — `notes/` doesn't match a
   symlink and will silently fail to ignore it). Verify with `git status`.
6. Don't commit/push the symlink itself, and don't add a "read notes first" pointer to the user's
   global `CLAUDE.md` — the user points agents to `notes/` explicitly when relevant.
7. `git add`/`commit`/`push` inside `~/notes` (not `<repo>`) after content changes.

## Using notes in an existing project

If `<repo>/notes` already exists as a symlink, just read/write through it normally — it resolves
to `~/notes/<Project>/`. Follow `~/notes/README.md`'s conventions for when to write and how to
split a file that's grown too large (topic-split files + an updated `README.md` index, see
`~/notes/DeepSeek-OCR/` for a worked example).
