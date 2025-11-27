#!/usr/bin/env bash
set -e

BIN="$HOME/.local/bin"
mkdir -p "$BIN"

divider() {
    echo "---------------------------------------------"
}
info() {
    echo -e "[$1] $2"
}
skip() {
    echo -e "⏭  $1 already installed, skipping"
}
done_msg() {
    echo -e "✔  $1 installed"
}

# Check if a tool exists
is_installed() {
    command -v "$1" >/dev/null 2>&1
}

###################################
# Function: add alias safely
###################################
add_alias() {
    KEY="$1"
    VALUE="$2"

    # If already exists, skip
    if grep -q "^alias $KEY=" ~/.bashrc 2>/dev/null; then
        echo "⏭  alias $KEY already exists"
    else
        echo "alias $KEY='$VALUE'" >> ~/.bashrc
        echo "✔  alias $KEY added"
    fi
}

###################################
# Install tools
###################################

###################################
# fzf
###################################
divider
if is_installed fzf; then
    skip "fzf"
else
    info fzf "installing..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf >/dev/null 2>&1
    ~/.fzf/install --all >/dev/null 2>&1
    done_msg "fzf"
fi

###################################
# fd
###################################
divider
if is_installed fd; then
    skip "fd"
else
    info fd "installing..."
    cd /tmp
    curl -sLO https://github.com/sharkdp/fd/releases/download/v8.7.0/fd-v8.7.0-x86_64-unknown-linux-musl.tar.gz
    tar xf fd-*.tar.gz
    cp fd-*/fd "$BIN"
    done_msg "fd"
fi

###################################
# ripgrep (rg)
###################################
divider
if is_installed rg; then
    skip "rg"
else
    info rg "installing..."
    cd /tmp
    curl -sLO https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep-14.1.0-x86_64-unknown-linux-musl.tar.gz
    tar xf ripgrep-*.tar.gz
    cp ripgrep-*/rg "$BIN"
    done_msg "rg"
fi

###################################
# zoxide
###################################
divider
if is_installed zoxide; then
    skip "zoxide"
else
    info zoxide "installing..."
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash >/dev/null 2>&1
    done_msg "zoxide"
fi

# ensure zoxide init present (no duplicate)
if ! grep -q 'zoxide init bash' ~/.bashrc 2>/dev/null; then
    echo 'eval "$(~/.local/bin/zoxide init bash --cmd cd)"' >> ~/.bashrc
    echo "✔  added zoxide init to .bashrc"
fi

###################################
# bat
###################################
divider
if is_installed bat; then
    skip "bat"
else
    info bat "installing..."
    cd /tmp
    curl -sLO https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-x86_64-unknown-linux-musl.tar.gz
    tar xf bat-*.tar.gz
    cp bat-*/bat "$BIN"
    done_msg "bat"
fi

###################################
# dust
###################################
divider
if is_installed dust; then
    skip "dust"
else
    info dust "installing..."
    cd /tmp
    curl -sLO https://github.com/bootandy/dust/releases/download/v0.9.0/dust-v0.9.0-x86_64-unknown-linux-musl.tar.gz
    tar xf dust-*.tar.gz
    cp dust-*/dust "$BIN"
    done_msg "dust"
fi

###################################
# delta
###################################
divider
if is_installed delta; then
    skip "delta"
else
    info delta "installing..."
    cd /tmp
    curl -sLO https://github.com/dandavison/delta/releases/download/0.18.2/delta-0.18.2-x86_64-unknown-linux-musl.tar.gz
    tar xf delta-*.tar.gz
    cp delta-*/delta "$BIN"
    done_msg "delta"
fi

###################################
# tldr
###################################
divider
if is_installed tldr; then
    skip "tldr"
else
    info tldr "installing..."
    pip install --user tldr >/dev/null 2>&1
    done_msg "tldr"
fi

###################################
# Add aliases
###################################
divider
echo "Adding recommended aliases..."

add_alias cat "bat"
add_alias diff "delta"
add_alias du "dust"

divider
echo "✨ All tools processed successfully!"
echo "➡️  Run: source ~/.bashrc"
echo "   to apply aliases and zoxide init."
