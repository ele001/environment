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
# Install package using apt
###################################
install_package() {
    local pkg="$1"
    sudo apt-get update -qq >/dev/null 2>&1
    sudo apt-get install -y "$pkg" >/dev/null 2>&1
}

###################################
# Check Python version
###################################
check_python_version() {
    local version="$1"
    if command -v "python${version}" >/dev/null 2>&1; then
        local installed_version=$(python${version} --version 2>&1 | awk '{print $2}' | cut -d. -f1,2)
        if [ "$installed_version" = "$version" ]; then
            return 0
        fi
    fi
    return 1
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
# Python 3.12
###################################
divider
if check_python_version "3.12"; then
    skip "python3.12"
else
    info python3.12 "installing..."
    # 添加 deadsnakes PPA（Ubuntu 官方仓库可能没有 3.12）
    sudo apt-get update -qq >/dev/null 2>&1
    sudo apt-get install -y software-properties-common >/dev/null 2>&1
    sudo add-apt-repository -y ppa:deadsnakes/ppa >/dev/null 2>&1
    sudo apt-get update -qq >/dev/null 2>&1
    # 安装 Python 3.12 和必要组件
    install_package python3.12
    install_package python3.12-venv
    install_package python3.12-dev
    done_msg "python3.12"
fi

###################################
# pip
###################################
divider
# 检查 pip 是否已安装（包括用户安装的）
PIP_AVAILABLE=0
if is_installed pip3 || is_installed pip; then
    PIP_AVAILABLE=1
elif [ -f ~/.local/bin/pip3 ] || [ -f ~/.local/bin/pip ]; then
    PIP_AVAILABLE=1
elif command -v python3.12 >/dev/null 2>&1 && python3.12 -m pip --version >/dev/null 2>&1; then
    PIP_AVAILABLE=1
elif command -v python3 >/dev/null 2>&1 && python3 -m pip --version >/dev/null 2>&1; then
    PIP_AVAILABLE=1
fi

if [ $PIP_AVAILABLE -eq 1 ]; then
    skip "pip"
else
    info pip "installing..."
    PIP_INSTALLED=0
    
    # 优先使用 python3.12
    if command -v python3.12 >/dev/null 2>&1; then
        # 尝试使用 get-pip.py 安装（ensurepip 在 Debian/Ubuntu 中被禁用）
        info pip "downloading get-pip.py..."
        if curl -sSL https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py; then
            info pip "installing pip for python3.12..."
            if python3.12 /tmp/get-pip.py --user --break-system-packages 2>&1; then
                PIP_INSTALLED=1
            else
                # 如果 --break-system-packages 失败，尝试只用 --user
                info pip "retrying without --break-system-packages..."
                python3.12 /tmp/get-pip.py --user 2>&1 && PIP_INSTALLED=1
            fi
            rm -f /tmp/get-pip.py
        fi
    fi
    
    # 如果 python3.12 的 pip 安装失败，尝试系统默认 python3
    if [ $PIP_INSTALLED -eq 0 ] && command -v python3 >/dev/null 2>&1; then
        info pip "downloading get-pip.py for system python3..."
        if curl -sSL https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py; then
            info pip "installing pip for python3..."
            if python3 /tmp/get-pip.py --user --break-system-packages 2>&1; then
                PIP_INSTALLED=1
            else
                info pip "retrying without --break-system-packages..."
                python3 /tmp/get-pip.py --user 2>&1 && PIP_INSTALLED=1
            fi
            rm -f /tmp/get-pip.py
        fi
    fi
    
    if [ $PIP_INSTALLED -eq 1 ]; then
        done_msg "pip"
        # 确保 ~/.local/bin 在 PATH 中
        if ! grep -q '\.local/bin' ~/.bashrc 2>/dev/null; then
            echo '' >> ~/.bashrc
            echo '# Add local bin to PATH (for pip and other user-installed tools)' >> ~/.bashrc
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
            echo "✔  added ~/.local/bin to PATH"
        fi
        # 立即添加到当前会话的 PATH
        export PATH="$HOME/.local/bin:$PATH"
    else
        echo "❌ pip installation failed"
        echo "   尝试手动安装: curl -sSL https://bootstrap.pypa.io/get-pip.py | python3.12 --user"
        exit 1
    fi
fi

###################################
# pipx (for installing Python CLI tools in isolated environments)
###################################
divider
if is_installed pipx; then
    skip "pipx"
else
    info pipx "installing..."
    # 优先尝试使用 apt 安装（更简单）
    if install_package pipx 2>/dev/null; then
        done_msg "pipx"
    else
        # 如果 apt 安装失败，使用 pip 安装
        info pipx "apt install failed, trying pip..."
        if command -v python3.12 >/dev/null 2>&1 && python3.12 -m pip --version >/dev/null 2>&1; then
            python3.12 -m pip install --user --break-system-packages pipx 2>&1 || \
            python3.12 -m pip install --user pipx 2>&1
        elif command -v pip3 >/dev/null 2>&1; then
            pip3 install --user --break-system-packages pipx 2>&1 || \
            pip3 install --user pipx 2>&1
        fi
        if is_installed pipx || [ -f ~/.local/bin/pipx ]; then
            done_msg "pipx"
        else
            echo "❌ pipx installation failed"
            exit 1
        fi
    fi
    # 确保 pipx 的 bin 目录在 PATH 中
    if ! grep -q '\.local/bin' ~/.bashrc 2>/dev/null; then
        echo '' >> ~/.bashrc
        echo '# Add local bin to PATH (for pipx and other user-installed tools)' >> ~/.bashrc
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        echo "✔  added ~/.local/bin to PATH"
    fi
    # 立即添加到当前会话的 PATH
    export PATH="$HOME/.local/bin:$PATH"
    # 确保 pipx 环境已初始化
    if command -v pipx >/dev/null 2>&1 || [ -f ~/.local/bin/pipx ]; then
        ~/.local/bin/pipx ensurepath >/dev/null 2>&1 || true
    fi
fi

###################################
# tldr (using pipx for isolated installation)
###################################
divider
if is_installed tldr; then
    skip "tldr"
else
    info tldr "installing with pipx..."
    # 使用 pipx 安装 tldr（自动创建独立虚拟环境）
    if command -v pipx >/dev/null 2>&1; then
        pipx install tldr >/dev/null 2>&1
    elif [ -f ~/.local/bin/pipx ]; then
        ~/.local/bin/pipx install tldr >/dev/null 2>&1
    else
        echo "❌ pipx not found, cannot install tldr"
        exit 1
    fi
    
    # 验证安装
    if is_installed tldr || [ -f ~/.local/bin/tldr ]; then
        done_msg "tldr"
    else
        echo "❌ tldr installation failed"
        echo "   尝试手动安装: pipx install tldr"
        exit 1
    fi
fi

###################################
# Add aliases
###################################
divider
echo "Adding recommended aliases..."

add_alias cat "bat"
add_alias diff "delta"
add_alias du "dust"

# Python alias (指向 python3，优先使用 python3.12)
if command -v python3.12 >/dev/null 2>&1; then
    add_alias python "python3.12"
    add_alias pip "python3.12 -m pip"
elif command -v python3 >/dev/null 2>&1; then
    add_alias python "python3"
    if command -v pip3 >/dev/null 2>&1; then
        add_alias pip "pip3"
    fi
fi

divider
echo "✨ All tools processed successfully!"
echo "➡️  Run: source ~/.bashrc"
echo "   to apply aliases and zoxide init."
