# Charleston Screenshot System

Комплексная система для создания скриншотов цветовой схемы Charleston, включая демонстрацию работы с популярными Neovim плагинами.

## 🎯 Два способа создания скриншотов

### 1. Реальные скриншоты Neovim (Рекомендуется)

Показывает Charleston в действии с реальными плагинами и UI элементами:
- Dashboard (приветственный экран)
- Telescope (поиск файлов)
- Neo-tree (файловый менеджер)
- Mason (установщик LSP)
- Lualine (статус-бар)
- Gitsigns, Treesitter и другие

### 2. Скриншоты кода (Silicon/Freeze)

Простые скриншоты кода с подсветкой синтаксиса (без UI плагинов).

## 📁 Структура

```
screenshots/
├── demo-config/         # Конфигурация Neovim для демо
│   └── init.lua         # Минимальная настройка с плагинами
├── demo-project/        # Демо-проект для скриншотов
│   ├── src/             # Исходный код
│   ├── lib/             # Библиотеки
│   ├── tests/           # Тесты
│   └── README.md        # Документация проекта
├── examples/            # Примеры для Silicon/Freeze
│   ├── example.lua
│   ├── example.py
│   ├── example.ts
│   └── example.rs
├── output/              # Сгенерированные скриншоты
└── README.md            # Эта документация
```

## 🚀 Быстрый старт: Реальные скриншоты Neovim

### Шаг 1: Установите инструмент для скриншотов

Выберите один из:

```bash
# Flameshot (рекомендуется)
sudo dnf install flameshot          # Fedora
sudo apt install flameshot          # Ubuntu/Debian

# Альтернативы
sudo dnf install spectacle          # KDE
sudo apt install gnome-screenshot   # GNOME
sudo dnf install scrot              # Минималистичный
```

### Шаг 2: Запустите демо Neovim

```bash
# Автоматический запуск с инструкциями
./scripts/demo-neovim.sh
```

Это откроет Neovim с:
- ✅ Charleston colorscheme
- ✅ Популярными плагинами
- ✅ Демо-проектом
- ✅ Готовыми командами для демонстрации

### Шаг 3: Создайте скриншоты

#### Вариант А: Интерактивный помощник (Рекомендуется)

```bash
# В отдельном терминале запустите
./scripts/auto-screenshot.sh
```

Скрипт проведет вас через все сценарии скриншотов:
1. Dashboard
2. Редактирование кода
3. Telescope (поиск файлов)
4. Neo-tree (файловый менеджер)
5. Mason (LSP)
6. Split layout
7. Диагностика
8. Git signs

#### Вариант Б: Вручную

1. Откройте Neovim через `./scripts/demo-neovim.sh`
2. Используйте команды для демо:

```vim
:DemoDashboard   " Показать dashboard
:DemoTelescope   " Открыть Telescope
:DemoNeotree     " Показать Neo-tree
:DemoMason       " Открыть Mason
:DemoSplit       " Создать split layout
```

3. Сделайте скриншот вашим инструментом:

```bash
flameshot gui    # Flameshot
spectacle        # KDE
```

## 🎨 Команды в демо Neovim

После запуска `./scripts/demo-neovim.sh` доступны:

| Команда | Описание |
|---------|----------|
| `:DemoDashboard` | Показать приветственный экран |
| `:DemoTelescope` | Открыть Telescope finder |
| `:DemoNeotree` | Переключить Neo-tree |
| `:DemoMason` | Открыть Mason (LSP installer) |
| `:DemoSplit` | Создать split layout |

**Горячие клавиши:**
- `<Space>ff` - Find files (Telescope)
- `<Space>fg` - Live grep (Telescope)
- `<Space>e` - Toggle Neo-tree

## 💡 Советы для отличных скриншотов

### Настройки терминала

1. **Размер окна**: Рекомендуется 120x40 или больше
   ```bash
   # Проверить текущий размер
   echo $COLUMNS x $LINES
   ```

2. **Шрифт**: Используйте моноширинный шрифт с лигатурами
   - JetBrains Mono (рекомендуется)
   - Fira Code
   - Cascadia Code

3. **Размер шрифта**: 12-16px для читаемости

