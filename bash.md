## kp
A simple bash script to kill processes by process name (any substr of process exec command).

``` bash
#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: kp <script_name>"
    exit 1
fi

SCRIPT_NAME=$1
USER_NAME=$(whoami)

ps -u luowanxiang -o pid,cmd | grep "$SCRIPT_NAME" | awk '{print $1}' | xargs -r kill
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
    
    ![clash verge yaml](./bash_mihomo_yaml.png)
    
    > Note that default ports 7890 and 9090 may cause conflict, you can change the configs below in the yaml to other available ports.
    
    ```yaml
    mixed-port: 17891   # to avoid port conflict
    external-controller: '127.0.0.1:19091'   # to avoid port conflict
    ```

4. Bind mihomo and the config directory and yaml file.

    ```bash
    mihomo -d ~/.config/mihomo -f ~/.config/mihomo/config.yaml
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
