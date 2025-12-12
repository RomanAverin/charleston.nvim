# План реализации кастомизации цветов для charleston.nvim

## Цель
Добавить возможность кастомизации цветов палитры и highlight групп, основываясь на best practices из популярных цветовых схем (catppuccin, tokyonight, gruvbox).

## Исследование популярных схем

### catppuccin/nvim
- `color_overrides` - переопределение цветов палитры (таблица с вложенными вариантами)
- `custom_highlights` / `highlight_overrides` - callbacks и таблицы для highlights

### tokyonight.nvim
- `on_colors` - callback для модификации палитры
- `on_highlights` - callback для модификации highlight групп

### gruvbox.nvim
- `palette_overrides` - простое переопределение цветов (таблица)
- `overrides` - переопределение highlight групп (таблица)

## Предлагаемый API

Комбинированный подход - и таблицы (для простоты), и callbacks (для гибкости):

```lua
require("charleston").setup({
  -- Существующие опции (совместимость)
  terminal_colors = true,
  italic = true,
  darker_background = false,
  transparent = false,

  -- НОВЫЕ опции

  -- 1. Переопределение палитры (таблица)
  palette_overrides = {
    red = "#ff0000",
    bg = "#000000",
    custom_color = "#abcdef", -- можно добавлять новые цвета
  },

  -- 2. Программная модификация палитры (callback)
  on_colors = function(colors)
    colors.comment = colors.faded_text
    return colors -- опционально
  end,

  -- 3. Переопределение highlights (таблица)
  highlight_overrides = {
    Comment = { fg = "#888888", italic = false },
    Normal = { bg = "NONE" },
  },

  -- 4. Программная модификация highlights (callback)
  on_highlights = function(highlights, colors)
    highlights.TelescopeNormal = { bg = colors.float_bg }
    return highlights -- опционально
  end,
})
```

### Дополнительная функция

```lua
-- Получить финальную палитру с учетом кастомизаций
local colors = require("charleston").get_palette()
```

## Архитектурное решение

### Проблема: кеширование с callbacks

**Проблема**: callbacks (функции) нельзя сериализовать для хеширования

**Решение**: при наличии callbacks (`on_colors` или `on_highlights`) пропускать кеш и применять напрямую через `theme.setup()`. Таблицы (`palette_overrides`, `highlight_overrides`) продолжают кешироваться.

### Порядок применения

```
1. Загрузка базовой палитры (colors.palette)
2. Применение palette_overrides (vim.tbl_deep_extend)
3. Вызов on_colors(palette)
4. Генерация highlights.get(palette, opts)
5. Применение highlight_overrides (vim.tbl_deep_extend)
6. Вызов on_highlights(highlights, palette)
7. Компиляция или прямое применение
```

### Логика кеширования

```lua
if has_callbacks then
  -- Пропустить кеш, применить напрямую
  theme.setup(opts)
else
  -- Использовать обычный путь с кешированием
  -- hash учитывает palette_overrides и highlight_overrides
end
```

## Файлы для модификации

### 1. Создать новый модуль customization
**Файл**: `lua/charleston/lib/customization.lua`

**Функции**:
- `apply_palette_customizations(base_palette, opts)` - применяет palette_overrides и on_colors
- `apply_highlight_customizations(base_highlights, palette, opts)` - применяет highlight_overrides и on_highlights
- `has_callbacks(opts)` - проверяет наличие callback функций

**Задачи**:
- Реализовать merge палитры с overrides
- Вызвать callback с валидацией
- Обработать случаи когда callback возвращает nil (мутация in-place)

### 2. Обновить init.lua
**Файл**: `lua/charleston/init.lua`

**Изменения в `defaults_opts`**:
```lua
M.defaults_opts = {
  terminal_colors = true,
  italic = true,
  darker_background = false,
  transparent = false,
  -- новые
  palette_overrides = {},
  on_colors = nil,
  highlight_overrides = {},
  on_highlights = nil,
}
```

**Изменения в `setup()`**:
- Добавить валидацию типов для новых опций
- Предупреждать если тип неверный

**Изменения в `load()`**:
- Проверить `has_callbacks(M.opts)` перед кешированием
- Если есть callbacks → пропустить кеш, вызвать `theme.setup(M.opts)` напрямую
- Если нет callbacks → использовать существующую логику с кешем
- После применения сохранить финальную палитру в `vim.g.palette`

**Новая функция `get_palette()`**:
```lua
function M.get_palette()
  local base_colors = require("charleston.colors")
  local customization = require("charleston.lib.customization")
  local opts = M.opts or M.defaults_opts
  return customization.apply_palette_customizations(base_colors.palette, opts)
end
```

**Обновление команды `CharlestonCompile`**:
- Добавить `package.loaded["charleston.lib.customization"] = nil`

### 3. Обновить compiler.lua
**Файл**: `lua/charleston/lib/compiler.lua`

