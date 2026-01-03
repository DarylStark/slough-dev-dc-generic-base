# Slough - Dev Container - Generic Base

Generic base Docker image for development containers. Contains no specific language or tooling, but provides a base image with common tools and utilities.

## About the Slough Project

**Slough** is a project by [Daryl Stark](https://github.com/DarylStark) that delivers consistent development tooling through dev containers. The goal of Slough is to provide standardized, pre-configured development environments that work seamlessly across different platforms and projects. This ensures that all team members work with the same tools, configurations, and dependencies, reducing "works on my machine" issues.

This repository provides the **Generic Base** dev container - a foundational image that includes common development tools and utilities without language-specific tooling. It serves as a base for more specialized dev containers or can be used directly for projects that don't require specific language runtimes.

## How to Use This Container

### Using as a Dev Container

To use this container as a dev container in your project, create a `.devcontainer/devcontainer.json` file in your project root:

```json
{
  "name": "My Project Dev Container",
  "image": "dast1968/slough-dev-dc-generic-base:1.0.0",
  "mounts": [
    "source=/var/run/docker.sock,target=/var/run/docker.sock,type=bind"
  ],
  "remoteUser": "developer"
}
```

**Image Tag Format:** `dast1968/slough-dev-dc-generic-base:1.0.0`
- **Registry:** Docker Hub
- **User:** `dast1968`
- **Repository:** `slough-dev-dc-generic-base`
- **Version:** `1.0.0` (for this release)

### Opening in VS Code

1. Install the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) in VS Code
2. Open your project folder in VS Code
3. Press `F1` and select "Dev Containers: Reopen in Container"
4. VS Code will build/pull the container and reopen your workspace inside it

## Working with Dev Containers

### General Tips

- **Persistent Storage:** Your workspace files are mounted from your host machine, so changes persist after the container stops
- **Extensions:** Install VS Code extensions inside the container for a consistent development experience
- **Git Configuration:** Your Git config and SSH keys can be forwarded from the host (configure in `devcontainer.json`)
- **Performance:** For better performance, consider using volumes instead of bind mounts for node_modules or other dependency folders

### Microsoft Windows Specific Tips

#### WSL 2 Backend (Recommended)

For the best performance on Windows, use Docker Desktop with the WSL 2 backend:

1. **Install WSL 2:**
   ```powershell
   wsl --install
   ```

2. **Install Docker Desktop:** Enable WSL 2 backend in Docker Desktop settings

3. **Clone Repositories in WSL:** Store your project files in the WSL filesystem (e.g., `/home/username/projects/`) rather than on the Windows filesystem (`/mnt/c/`). This significantly improves file I/O performance.

4. **Access from VS Code:** Use the "WSL" extension in VS Code to open projects directly from WSL, then use the Dev Containers extension.

#### Line Endings

Windows uses CRLF (`\r\n`) line endings while Linux uses LF (`\n`). Configure Git to handle this automatically:

```bash
git config --global core.autocrlf input
```

This ensures that files are checked out with LF endings in the container, but you can edit them on Windows without issues.

#### File Permissions

File permission issues can occur when mounting Windows directories. The container runs as the `developer` user (UID 1001). If you encounter permission problems:

- Use WSL 2 and store files in the WSL filesystem
- Or, ensure your Windows user has appropriate permissions on mounted directories

#### Docker Socket Mounting

The container mounts the Docker socket (`/var/run/docker.sock`) to enable Docker-in-Docker operations. Ensure Docker Desktop is running and the socket is accessible.

## Container Configuration

### User Account

- **Username:** `developer`
- **User ID:** 1001
- **Home Directory:** `/home/developer`
- **Shell:** `/bin/bash`
- **Groups:** `docker`

### Sudo Access

The `developer` user has **passwordless sudo access**. You can run administrative commands without entering a password:

```bash
sudo apt-get update
sudo apt-get install <package>
```

**Note:** While convenient for development, be cautious when running sudo commands as they have full system access.

### Working Directory

The default working directory for projects is `/workspaces`, which is owned by the `developer` user.

### Environment Variables

- `VISUAL=vi` - Default visual editor
- `EDITOR=vi` - Default text editor
- `PATH` includes:
  - `/home/developer/.local/bin` (Python/UV tools)
  - `/home/developer/.cargo/bin` (Rust tools)
  - `~/bin` (User scripts)

## Installed Tools

