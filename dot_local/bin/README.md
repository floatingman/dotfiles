Synopsis
Here is a bunch of utilities I use and don't use because I'm too scared to get rid of them.
I put them in a directory in my path for easy access.

## Permissions

Scripts are made executable via a `run_once_` chezmoi script. When adding new scripts,
reset it so it runs again:

```
chezmoi forget ~/.local/bin/run_once_fix-executable-permissions
chezmoi apply
```
