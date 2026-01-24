## kp
A simple bash script to kill processes by process name (any substr of process exec command).

> user_name `lwx` should be replaced for different server.

``` bash
#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: kp <script_name>"
    exit 1
fi

SCRIPT_NAME=$1
USER_NAME=$(whoami)

ps -u "$USER_NAME" -o pid,cmd | grep "$SCRIPT_NAME" | awk '{print $1}' | xargs -r kill
```

### Usage
1. create ~/bin/kp
2. `chmod +x ~/bin/kp`
3. Add ~/bin to system path: `export PATH="$HOME/bin:$PATH"`
4. `source ~/.bashrc`

## uv
Network error when using uv:

``` bash
$ uv run examples/distributed_test/scripts/pcg_maze.py 
Using CPython 3.11.13
Creating virtual environment at: .venv
  × Failed to download `werkzeug==3.1.1`
  ├─▶ Failed to fetch:
  │   `https://files.pythonhosted.org/packages/ee/ea/c67e1dee1ba208ed22c06d1d547ae5e293374bfc43e0eb0ef5e262b68561/werkzeug-3.1.1-py3-none-any.whl`
  ├─▶ Request failed after 3 retries
  ├─▶ error sending request for url
  │   (https://files.pythonhosted.org/packages/ee/ea/c67e1dee1ba208ed22c06d1d547ae5e293374bfc43e0eb0ef5e262b68561/werkzeug-3.1.1-py3-none-any.whl)
  ╰─▶ operation timed out
```

For Linux, uv config file is `~/.config/uv/uv.toml`.

Add pypi source config in `uv.toml`:

```toml
# ~/.config/uv/uv.toml
  
index-url = "https://pypi.tuna.tsinghua.edu.cn/simple"
```

## Linux network proxy
mihomo

1. Download mihomo from [github releases page](https://github.com/MetaCubeX/mihomo/releases).

    ```bash
    $ uname -i
    x86_64    # amd64
    ```

    Thus, we should download [mihomo-linux-amd64-alpha-e2ee743.gz](https://github.com/MetaCubeX/mihomo/releases/download/Prerelease-Alpha/mihomo-linux-amd64-alpha-e2ee743.gz).

2. Unzip gz file and move to ~/bin.
    ```bash
    # unzip the downloaded file
    gzip -d mihomo-linux-amd64-alpha-e2ee743.gz
    # rename
    mv mihomo-linux-amd64-alpha-e2ee743 mihomo
    chmod +x mihomo
    mv mihomo ~/bin/
    ```

3. Import subscribe yaml config.
    ```bash
    mkdir -p ~/.config/mihomo/
    vim ~/.config/mihomo/config.yaml
    ```
    
    Then, paste your clash verge yaml to `~/.config/mihomo/config.yaml`.
    
    ![clash verge yaml](./figures/bash_mihomo_yaml.png)
    
    > Note that default ports 7890 and 9090 may cause conflict, you can change the configs below in the yaml to other available ports.
    
    ```yaml
    mixed-port: 17891   # to avoid port conflict
    external-controller: '127.0.0.1:19091'   # to avoid port conflict
    ```

4. Bind mihomo and the config directory and yaml file.

    ```bash
    mihomo -d ~/.config/mihomo -f ~/.config/mihomo/config.yaml
    ```
    
    > Error: Initializing mihomo itself needs downloading `geoip.metadb` and `geosite.dat` from [MetaCubeX github](https://github.com/MetaCubeX/meta-rules-dat). If it failed, you should download locally from and scp it to the `~/.config/mihomo`

    ```bash
    $ ~/bin/mihomo -d ~/.config/mihomo/ -f ~/.config/mihomo/config.yaml
    INFO[2025-11-12T09:47:34.095432542+08:00] Start initial configuration in progress      
    INFO[2025-11-12T09:47:34.123926135+08:00] Geodata Loader mode: memconservative         
    INFO[2025-11-12T09:47:34.123960203+08:00] Geosite Matcher implementation: succinct     
    INFO[2025-11-12T09:47:34.124351708+08:00] Can't find MMDB, start download              
    ERRO[2025-11-12T09:49:04.124737710+08:00] can't initial GeoIP: can't download MMDB: Get "https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.metadb": context deadline exceeded 
    FATA[2025-11-12T09:49:04.124816193+08:00] Parse config error: rules[514] [GEOIP,CN,DIRECT] error: can't download MMDB: Get "https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.metadb": context deadline exceeded
    ```

5. Create a useful script.

    ```bash
    vim ~/.config/mihomo/mihomo.sh
    ```

    ```bash
    mihomo() {
        case $1 in
        on)
            export http_proxy=http://127.0.0.1:17891
            export https_proxy=$http_proxy
            export HTTP_PROXY=$http_proxy
            export HTTPS_PROXY=$http_proxy
            export all_proxy=$http_proxy
            export ALL_PROXY=$http_proxy
            export NO_PROXY="localhost,127.0.0.1,::1"
            pgrep -f mihomo || {
                ~/bin/mihomo -d ~/.config/mihomo/ -f ~/.config/mihomo/config.yaml >& ~/.config/mihomo/log & 
            }
            echo '已开启代理环境'
            ;;
        off)
            unset http_proxy
            unset https_proxy
            unset HTTP_PROXY
            unset HTTPS_PROXY
            unset all_proxy
            unset ALL_PROXY
            unset no_proxy
            unset NO_PROXY
            pkill -9 -f mihomo
            echo '已关闭代理环境'
            ;;
        esac
    }
    ```
    
    Then, start this script whenever login bash.
    ```bash
    vim ~/.bashrc
    ```

    ```bash
    source ~/.config/mihomo/mihomo.sh
    mihomo on
    ```

    > Note that 7890 and 9090 port may cause conflict, you can change the configs below in the yaml to other available ports.
    
    ```bash
    export http_proxy=http://127.0.0.1:17891
    ```

6. Usage:
    ```bash
    mihomo on    # open proxy
    mihomo off   # close proxy
    ```
    
    Check whether the port is listened:
    ```bash
    sudo ss -tulnp | grep 17891
    sudo lsof -i :17891    # alternatively
    ```

## Reverse Proxy
Since the server and computer are in the same LAN, the server can directly access the LAN ip.

Add to `.bashrc`
``` bash
# 2025-11-13
IP="10.87.51.120"    # computer LAN ip
export IP_ADDR="http://$IP:7897"

