# Quick Start: Charleston Screenshots

Быстрое руководство по созданию скриншотов Charleston colorscheme.

## 🎯 Цель

Создать скриншоты, показывающие Charleston в действии с реальными плагинами Neovim.

## ⚡ За 3 шага

### 1. Установите screenshot tool

```bash
sudo dnf install flameshot    # Fedora
sudo apt install flameshot    # Ubuntu/Debian
```

### 2. Запустите демо

```bash
./scripts/demo-neovim.sh
```

### 3. Создайте скриншоты

В отдельном терминале:

```bash
./scripts/auto-screenshot.sh
```

Следуйте инструкциям скрипта!

## 📸 Ручной режим

### Запустите демо Neovim

```bash
./scripts/demo-neovim.sh
```

### Используйте команды

```vim
:DemoDashboard   " Приветственный экран
:DemoTelescope   " Поиск файлов
:DemoNeotree     " Файловый менеджер
:DemoMason       " LSP installer
:DemoSplit       " Split layout
```

### Сделайте скриншот

```bash
flameshot gui
```

## 📋 Чек-лист скриншотов

- [ ] Dashboard
- [ ] Code editing (src/main.lua)
- [ ] Telescope
- [ ] Neo-tree
- [ ] Mason
- [ ] Split windows
- [ ] Diagnostics
- [ ] Git signs

## 💡 Советы

1. **Размер окна**: минимум 120x40
2. **Шрифт**: JetBrains Mono или Fira Code
3. **Размер шрифта**: 14-16px
4. **True color**: Проверьте `echo $COLORTERM`

## 🔗 Подробности

Полная документация: [README.md](README.md)

## ⚠️ Проблемы?

### Плагины не устанавливаются

```bash
# Подождите завершения установки при первом запуске
# Или очистите и попробуйте снова:
rm -rf ~/.local/share/nvim/charleston-demo
./scripts/demo-neovim.sh
```

### Неправильные цвета

```bash
# Проверьте true color поддержку
echo $COLORTERM  # Должно быть: truecolor или 24bit
```

### Screenshot tool не работает

```bash
# Установите альтернативу
sudo dnf install spectacle     # KDE
sudo dnf install scrot          # Простой CLI
```

---

**Готово!** Скриншоты сохранены в `screenshots/output/`