### Что показать на скриншотах

1. **Dashboard** - Первое впечатление
2. **Редактирование кода** - Подсветка синтаксиса, номера строк, git signs
3. **Telescope** - Поиск файлов, красивый UI
4. **Neo-tree** - Файловый менеджер, иконки
5. **Mason** - UI для установки LSP
6. **Split windows** - Несколько панелей
7. **Diagnostics** - Ошибки, предупреждения
8. **Status line** - Lualine с Charleston темой

### Композиция

- Центрируйте важный контент
- Оставьте немного padding вокруг окна
- Покажите полезную информацию (строка состояния, номера строк)
- Избегайте личной информации в скриншотах

## 🔧 Альтернатива: Скриншоты кода (Silicon)

Для простых скриншотов кода без UI плагинов:

### Установка Silicon

```bash
cargo install silicon
```

### Использование

```bash
# Сгенерировать скриншоты для примеров
$HOME/.cargo/bin/silicon \
  --background "#1D2024" \
  --font "Fira Mono" \
  --shadow-blur-radius 0 \
  --pad-horiz 40 \
  --pad-vert 30 \
  --output screenshots/output/my-code.png \
  my-file.lua
```

### Автоматическая генерация всех примеров

```bash
./scripts/generate-screenshots.sh --method silicon
```

## 📋 Рекомендуемые скриншоты

Для полной демонстрации Charleston создайте эти скриншоты:

- [ ] **01-dashboard** - Приветственный экран с ASCII art
- [ ] **02-code-lua** - Lua код с подсветкой
- [ ] **03-code-python** - Python код
- [ ] **04-telescope** - Telescope file finder
- [ ] **05-neotree** - Neo-tree sidebar
- [ ] **06-mason** - Mason LSP installer
- [ ] **07-splits** - Multiple split windows
- [ ] **08-diagnostics** - LSP diagnostics
- [ ] **09-git** - Git signs и diff
- [ ] **10-terminal** - Встроенный терминал

## 🎬 Продвинутые сценарии

### Показать git diff

```bash
# В demo-project создайте изменения
cd screenshots/demo-project
echo "-- Modified" >> src/main.lua
git add .
```

Затем в Neovim увидите git signs в gutter.

### Показать LSP диагностику

Добавьте синтаксическую ошибку в файл для демонстрации подсветки ошибок.

### Множественные окна

```vim
:DemoSplit
:edit lib/config.lua
<C-w>w
:edit lib/utils.lua
<C-w>w
:edit tests/test_utils.lua
```

## 🔍 Troubleshooting

### Neovim не запускается

```bash
# Проверьте Neovim
nvim --version

# Должен быть >= 0.9
```

### Плагины не устанавливаются

При первом запуске lazy.nvim автоматически установит плагины. Подождите завершения.

Если проблемы:
```bash
# Очистите кеш и попробуйте снова
rm -rf ~/.local/share/nvim/charleston-demo
./scripts/demo-neovim.sh
```

### Screenshot tool не работает

```bash
# Проверьте установлен ли инструмент
which flameshot spectacle gnome-screenshot scrot

# Установите один из них
sudo dnf install flameshot
```

### Неправильные цвета

Убедитесь, что терминал поддерживает true color:

```bash
# Проверьте
echo $COLORTERM

# Должно быть: truecolor или 24bit
```

## 📚 Дополнительные ресурсы

### Customизация demo-config

Отредактируйте `screenshots/demo-config/init.lua` для:
- Добавления своих плагинов
- Изменения настроек Charleston
- Настройки keybindings

### Добавление своих файлов

Добавьте файлы в `screenshots/demo-project/` для демонстрации:
- Разных языков программирования
- Специфичных сценариев
- Ваших кейсов использования

## 🤝 Участие

Если вы создали отличные скриншоты Charleston:

1. Оптимизируйте размер (используйте PNG оптимизацию)
2. Назовите файлы описательно (`telescope-find-files.png`)
3. Создайте PR в основной репозиторий

## 📄 Лицензия

Часть Charleston colorscheme project. Та же лицензия.

---

**Нужна помощь?** Создайте issue в репозитории Charleston!