alias proxy="
    export http_proxy=$IP_ADDR;
    export https_proxy=$IP_ADDR;
    export all_proxy=$IP_ADDR;
    export HTTP_PROXY=$IP_ADDR;
    export HTTPS_PROXY=$IP_ADDR;
    export ALL_PROXY=$IP_ADDR;
alias unproxy="
    unset http_proxy;
    unset https_proxy;
    unset all_proxy;
    unset HTTP_PROXY;
    unset HTTPS_PROXY;
    unset ALL_PROXY;

proxy
```

## frp
[Reverse proxy](#reverse-proxy) hardcodes the ip of our computer, but it may change due to DHCP.

FRP builds a tunnel between server and local computer. We do not need to specify the ip in `.bashrc`.

1. Modify `.bashrc`
    ``` bash
    IP="127.0.0.1"	# frp
    export IP_ADDR="http://$IP:7897"

    alias proxy="
        export http_proxy=$IP_ADDR;
        export https_proxy=$IP_ADDR;
        export all_proxy=$IP_ADDR;
        export HTTP_PROXY=$IP_ADDR;
        export HTTPS_PROXY=$IP_ADDR;
        export ALL_PROXY=$IP_ADDR;
    alias unproxy="
        unset http_proxy;
        unset https_proxy;
        unset all_proxy;
        unset HTTP_PROXY;
        unset HTTPS_PROXY;
        unset ALL_PROXY;

    proxy
    ```

2. Configure frp server `frps` in the server.

    1. Download `frp`:
    ``` bash
    wget https://github.com/fatedier/frp/releases/download/v0.65.0/frp_0.65.0_linux_amd64.tar.gz

    tar -xzf frp_0.65.0_linux_amd64.tar.gz

    mv frp_0.65.0_linux_amd64 ~/bin/frp
    
    cd ~/bin
    ```
    
    2. Modify frps.toml. `bindPort` is the frp server exposed port

    ``` bash
    bindPort = 7007        # exposed port of frp server
    auth.token = "5525"
    ```
    
    3. Setup auto starting `frps` whenever login.

        - Create `~/bin/start_frps.sh`
        ``` bash
        #!/bin/bash

        FRP_DIR="$HOME/bin/frp"
        LOG_FILE="$FRP_DIR/frps.log"
        PID_FILE="$FRP_DIR/frps.pid"

        # 如果已经在运行，直接退出
        if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
            echo "frps already running"
            exit 0
        fi

        # 启动 frps
        nohup "$FRP_DIR/frps" -c "$FRP_DIR/frps.toml" >> "$LOG_FILE" 2>&1 &
        echo $! > "$PID_FILE"

        echo "frps started"
        ```
        
        - Append to `~/.bashrc`
        ```
        ~/bin/start_frps.sh
        ```

3. Configure frp client in local computer.

    1. Download [frp_0.65.0_windows_amd64.zip](https://github.com/fatedier/frp/releases/download/v0.65.0/frp_0.65.0_windows_amd64.zip)
from [github page](https://github.com/fatedier/frp/releases).

    2. Modify [frpc.toml](../../../frp_0.65.0_windows_amd64/frpc.toml).

    ``` bash
    serverAddr = "10.82.1.210"
    serverPort = 7007       # exposed port of frp server

    auth.token = "5525"

    [[proxies]]
    name = "proxy7897"
    type = "tcp"
    localIP = "127.0.0.1"
    localPort = 7897        # local windows clash verge proxy port
    remotePort = 7897       # map to lab server port
    ```

    3. Use `nssm` to setup auto starting `frpc` whenever login.
    
    ``` bash
    # use command line
    .\nssm.exe install frpc_a100 "D:\frp_0.65.0_windows_amd64\frpc.exe" "-c D:\frp_0.65.0_windows_amd64\frpc_a100.toml"
    .\nssm.exe set frpc_a100 AppStdout "D:\frp_0.65.0_windows_amd64\logs\frpc_a100.log"
    .\nssm.exe set frpc_a100 AppStderr "D:\frp_0.65.0_windows_amd64\logs\frpc_a100.log"

    .\nssm.exe install frpc_4090 "D:\frp_0.65.0_windows_amd64\frpc.exe" "-c D:\frp_0.65.0_windows_amd64\frpc_4090.toml"
    .\nssm.exe set frpc_4090 AppStdout "D:\frp_0.65.0_windows_amd64\logs\frpc_4090.log"
    .\nssm.exe set frpc_4090 AppStderr "D:\frp_0.65.0_windows_amd64\logs\frpc_4090.log"
    
    # GUI
    .\nssm.exe install frpc_a100
    # set on GUI ...
    ```

## Useful tools
One script for installing all tools: [install_tools.sh](./scripts/install_tools.sh). 

Don't forget to `source ~/.bashrc` to activate the installations.

### ⭐ Recommended Aliases (Optional)

Add to `~/.bashrc`:

```bash
alias cat='bat'
alias cd='z'
alias du='dust'
alias diff='delta'
```

### fzf
Fuzzy finder for command history, file names, git, and more.

#### Features
* Interactive search for command history
* Fuzzy search on file paths
* Works with many tools (`rg`, `fd`)

#### Usage
* **Ctrl + R** — fuzzy search command history
* `fd | fzf` — fuzzy file picker
* `fzf --preview 'bat --style=numbers --color=always {}'` — file preview (with bat)

#### Install
```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