**Изменения в `compile(opts)`**:
```lua
function M.compile(opts)
  local base_colors = require("charleston.colors")
  local customization = require("charleston.lib.customization")

  -- Применить кастомизации палитры
  local palette = customization.apply_palette_customizations(base_colors.palette, opts)

  -- Получить базовые highlights с кастомизированной палитрой
  local base_highlights = require("charleston.highlights").get(palette, opts)

  -- Применить кастомизации highlights
  local highlights = customization.apply_highlight_customizations(base_highlights, palette, opts)

  -- Остальная логика компиляции без изменений
  -- ...
end
```

### 4. Обновить theme.lua
**Файл**: `lua/charleston/theme.lua`

**Изменения в `setup(opts)`**:
```lua
function M.setup(opts)
  local base_colors = require("charleston.colors")
  local customization = require("charleston.lib.customization")

  -- Применить кастомизации палитры
  local palette = customization.apply_palette_customizations(base_colors.palette, opts)

  -- Получить базовые highlights с кастомизированной палитрой
  local base_highlights = require("charleston.highlights").get(palette, opts)

  -- Применить кастомизации highlights
  local highlights = customization.apply_highlight_customizations(base_highlights, palette, opts)

  require("charleston.lib.apply_highlights").apply(highlights)

  if opts.terminal_colors then
    M.apply_terminal_colors(palette)
  end
end
```

### 5. Обновить README.md
**Файл**: `README.md`

**Добавить секцию**:
- Примеры использования всех 4 опций
- Объяснение разницы между таблицами и callbacks
- Примечание о производительности (callbacks пропускают кеш)
- Пример с `get_palette()` для использования в других плагинах

## Обеспечение обратной совместимости

✅ Все существующие конфигурации продолжают работать без изменений:

```lua
-- Старая конфигурация
require("charleston").setup({
  terminal_colors = true,
  italic = false,
})
-- Работает как раньше, кеширование сохраняется
```

✅ Новые опции имеют безопасные дефолты (пустые таблицы / nil)

✅ Hash учитывает новые опции для корректной инвалидации кеша

## Примеры использования

### Пример 1: Простое переопределение
```lua
require("charleston").setup({
  palette_overrides = {
    red = "#ff0000",
    bg = "#000000",
  }
})
```

### Пример 2: Программная модификация
```lua
require("charleston").setup({
  on_colors = function(colors)
    -- Сделать фон чисто черным
    colors.bg = "#000000"
    colors.bg_dimmed = "#0a0a0a"
  end
})
```

### Пример 3: Кастомизация highlights для плагинов
```lua
require("charleston").setup({
  on_highlights = function(hl, colors)
    hl.TelescopeNormal = { bg = colors.float_bg }
    hl.TelescopeBorder = { fg = colors.cyan, bg = colors.float_bg }
  end
})
```

### Пример 4: Использование в других плагинах
```lua
require("charleston").setup({
  palette_overrides = {
    lualine_bg = "#2a2a2a",
  }
})

local colors = require("charleston").get_palette()

require("lualine").setup({
  options = {
    theme = {
      normal = {
        a = { bg = colors.blue, fg = colors.bg },
        b = { bg = colors.lualine_bg, fg = colors.text },
      }
    }
  }
})
```

## Производительность

| Конфигурация | Кеширование | Время загрузки |
|-------------|-------------|----------------|
| Без кастомизаций | ✅ | ~1-2ms |
| С palette_overrides | ✅ | ~1-2ms |
| С highlight_overrides | ✅ | ~1-2ms |
| С on_colors callback | ❌ | ~5-10ms |
| С on_highlights callback | ❌ | ~5-10ms |

**Вывод**: таблицы кешируются, callbacks нет (но дают максимальную гибкость)

## Порядок реализации

1. **Создать customization.lua** - новый модуль с логикой кастомизаций
2. **Обновить defaults_opts в init.lua** - добавить 4 новые опции
3. **Добавить валидацию в setup()** - проверка типов
4. **Модифицировать compiler.lua** - применить кастомизации перед компиляцией
5. **Модифицировать theme.lua** - применить кастомизации для прямого применения
6. **Обновить load() в init.lua** - логика обхода кеша для callbacks
7. **Добавить get_palette()** - публичный API для доступа к палитре
8. **Обновить CharlestonCompile** - очистка customization модуля
9. **Написать документацию в README.md** - примеры и объяснения

## Критические файлы

- **Новый**: `lua/charleston/lib/customization.lua` - модуль кастомизации
- **Изменить**: `lua/charleston/init.lua` - setup, load, get_palette, команда
- **Изменить**: `lua/charleston/lib/compiler.lua` - интеграция кастомизаций
- **Изменить**: `lua/charleston/theme.lua` - интеграция кастомизаций
- **Изменить**: `README.md` - документация

## Ссылки на исследование

**Sources:**
- [catppuccin/nvim GitHub](https://github.com/catppuccin/nvim) - color_overrides и highlight_overrides подходы
- [tokyonight.nvim GitHub](https://github.com/folke/tokyonight.nvim) - on_colors и on_highlights callbacks
- [gruvbox.nvim GitHub](https://github.com/ellisonleao/gruvbox.nvim) - palette_overrides паттерн
