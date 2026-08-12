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

## Setting up notes for a new project

Given a project repo at `<repo>` with directory name `<Project>`:

1. Ensure `~/notes` exists and is the git repo (should already exist after first use — don't
   re-init if `~/notes/.git` is present).
2. `mkdir -p ~/notes/<Project>` if missing.
3. If `~/notes/<Project>/README.md` doesn't exist, create one: a short index describing the
   directory's purpose and (once there are files) a table of `file — what it covers`. Match the
   style of an existing project dir under `~/notes/` if one exists, as a template.
4. In `<repo>`: `ln -s ../notes/<Project> notes` (relative symlink — portable as long as the repo
   and `~/notes` are siblings under the same parent directory; adjust the relative path if not).
5. Add a `notes` line to `<repo>/.gitignore` if not already present. **No trailing slash** —
   `notes/` does not match a symlink (git treats it as a file, not a directory, for that pattern)
   and will silently fail to ignore it. Verify with `git status` that `notes` shows as untracked/
   ignored, not staged.
6. Do not commit or push the symlink itself, and do not add a "read notes first" pointer to the
   user's global `CLAUDE.md` — the user points agents to `notes/` explicitly when relevant.
7. `git add`/`commit`/`push` inside `~/notes` (not `<repo>`) after content changes.

## Migrating an existing local `notes/` folder

If `<repo>/notes` is a real directory (not a symlink) with existing content, migrate it instead of
starting fresh:

1. `sha256sum` every file under `<repo>/notes` before touching anything, so the move can be
   verified.
2. `mkdir -p ~/notes/<Project>`, then `mv <repo>/notes/* ~/notes/<Project>/` (including any
   `archive/` or other subdirectories — move everything, don't cherry-pick).
3. Re-run `sha256sum` against the new location and diff against the pre-move checksums — every
   file must match before proceeding. Only then remove the now-empty `<repo>/notes` directory.
4. Continue with steps 4–7 above (symlink, `.gitignore`, commit/push in `~/notes`).

## Using notes in an existing project

If `<repo>/notes` already exists as a symlink, just read/write through it normally — it resolves
to `~/notes/<Project>/`. Follow `~/notes/README.md`'s conventions for when to write and how to
split a file that's grown too large (topic-split files + an updated `README.md` index, see
`~/notes/DeepSeek-OCR/` for a worked example).
