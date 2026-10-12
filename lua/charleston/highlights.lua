local M = {}

---@param pallete Palette
---@return table
function M.get(pallete, opts)
  local color = pallete
  -- setup options
  color.bg = opts.darker_background and color.bg or color.bg_dimmed

  -- setup transparent backgrounds
  local bg = opts.transparent and "NONE" or color.bg
  local float_bg = color.float_bg -- always explicit background for float windows and messages
  local bar_bg = opts.transparent and "NONE" or color.bar_bg

  -- Semantic roles: one role = one color, the same one in every language.
  -- Color marks meaning, not the parser category. See README "Design philosophy".
  local syn = {
    keyword = color.magenta, -- every keyword: if/for/return/import/pub/static/try
    type = color.cyan, -- types, classes, structs, enums, traits, modules
    call = color.cyan, -- function and method calls -- the same family as types
    definition = color.white, -- a function or method name where it is introduced
    name = color.beige, -- variables, parameters, fields, properties, named constants
    value = color.orange, -- numbers, booleans, enum variants, escapes
    literal = color.green, -- strings, characters, raw text
    macro = color.orange, -- macros and attributes
    punctuation = color.silver, -- brackets, commas, semicolons, operators
    comment = color.faded_text, -- comments
  }

  local hl = {
    Normal = { fg = color.text, bg = bg }, -- Normal text
    Comment = { fg = syn.comment, italic = opts.italic == true }, -- Any comment
    Constant = { fg = syn.name }, -- (*) Any constant
    String = { fg = syn.literal }, --   A string constant: "this is a string"
    Character = { fg = syn.literal }, --   A character constant: 'c', '\n'
    Number = { fg = syn.value }, --   A number constant: 234, 0xff
    Boolean = { fg = syn.value }, --   A boolean constant: TRUE, false
    Float = { fg = syn.value }, --   A floating point constant: 2.3e10
    Identifier = { fg = syn.name }, -- (*) Any variable name
    Variable = { link = "Identifier" }, -- Variable name
    Function = { fg = syn.definition }, --   Function name (also: methods for classes)
    Statement = { fg = syn.keyword }, -- (*) Any statement
    Conditional = { fg = syn.keyword }, --   if, then, else, endif, switch, etc.
    Repeat = { fg = syn.keyword }, --   for, do, while, etc.
    Label = { fg = syn.keyword }, --   case, default, etc.
    Operator = { fg = syn.punctuation }, --   "sizeof", "+", "*", etc.
    Keyword = { fg = syn.keyword }, --   any other keyword
    Exception = { fg = syn.keyword }, --   try, catch, throw
    PreProc = { fg = syn.keyword }, -- (*) Generic Preprocessor
    Include = { fg = syn.keyword }, --   Preprocessor #include
    Define = { fg = syn.keyword }, --   Preprocessor #define
    Macro = { fg = syn.macro }, --   Macro invocation: vec!, format!
    PreCondit = { link = "Define" }, --   Preprocessor #if, #else, #endif, etc.
    Type = { fg = syn.type }, -- (*) int, long, char, etc.
    Typedef = { link = "Type" }, --   A typedef
    StorageClass = { fg = syn.keyword }, --   static, register, volatile, etc.
    Structure = { fg = syn.type }, --   struct, union, enum, etc.
    Special = { fg = syn.value }, -- (*) Any special symbol
    SpecialChar = { fg = syn.value }, -- Special character in a constant
    Tag = { fg = syn.type, underline = true }, --   You can use CTRL-] on this
    Delimiter = { fg = syn.punctuation }, --   Character that needs attention
    SpecialComment = { fg = syn.comment }, --   Special things inside a comment (e.g. '\n')
    Debug = { fg = color.orange, bold = true }, --   Debugging statements

    Underlined = { bg = float_bg, underline = true }, -- Text that stands out, HTML links
    Ignore = { fg = color.faded_text }, -- Left blank, hidden |hl-Ignore| (NOTE May be invisible here in template)
    Error = { fg = color.red }, -- Any erroneous construct
    Todo = { fg = color.blue, bg = color.medium_background, bold = true }, -- Anything that needs extra attention; mostly the keywords TODO FIXME and XXX
    Added = { fg = color.green }, -- Added line in a diff
    Changed = { fg = color.blue }, -- Changed line in a diff
    Removed = { fg = color.red }, -- Removed line in a diff

    Conceal = { fg = color.faded_text }, -- Placeholder characters substituted for concealed text (see 'conceallevel')
    Cursor = { reverse = true }, -- Character under the cursor
    lCursor = { link = "Cursor" }, -- Character under the cursor when |language-mapping| is used (see 'guicursor')
    CursorIM = { link = "Cursor" }, -- Like Cursor, but used when in IME mode |CursorIM|
    CursorColumn = { bg = color.bar_bg }, -- Screen-column at the cursor, when 'cursorcolumn' is set.
    CursorLine = { bg = color.lighter_gray }, -- Screen-line at the cursor, when 'cursorline' is set. Low-priority if foreground (ctermfg OR guifg) is not set.
    IblIndent = { fg = color.thin_line },
    IblScope = { fg = color.white },
    VirtColumn = { fg = color.thin_line },
    ColorColumn = { bg = color.thin_line }, -- Columns set with 'colorcolumn'
    Directory = { fg = color.text }, -- Directory names (and other special names in listings)
    EndOfBuffer = { fg = color.faded_text, bg = bg }, -- Filler lines ~ after the end of the buffer. By default, this is highlighted like |hl-NonText|.
    TermCursor = { reverse = true }, -- Cursor in a focused terminal
    TermCursorNC = { link = "TermCursor" }, -- Cursor in an unfocused terminal
    ErrorMsg = { fg = color.red }, -- Error messages on the command line
    Folded = { fg = color.bg, bg = color.charcoal }, -- Line used for closed folds
    FoldColumn = { fg = color.charcoal }, -- 'foldcolumn'
    SignColumn = { fg = color.text }, -- Column where |signs| are displayed
    IncSearch = { fg = color.bg, bg = color.orange, bold = true }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
    Substitute = { fg = color.bg, bg = color.purple }, -- |:substitute| replacement text highlighting
    LineNr = { fg = color.strong_faded_text }, -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
    LineNrAbove = { fg = color.strong_faded_text }, -- Line number for when the 'relativenumber' option is set, above the cursor line
    LineNrBelow = { fg = color.strong_faded_text }, -- Line number for when the 'relativenumber' option is set, below the cursor line
    CursorLineNr = { fg = color.silver, bold = true }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
    CursorLineFold = { link = "FoldColumn" }, -- Like FoldColumn when 'cursorline' is set for the cursor line
    CursorLineSign = { link = "SignColumn" }, -- Like SignColumn when 'cursorline' is set for the cursor line
    MatchParen = { fg = color.white, bold = true, underline = true }, -- Character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
    MsgArea = { fg = color.silver, bg = float_bg }, -- Area for messages and cmdline
    ModeMsg = { link = "MsgArea" }, -- 'showmode' message (e.g., "-- INSERT -- ")
    MsgSeparator = { link = "MsgArea" }, -- Separator for scrolled messages, `msgsep` flag of 'display'
    MoreMsg = { fg = color.silver, bg = float_bg }, -- |more-prompt|
    OkMsg = { fg = color.green, bold = true }, -- Success messages
    StdoutMsg = { fg = color.text }, -- Messages in stdout from shell commands
    StderrMsg = { fg = color.red }, -- Messages in stderr from shell commands
    NonText = { fg = color.strong_faded_text }, -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
    NormalFloat = { fg = color.text, bg = color.float_bg }, -- Normal text in floating windows.
    FloatBorder = { fg = color.thick_line, bg = color.float_bg },
    NormalNC = { fg = color.text, bg = bg }, -- normal text in non-current windows
    Pmenu = { fg = color.text, bg = color.float_bg }, -- Popup menu: Normal item.
    PmenuSel = { fg = color.white, bg = color.medium_background, bold = true }, -- Popup menu: Selected item.
    PmenuKind = { fg = color.cyan, bg = color.float_bg }, -- Popup menu: Normal item "kind".
    PmenuKindSel = { fg = color.cyan, bg = color.medium_background, bold = true }, -- Popup menu: Selected item "kind".
    PmenuExtra = { fg = color.faded_text, bg = color.float_bg }, -- Popup menu: Normal item "extra text".
    PmenuExtraSel = { fg = color.faded_text, bg = color.medium_background }, -- Popup menu: Selected item "extra text".
    PmenuSbar = { bg = color.strong_faded_text }, -- Popup menu: Scrollbar.
    PmenuThumb = { bg = color.silver }, -- Popup menu: Thumb of the scrollbar.
    PmenuMatch = { fg = color.orange, bg = color.float_bg, bold = true }, -- Popup menu: Matched text in normal item. Combined with |hl-Pmenu|.
    PmenuMatchSel = { fg = color.orange, bg = color.medium_background, bold = true }, -- Popup menu: Matched text in selected item. Combined with |hl-PmenuMatch| and |hl-PmenuSel|.
    PmenuBorder = { fg = color.thick_line, bg = color.float_bg }, -- Popup menu: border of popup menu.
    PmenuShadow = { bg = color.bg }, -- Popup menu: blended areas when 'pumborder' is "shadow".
    PmenuShadowThrough = { bg = "NONE" }, -- Popup menu: shadow corners when 'pumborder' is "shadow".
    ComplMatchIns = { fg = color.orange, bold = true }, -- Matched text of the currently inserted completion.
    PreInsert = { fg = color.faded_text, italic = opts.italic == true }, -- Text inserted when "preinsert" is in 'completeopt'.
    ComplHint = { fg = color.faded_text, italic = opts.italic == true }, -- Virtual text of the currently selected completion.
    ComplHintMore = { fg = color.silver }, -- The additional information of the virtual text.
    SnippetTabstop = { fg = color.text, bg = color.medium_background }, -- Tabstops in snippets. |vim.snippet|
    SnippetTabstopActive = { fg = color.cyan, bg = color.medium_background, bold = true }, -- The currently active tabstop. |vim.snippet|
    Question = { fg = color.silver }, -- |hit-enter| prompt and yes/no questions
    QuickFixLine = { bg = color.lighter_gray, bold = true }, -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
    Search = { fg = color.bg, bg = color.cyan }, -- Last search pattern highlighting (see 'hlsearch'). Also used for similar items that need to stand out.
    CurSearch = { fg = color.bg, bg = color.yellow, bold = true }, -- Current match for the last search pattern (see 'hlsearch'). Note: This is correct after a search, but may get outdated if changes are made or the screen is redrawn.
    Scrollbar = { fg = bar_bg }, -- Current background and foreground of the main window's scrollbars
    SpecialKey = { fg = color.faded_text }, -- Unprintable characters: text displayed differently from what it really is. But not 'listchars' whitespace. |hl-Whitespace|
    SpellBad = { sp = color.red, undercurl = true }, -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
    SpellCap = { sp = color.yellow, undercurl = true }, -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
    SpellLocal = { sp = color.blue, undercurl = true }, -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
    SpellRare = { sp = color.teal, undercurl = true }, -- Word that is recognized by the spellchecker as one that is hardly ever used. |spell| Combined with the highlighting used otherwise.
    StatusLine = { bg = bar_bg }, -- Status line of current window
    StatusLineNC = { bg = bar_bg }, -- Status lines of not-current windows. Note: If this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
    StatusLineTerm = { link = "StatusLine" }, -- Status line of terminal window
    StatusLineTermNC = { link = "StatusLineNC" }, -- Status line of non-current terminal window
    StatusBarSegmentNormal = { fg = color.bar_text, bg = bar_bg },
    StatusBarSegmentFaded = { fg = color.bar_faded_text, bg = bar_bg },
    StatusBarDiagnosticError = { fg = color.red, bg = bar_bg },
    StatusBarDiagnosticWarn = { fg = color.yellow, bg = bar_bg },
    StatusBarDiagnosticInfo = { fg = color.blue, bg = bar_bg },
    StatusBarDiagnosticHint = { fg = color.silver, bg = bar_bg },
    FloatTitle = { fg = color.bg, bg = color.yellow, bold = true },
    FloatFooter = { fg = color.bg, bg = color.charcoal }, -- Footer of floating windows
    FloatShadow = { bg = color.bg }, -- Shadow area for floating windows (blurred areas when border is "shadow")
    FloatShadowThrough = { bg = "NONE" }, -- Shadow corners for floating windows (transparent)
    IndentBlanklineChar = { fg = color.thin_line },
    IndentBlanklineContextChar = { fg = color.thin_line },
    TodoComment = { fg = color.blue, bold = true },
    FixmeComment = { fg = color.red, bold = true },
    HackComment = { fg = color.yellow, bold = true },
    PriorityComment = { fg = color.orange, bold = true },
    MiniStarterSection = { fg = color.text, bg = bg, bold = true },
    MiniStarterFooter = { link = "Comment" },
    ZenBg = { fg = color.text, bg = bg },
    WinShiftMove = { bg = bg },
    TabsVsSpaces = { fg = color.faded_text, underline = true },
    FlashCurrent = { fg = color.bg, bg = color.green, bold = true },
    FlashMatch = { fg = color.bg, bg = color.cyan },
    FlashLabel = { fg = color.bg, bg = color.purple, bold = true },
    FlashPrompt = { bg = bar_bg },
    FlashPromptIcon = { bg = bar_bg },
    MiniCursorword = { bg = bg },
    NvimSurroundHighlight = { fg = color.bg, bg = color.cyan },

    TabLine = { bg = bar_bg }, -- Tab pages line, not active tab page label
    TabLineFill = { bg = bar_bg }, -- Tab pages line, where there are no labels
    TabLineSel = { fg = color.magenta, bg = bar_bg }, -- Tab pages line, active tab page label
    Title = { fg = color.magenta, bold = true }, -- Titles for output from ":set all", ":autocmd" etc.

    -- NB!: VertSplit is dynamic. See functions below.
    VertSplit = { fg = color.white }, -- Vertical split line
    Visual = { bg = color.lighter_gray }, -- Visual mode selection
    VisualNOS = { link = "Visual" }, -- Visual mode selection when vim is "Not Owning the Selection".
    WarningMsg = { fg = color.yellow }, -- Warning messages
    Whitespace = { fg = color.faded_text }, -- "nbsp", "space", "tab" and "trail" in 'listchars'
    WinSeparator = { link = "VertSplit" }, -- Separator between window splits. Inherts from |hl-VertSplit| by default, which it will replace eventually.
    WildMenu = { fg = color.white, bg = color.medium_background }, -- Current match in 'wildmenu' completion
    Winbar = { bg = bar_bg },
    WinbarNC = { bg = bar_bg },

    --
    -- Tree-sitter syntax groups.
    --
    -- One role = one color, identical in every language. There are no
    -- language-specific rules except for Vim commands used by Noice: the same
    -- meaning must not look different just because the file is Rust instead of Python.
    --
    -- Literals
    ["@string"] = { link = "String" },
    ["@string.regexp"] = { fg = syn.literal },
    ["@string.escape"] = { fg = syn.value },
    ["@string.special"] = { fg = syn.value },
    ["@character"] = { link = "Character" },
    ["@character.special"] = { fg = syn.value },
    ["@number"] = { link = "Number" },
    ["@number.float"] = { link = "Float" },
    ["@boolean"] = { link = "Boolean" },
    ["@constant.builtin"] = { fg = syn.value },
    ["@constructor"] = { fg = syn.value }, -- Ok(), Some(), and table constructors

    -- Names that hold data
    ["@variable"] = { fg = syn.name },
    ["@variable.builtin"] = { fg = syn.name },
    ["@variable.member"] = { fg = syn.name },
    ["@variable.parameter"] = { fg = syn.name },
    ["@property"] = { fg = syn.name },
    ["@field"] = { fg = syn.name },
    ["@constant"] = { link = "Constant" },
    ["@constant.macro"] = { fg = syn.name },
    ["@label"] = { fg = syn.name },
    ["@tag.attribute"] = { fg = syn.name },

    -- Definitions stand out; calls share the type family
    ["@function"] = { fg = syn.definition },
    ["@function.method"] = { fg = syn.definition },
    ["@function.call"] = { fg = syn.call },
    ["@function.method.call"] = { fg = syn.call },
    ["@function.builtin"] = { fg = syn.call },
    ["@method"] = { fg = syn.definition }, -- Legacy Tree-sitter method captures
    ["@method.call"] = { fg = syn.call },

    -- Types and modules
    ["@type"] = { fg = syn.type },
    ["@type.builtin"] = { fg = syn.type },
    ["@type.definition"] = { fg = syn.type },
    ["@module"] = { fg = syn.type },
    ["@tag"] = { fg = syn.type },
    ["@structure"] = { link = "Structure" },

    -- Keywords: every one of them, in a single accent
    ["@keyword"] = { fg = syn.keyword },
    ["@include"] = { link = "Include" },

    -- Macros and attributes
    ["@attribute"] = { fg = syn.macro },
    ["@macro"] = { link = "Macro" },
    ["@function.macro"] = { link = "Macro" },
    ["@function.macro.vim"] = { fg = color.yellow }, -- Vim commands, including Noice command input

    -- Syntax noise: quiet, so that names and literals stay in front
    ["@operator"] = { fg = syn.punctuation },
    ["@punctuation.delimiter"] = { fg = syn.punctuation },
    ["@punctuation.bracket"] = { fg = syn.punctuation },
    ["@punctuation.special"] = { fg = syn.punctuation },
    ["@tag.delimiter"] = { fg = syn.punctuation },

    -- Comments: the attention markers keep their signal colors
    ["@comment"] = { link = "Comment" },
    ["@comment.hint"] = { fg = color.silver },
    ["@comment.info"] = { fg = color.blue },
    ["@comment.note"] = { fg = color.blue },
    ["@comment.todo"] = { fg = color.blue },
    ["@comment.warning"] = { fg = color.yellow },
    ["@comment.error"] = { fg = color.red },

    -- Markup
    ["@markup"] = { fg = color.text },
    ["@markup.heading"] = { fg = syn.name, bold = true },
    ["@markup.strong"] = { bold = true },
    ["@markup.italic"] = { italic = true },
    ["@markup.strikethrough"] = { strikethrough = true },
    ["@markup.raw"] = { fg = syn.literal },
    ["@markup.link"] = { fg = syn.definition },
    ["@markup.link.url"] = { fg = syn.definition, underline = true },
    ["@markup.list"] = { fg = syn.punctuation },
    ["@markup.quote"] = { fg = syn.comment },

    -- Diff
    ["@diff.plus"] = { fg = color.green },
    ["@diff.minus"] = { fg = color.red },
    ["@diff.delta"] = { fg = color.blue },

    --
    -- LSP semantic tokens.
    --
    -- These win over tree-sitter, so every role is spelled out. Left to the
    -- default links (@lsp.type.function -> Function) the server would paint call
    -- sites with the definition color again, per language.
    --
    ["@lsp.type.variable"] = { fg = syn.name },
    ["@lsp.type.property"] = { fg = syn.name },
    ["@lsp.type.parameter"] = { fg = syn.name },
    ["@lsp.type.function"] = { fg = syn.call },
    ["@lsp.type.method"] = { fg = syn.call },
    ["@lsp.type.namespace"] = { fg = syn.type },
    ["@lsp.type.class"] = { fg = syn.type },
    ["@lsp.type.struct"] = { fg = syn.type },
    ["@lsp.type.interface"] = { fg = syn.type },
    ["@lsp.type.enum"] = { fg = syn.type },
    ["@lsp.type.type"] = { fg = syn.type },
    ["@lsp.type.typeParameter"] = { fg = syn.type },
    ["@lsp.type.enumMember"] = { fg = syn.value },
    ["@lsp.type.keyword"] = { fg = syn.keyword },
    ["@lsp.type.macro"] = { fg = syn.macro },
    ["@lsp.type.operator"] = { fg = syn.punctuation },
    ["@lsp.typemod.function.declaration"] = { fg = syn.definition },
    ["@lsp.typemod.method.declaration"] = { fg = syn.definition },
    ["@lsp.typemod.function.definition"] = { fg = syn.definition },
    ["@lsp.typemod.method.definition"] = { fg = syn.definition },
    ["@lsp.mod.deprecated"] = { strikethrough = true },

    -- Legacy markdown syntax, for buffers without a tree-sitter parser
    markdownCode = { fg = syn.literal },
    markdownCodeBlock = { fg = syn.literal },
    markdownLinkText = { fg = syn.definition, underline = true },

    --
    -- Bufferline
    --
    BufferlineBackground = { fg = color.bar_faded_text, bg = bar_bg },
    BufferlineBufferVisible = { fg = color.bar_text, bg = bar_bg },
    BufferlineBufferSelected = { fg = color.white, bold = true, bg = "NONE" },
    BufferlineFill = { bg = bar_bg },
    -- tabs
    BufferlineTab = { bg = bar_bg },
    BufferlineTabSelected = { fg = color.white, bg = "NONE" },
    BufferlineTabSeparator = { fg = color.bg, bg = bar_bg },
    BufferlineTabSeparatorVisible = { fg = color.bg, bg = bar_bg },
    BufferlineTabSeparatorSelected = { fg = color.bg, bg = "NONE" },

    BufferlineTabClose = { fg = color.red, bg = bar_bg },
    BufferlineIndicatorVisible = { fg = color.magenta, bg = bar_bg },
    BufferlineIndicatorSelected = { fg = color.magenta, bg = "NONE" },
    -- separators
    BufferlineSeparator = { fg = color.bg, bg = bar_bg },
    BufferlineSeparatorVisible = { fg = color.bg, bg = bar_bg },
    BufferlineSeparatorSelected = { fg = color.bg, bg = "NONE" },
    BufferlineOffsetSeparator = { fg = color.bg, bg = bar_bg },

    BufferlineModified = { fg = color.cyan, bg = bar_bg },
    BufferlineModifiedVisible = { fg = color.cyan, bg = bar_bg },
    BufferlineModifiedSelected = { fg = color.cyan, bg = "NONE" },
    BufferlineDuplicate = { fg = color.faded_text, bg = bar_bg },
    BufferlineDuplicateVisible = { fg = color.faded_text, bg = bar_bg },
    BufferlineDuplicateSelected = { fg = color.text, bg = "NONE" },
    BufferlineCloseButton = { fg = color.faded_text, bg = bar_bg },
    BufferlineCloseButtonVisible = { fg = color.faded_text, bg = bar_bg },
    BufferlineCloseButtonSelected = { fg = color.red, bg = "NONE" },
    -- Numbers
    BufferlineNumbers = { fg = color.bar_faded_text, bg = bar_bg },
    BufferlineNumbersVisible = { fg = color.bar_text, bg = bar_bg },
    BufferlineNumbersSelected = { fg = color.white, bold = true, bg = "NONE" },
    -- Diagnostic states
    BufferlineDiagnostic = { fg = color.text, bg = bar_bg },
    BufferlineDiagnosticVisible = { fg = color.text, bg = bar_bg },
    BufferlineDiagnosticSelected = { fg = color.text, bg = "NONE" },
    -- Error
    BufferlineError = { fg = color.red, bg = bar_bg },
    BufferlineErrorVisible = { fg = color.red, bg = bar_bg },
    BufferlineErrorSelected = { fg = color.white, bg = "NONE", bold = true },
    BufferlineErrorDiagnostic = { fg = color.red, bg = bar_bg },
    BufferlineErrorDiagnosticVisible = { fg = color.red, bg = bar_bg },
    BufferlineErrorDiagnosticSelected = { fg = color.red, bg = "NONE" },
    -- Warning
    BufferlineWarning = { fg = color.yellow, bg = bar_bg },
    BufferlineWarningVisible = { fg = color.yellow, bg = bar_bg },
    BufferlineWarningSelected = { fg = color.white, bg = "NONE", bold = true },
    BufferlineWarningDiagnostic = { fg = color.yellow, bg = bar_bg },
    BufferlineWarningDiagnosticVisible = { fg = color.yellow, bg = bar_bg },
    BufferlineWarningDiagnosticSelected = { fg = color.yellow, bg = "NONE" },
    -- Info
    BufferlineInfo = { fg = color.blue, bg = bar_bg },
    BufferlineInfoVisible = { fg = color.blue, bg = bar_bg },
    BufferlineInfoSelected = { fg = color.white, bg = "NONE", bold = true },
    BufferlineInfoDiagnostic = { fg = color.blue, bg = bar_bg },
    BufferlineInfoDiagnosticVisible = { fg = color.blue, bg = bar_bg },
    BufferlineInfoDiagnosticSelected = { fg = color.blue, bg = "NONE" },
    -- Hint
    BufferlineHint = { fg = color.silver, bg = bar_bg },
    BufferlineHintVisible = { fg = color.silver, bg = bar_bg },
    BufferlineHintSelected = { fg = color.white, bg = "NONE", bold = true },
    BufferlineHintDiagnostic = { fg = color.silver, bg = bar_bg },
    BufferlineHintDiagnosticVisible = { fg = color.silver, bg = bar_bg },
    BufferlineHintDiagnosticSelected = { fg = color.silver, bg = "NONE" },
    -- Pick state
    BufferlinePick = { fg = color.orange, bg = bar_bg, bold = true },
    BufferlinePickVisible = { fg = color.orange, bg = bar_bg, bold = true },
    BufferlinePickSelected = { fg = color.orange, bold = true, bg = "NONE" },
    -- Trunc marker
    BufferlineTruncMarker = { fg = color.bar_faded_text, bg = bar_bg },

    --
    -- Render-markdown.nvim
    --
    RenderMarkdownH1 = { fg = color.white, bold = true },
    RenderMarkdownH2 = { fg = color.silver, bold = true },
    RenderMarkdownH3 = { fg = color.silver },
    RenderMarkdownH4 = { fg = color.text, bold = true },
    RenderMarkdownH5 = { fg = color.text },
    RenderMarkdownH6 = { fg = color.strong_text },
    RenderMarkdownH1Bg = { bg = bg },
    RenderMarkdownH2Bg = { link = "RenderMarkdownH1Bg" },
    RenderMarkdownH3Bg = { link = "RenderMarkdownH1Bg" },
    RenderMarkdownH4Bg = { link = "RenderMarkdownH1Bg" },
    RenderMarkdownH5Bg = { link = "RenderMarkdownH1Bg" },
    RenderMarkdownH6Bg = { link = "RenderMarkdownH1Bg" },
    RenderMarkdownCode = { fg = color.green, bg = float_bg },
    RenderMarkdownCodeInline = { fg = color.faded_text, bg = float_bg },
    RenderMarkdownInlineHighlight = { fg = color.faded_text, bg = float_bg },
    RenderMarkdownBullet = { fg = color.silver },
    RenderMarkdownTableHead = { fg = color.blue },
    RenderMarkdownTableRow = { fg = color.text },
    RenderMarkdownSuccess = { fg = color.green },
    RenderMarkdownInfo = { fg = color.silver },
    RenderMarkdownHint = { fg = color.teal },
    RenderMarkdownWarn = { fg = color.yellow },
    RenderMarkdownError = { fg = color.red },

    --
    -- Snacks.nvim
    --
    SnacksIndentBlank = { fg = color.medium_gray },
    SnacksIndentScope = { fg = color.medium_gray },
    SnacksIndentChunk = { fg = color.medium_gray },
    SnacksDashboardDesc = { fg = color.white },
    SnacksDashboardDir = { fg = color.cyan },
    SnacksDashboardHeader = { fg = color.cyan },
    SnacksDashboardIcon = { fg = color.cyan },
    SnacksDashboardFile = { fg = color.cyan },
    SnacksDashboardSpecial = { fg = color.cyan },
    SnacksDashboardKey = { fg = color.cyan },
    -- Snacks.nvim Picker
    SnacksPicker = { bg = color.float_bg },
    SnacksPickerBorder = { fg = color.faded_text, bg = color.float_bg },
    SnacksPickerMatch = { fg = color.orange, bold = true },
    SnacksPickerList = { bg = color.float_bg },
    SnacksPickerListBorder = { fg = color.faded_text, bg = color.float_bg },
    SnacksPickerListCursorLine = { bg = bg },
    SnacksPickerPrompt = { fg = color.white },
    SnacksPickerInput = { fg = color.white, bg = color.float_bg },
    SnacksPickerInputBorder = { fg = color.faded_text, bg = color.float_bg },
    SnacksPickerInputSearch = { fg = color.orange, bold = true },
    SnacksPickerFile = { fg = color.text },
    SnacksPickerDir = { fg = color.cyan },
    SnacksPickerPathHidden = { fg = color.faded_text },
    SnacksPickerPathIgnored = { fg = color.bar_faded_text },
    SnacksPickerIcon = { fg = color.faded_text },
    SnacksPickerIconFile = { fg = color.faded_text },
    SnacksPickerIconDir = { fg = color.cyan },
    SnacksPickerGitStatusModified = { fg = color.blue },
    SnacksPickerGitStatusAdded = { fg = color.green },
    SnacksPickerGitStatusDeleted = { fg = color.red },
    SnacksPickerGitStatusUntracked = { fg = color.bar_faded_text },
    SnacksPickerPreview = { bg = color.float_bg },
    SnacksPickerPreviewBorder = { fg = color.faded_text, bg = color.float_bg },
    SnacksPickerPreviewTitle = { link = "FloatTitle" },
    -- Snacks.nvim Notifier
    SnacksNotifierInfo = { fg = color.white, bg = bg, blend = 0 },
    SnacksNotifierWarn = { fg = color.white, bg = bg, blend = 0 },
    SnacksNotifierError = { fg = color.white, bg = bg, blend = 0 },
    SnacksNotifierDebug = { fg = color.white, bg = bg, blend = 0 },
    SnacksNotifierTrace = { fg = color.white, bg = bg, blend = 0 },
    SnacksNotifierBorderInfo = { fg = color.faded_text, bg = bg, blend = 0 },
    SnacksNotifierBorderWarn = { fg = color.faded_text, bg = bg, blend = 0 },
    SnacksNotifierBorderError = { fg = color.faded_text, bg = bg, blend = 0 },
    SnacksNotifierBorderDebug = { fg = color.faded_text, bg = bg, blend = 0 },
    SnacksNotifierBorderTrace = { fg = color.faded_text, bg = bg, blend = 0 },
    SnacksNotifierIconInfo = { fg = color.blue, bg = bg, blend = 0 },
    SnacksNotifierIconWarn = { fg = color.yellow, bg = bg, blend = 0 },
    SnacksNotifierIconError = { fg = color.red, bg = bg, blend = 0 },
    SnacksNotifierIconDebug = { fg = color.silver, bg = bg, blend = 0 },
    SnacksNotifierIconTrace = { fg = color.magenta, bg = bg, blend = 0 },
    SnacksNotifierTitleInfo = { fg = color.blue, bg = bg, blend = 0 },
    SnacksNotifierTitleWarn = { fg = color.yellow, bg = bg, blend = 0 },
    SnacksNotifierTitleError = { fg = color.red, bg = bg, blend = 0 },
    SnacksNotifierTitleDebug = { fg = color.white, bg = bg, blend = 0 },
    SnacksNotifierTitleTrace = { fg = color.white, bg = bg, blend = 0 },
    SnacksNotifierFooterInfo = { fg = color.faded_text, bg = bg, blend = 0 },
    SnacksNotifierFooterWarn = { fg = color.faded_text, bg = bg, blend = 0 },
    SnacksNotifierFooterError = { fg = color.faded_text, bg = bg, blend = 0 },
    SnacksNotifierFooterDebug = { fg = color.faded_text, bg = bg, blend = 0 },
    SnacksNotifierFooterTrace = { fg = color.faded_text, bg = bg, blend = 0 },
    SnacksNotifierHistory = { fg = color.text, bg = float_bg },
    SnacksNotifierHistoryTitle = { link = "FloatTitle" },
    SnacksNotifierHistoryDateTime = { fg = color.faded_text },
    SnacksNotifierMinimal = { fg = color.white, bg = bg, blend = 0 },
    --
    -- Noice.nvim
    --
    NoiceCmdline = { fg = color.white }, -- Search prompt
    NoiceCmdlinePopup = { fg = color.white, bg = bg },
    NoiceCmdlinePopupBorder = { fg = color.faded_text }, -- Cmd window boarder
    NoiceCmdlinePopupTitle = { fg = color.white },
    NoiceCmdlineIcon = { fg = color.white }, -- Prompt begin icon
    NoiceCmdlineIconCalculator = { fg = color.blue },
    NoiceCmdlineIconCmdLine = { fg = color.white },
    NoiceCmdlineIconFilter = { fg = color.magenta },
    NoiceCmdlineIconHelp = { fg = color.cyan },
    NoiceCmdlineIconInput = { fg = color.cyan },
    NoiceCmdlineIconLua = { fg = color.blue },
    NoiceCmdlineIconSearch = { fg = color.yellow },
    NoiceConfirmBorder = { fg = color.blue },

    --
    -- Blink.Cmp
    --
    BlinkCmpMenu = { bg = color.bar_bg, fg = color.bar_text },
    BlinkCmpLabel = { bg = color.bar_bg, fg = color.cyan },
    BlinkCmpLabelDeprecated = { link = "BlinkCmpLabel" },
    BlinkCmpSource = { fg = color.teal },
    BlinkCmpMenuSelection = { bg = color.strong_faded_text },
    BlinkCmpLabelMatch = { fg = color.yellow },
    BlinkCmpGhostText = { fg = color.bar_faded_text },
    BlinkCmpKind = { fg = color.bar_text },
    BlinkCmpKindDefaul = { fg = color.bar_text },
    BlinkCmpKindArray = { link = "BlinkCmpKindText" },
    BlinkCmpKindBoolean = { link = "BlinkCmpKindText" },
    BlinkCmpKindClass = { link = "BlinkCmpKindText" },
    BlinkCmpKindColor = { link = "BlinkCmpKindText" },
    BlinkCmpKindConstant = { link = "BlinkCmpKindText" },
    BlinkCmpKindConstructor = { link = "BlinkCmpKindText" },
    BlinkCmpKindEnum = { link = "BlinkCmpKindText" },
    BlinkCmpKindEnumMember = { link = "BlinkCmpKindText" },
    BlinkCmpKindEvent = { link = "BlinkCmpKindText" },
    BlinkCmpKindField = { link = "BlinkCmpKindText" },
    BlinkCmpKindFile = { link = "BlinkCmpKindText" },
    BlinkCmpKindFolder = { link = "BlinkCmpKindText" },
    BlinkCmpKindFunction = { link = "BlinkCmpKindText" },
    BlinkCmpKindIdentifier = { link = "BlinkCmpKindText" },
    BlinkCmpKindInterface = { link = "BlinkCmpKindText" },
    BlinkCmpKindKey = { link = "BlinkCmpKindText" },
    BlinkCmpKindKeyword = { link = "BlinkCmpKindText" },
    BlinkCmpKindMethod = { link = "BlinkCmpKindText" },
    BlinkCmpKindModule = { link = "BlinkCmpKindText" },
    BlinkCmpKindNumber = { link = "BlinkCmpKindText" },
    BlinkCmpKindObject = { link = "BlinkCmpKindText" },
    BlinkCmpKindOperator = { link = "BlinkCmpKindText" },
    BlinkCmpKindPackage = { link = "BlinkCmpKindText" },
    BlinkCmpKindProperty = { link = "BlinkCmpKindText" },
    BlinkCmpKindReference = { link = "BlinkCmpKindText" },
    BlinkCmpKindSnippet = { link = "BlinkCmpKindText" },
    BlinkCmpKindStruct = { link = "BlinkCmpKindText" },
    BlinkCmpKindText = { fg = color.bar_text },
    BlinkCmpKindTypeParameter = { link = "BlinkCmpKindText" },
    BlinkCmpKindUnit = { link = "BlinkCmpKindText" },
    BlinkCmpKindValue = { link = "BlinkCmpKindText" },
    BlinkCmpKindVariable = { link = "BlinkCmpKindText" },

    --
    -- Mason
    --
    MasonNormal = { fg = color.text, bg = color.float_bg },
    MasonHeader = { fg = color.bg, bg = color.yellow, bold = true },
    MasonHeaderSecondary = { fg = color.bg, bg = color.cyan, bold = true },
    MasonHighlight = { fg = color.cyan },
    MasonHighlightBlock = { fg = color.bg, bg = color.cyan },
    MasonHighlightBlockBold = { fg = color.bg, bg = color.magenta, bold = true },
    MasonHighlightSecondary = { fg = color.magenta },
    MasonHighlightBlockSecondary = { fg = color.bg, bg = color.magenta },
    MasonHighlightBlockBoldSecondary = { fg = color.bg, bg = color.magenta, bold = true },
    MasonMuted = { fg = color.faded_text },
    MasonMutedBlock = { fg = color.cyan, bg = color.medium_background },
    MasonMutedBlockBold = { fg = color.faded_text, bg = color.medium_background, bold = true },
    MasonLink = { fg = color.cyan, underline = true },
    MasonError = { fg = color.red },
    MasonWarning = { fg = color.yellow },
    MasonHeading = { fg = color.magenta, bold = true },

    --
    -- Lazy.nvim
    --
    LazyNormal = { fg = color.text, bg = color.float_bg },
    LazyButton = { fg = color.cyan, bg = color.medium_background },
    LazyButtonActive = { fg = color.bg, bg = color.magenta, bold = true },
    LazyH1 = { fg = color.bg, bg = color.magenta, bold = true },
    LazyH2 = { fg = color.magenta, bold = true },
    LazyComment = { fg = color.faded_text },
    LazyCommit = { fg = color.faded_text },
    LazyCommitIssue = { fg = color.orange },
    LazyCommitScope = { fg = color.cyan, italic = true },
    LazyCommitType = { fg = color.cyan },
    LazyDimmed = { fg = color.faded_text },
    LazyDir = { fg = color.cyan },
    LazyError = { fg = color.red },
    LazyInfo = { fg = color.cyan },
    LazyBold = { bold = true },
    LazyItalic = { italic = true },
    LazyLocal = { fg = color.orange },
    LazyNoCond = { fg = color.yellow },
    LazyProgressDone = { fg = color.green },
    LazyProgressTodo = { fg = color.faded_text },
    LazyProp = { fg = color.faded_text },
    LazyReasonCmd = { fg = color.magenta },
    LazyReasonEvent = { fg = color.magenta },
    LazyReasonFt = { fg = color.cyan },
    LazyReasonImport = { fg = color.cyan },
    LazyReasonKeys = { fg = color.magenta },
    LazyReasonPlugin = { fg = color.cyan },
    LazyReasonRequire = { fg = color.cyan },
    LazyReasonRuntime = { fg = color.orange },
    LazyReasonSource = { fg = color.cyan },
    LazyReasonStart = { fg = color.green },
    LazySpecial = { fg = color.yellow },
    LazyTaskOutput = { fg = color.text },
    LazyUrl = { fg = color.cyan, underline = true },
    LazyValue = { fg = color.green },
    LazyWarning = { fg = color.yellow },

    --
    -- Git
    --
    GitAdded = { fg = color.green },
    GitChanged = { fg = color.blue },
    GitDeleted = { fg = color.red },

    diffAdded = { link = "GitAdded" },
    diffChanged = { link = "GitChanged" },
    diffDeleted = { link = "GitDeleted" },

    DiffAdd = { fg = color.green, bg = color.diff_add_bg }, -- Diff mode: Added line |diff.txt|
    DiffChange = { fg = color.blue, bg = color.bg_dimmed }, -- Diff mode: Changed line |diff.txt|
    DiffDelete = { fg = color.red, bg = bg }, -- Diff mode: Deleted line |diff.txt|
    DiffText = { fg = color.blue, bg = color.medium_background }, -- Diff mode: Changed text within a changed line |diff.txt|
    DiffTextAdd = { bg = color.diff_add_bg, fg = color.green, bold = true }, -- Diff mode: Added text within a changed line |diff.txt|

    --
    -- Diffview
    --
    -- Diff content
    DiffviewDiffAdd = { bg = color.diff_add_bg },
    DiffviewDiffAddText = { fg = color.silver },
    DiffviewDiffDelete = { bg = color.diff_delete_bg },
    DiffviewDiffDeleteText = { fg = color.red },
    DiffviewDiffChange = { link = "DiffChange" },
    DiffviewDiffText = { link = "DiffText" },
    DiffviewDiffFill = { fg = color.faded_text, bg = bg },
    DiffviewDiffAddAsDelete = { bg = color.diff_delete_bg, fg = color.red },
    DiffviewDiffDeleteDim = { link = "Comment" },

    -- File panel
    DiffviewFilePanelTitle = { fg = color.magenta, bold = true },
    DiffviewFilePanelCounter = { fg = color.cyan, bold = true },
    DiffviewFilePanelFileName = { fg = color.text },
    DiffviewFilePanelPath = { fg = color.faded_text },
    DiffviewFilePanelRootPath = { link = "DiffviewFilePanelTitle" },
    DiffviewFilePanelSelected = { fg = color.cyan, bold = true },
    DiffviewFilePanelInsertions = { fg = color.green },
    DiffviewFilePanelDeletions = { fg = color.red },
    DiffviewFilePanelConflicts = { fg = color.yellow },

    -- File statuses
    DiffviewStatusAdded = { link = "GitAdded" },
    DiffviewStatusDeleted = { link = "GitDeleted" },
    DiffviewStatusModified = { link = "GitChanged" },
    DiffviewStatusRenamed = { link = "GitChanged" },
    DiffviewStatusCopied = { link = "GitChanged" },
    DiffviewStatusTypeChange = { link = "GitChanged" },
    DiffviewStatusUnmerged = { fg = color.yellow },
    DiffviewStatusUntracked = { fg = color.faded_text },
    DiffviewStatusBroken = { fg = color.red },
    DiffviewStatusUnknown = { fg = color.faded_text },
    DiffviewStatusIgnored = { link = "Comment" },

    -- Folders
    DiffviewFolderName = { link = "Directory" },
    DiffviewFolderSign = { link = "PreProc" },

    -- Git metadata
    DiffviewHash = { link = "Identifier" },
    DiffviewReference = { link = "Function" },
    DiffviewReflogSelector = { link = "Special" },

    -- UI elements
    DiffviewNormal = { link = "Normal" },
    DiffviewNonText = { link = "NonText" },
    DiffviewCursorLine = { link = "CursorLine" },
    DiffviewWinSeparator = { link = "WinSeparator" },
    DiffviewSignColumn = { link = "SignColumn" },
    DiffviewStatusLine = { link = "StatusLine" },
    DiffviewStatusLineNC = { link = "StatusLineNC" },
    DiffviewEndOfBuffer = { link = "EndOfBuffer" },
    DiffviewVertSplit = { link = "VertSplit" },

    -- Color helpers
    DiffviewDim1 = { fg = color.faded_text },
    DiffviewPrimary = { fg = color.cyan },
    DiffviewSecondary = { fg = color.orange },

    --
    -- Gitsigns
    --
    GitSignsAdd = { link = "GitAdded" },
    GitSignsChange = { link = "GitChanged" },
    GitSignsDelete = { link = "GitDeleted" },
    GitSignsAddPreview = { link = "DiffviewDiffAdd" },
    GitSignsDeletePreview = { link = "DiffviewDiffDelete" },
    GitSignsAddInline = { link = "DiffviewDiffAddText" },
    GitSignsDeleteInline = { link = "DiffviewDiffDeleteText" },

    --
    -- LSP highlighting
    --
    LspReferenceText = { sp = color.beige, underline = true }, -- Used for highlighting "text" references
    LspReferenceRead = { sp = color.beige, underline = true }, -- Used for highlighting "read" references
    LspReferenceWrite = { sp = color.beige, underline = true, bold = true }, -- Used for highlighting "write" references
    LspInlayHint = { fg = color.faded_text, italic = opts.italic == true, underdashed = true },
    LspCodeLens = { link = "Comment" }, -- Used to color the virtual text of the codelens. See |nvim_buf_set_extmark()|.
    -- LspCodeLensSeparator        { } , -- Used to color the seperator between two or more code lens.
    -- LspSignatureActiveParameter { } , -- Used to highlight the active parameter in the signature help. See |vim.lsp.handlers.signature_help()|.

    --
    -- Diagnostic
    --
    DiagnosticError = { fg = color.red }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
    DiagnosticWarn = { fg = color.yellow }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
    DiagnosticInfo = { fg = color.blue }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
    DiagnosticHint = { fg = color.silver }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
    DiagnosticVirtualTextError = { fg = color.red }, -- Used for "Error" diagnostic virtual text.
    DiagnosticVirtualTextWarn = { fg = color.yellow }, -- Used for "Warn" diagnostic virtual text.
    DiagnosticVirtualTextInfo = { fg = color.blue }, -- Used for "Info" diagnostic virtual text.
    DiagnosticVirtualTextHint = { fg = color.silver }, -- Used for "Hint" diagnostic virtual text.
    DiagnosticUnderlineError = { sp = color.red, undercurl = true }, -- Used to underline "Error" diagnostics.
    DiagnosticUnderlineWarn = { sp = color.yellow, undercurl = true }, -- Used to underline "Warn" diagnostics.
    DiagnosticUnderlineInfo = { sp = color.blue, undercurl = true }, -- Used to underline "Info" diagnostics.
    DiagnosticUnderlineHint = { sp = color.silver, undercurl = true }, -- Used to underline "Hint" diagnostics.
    DiagnosticFloatingErrorLabel = { fg = color.float_bg, bg = color.red },
    DiagnosticFloatingWarnLabel = { fg = color.float_bg, bg = color.yellow },
    DiagnosticFloatingInfoLabel = { fg = color.float_bg, bg = color.blue },
    DiagnosticFloatingHintLabel = { fg = color.float_bg, bg = color.silver },
    DiagnosticFloatingError = { fg = color.red }, -- Used to color "Error" diagnostic messages in diagnostics float. See |vim.diagnostic.open_float()|
    DiagnosticFloatingWarn = { fg = color.yellow }, -- Used to color "Warn" diagnostic messages in diagnostics float.
    DiagnosticFloatingInfo = { fg = color.blue }, -- Used to color "Info" diagnostic messages in diagnostics float.
    DiagnosticFloatingHint = { fg = color.silver }, -- Used to color "Hint" diagnostic messages in diagnostics float.
    DiagnosticSignError = { fg = color.red }, -- Used for "Error" signs in sign column.
    DiagnosticSignWarn = { fg = color.yellow }, -- Used for "Warn" signs in sign column.
    DiagnosticSignInfo = { fg = color.blue }, -- Used for "Info" signs in sign column.
    DiagnosticSignHint = { fg = color.silver }, -- Used for "Hint" signs in sign column.

    --
    -- Telescope
    --
    TelescopeNormal = { bg = color.float_bg },
    TelescopeMatching = { fg = color.orange, bold = true },
    TelescopeSelection = { bg = bg },
    TelescopeSelectionCaret = { fg = color.cyan },
    TelescopePromptPrefix = { fg = color.white },
    TelescopeBorder = { fg = color.faded_text, bg = float_bg }, -- this is used for telescope titles
    TelescopeResultsDiffAdd = { link = "GitAdded" },
    TelescopeResultsDiffChange = { link = "GitChanged" },
    TelescopeResultsDiffDelete = { link = "GitDeleted" },
    TelescopePromptCounter = { link = "Comment" },

    --
    -- Fzf-lua
    --
    FzfLuaNormal = { bg = color.float_bg },
    FzfLuaTitle = { link = "FloatTitle" },
    FzfLuaBorder = { fg = color.faded_text, bg = color.float_bg },
    FzfLuaHelpNormal = { fg = color.yellow }, --
    FzfLuaHeaderBind = { fg = color.yellow, bold = true }, -- header keybind
    FzfLuaHeaderText = { fg = color.magenta }, -- keybind help text
    FzfLuaDirPart = { fg = color.bar_faded_text },
    FzfLuaFilePart = { fg = color.text },
    FzfLuaPathLineNr = { fg = color.green },
    FzfLuaDirIcon = { fg = color.cyan },
    FzfLuaSearch = { fg = color.orange, bold = true },
    FzfLuaFzfMatch = { fg = color.orange, bold = true },
    FzfLuaBackdrop = { bg = bar_bg },

    --
    -- NeoTree
    --
    NeoTreeRootName = { fg = color.strong_text, bold = true },
    NeoTreeDirectoryIcon = { fg = color.faded_text },
    NeoTreeFileIcon = { fg = color.faded_text },
    NeoTreeIndentMarker = { link = "IndentBlanklineChar" },
    NeoTreeGitAdded = { fg = color.green },
    NeoTreeGitUntracked = { fg = color.green },
    NeoTreeGitModified = { fg = color.blue },
    NeoTreeGitStaged = { fg = color.green },
    NeoTreeGitIgnored = { fg = color.faded_text },

    --
    -- NeoGit
    --
    NeogitSectionHeader = { fg = color.magenta },
    gitcommitFirstLine = { fg = color.text },
    gitcommitSummary = { fg = color.text },
    NeogitDiffAdd = { fg = color.green, bg = color.diff_add_bg },
    NeogitDiffDelete = { fg = color.red, bg = color.diff_delete_bg },
    NeogitDiffDeleteHighlight = { link = "NeogitDiffDelete" },
    NeogitDiffDeletions = { link = "NeogitDiffDelete" },
    NeogitChangeDeleted = { link = "NeogitDiffDelete" },
    NeogitHunkHeader = { fg = color.bar_text, bg = color.strong_faded_text },
    NeogitHunkHeaderHighlight = { link = "NeogitHunkHeader" },
    NeogitHunkHeaderCursor = { link = "NeogitHunkHeader" },
    NeogitDiffHeader = { link = "NeogitHunkHeader" },

    NotifyBackground = { bg = float_bg },
    NotifyINFOIcon = { fg = color.blue },
    NotifyINFOTitle = { fg = color.blue },
    NotifyINFOBody = { fg = color.text, bg = float_bg },
    NotifyINFOBorder = { fg = color.float_bg, bg = float_bg },
    NotifyWARNIcon = { fg = color.yellow },
    NotifyWARNTitle = { fg = color.yellow },
    NotifyWARNBody = { fg = color.text, bg = float_bg },
    NotifyWARNBorder = { fg = color.float_bg, bg = float_bg },
    NotifyERRORIcon = { fg = color.red },
    NotifyERRORTitle = { fg = color.red },
    NotifyERRORBody = { fg = color.text, bg = float_bg },
    NotifyERRORBorder = { fg = color.float_bg, bg = float_bg },
    NotifyDEBUGIcon = { fg = color.silver },
    NotifyDEBUGTitle = { fg = color.silver },
    NotifyDEBUGBody = { fg = color.text, bg = float_bg },
    NotifyDEBUGBorder = { fg = color.float_bg, bg = float_bg },
    NotifyTRACEIcon = { fg = color.magenta },
    NotifyTRACETitle = { fg = color.magenta },
    NotifyTRACEBody = { fg = color.text, bg = float_bg },
    NotifyTRACEBorder = { fg = color.float_bg, bg = float_bg },

    ---
    --- Cmp
    ---
    CmpItemMenu = { fg = color.blue },
    CmpItemAbbrMatch = { fg = color.orange, bold = true, force = true },
    CmpItemKindFunction = { link = "Function", force = true },
    CmpItemKindMethod = { link = "Function" },
    CmpItemKindClass = { link = "Type", force = true },
    CmpItemKindSnippet = { fg = color.blue },
    CmpItemKindConstant = { link = "Constant" },
    CmpItemKindEnum = { link = "Constant" },
    CmpItemKindVariable = { link = "Variable" },
    CmpItemKindKeyword = { link = "Keyword" },
    CmpItemKindFolder = { link = "Directory" },
  }

  return hl
end

return M
