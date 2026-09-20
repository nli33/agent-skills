---
name: overnight
description: Run Claude Code autonomously overnight on the UTM Linux VM (warvm) via a "Ralph loop" — fresh stateless claude -p per iteration, state on disk. Use when the user wants to launch, check on, or resume an unattended overnight agent run on the VM.
---

# overnight

Architecture: an outer bash loop (`scripts/overnight.sh` in the target repo) launches a **fresh,
stateless `claude -p` each iteration** — no `--continue`/`--resume`. Each invocation reads
`PROGRESS.md` + `CLAUDE.md`, does one task, updates `PROGRESS.md`, commits, exits. The filesystem
(not conversation context) is the memory. Exit conditions: `DONE` written as the last line of
`PROGRESS.md`, or `STALL_LIMIT` iterations with no new commit. Full design rationale lives in the
target repo's `OVERNIGHT.md` if present — read that for the why, this skill covers the mechanics.

## What the agent should know

- VM reached via SSH alias `warvm` (`~/.ssh/config`), passwordless key auth. VM is UTM/QEMU on
  `bridge100`, typically `192.168.64.2` — re-derive with `arp -a | grep bridge100` +
  `nc -zv <ip> 22` if the alias ever stops resolving (DHCP lease tied to VM's fixed MAC, so it's
  stable in practice but not guaranteed).
- Git on the VM **must use the SSH remote** (`git@github.com:...`), not HTTPS — GitHub dropped
  git password auth over HTTPS; the VM's existing SSH key is what's registered on GitHub.
- File transfer: 9p mount, host `/Users/n/code/shared` ↔ VM `/mnt/shared`, persistent via VM's
  `/etc/fstab`. Ad hoc copy/paste: `warvm-copy` / `warvm-paste` (host-initiated only, no live
  clipboard sync — intentional, since the VM runs an unrestricted agent).
- Interrupting a running iteration (Ctrl-C) is safe: the loop only commits after `claude -p`
  fully returns, so a killed mid-task run just means no commit happened — same as a stall, not
  corruption. Untracked scratch dirs (e.g. `.venv/`) may need a `.gitignore` entry afterward.
- Remote Control doesn't fit this architecture — each iteration is a new short-lived headless
  process, so there's no persistent interactive session to attach to. For phone visibility, SSH
  into the VM and either `tmux attach` (see below) or tail `PROGRESS.md` / a log file directly —
  works from any SSH client (e.g. Termius, Blink) with no extra setup.
- Run must be in tmux (or equivalent) so it survives SSH disconnects — a plain foreground
  `./scripts/overnight.sh` over SSH dies when the connection drops.

## End-to-end instructions (human, no agent needed)

```bash
# 1. Start the VM (UTM app on the Mac, or `utmctl start "Linux-ubuntu"` from the CLI)

# 2. SSH in (alias already configured)
ssh warvm

# 3. Start tmux and launch the loop
tmux new -s overnight
cd ~/war-analyzer          # or whichever repo has scripts/overnight.sh
./scripts/overnight.sh     # override MAX_ITERATIONS=NN / STALL_LIMIT=NN as env vars if needed

# 4. Detach, leave it running
#    Ctrl-b then d

# 5. Check on it anytime (from laptop or phone SSH client)
ssh warvm -t tmux attach -t overnight    # reattach and watch live
ssh warvm 'tail -30 ~/war-analyzer/PROGRESS.md'   # peek without attaching

# 6. When finished
ssh warvm -t tmux attach -t overnight
# exit   (or from outside: ssh warvm 'tmux kill-session -t overnight')
```

If `ssh warvm` doesn't resolve (VM's DHCP lease changed): find its IP with
`arp -a | grep bridge100` on the Mac, confirm SSH is up with `nc -zv <ip> 22`, then update
`HostName` in `~/.ssh/config`'s `Host warvm` block.
