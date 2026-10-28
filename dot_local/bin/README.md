Synopsis
Here is a bunch of utilities I use and don't use because I'm too scared to get rid of them.
I put them in a directory in my path for easy access.

## Permissions

Scripts are made executable via a `run_` chezmoi script that runs on every `chezmoi apply`.
This causes chezmoi to detect permission changes and prompt to overwrite. Use `chezmoi apply --force`
or accept the prompt to proceed.

## herdr machines

herdr's saved-machine catalog (`~/.local/state/herdr/client/endpoints.json`) is
per-host: each machine owns its own copy and it is never synced through this
repo (the path is in `.chezmoiignore`). Host aliases for my regular boxes live
in `~/.ssh/config` instead.

Still true after the desync: herdr checks host keys strictly and `known_hosts`
matches by the exact target string, so trust recorded under another name
(hostname, LAN IP) doesn't cover a catalog target. One plain `ssh <target>` per
new machine, or `herdr machine reconnect <label>`, seeds it; open herdr clients
reconnect within ~30s.