This container comes pre-configured with a comprehensive set of development tools:

### Core System Tools

- **Git** - Version control system
  - Pre-configured with bash completion
  - Custom vim commands for Git operations (`:GitStatus`, `:GitCommit`, etc.)
- **curl** - Data transfer tool
- **wget** - File downloader
- **OpenSSH Client** - SSH connectivity
- **ca-certificates** - SSL certificate bundle
- **less** - File pager
- **sudo** - Administrative access

### Docker Tools

- **Docker CLI** - Docker command-line interface
  - **Docker Compose** - Multi-container orchestration (via plugin)
  - **Docker Buildx** - Extended build capabilities (via plugin)
  - Access to host Docker daemon via mounted socket
  - `docker` command is aliased to `sudo docker` in the shell

### Development Tools

- **GitHub CLI (`gh`)** - GitHub command-line tool
  ```bash
  gh auth login
  gh pr create
  gh issue list
  ```

- **Hadolint** - Dockerfile linter
  ```bash
  hadolint Dockerfile
  ```

- **pre-commit** - Git hook framework (via UV)
  ```bash
  pre-commit install
  pre-commit run --all-files
  ```
  - Aliased as `uvx pre-commit` in the shell

- **UV** - Fast Python package installer and resolver
  - Installed for the `developer` user
  - Used to manage pre-commit and other Python tools

- **Rust & Cargo** - Rust programming language and package manager
  - Full Rust toolchain installed via rustup
  - Used to build additional tools like `onefetch`

### Information & Productivity Tools

- **Onefetch** - Git repository summary tool
  - Automatically displays repository information when you `cd` into a Git repo
  - Shows language breakdown, contributors, and other metadata

- **Starship** - Customizable shell prompt
  - Pre-configured with custom prompt showing:
    - Current time
    - Git branch information with status
    - Working directory (color-coded)
    - Issue numbers and branch types
  - Configuration at `~/.config/starship.toml`

- **cht.sh** - Command-line cheat sheet tool
  ```bash
  cht.sh tar                    # Show tar cheat sheet
  cht.sh python zip             # Python zip examples
  cht.sh --shell                # Interactive mode
  ```
  - Available at `/usr/local/bin/cht.sh`
  - Powered by [cheat.sh](https://cheat.sh)

### Editor Configuration

#### Vim

A fully configured Vim setup is included at `~/.vimrc`:

- **Features:**
  - Syntax highlighting (elflord colorscheme)
  - Relative line numbers
  - Search highlighting
  - Code folding
  - Git integration commands
  - Custom status line showing mode, file, line/column
  - Tab/buffer navigation

- **Custom Git Commands:**
  - `:GitStatus` - Show git status
  - `:GitAddFile` - Add current file
  - `:GitAddAll` - Add all files
  - `:GitCommit` - Commit changes
  - `:GitDiff` - Show diff for current file
  - `:GitLogOneline` - Show one-line log with graph

- **Key Mappings:**
  - Leader key: `;`
  - `<Space>` - Toggle fold
  - `<Tab>` / `<Shift-Tab>` - Navigate tabs
  - `;gs` - Git status
  - `;ga` - Git add current file
  - `;gc` - Git commit
  - `{{` / `}}` - Previous/next buffer

### Shell Configuration

A custom Bash configuration is sourced at `~/.bashrc.slough`:

- **Aliases:**
  - `ll` - `ls -alF` (detailed list)
  - `la` - `ls -l` (long list)
  - `ls` - `ls -h --color` (human-readable, colored)
  - `docker` - `sudo docker` (automatic sudo)
  - `pre-commit` - `uvx pre-commit` (UV-managed)

- **Features:**
  - Command history with timestamps
  - Starship prompt integration
  - Automatic repository information display (via onefetch) when entering Git repos
  - Git bash completion

- **History Configuration:**
  - Format: `[YYYY-MM-DD HH:MM:SS] :: command`
  - Ignores duplicates and commands starting with spaces

## Building the Image

If you want to build this image locally:

```bash
cd src
docker build -t dast1968/slough-dev-dc-generic-base:1.0.0 .
```

## License

This project is licensed under the MIT License. See the [LICENSE.md](LICENSE.md) file for details.

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests to improve this dev container.

## Support

For issues, questions, or suggestions, please open an issue on the [GitHub repository](https://github.com/DarylStark/slough-dev-dc-generic-base).
