### Win + R Histroy Items
To clean histroy items that we do not use anymore in `Win+R`.

1. Open regedit（注册表编辑器）

2. Go to `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU`

3. In the right window, you will see items with keyname such as `a`, `b`, `c`, ..., which are the histroy items you've used before.

4. Delete items or modify the `Data` value of some items which you do not need anymore according to the `Data`（数据） col.

> Regedit RunMRU is a dict `{chr: Data}` with an `MRUList` (Most Recently Used List), which records the history sequence. By default, Windows reserve at most 26 history items.

> For every new item, it will use a smallest chr which is not assigned yet. If the 27th item arrives, it will swap out the oldest item in `MRUList`.

### Fix Input Method for Each Task When Switching Windows
When using `Alt+Tab` to swich windows, the input method may also change to zh, which is disturbing. It is recommended to fix input method for each window.

#### Method 1: Rename Desktop
Reference: [如何解决更新Windows11后，出现切换应用时，输入法自动变为英文的问题](https://zhuanlan.zhihu.com/p/23887468991)

1. Press `Win+Tab` to open the Task View.

2. Right-click "Desktop 1" and select "Rename".

3. In the rename input box, press `Ctrl+Space` to switch the input method to English.

4. Press `Enter` to confirm the change.

#### Method 2: System Setting
设置 → 时间和语言 → 语言和区域 → 输入 → 高级键盘设置

开启"允许我为每个应用窗口设置不同的输入法"
