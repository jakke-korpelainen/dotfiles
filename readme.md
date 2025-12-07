# .config
currently from cachyos on a non-laptop pc, setup mostly with tokyo night storm theme

| category     | apps                           |
|--------------|--------------------------------|
| lockscreen   | hyprlock                       |
| terminal     | kitty                          |
| calculator   | kalker                         |
| shell        | fish                           |
| editor       | zed                            |
| notify       | mako                           |
| tiling       | hyprland                       |
| hyprland     | waybar, wofi, hyprshell, grim  |
| file manager | nemo                           |

## .config/scripts
| script                    | description                                                  |
|---------------------------|--------------------------------------------------------------|
| **bin-symlink.sh**        | create symlink to here from ~/bin                            |
| **waybar-date.sh**        | simple date formating for waybar                             |
| **waybar-power.sh**       | wofi menu for power options (from somewhere on the web)      |
| **workspace-autorun.fish**| autorun individual app into workspace if not already running |
| **workspace-switch.fish** | handle workspace switch logic & delegate autoruns            |

## .config/fish/alias.fish

| alias/function | description |
|----------------|-------------|
| `docker` | Routes docker commands to podman |
| `calc` | Shortcut for kalker calculator |
| `dev` | Navigates to ~/Development directory |
| `zed` | Shortcut for zeditor |
| `gs` | Shows git status |
| `add` | Adds all changes to git staging |
| `gp` | Pulls latest changes from git |
| `latest` | Shows the latest git tag (without 'v' prefix) |
| `git-branches` | Lists git branches sorted by commit date |
| `main` | Checks out the main branch |
| `gnb <branch>` | Creates and checks out a new git branch |
| `gb <branch>` | Checks out an existing git branch |
| `commit <msg>` | Commits changes with a message |
| `chore <msg>` | Commits with "chore: " prefix |
| `feat <msg>` | Commits with "feat: " prefix |
| `fix <msg>` | Commits with "fix: " prefix |
| `refactor <msg>` | Commits with "refactor: " prefix |
