# Dotfiles

Personal configuration files for a modern macOS development environment.

## Structure

```
dotfiles/
├── terminal/ghostty/     # Ghostty terminal config
├── shell/                # Zsh + Starship prompt
├── nvim/                 # Neovim IDE setup
├── Brewfile              # Homebrew dependencies
└── install.sh            # Automated setup
```

## Quick Start

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

---

## Keybindings

All keybindings follow a **unified hjkl navigation pattern**:

```
     k (up)
h (left)   l (right)
     j (down)
```

### Ghostty Terminal

| Action | Keybind |
|--------|---------|
| New tab | `⌘T` |
| Close tab/split | `⌘W` |
| New window | `⌘N` |
| Split right | `⌘D` |
| Split down | `⌘⇧D` |
| Equalize splits | `⌘⇧E` |
| Navigate splits | `⌘H/J/K/L` |
| Go to tab 1-9 | `⌘1-9` |
| Toggle quick terminal | `` ⌘` `` |
| Reload config | `⌘⇧R` |

### Neovim

Leader key: `Space`

#### Core Navigation

| Action | Keybind |
|--------|---------|
| Exit insert mode | `jj` |
| Clear search | `<Space>nh` |

#### Window Management

| Action | Keybind |
|--------|---------|
| Split vertical | `<Space>sv` |
| Split horizontal | `<Space>sh` |
| Equalize splits | `<Space>se` |
| Close split | `<Space>sx` |
| Navigate left | `<Space>wh` |
| Navigate down | `<Space>wj` |
| Navigate up | `<Space>wk` |
| Navigate right | `<Space>wl` |

#### Tab Management

| Action | Keybind |
|--------|---------|
| Create tab | `<Space>tc` |
| Close tab | `<Space>tx` |
| Next tab | `<Space>tn` |
| Prev tab | `<Space>tp` |

#### File Explorer (nvim-tree)

| Action | Keybind |
|--------|---------|
| Toggle explorer | `<Space>ee` |
| Find current file | `<Space>ef` |
| Collapse all | `<Space>ec` |
| Refresh | `<Space>er` |

#### Telescope (Fuzzy Finder)

| Action | Keybind |
|--------|---------|
| Find files | `<Space>ff` |
| Recent files | `<Space>fr` |
| Live grep | `<Space>fs` |
| Grep under cursor | `<Space>fc` |
| Find TODOs | `<Space>ft` |
| Show keymaps | `<Space>fk` |

#### Clipboard (macOS)

| Action | Keybind |
|--------|---------|
| Copy | `⌘C` |
| Paste | `⌘V` |
| Cut | `⌘X` |
| Yank to clipboard | `<Space>y` |
| Paste from clipboard | `<Space>v` |

---

## What's Included

### Terminal — Ghostty

- **Theme**: Dark Modern with 75% opacity + blur
- **Font**: JetBrainsMono Nerd Font (15pt)
- **Features**: Block cursor, hidden titlebar, copy-on-select
- **Shaders**: CRT + retro terminal effects

### Shell — Zsh + Starship

- **Prompt**: [Starship](https://starship.rs/) cross-shell prompt
- **Plugins**: zsh-autosuggestions, zsh-syntax-highlighting
- **Aliases**: `ls` → `eza --icons`, `cd` → `zoxide`
- **Colors**: One Dark via `vivid`

### Editor — Neovim

27 plugins managed by [lazy.nvim](https://github.com/folke/lazy.nvim):

| Category | Plugins |
|----------|---------|
| **UI** | bufferline, lualine, alpha, indent-blankline, which-key, dressing |
| **Navigation** | telescope, nvim-tree, flash |
| **Editing** | autopairs, surround, comment, substitute, nvim-ts-autotag |
| **LSP** | mason, nvim-cmp, trouble |
| **Git** | gitsigns, lazygit |
| **Syntax** | treesitter, todo-comments |
| **Session** | auto-session |
| **Appearance** | colorscheme (Dark Modern), smear-cursor |

---

## Dependencies

Installed via `brew bundle`:

```
neovim          # Editor
ghostty         # Terminal
starship        # Prompt
zsh-autosuggestions
zsh-syntax-highlighting
zoxide          # Smart cd
eza             # Modern ls
vivid           # LS_COLORS
ripgrep         # Fast grep
font-meslo-lg-nerd-font
```

---

## Manual Installation

### Symlinks

```bash
# Terminal
ln -sf ~/dotfiles/terminal/ghostty ~/.config/ghostty

# Shell
ln -sf ~/dotfiles/shell/.zshrc ~/.zshrc
ln -sf ~/dotfiles/shell/starship.toml ~/.config/starship.toml

# Neovim
ln -sf ~/dotfiles/nvim ~/.config/nvim
```

### Packages

```bash
brew bundle --file=~/dotfiles/Brewfile
```

---

## Updating

```bash
cd ~/dotfiles && git pull
brew update && brew upgrade
nvim --headless "+Lazy sync" +qa
```

---

## Security

This repository includes automated secret scanning via GitHub Actions (gitleaks) to prevent accidental commits of sensitive data.

---

## License

MIT
