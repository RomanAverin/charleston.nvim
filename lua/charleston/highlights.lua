local M = {}

---@param pallet Palette
---@return table
function M.get(pallet, opts)
  local color = pallet
  -- setup options
  color.bg = opts.darker_background and color.bg or color.bg_dimmed

  local hl = {
    Normal = { fg = color.text, bg = color.bg }, -- Normal text
    Comment = { fg = color.faded_text, italic = opts.italic == true }, -- Any comment
    Constant = { fg = color.cyan }, -- (*) Any constant
    String = { fg = color.green }, --   A string constant: "this is a string"
    Character = { fg = color.teal }, --   A character constant: 'c', '\n'
    Number = { fg = color.yellow }, --   A number constant: 234, 0xff
    Boolean = { fg = color.red }, --   A boolean constant: TRUE, false
    Float = { fg = color.yellow }, --   A floating point constant: 2.3e10
    Identifier = { fg = color.beige }, -- (*) Any variable name
    Function = { fg = color.cyan }, --   Function name (also: methods for classes)
    Statement = { fg = color.purple }, -- (*) Any statement
    Conditional = { fg = color.purple }, --   if, then, else, endif, switch, etc.
    Repeat = { fg = color.english_violet }, --   for, do, while, etc.
    Label = { fg = color.text }, --   case, default, etc.
    Operator = { fg = color.orange }, --   "sizeof", "+", "*", etc.
    Keyword = { fg = color.blue }, --   any other keyword
    Exception = { fg = color.purple }, --   try, catch, throw
    PreProc = { fg = color.magenta }, -- (*) Generic Preprocessor
    Include = { fg = color.blue, bold = true }, --   Preprocessor #include
    Define = { fg = color.brightBlue }, --   Preprocessor #define
    Macro = { link = "Define" }, --   Same as Define
    PreCondit = { link = "Define" }, --   Preprocessor #if, #else, #endif, etc.
    Type = { fg = color.cyan }, -- (*) int, long, char, etc.
    Typedef = { link = "Type" }, --   A typedef
    StorageClass = { fg = color.orange }, --   static, register, volatile, etc.
    Structure = { fg = color.orange }, --   struct, union, enum, etc.
    Special = { fg = color.silver }, -- (*) Any special symbol
    SpecialChar = { fg = color.silver }, -- Special character in a constant
    -- Tag            { }, --   You can use CTRL-] on this
    -- Delimiter = { link = "Normal" }, --   Character that needs attention
    SpecialComment = { fg = color.strong_text }, --   Special things inside a comment (e.g. '\n')
    -- Debug          { }, --   Debugging statements

    Underlined = { underline = true }, -- Text that stands out, HTML links
    -- Ignore         { }, -- Left blank, hidden |hl-Ignore| (NOTE May be invisible here in template)
    -- Error          { }, -- Any erroneous construct
    -- Todo           { }, -- Anything that needs extra attention; mostly the keywords TODO FIXME and XXX

    Conceal = { fg = color.faded_text }, -- Placeholder characters substituted for concealed text (see 'conceallevel')
    Cursor = { reverse = true }, -- Character under the cursor
    lCursor = { link = "Cursor" }, -- Character under the cursor when |language-mapping| is used (see 'guicursor')
    CursorIM = { link = "Cursor" }, -- Like Cursor, but used when in IME mode |CursorIM|
    CursorColumn = { bg = color.lighter_gray }, -- Screen-column at the cursor, when 'cursorcolumn' is set.
    CursorLine = { bg = color.lighter_gray }, -- Screen-line at the cursor, when 'cursorline' is set. Low-priority if foreground (ctermfg OR guifg) is not set.
    IblIndent = { fg = color.thin_line },
    VirtColumn = { fg = color.thin_line },
    ColorColumn = { fg = color.thin_line }, -- Columns set with 'colorcolumn'
    Directory = { fg = color.text }, -- Directory names (and other special names in listings)
    -- EndOfBuffer  { }, -- Filler lines ~ after the end of the buffer. By default, this is highlighted like |hl-NonText|.
    -- TermCursor   { }, -- Cursor in a focused terminal
    -- TermCursorNC { }, -- Cursor in an unfocused terminal
    -- ErrorMsg     { }, -- Error messages on the command line
    Folded = { fg = color.bg, bg = color.charcoal }, -- Line used for closed folds
    FoldColumn = { fg = color.charcoal, bg = color.bg }, -- 'foldcolumn'
    SignColumn = { fg = color.text, bg = color.bg }, -- Column where |signs| are displayed
    -- IncSearch    { }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
    -- Substitute   { }, -- |:substitute| replacement text highlighting
    LineNr = { fg = color.strong_faded_text }, -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
    CursorLineNr = { fg = color.silver, bold = true }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
    MatchParen = { fg = color.white, bold = true, underline = true }, -- Character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
    MsgArea = { fg = color.silver }, -- Area for messages and cmdline
    ModeMsg = { link = "MsgArea" }, -- 'showmode' message (e.g., "-- INSERT -- ")
    -- MsgSeparator { }, -- Separator for scrolled messages, `msgsep` flag of 'display'
    -- MoreMsg      { }, -- |more-prompt|
    NonText = { fg = color.cyan }, -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
    NormalFloat = { fg = color.text, bg = color.float_bg }, -- Normal text in floating windows.
    FloatBorder = { fg = color.thick_line },
    -- NormalNC     { }, -- normal text in non-current windows
    Pmenu = { fg = color.text, bg = color.float_bg }, -- Popup menu: Normal item.
    -- PmenuSel = { }, -- Popup menu: Selected item.
    -- PmenuSbar = {  }, -- Popup menu: Scrollbar.d
    -- PmenuThumb = { }, -- Popup menu: Thumb of the scrollbar.
    -- Question     { }, -- |hit-enter| prompt and yes/no questions
    -- QuickFixLine { }, -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
    Search = { fg = color.bg, bg = color.cyan }, -- Last search pattern highlighting (see 'hlsearch'). Also used for similar items that need to stand out.
    SpecialKey = { fg = color.faded_text }, -- Unprintable characters: text displayed differently from what it really is. But not 'listchars' whitespace. |hl-Whitespace|
    -- SpellBad     { }, -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
    -- SpellCap     { }, -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
    -- SpellLocal   { }, -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
    -- SpellRare    { }, -- Word that is recognized by the spellchecker as one that is hardly ever used. |spell| Combined with the highlighting used otherwise.
    StatusLine = { bg = color.bar_bg }, -- Status line of current window
    StatusLineNC = { bg = color.bar_bg }, -- Status lines of not-current windows. Note: If this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
    TabLine = { bg = color.bar_bg }, -- Tab pages line, not active tab page label
    TabLineFill = { bg = color.bar_bg }, -- Tab pages line, where there are no labels
    TabLineSel = { bg = color.bar_bg }, -- Tab pages line, active tab page label
    Title = { fg = color.magenta }, -- Titles for output from ":set all", ":autocmd" etc.
    -- NB!: VertSplit is dynamic. See functions below.
    VertSplit = { fg = color.white }, -- Vertical split line
    Visual = { bg = color.medium_backgroud }, -- Visual mode selection
    -- VisualNOS    { }, -- Visual mode selection when vim is "Not Owning the Selection".
    -- WarningMsg   { }, -- Warning messages
    Whitespace = { fg = color.faded_text }, -- "nbsp", "space", "tab" and "trail" in 'listchars'
    Winseparator = { link = "VertSplit" }, -- Separator between window splits. Inherts from |hl-VertSplit| by default, which it will replace eventually.
    -- WildMenu     { }, -- Current match in 'wildmenu' completion
    Winbar = { bg = color.bar_bg },
    WinbarNC = { bg = color.bar_bg },

    -- Tree-Sitter syntax groups.
    --
    ["@comment"] = { link = "Comment" }, -- Comment
    ["@comment.hint"] = { fg = color.silver },
    ["@comment.info"] = { fg = color.silver },
    ["@comment.note"] = { fg = color.teal },
    ["@comment.todo"] = { fg = color.cyan },
    ["@comment.warning"] = { fg = color.yellow },
    ["@constant"] = { link = "Constant" }, -- Constant
    ["@keyword"] = { fg = color.magenta },
    ["@macro"] = { link = "Macro" }, -- Macro
    ["@string"] = { link = "String" }, -- String
    ["@markup"] = { fg = color.faded_text }, -- Markup

    -- ["@markup.emphasis"] = { italic = true },
    -- ["@markup.environment"] = { link = "Macro" },
    -- ["@markup.environment.name"] = { link = "Type" },
    -- ["@markup.heading"] = { link = "Title" },
    -- ["@markup.italic"] = { italic = true },
    -- ["@markup.link"] = { fg = color.teal },
    -- ["@markup.link.label"] = { link = "SpecialChar" },
    -- ["@markup.link.label.symbol"] = { link = "Identifier" },
    -- ["@markup.link.url"] = { link = "Underlined" },
    -- ["@markup.list"] = { fg = color.blue }, -- For special punctutation that does not fall in the categories before.
    -- ["@markup.list.checked"] = { fg = color.green }, -- For brackets and parens.
    -- ["@markup.list.markdown"] = { fg = color.orange, bold = true },
    -- ["@markup.list.unchecked"] = { fg = color.blue }, -- For brackets and parens.
    -- ["@markup.math"] = { link = "Special" },
    -- ["@markup.raw"] = { link = "String" },
    -- ["@markup.raw.block"] = { link = "String" },
    -- ["@markup.raw.block.markdown"] = { link = "Normal" },
    ["@label.markdown"] = { link = "Normal" },

    -- ["@variable.parameter.builtin"] = { fg = color.teal },
    -- ["@markup.raw.markdown_inline"] = { bg = color.float_bg, fg = color.blue },
    -- ["@constructor"] = { link = "Special" }, -- Special
    -- ["@operator"] = { link = "Operator" }, -- Operator
    -- ["@keyword"] = { link = "Keyword" }, -- Keyword
    ["@variable"] = { fg = color.beige, italic = opts.italic == true }, -- Variable
    ["@punctuation.bracket"] = { fg = color.beige },
    ["@tag"] = { link = "Label" },
    ["@type"] = { link = "Type" }, -- Type
    ["@type.definition"] = { link = "Typedef" }, -- Typedef
    ["@structure"] = { link = "Structure" }, -- Structure
    ["@include"] = { link = "Include" }, -- Include
    --
    --  highlights for a languages
    --
    ["@keyword.import"] = { link = "Include" },
    ["@keyword.rust"] = { fg = color.magenta },
    ["@keyword.python"] = { fg = color.magenta },
    -- ["@keyword.lua"] = { fg = color.cyan },
    --  LSP
    ["@lsp.type.parameter"] = { fg = color.cyan },
    ["@lsp.type.variable.lua"] = { link = "@lsp.type.parameter" },

    markdownCode = { fg = color.faded_text },
    markdownCodeBlock = { fg = color.faded_text },
    markdownLinkText = { fg = color.blue, underline = true },

    --
    -- Render-markdown.nvim
    --
    RenderMarkdownH1 = { fg = color.silver },
    RenderMarkdownH2 = { fg = color.silver },
    RenderMarkdownH3 = { fg = color.silver },
    RenderMarkdownH4 = { fg = color.silver },
    RenderMarkdownH5 = { fg = color.silver },
    RenderMarkdownH6 = { fg = color.silver },
    RenderMarkdownH1Bg = { bg = color.float_bg },
    RenderMarkdownH2Bg = { bg = color.float_bg },
    RenderMarkdownH3Bg = { bg = color.float_bg },
    RenderMarkdownH4Bg = { bg = color.bg },
    RenderMarkdownH5Bg = { bg = color.bg },
    RenderMarkdownH6Bg = { bg = color.bg },
    RenderMarkdownCode = { fg = color.green, bg = color.float_bg },
    RenderMarkdownCodeInline = { fg = color.faded_text, bg = color.float_bg },
    RenderMarkdownInlineHighlight = { fg = color.faded_text, bg = color.float_bg },
    RenderMarkdownBullet = { fg = color.silver },
    RenderMarkdownTableHead = { fg = color.blue },
    RenderMarkdownTableRow = { fg = color.cyan },
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
    SnacksDashboardDir = { fg = color.green },
    SnacksDashboardHeader = { fg = color.green },
    --
    -- Noice.nvim
    --
    NoiceCmdline = { fg = color.white }, -- Search prompt
    NoiceCmdlinePopup = { fg = color.white, bg = color.bg },
    NoiceCmdlinePopupBorder = { fg = color.faded_text }, -- Cmd window boarder
    NoiceCmdlinePopupTitle = { fg = color.white },
    NoiceCmdlineIcon = { fg = color.white }, -- Prompt begin icon
    NoiceCmdlineIconCalculator = { fg = color.blue },
    NoiceCmdlineIconCmdLine = { fg = color.white },
    NoiceCmdlineIconFilter = { fg = color.magenta },
    NoiceCmdlineIconHelp = { fg = color.cyan },
    NoiceCmdlineIconInput = { fg = color.red },
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
    BlinkCmpMenuSelection = { bg = color.silver, fg = color.strong_faded_text },
    BlinkCmpLabelMatch = { bold = true, fg = color.beige },
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

    -- Mason
    MasonHighlight = { fg = color.magenta },
    MasonHighlightBlockBold = { fg = color.magenta },

    -- Git
    --
    GitAdded = { fg = color.green },
    GitChanged = { fg = color.blue },
    GitDeleted = { fg = color.red },

    diffAdded = { link = "GitAdded" },
    diffChanged = { link = "GitChanged" },
    diffDeleted = { link = "GitDeleted" },

    DiffAdd = { bg = color.diff_add_bg }, -- Diff mode: Added line |diff.txt|
    DiffChange = { bg = color.blue }, -- Diff mode: Changed line |diff.txt|
    DiffDelete = { fg = color.faded_text, bg = color.bg }, -- Diff mode: Deleted line |diff.txt|
    DiffText = { bg = color.cyan }, -- Diff mode: Changed text within a changed line |diff.txt|

    -- Diffview
    DiffviewDiffAdd = { bg = color.diff_add_bg },
    DiffviewDiffAddText = { bg = color.diff_add_bg },
    DiffviewDiffDelete = { bg = color.diff_delete_bg },
    DiffviewDiffDeleteText = { bg = color.diff_delete_bg },
    DiffviewDiffFill = { fg = color.faded_text, bg = color.bg },

    -- Gitsigns
    GitSignsAdd = { link = "GitAdded" },
    GitSignsChange = { link = "GitChanged" },
    GitSignsDelete = { link = "GitDeleted" },
    GitSignsAddPreview = { link = "DiffviewDiffAdd" },
    GitSignsDeletePreview = { link = "DiffviewDiffDelete" },
    GitSignsAddInline = { link = "DiffviewDiffAddText" },
    GitSignsDeleteInline = { link = "DiffviewDiffDeleteText" },

    -- LSP highlighting
    LspReferenceText = { underline = true }, -- Used for highlighting "text" references
    LspReferenceRead = { link = "LspReferenceText" }, -- Used for highlighting "read" references
    LspReferenceWrite = { link = "LspReferenceText" }, -- Used for highlighting "write" references
    LspInlayHint = { link = "Comment", bold = true },
    LspCodeLens = { link = "LspInlayHint" }, -- Used to color the virtual text of the codelens. See |nvim_buf_set_extmark()|.
    -- LspCodeLensSeparator        { } , -- Used to color the seperator between two or more code lens.
    -- LspSignatureActiveParameter { } , -- Used to highlight the active parameter in the signature help. See |vim.lsp.handlers.signature_help()|.

    -- See :h diagnostic-highlights, some groups may not be listed, submit a PR fix to lush-template!
    --
    DiagnosticError = { fg = color.red }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
    DiagnosticWarn = { fg = color.yellow }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
    DiagnosticInfo = { fg = color.blue }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
    DiagnosticHint = { fg = color.silver }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
    DiagnosticVirtualTextError = { fg = color.red }, -- Used for "Error" diagnostic virtual text.
    DiagnosticVirtualTextWarn = { fg = color.yellow }, -- Used for "Warn" diagnostic virtual text.
    DiagnosticVirtualTextInfo = { fg = color.blue }, -- Used for "Info" diagnostic virtual text.
    DiagnosticVirtualTextHint = { fg = color.silver }, -- Used for "Hint" diagnostic virtual text.
    DiagnosticUnderlineError = { link = "DiagnosticError", undercurl = true }, -- Used to underline "Error" diagnostics.
    DiagnosticUnderlineWarn = { link = "DiagnosticWarn", undercurl = true }, -- Used to underline "Warn" diagnostics.
    DiagnosticUnderlineInfo = { link = "DiagnosticInfo", undercurl = true }, -- Used to underline "Info" diagnostics.
    DiagnosticUnderlineHint = { link = "DiagnosticHint", undercurl = true }, -- Used to underline "Hint" diagnostics.
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
    StatusBarSegmentNormal = { fg = color.bar_text, bg = color.bar_bg },
    StatusBarSegmentFaded = { fg = color.bar_faded_text, bg = color.bar_bg },
    StatusBarDiagnosticError = { fg = color.red, bg = color.bar_bg },
    StatusBarDiagnosticWarn = { fg = color.yellow, bg = color.bar_bg },
    StatusBarDiagnosticInfo = { fg = color.blue, bg = color.bar_bg },
    StatusBarDiagnosticHint = { fg = color.silver, bg = color.bar_bg },
    FloatTitle = { fg = color.bg, bg = color.cyan, bold = true },
    IndentBlanklineChar = { fg = color.thin_line },
    IndentBlanklineContextChar = { fg = color.thin_line },
    TodoComment = { fg = color.purple },
    FixmeComment = { fg = color.purple },
    HackComment = { fg = color.yellow },
    PriorityComment = { fg = color.orange },
    MiniStarterSection = { fg = color.text, bg = color.bg, bold = true },
    MiniStarterFooter = { link = "Comment" },
    ZenBg = { fg = color.text, bg = color.bg },
    WinShiftMove = { bg = color.bg },
    TabsVsSpaces = { fg = color.faded_text, underline = true },
    FlashCurrent = { fg = color.bg, bg = color.green, bold = true },
    FlashMatch = { fg = color.bg, bg = color.cyan },
    FlashLabel = { fg = color.bg, bg = color.purple, bold = true },
    FlashPrompt = { bg = color.bar_bg },
    FlashPromptIcon = { bg = color.bar_bg },
    MiniCursorword = { bg = color.bg },
    NvimSurroundHighlight = { fg = color.bg, bg = color.cyan },

    -- Telescope
    TelescopeNormal = { bg = color.float_bg },
    TelescopeMatching = { fg = color.charcoal },
    TelescopeSelection = { bg = color.bg },
    TelescopeBorder = { fg = color.faded_text, bg = color.float_bg }, -- this is used for telescope titles
    TelescopeResultsDiffAdd = { link = "GitAdded" },
    TelescopeResultsDiffChange = { link = "GitChanged" },
    TelescopeResultsDiffDelete = { link = "GitDeleted" },
    TelescopePromptCounter = { link = "Comment" },

    -- Fzf-lua
    FzfLuaNormal = { bg = color.float_bg },
    FzfLuaTitle = { bg = color.english_violet },
    FzfLuaBorder = { fg = color.faded_text, bg = color.float_bg },
    FzfLuaHelpNormal = { fg = color.yellow }, --
    FzfLuaHeaderBind = { fg = color.yellow, bold = true }, -- header keybind
    FzfLuaHeaderText = { fg = color.magenta }, -- keybind help text
    FzfLuaDirPart = { fg = color.bar_faded_text },
    FzfLuaSearch = { fg = color.orange, bold = true },
    FzfLuaFzfMatch = { fg = color.orange, bold = true },

    -- NeoTree
    NeoTreeRootName = { fg = color.strong_text, bold = true },
    NeoTreeDirectoryIcon = { fg = color.faded_text },
    NeoTreeFileIcon = { fg = color.faded_text },
    NeoTreeIndentMarker = { link = "IndentBlanklineChar" },
    NeoTreeGitAdded = { fg = color.green },
    NeoTreeGitUntracked = { fg = color.green },
    NeoTreeGitModified = { fg = color.blue },
    NeoTreeGitStaged = { fg = color.green },
    NeoTreeGitIgnored = { fg = color.faded_text },

    -- NeoGit
    NeogitSectionHeader = { fg = color.magenta },
    gitcommitFirstLine = { fg = color.text },
    gitcommitSummary = { fg = color.text },

    NotifyINFOIcon = { fg = color.blue },
    NotifyINFOTitle = { fg = color.blue },
    NotifyINFOBody = { fg = color.text, bg = color.float_bg },
    NotifyINFOBorder = { fg = color.float_bg, bg = color.float_bg },
    NotifyWARNIcon = { fg = color.yellow },
    NotifyWARNTitle = { fg = color.yellow },
    NotifyWARNBody = { fg = color.text, bg = color.float_bg },
    NotifyWARNBorder = { fg = color.float_bg, bg = color.float_bg },
    NotifyERRORIcon = { fg = color.red },
    NotifyERRORTitle = { fg = color.red },
    NotifyERRORBody = { fg = color.red, bg = color.float_bg },
    NotifyERRORBorder = { fg = color.float_bg, bg = color.float_bg },

    --- Cmp
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
