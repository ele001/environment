### HyperSwitch
[Disable "HyperSwitch expired!" window](https://gist.github.com/xqin/20a51ea523a738acfe6773616a26b2c9?permalink_comment_id=5521427)

```bash
cd /Applications/HyperSwitch.app/Contents/MacOS/

cp HyperSwitch HyperSwitch.original

cp HyperSwitch.original HyperSwitch.unsigned

codesign --remove-signature HyperSwitch.unsigned

printf "03B202: 8D\n01146C4: 0C" | xxd -r - HyperSwitch.unsigned

mv HyperSwitch.unsigned HyperSwitch


rm HyperSwitch.original # remove HyperSwitch.original, if you want
```
