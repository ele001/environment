
### Clash Verge (github)

### [capsicain.exe: CapsLock 映射 单击 Esc, 组合键 Ctrl](https://zhuanlan.zhihu.com/p/595742183)

开机静默自启：
1. 创建快捷方式
2. 复制到 `C:\Users\ele 001\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup` 文件夹
3. Alt + Enter 查看属性
    - 修改 `目标(T):` 为 `<PATH> /startminimized /hidewindow` (例如 D:\VimPlungins\capsicain\capsicain.exe /startminimized /hidewindow)
    - 修改 `运行方式(R):` 为`最小化`

> Clash Verge uses the same way to set automatically startup. You can fine `Clash Verge` quick start in the same directory.

### Cursor

### Git

### Nvim
1. Download Neovim and set PATH
2. Download `VSCode Neovim` extension
3. Cursor > Settings >
    - Neovim Executable Paths: Win32 `D:\nvim\bin\nvim.exe`
    - Neovim Init Vim Paths: Win32 `D:\nvim\init.lua` (Use [init.lua](./scripts/init.lua))
