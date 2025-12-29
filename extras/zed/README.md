# Theme for Zed editor

You can find the color scheme [here](https://zed-themes.com/themes/O3bqjemHpBtsD8_ZQf-Kk)
or set it manually.

To use the Charleston color scheme in Zed, copy the theme file to the Zed configuration folder,
usually `~/.config/zed/themes` on Linux/macOS or `%USERPROFILE%\AppData\Roaming\Zed\themes\` on Windows.

```bash
# Linux/macOS
mkdir -p ~/.config/zed/themes
cp charleston.json ~/.config/zed/themes/
```

```powershell
# Windows
mkdir $env:USERPROFILE\AppData\Roaming\Zed\themes
cp charleston.json $env:USERPROFILE\AppData\Roaming\Zed\themes\
```

After copying the theme file, activate it by opening Zed settings and adding:

```json
{
  "theme": "Charleston Dark"
}
```

Or use the command palette (`Ctrl+Shift+P` / `Cmd+Shift+P`) and select `theme selector: toggle` to choose Charleston Dark from the list.

For more information about themes in Zed, visit the official documentation: <https://zed.dev/docs/themes>
