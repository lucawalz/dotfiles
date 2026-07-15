# Contributing to dotfiles

## Prerequisites

- macOS on Apple Silicon
- [Homebrew](https://brew.sh)
- GNU Stow, installed through the Brewfile

## Setup

Clone the repository to a stable path, install the dependencies, and link the packages:

```bash
git clone https://github.com/lucawalz/dotfiles.git ~/dotfiles
cd ~/dotfiles
brew bundle
stow -t ~ ghostty starship btop fastfetch nvim zsh sketchybar borders
```

Stow refuses to overwrite an existing real file. Move any pre-existing configuration out of the way before linking.

## Testing

There is no test suite. A change is verified by stowing the package and exercising the tool it configures:

```bash
# Relink the changed package
stow -R -t ~ <package>

# Confirm the target is a symlink into the clone
ls -l ~/.config/<package>
```

Then restart or reload the affected tool and confirm the change took effect. Ghostty reloads its config with `⌘` `⇧` `,`, zsh needs a new shell, Neovim needs a restart for plugin changes, and SketchyBar reloads with `sketchybar --reload`.

Shell scripts are linted with shellcheck, which CI runs on every push:

```bash
shellcheck -x -e SC1091 \
  sketchybar/.config/sketchybar/sketchybarrc \
  sketchybar/.config/sketchybar/colors.sh \
  sketchybar/.config/sketchybar/plugins/*.sh \
  borders/.config/borders/bordersrc
```

Adding a new tool means adding a new Stow package whose interior mirrors the target path under `~`, adding its dependency to the `Brewfile`, and documenting it in the repository layout.

## Branch naming

dotfiles follows [Conventional Branch](https://conventionalbranch.org/).

Format: `<type>/<description>`

| Type | Alias | Use case | Example |
|------|-------|----------|---------|
| `feat/` | `feature/` | New features | `feat/add-yazi-package` |
| `fix/` | `bugfix/` | Bug fixes | `fix/ghostty-ansi-palette` |
| `hotfix/` | - | Urgent fixes | `hotfix/broken-zshrc-source` |
| `release/` | - | Release preparation | `release/v0.2.0` |
| `chore/` | - | Non-code tasks (deps, docs) | `chore/update-brewfile` |

Rules: lowercase letters, numbers, and hyphens only, with no uppercase, underscores, spaces, or consecutive hyphens.

## Commit conventions

dotfiles follows [Conventional Commits](https://www.conventionalcommits.org/).

**Format**: `<type>[optional scope]: <description>`

- Description: brief, imperative, lowercase, 7-12 words
- Scope: package name (`ghostty`, `nvim`, `zsh`, `starship`, `btop`, `fastfetch`, `sketchybar`, `borders`, …)
- No period at end of subject line
- Subject line only, no body, no bullet points

**Allowed types**: `feat` `fix` `chore` `ci` `docs` `refactor` `perf` `test` `build`

**Examples**:

```
feat(ghostty): pin ansi palette to canonical base16 oxocarbon
fix(zsh): source fzf-tab before setting completion styles
chore(nvim): bump lazy-lock plugin revisions
```

## Code quality

All contributions follow these principles:

- **DRY**: the palette is defined once and referenced; do not paste hex values that already have a name
- **KISS**: simplest configuration that produces the desired behavior
- **Meaningful names**: package and file names reveal what tool they configure
- **No magic numbers**: name colors and reusable values rather than repeating literals
- **Comments**: add only where the intent is not obvious from the configuration itself, one line max

Never commit a secret. Machine-local values such as API tokens and age keys stay out of the repository; `.gitignore` and `.gitleaks.toml` guard against this, and CI scans every push.

## Architectural decisions

Significant design choices are documented as ADRs in [`docs/adr/`](docs/adr/). Add or update an ADR when a PR introduces or changes an architectural decision, such as how packages are deployed or where the palette comes from.

## Pull requests

1. Verify the change against the running tool locally
2. Open a PR against `main`
3. Fill in the PR template completely
4. CI must pass before merging
