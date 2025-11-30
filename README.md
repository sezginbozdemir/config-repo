# Config Repo

Personal configuration files for my development environment.

Currently includes:

- **Neovim** config (`~/.config/nvim`)
- **Kitty** terminal config (`~/.config/kitty`)

The idea is to keep these configs version-controlled and easy to reuse on new machines.

---

## Structure

```text
config-repo/
  nvim/
    init.vim
    coc-settings.json
    plugged/           # ignored by git (plugins installed by vim-plug)
    package.json       # ignored by git
    package-lock.json  # ignored by git

  kitty/
    kitty.conf
    kitty-themes/
    theme.conf       # symlink to a theme inside kitty-themes
      ...              # theme files / theme repo content

  .gitignore
  README.md
```
