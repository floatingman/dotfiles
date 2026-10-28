Synopsis
Here is a bunch of utilities I use and don't use because I'm too scared to get rid of them.
I put them in a directory in my path for easy access.

## Permissions

Scripts are made executable via a `run_` chezmoi script that runs on every `chezmoi apply`.
This causes chezmoi to detect permission changes and prompt to overwrite. Use `chezmoi apply --force`
or accept the prompt to proceed.

## herdr-machines

Shares herdr's saved SSH machine catalog (`~/.local/state/herdr/client/endpoints.json`)
between my machines through this repo (`dot_local/private_state/herdr/client/`).
The catalog carries no secrets; SSH auth stays with my own keys on each machine.

- `herdr-machines status` — show both copies and any drift
- `herdr-machines pull` — take the repo copy. Machines that exist only on this machine
  are merged in, not dropped (repo wins where both have the same machine). Run
  `herdr-machines push` afterwards to publish a merge.
- `herdr-machines push` — adopt the local catalog into the repo, commit, push
  (no commit when nothing changed).

Footguns already hit, so you don't have to:

- Always path-target chezmoi: a bare `chezmoi apply` reverts unrelated local drift.
- On a fresh machine, plain `chezmoi update` is enough. A path-targeted apply fails
  until `~/.local/state/herdr/client/` exists, which only happens after herdr has
  run as a client there.
- A pulled catalog isn't enough on a fresh machine: herdr checks host keys strictly,
  and `known_hosts` matches by the exact target string — trust recorded under another
  name (hostname, LAN IP) doesn't cover the catalog's target. One plain `ssh <target>`
  per machine, or `herdr machine reconnect <label>`, seeds it; open herdr clients
  reconnect within ~30s.
- `--force` overwrites without asking and silently drops machines only this machine
  had. `pull` merges first automatically; when merging by hand, do it before forcing.
