# Use a minimal base image
FROM debian:12.7-slim AS base

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Make sure man pages are installed
RUN sed -i 's:^path-exclude /usr/share/man:#path-exclude /usr/share/man:' \
        /etc/dpkg/dpkg.cfg.d/docker

# Install needed tools
# hadolint ignore=DL3008
RUN apt-get update && \
    apt-get install -y --no-install-recommends --reinstall \
    manpages \
    man-db \
    coreutils \
    curl \
    git \
    less \
    sudo \
    vim \
    wget \
    openssh-client \
    bash-completion \
    iputils-ping \
    ca-certificates \
    rlwrap \
    xsel && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists

# Add GitHub CLI repository
# hadolint ignore=DL3008
RUN wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null && \
    chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && \
    apt-get install gh -y --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists

# Install Hadolint
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then \
    wget -qO /usr/local/bin/hadolint https://github.com/hadolint/hadolint/releases/download/v2.12.0/hadolint-Linux-x86_64; \
    elif [ "$ARCH" = "arm64" ]; then \
    wget -qO /usr/local/bin/hadolint https://github.com/hadolint/hadolint/releases/download/v2.12.0/hadolint-Linux-arm64; \
    else \
    echo "Unsupported architecture: $ARCH"; exit 1; \
    fi && \
    chmod +x /usr/local/bin/hadolint

# Install Docker CLI
# hadolint ignore=DL3008,SC1091
RUN install -m 0755 -d /etc/apt/keyrings && \
    wget -q https://download.docker.com/linux/debian/gpg -O /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get -y --no-install-recommends install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists

# Create a non-root user and group
RUN useradd --home-dir /home/developer --create-home --skel /etc/skel --shell /bin/bash --uid 1001 developer --groups docker

# Set the working directory for the new user
WORKDIR /home/developer

# Copy VIM configuration
COPY ./vim/vimrc /home/developer/.vimrc

# Copy BASH configuration
COPY ./bash/bashrc /home/developer/.bashrc.slough
RUN echo "source /home/developer/.bashrc.slough" >> /home/developer/.bashrc

# Copy Starship configuration
COPY ./starship/starship.toml /home/developer/.config/starship.toml
COPY ./starship/StarshipPrompt/* /home/developer/StarshipPrompt/

# Directory for Dev Container
RUN mkdir -p /workspaces && chown -R developer:developer /workspaces

# Allow the developer user to use sudo without a password
RUN echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install Starship
RUN wget -q https://starship.rs/install.sh -O install.sh && \
    chmod +x install.sh && \
    ./install.sh -y && \
    rm ./install.sh

# Download Git completion script
RUN wget -q https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -O /etc/bash_completion.d/git-completion.bash && \
    echo "source /etc/bash_completion.d/git-completion.bash" >> /home/developer/.bashrc

# Copy and install cheat.sh client script
COPY ./bin/cht.sh /usr/local/bin/cht.sh

# Fix all permissions for the home folder and make cheat.sh executable
RUN chmod +x /usr/local/bin/cht.sh && \
    chown -R developer:developer /home/developer

# Switch to the non-root user
USER developer

# Install `uv`. Used for pre-commit
RUN wget -qO- https://astral.sh/uv/install.sh | sh

# Install pre-commit using uv
ENV PATH="/home/developer/.local/bin:${PATH}"
RUN uv tool install pre-commit

# Install Rust and Cargo
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install onefetch using cargo
ENV PATH="/home/developer/.cargo/bin:${PATH}"
RUN cargo install onefetch

# Configure Starship
RUN mkdir -p .config && \
    mkdir -p StarshipPrompt
ENV PROMPTNAME="BASE"

# Set the default command to bash
CMD ["bash"]