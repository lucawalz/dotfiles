# Security policy

dotfiles holds shell and application configuration only, and no secret is committed. The shell configuration prepends tool directories to `PATH` but references no keys or credentials; any secret a workflow needs lives outside the repository. `.gitignore` excludes keys, credential files, and history, and `.gitleaks.toml` adds rules for age secret keys, SOPS keys, and SSH private keys on top of the gitleaks defaults.

## Reporting a vulnerability

Report a suspected vulnerability privately through the "Report a vulnerability" form under the repository's Security tab, rather than opening a public issue. A maintainer will respond there.

## Supported versions

Only the `main` branch is maintained.
