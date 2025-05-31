### Win + R Histroy Items
To clean histroy items that we do not use anymore in `Win+R`.

1. Open regedit（注册表编辑器）

2. Go to `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU`

3. In the right window, you will see items with keyname such as `a`, `b`, `c`, ..., which are the histroy items you've used before.

4. Delete items or modify the `Data` value of some items which you do not need anymore according to the `Data`（数据） col.

> Regedit RunMRU is a dict `{chr: Data}` with an `MRUList` (Most Recently Used List), which records the history sequence. By default, Windows reserve at most 26 history items.

>For every new item, it will use a smallest chr which is not assigned yet. If the 27th item arrives, it will swap out the oldest item in `MRUList`.