---

### fd
Replacement for `find`.

#### Usage Examples
```bash
fd keyword
fd ".*\.py"
fd -e py         # search by extension
fd -t d          # directories only
```

#### Install
```bash
mkdir -p ~/.local/bin
cd /tmp
wget https://github.com/sharkdp/fd/releases/download/v8.7.0/fd-v8.7.0-x86_64-unknown-linux-musl.tar.gz
tar xf fd-*.tar.gz
cp fd-*/fd ~/.local/bin/
```

---

### rg (ripgrep)

Recursive text search. Replacement for `grep -r`.

#### Usage Examples
```bash
rg something
rg "def\s+main"
rg pattern -g "*.py"
rg -n -C 3 keyword    # with line numbers and context
```

#### Install
```bash
cd /tmp
wget https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep-14.1.0-x86_64-unknown-linux-musl.tar.gz
tar xf ripgrep-*.tar.gz
cp ripgrep-*/rg ~/.local/bin/
```

---

### zoxide
Smarter `cd`. Learns your directory usage patterns.

#### Usage

```bash
z foo       # jump to most used directory matching "foo"
zi config   # interactive mode (if enabled)
```

#### Install
```bash
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
```

Add to `.bashrc`:

```bash
eval "$(~/.local/bin/zoxide init bash)"
```

---

### bat
replacement for `cat` and `less` with syntax highlighting.

#### Usage
```bash
bat file.py
bat --style=plain file.txt
```

#### Install
Download binary and place in `~/.local/bin`:

[https://github.com/sharkdp/bat/releases](https://github.com/sharkdp/bat/releases)

---

### dust
Disk usage viewer (replacement for `du`).

#### Usage
```bash
dust
dust ~/projects
```

Binary releases:
[https://github.com/bootandy/dust/releases](https://github.com/bootandy/dust/releases)

---

### delta

Enhanced syntax-highlighted diff viewer. Best used with git.

#### Git Integration
```bash
git config --global core.pager delta
git config --global interactive.diffFilter "delta --color-only"
```

#### Usage
```bash
git diff
delta file1 file2
```

Binary releases:
[https://github.com/dandavison/delta/releases](https://github.com/dandavison/delta/releases)

---

### tldr

Minimalist alternative to man pages.

#### Usage
```bash
tldr tar
tldr rsync
tldr find
```

#### Install
```bash
pip install --user tldr
```
