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