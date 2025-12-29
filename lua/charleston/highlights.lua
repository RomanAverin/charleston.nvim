local M = {}

---@param pallete Palette
---@return table
function M.get(pallete, opts)
  local color = pallete
  -- setup options
  color.bg = opts.darker_background and color.bg or color.bg_dimmed

  -- setup transparent backgrounds
  local bg = opts.transparent and "NONE" or color.bg
  local float_bg = opts.transparent and "NONE" or color.float_bg
  local bar_bg = opts.transparent and "NONE" or color.bar_bg

  local hl = {
    Normal = { fg = color.text, bg = bg }, -- Normal text
    Comment = { fg = color.faded_text, italic = opts.italic == true }, -- Any comment
    Constant = { fg = color.cyan }, -- (*) Any constant
    String = { fg = color.green }, --   A string constant: "this is a string"
    Character = { fg = color.teal }, --   A character constant: 'c', '\n'
    Number = { fg = color.yellow }, --   A number constant: 234, 0xff
    Boolean = { fg = color.cyan }, --   A boolean constant: TRUE, false
    Float = { fg = color.yellow }, --   A floating point constant: 2.3e10
    Identifier = { fg = color.beige }, -- (*) Any variable name
    Variable = { link = "Identifier" }, -- Variable name
    Function = { fg = color.cyan }, --   Function name (also: methods for classes)
    Statement = { fg = color.purple }, -- (*) Any statement
    Conditional = { fg = color.purple }, --   if, then, else, endif, switch, etc.
    Repeat = { fg = color.purple }, --   for, do, while, etc.
    Label = { fg = color.text }, --   case, default, etc.
    Operator = { fg = color.orange }, --   "sizeof", "+", "*", etc.
    Keyword = { fg = color.magenta }, --   any other keyword
    Exception = { fg = color.purple }, --   try, catch, throw
    PreProc = { fg = color.magenta }, -- (*) Generic Preprocessor
    Include = { fg = color.blue, bold = true }, --   Preprocessor #include
    Define = { fg = color.brightBlue }, --   Preprocessor #define
    Macro = { link = "Define" }, --   Same as Define
    PreCondit = { link = "Define" }, --   Preprocessor #if, #else, #endif, etc.
    Type = { fg = color.beige }, -- (*) int, long, char, etc.
    Typedef = { link = "Type" }, --   A typedef
    StorageClass = { fg = color.purple }, --   static, register, volatile, etc.
    Structure = { fg = color.cyan }, --   struct, union, enum, etc.
    Special = { fg = color.silver }, -- (*) Any special symbol
    SpecialChar = { fg = color.silver }, -- Special character in a constant
    Tag = { fg = color.cyan, underline = true }, --   You can use CTRL-] on this
    Delimiter = { fg = color.beige }, --   Character that needs attention
    SpecialComment = { fg = color.strong_text }, --   Special things inside a comment (e.g. '\n')
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
    CursorColumn = { bg = color.lighter_gray }, -- Screen-column at the cursor, when 'cursorcolumn' is set.
    CursorLine = { bg = color.lighter_gray }, -- Screen-line at the cursor, when 'cursorline' is set. Low-priority if foreground (ctermfg OR guifg) is not set.
    IblIndent = { fg = color.thin_line },
    IblScope = { fg = color.white },
    VirtColumn = { fg = color.thin_line },
    ColorColumn = { fg = color.thin_line }, -- Columns set with 'colorcolumn'
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
    NonText = { fg = color.beige }, -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
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
    SnippetTabstop = { fg = color.beige, bg = color.medium_background }, -- Tabstops in snippets. |vim.snippet|
    SnippetTabstopActive = { fg = color.cyan, bg = color.medium_background, bold = true }, -- The currently active tabstop. |vim.snippet|
    Question = { fg = color.silver }, -- |hit-enter| prompt and yes/no questions
    QuickFixLine = { bg = color.lighter_gray, bold = true }, -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
    Search = { fg = color.bg, bg = color.cyan }, -- Last search pattern highlighting (see 'hlsearch'). Also used for similar items that need to stand out.
    CurSearch = { fg = color.bg, bg = color.yellow, bold = true }, -- Current match for the last search pattern (see 'hlsearch'). Note: This is correct after a search, but may get outdated if changes are made or the screen is redrawn.
    Scrollbar = { fg = bar_bg }, -- Current background and foreground of the main window's scrollbars
    SpecialKey = { fg = color.faded_text }, -- Unprintable characters: text displayed differently from what it really is. But not 'listchars' whitespace. |hl-Whitespace|
    SpellBad = { sp = color.teal, undercurl = true }, -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
    SpellCap = { sp = color.teal, undercurl = true }, -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
    SpellLocal = { sp = color.teal, undercurl = true }, -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
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
    Visual = { bg = color.medium_background }, -- Visual mode selection
    VisualNOS = { link = "Visual" }, -- Visual mode selection when vim is "Not Owning the Selection".
    WarningMsg = { fg = color.yellow }, -- Warning messages
    Whitespace = { fg = color.faded_text }, -- "nbsp", "space", "tab" and "trail" in 'listchars'
    WinSeparator = { link = "VertSplit" }, -- Separator between window splits. Inherts from |hl-VertSplit| by default, which it will replace eventually.
    WildMenu = { fg = color.white, bg = color.medium_background }, -- Current match in 'wildmenu' completion
    Winbar = { bg = bar_bg },
    WinbarNC = { bg = bar_bg },

    --
    -- Tree-Sitter syntax groups.
    --
    ["@comment"] = { link = "Comment" }, -- Comment
    ["@comment.hint"] = { fg = color.silver },
    ["@comment.info"] = { fg = color.silver },
    ["@comment.note"] = { fg = color.teal },
    ["@comment.todo"] = { fg = color.blue },
    ["@comment.warning"] = { fg = color.yellow },
    ["@constant"] = { link = "Constant" }, -- Constant
    ["@keyword"] = { fg = color.magenta },
    ["@macro"] = { link = "Macro" }, -- Macro
    ["@string"] = { link = "String" }, -- String
    ["@markup"] = { fg = color.faded_text }, -- Markup
    ["@label.markdown"] = { link = "Normal" },

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
    ["@lsp.type.struct.rust"] = { fg = color.cyan },
    ["@lsp.type.variable.lua"] = { link = "@lsp.type.parameter" },
    ["@lsp.type.parameter.rust"] = { link = "@lsp.type.parameter" },

    --
    --  LSP syntax groups
    --
    ["@lsp.type.parameter"] = { fg = color.cyan },

    markdownCode = { fg = color.faded_text },
    markdownCodeBlock = { fg = color.faded_text },
    markdownLinkText = { fg = color.blue, underline = true },

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
    BufferlineErrorSelected = { fg = color.red, bg = "NONE" },
    BufferlineErrorDiagnostic = { fg = color.red, bg = bar_bg },
    BufferlineErrorDiagnosticVisible = { fg = color.red, bg = bar_bg },
    BufferlineErrorDiagnosticSelected = { fg = color.red, bg = "NONE" },
    -- Warning
    BufferlineWarning = { fg = color.yellow, bg = bar_bg },
    BufferlineWarningVisible = { fg = color.yellow, bg = bar_bg },
    BufferlineWarningSelected = { fg = color.yellow, bg = "NONE" },
    BufferlineWarningDiagnostic = { fg = color.yellow, bg = bar_bg },
    BufferlineWarningDiagnosticVisible = { fg = color.yellow, bg = bar_bg },
    BufferlineWarningDiagnosticSelected = { fg = color.yellow, bg = "NONE" },
    -- Info
    BufferlineInfo = { fg = color.blue, bg = bar_bg },
    BufferlineInfoVisible = { fg = color.blue, bg = bar_bg },
    BufferlineInfoSelected = { fg = color.blue, bg = "NONE" },
    BufferlineInfoDiagnostic = { fg = color.blue, bg = bar_bg },
    BufferlineInfoDiagnosticVisible = { fg = color.blue, bg = bar_bg },
    BufferlineInfoDiagnosticSelected = { fg = color.blue, bg = "NONE" },
    -- Hint
    BufferlineHint = { fg = color.silver, bg = bar_bg },
    BufferlineHintVisible = { fg = color.silver, bg = bar_bg },
    BufferlineHintSelected = { fg = color.silver, bg = "NONE" },
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
    SnacksDashboardDir = { fg = color.cyan },
    SnacksDashboardHeader = { fg = color.cyan },
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
    BlinkCmpMenuSelection = { bg = color.strong_faded_text },
    BlinkCmpLabelMatch = { bold = true, fg = color.yellow },
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
    MasonHighlight = { fg = color.magenta },
    MasonHighlightBlockBold = { fg = color.magenta },

    --
    -- Git
    --
    GitAdded = { fg = color.green },
    GitChanged = { fg = color.blue },
    GitDeleted = { fg = color.red },

    diffAdded = { link = "GitAdded" },
    diffChanged = { link = "GitChanged" },
    diffDeleted = { link = "GitDeleted" },

    DiffAdd = { bg = color.diff_add_bg }, -- Diff mode: Added line |diff.txt|
    DiffChange = { bg = color.bg_dimmed }, -- Diff mode: Changed line |diff.txt|
    DiffDelete = { fg = color.faded_text, bg = bg }, -- Diff mode: Deleted line |diff.txt|
    DiffText = { bg = color.medium_background }, -- Diff mode: Changed text within a changed line |diff.txt|
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

    -- LSP highlighting
    LspReferenceText = { sp = color.beige, underline = true }, -- Used for highlighting "text" references
    LspReferenceRead = { link = "LspReferenceText" }, -- Used for highlighting "read" references
    LspReferenceWrite = { link = "LspReferenceText" }, -- Used for highlighting "write" references
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
    NotifyERRORBody = { fg = color.red, bg = float_bg },
    NotifyERRORBorder = { fg = color.float_bg, bg = float_bg },

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
