# linux-setup

My personal setup for a Debian machine. One repo, one script. After a fresh
install, clone this and run `./setup.sh` to get everything back.

## Quick start

```bash
git clone <your-repo-url> linux-setup
cd linux-setup
./setup.sh
```

Run it as your **normal user** (not with `sudo`). It asks for your password
only when a step needs root, and asks `y/n` before each part so you can pick
what to run. It's safe to run again later.

## What's inside

Each folder is one self-contained project. You can run any folder's
`install.sh` on its own, or let `setup.sh` run them all.

| Folder | What it does |
|--------|--------------|
| `shell-and-vim/` | `.bash_aliases` (colored prompt) and `.vimrc`, symlinked for your user and root, with `.bashrc` set to load the aliases. |
| `battery-notifier/` | Desktop notification when the battery hits 80% while charging, as a `systemd --user` service. |
| `hosts-blocker/` | Rewrites `/etc/hosts` from an ad/malware blocklist (backs up the old file first). |
| `system-packages/` | `install_packages.sh` installs preferred apps; `gnome_cleanup.sh` removes unwanted default GNOME apps. |
| `lib/common.sh` | Shared helpers (logging, prompts) used by the scripts. |

## Notes

- Nothing depends on this folder being named `linux-setup` - rename it if you
  like, the scripts find their own location.
- Edit the package list in `system-packages/install_packages.sh` and the GNOME
  app list in `system-packages/gnome_cleanup.sh` to taste.
- The battery limit defaults to 80% - override with `LIMIT=85` if needed.
