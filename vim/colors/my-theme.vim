" my-theme.vim - Gruvbox Material Muted Pastel Edition
" 16-color palette only - no guifg/guibg, no termguicolors required.
" The actual displayed hues come entirely from your terminal/console's own
" 16-slot ANSI palette (Alacritty config, /etc/vtrgb, etc.) - configure the
" palette there to match Gruvbox Material; this file only assigns names.
"
" 8-color fallback: if &t_Co < 16 (e.g. raw Linux tty with $TERM=linux),
" any bright token (numeric cterm 8-15) is folded down to its base 0-7
" ANSI color and gets 'bold' added to preserve some visual distinction.
"
" All tokens use raw numeric ANSI indices (0-15), never Vim's named
" colors (Black, DarkGray, DarkBlue, ...). Named colors are NOT stable
" across color-mode: Vim resolves them to literal ANSI 0-15 only when
" &t_Co is 8 or 16, but routes them through a separate, fixed xterm-256
" grayscale/cube lookup table once &t_Co reaches 256 (e.g. under tmux) -
" a table your terminal's customizable ANSI palette does NOT override.
" Raw numbers bypass that inconsistency and always target the literal
" ANSI index, so your terminal/vtrgb palette applies consistently in
" every mode.

set background=dark
highlight clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "my-theme"

if !exists('g:my_theme_transparent')
  let g:my_theme_transparent = 0
endif

" 1. Token Definition Registry
" Each token is a single cterm (16-color ANSI code) value - no gui hex.
" Base colors are the standard 0-7 slots; 'br_' prefixed tokens are their
" bright 8-15 counterparts (e.g. red=1 / br_red=9), same convention as
" bex.vim. This theme's main palette is built on the bright half (8-15),
" since Vim's named colors (Red, Green, ...) map to its own historical
" cterm table rather than the standard terminal ANSI bright slots - using
" the numbers directly guarantees we hit the real bright colors in your
" terminal palette.
let s:tokens = {
      \ 'black':      0,
      \ 'red':        1,
      \ 'green':      2,
      \ 'yellow':     3,
      \ 'blue':       4,
      \ 'magenta':    5,
      \ 'cyan':       6,
      \ 'white':      7,
      \ 'br_black':   8,
      \ 'br_red':     9,
      \ 'br_green':   10,
      \ 'br_yellow':  11,
      \ 'br_blue':    12,
      \ 'br_magenta': 13,
      \ 'br_cyan':    14,
      \ 'br_white':   15,
      \
      \ 'bg': g:my_theme_transparent ? 'NONE' : 0,
      \ 'bg_alt': 8,
      \ 'bg_float': 8,
      \ 'bg_popup': 0,
      \ 'border': 8,
      \ 'line_nr': 8,
      \ 'visual': 12,
      \
      \ 'diff_add_bg': 2,
      \ 'diff_change_bg': 6,
      \ 'diff_delete_bg': 4,
      \ 'diff_text_bg': 3,
      \
      \ 'NONE': 'NONE'
      \ }

" Semantic Aliases (main palette uses the bright 8-15 tokens)
let s:tokens['keyword']   = s:tokens['br_red']
let s:tokens['func']      = s:tokens['br_yellow']
let s:tokens['type']      = s:tokens['br_blue']
let s:tokens['lvar']      = s:tokens['br_white']
let s:tokens['string']    = s:tokens['br_magenta']
let s:tokens['number']    = s:tokens['br_green']
let s:tokens['comment']   = s:tokens['br_black']
let s:tokens['operator']  = s:tokens['br_cyan']
let s:tokens['preproc']   = s:tokens['br_black']
let s:tokens['special']   = s:tokens['br_cyan']
let s:tokens['error']     = s:tokens['br_red']
let s:tokens['warn']      = s:tokens['br_yellow']
let s:tokens['info']      = s:tokens['br_blue']
let s:tokens['hint']      = s:tokens['br_cyan']
let s:tokens['ok']        = s:tokens['br_green']

" 16-color tty fix: distinct cterm value from br_black (8), used
" where text would otherwise sit on a DarkGray background and vanish
let s:tokens['muted_alt'] = 0

" No g:terminal_ansi_colors here anymore - that variable needs hex RGB
" values to program Neovim/Vim's :terminal palette, which this theme no
" longer carries. Configure your terminal emulator (e.g. Alacritty) and/or
" /etc/vtrgb directly with the Gruvbox Material palette instead.

" 2. Refactored Highlight Function (cterm/16-color only, with 8-color fallback)
"
" On terminals reporting &t_Co < 16 (e.g. the raw Linux console with
" $TERM=linux, which only ever advertises 8 colors), a numeric bright
" token (8-15) is meaningless - ctermfg=12 has no 9th-15th slot to draw
" from. We fold it back to its base ANSI color (n - 8) and add 'bold',
" which is the traditional way 8-color terminals simulate a "bright"
" variant. Callers never pass 'bold' explicitly - it is added here, and
" only here, so it only ever appears in the 8-color fallback case.
function! s:hi(group, fg_token, bg_token, attr)
  let l:cmd = 'highlight ' . a:group
  let l:attrs = []

  if a:attr != ''
    " Many terminals/multiplexers don't support italic (SGR 3) and
    " silently substitute reverse video instead - a full fg/bg swap,
    " which is far more jarring than just losing the slant.
    call add(l:attrs, (a:attr ==# 'italic') ? 'NONE' : a:attr)
  endif

  " Handle Foreground
  if a:fg_token != '' && has_key(s:tokens, a:fg_token)
    let l:fg = s:tokens[a:fg_token]
    if type(l:fg) == v:t_number && &t_Co < 16 && l:fg >= 8 && l:fg <= 15
      let l:fg = l:fg - 8
      if index(l:attrs, 'bold') < 0
        call add(l:attrs, 'bold')
      endif
    endif
    let l:cmd .= ' ctermfg=' . l:fg
  endif

  " Handle Background
  if a:bg_token != '' && has_key(s:tokens, a:bg_token)
    let l:bg = s:tokens[a:bg_token]
    if type(l:bg) == v:t_number && &t_Co < 16 && l:bg >= 8 && l:bg <= 15
      let l:bg = l:bg - 8
    endif
    let l:cmd .= ' ctermbg=' . l:bg
  endif

  " Handle Attributes
  if !empty(l:attrs)
    " NONE should only ever appear alone - if a real attribute (e.g. a
    " 'bold' added by the fold-down above) is also present, drop NONE.
    if len(l:attrs) > 1
      call filter(l:attrs, 'v:val !=# "NONE"')
    endif
    let l:cmd .= ' cterm=' . join(l:attrs, ',')
  endif

  execute l:cmd
endfunction

" 3. Highlighting Definitions
set cursorline

call s:hi('Normal', 'br_white', 'bg', 'NONE')
call s:hi('NormalFloat', 'br_white', 'bg_popup', '')
call s:hi('SignColumn', 'br_black', 'bg', '')
call s:hi('ColorColumn', '', 'bg_float', '')
call s:hi('CursorLine', '', 'bg', 'NONE')
call s:hi('CursorLineNr', 'br_yellow', 'bg', 'NONE')
call s:hi('LineNr', 'line_nr', 'bg', '')
call s:hi('Visual', 'br_white', 'visual', '')
call s:hi('VisualNOS', 'br_white', 'visual', '')
call s:hi('Search', 'br_white', 'visual', '')
call s:hi('IncSearch', 'br_white', 'visual', '')
call s:hi('MatchParen', 'br_red', 'NONE', 'NONE')
call s:hi('Pmenu', 'br_white', 'bg_popup', '')
call s:hi('PmenuSel', 'black', 'keyword', '')
call s:hi('PmenuSbar', '', 'border', '')
call s:hi('PmenuThumb', '', 'br_black', '')
call s:hi('StatusLine', 'br_white', 'bg_alt', '')
call s:hi('StatusLineNC', 'muted_alt', 'bg_alt', '')
call s:hi('VertSplit', 'border', 'bg', '')
call s:hi('TabLine', 'muted_alt', 'bg_alt', '')
call s:hi('TabLineSel', 'br_white', 'bg', '')
call s:hi('TabLineFill', '', 'bg_alt', '')
call s:hi('Folded', 'muted_alt', 'bg_float', 'italic')
call s:hi('FoldColumn', 'br_black', 'bg', '')
call s:hi('NonText', 'border', 'NONE', '')
call s:hi('SpecialKey', 'br_black', 'NONE', '')
call s:hi('Whitespace', 'br_black', 'NONE', '')
call s:hi('Directory', 'func', 'NONE', '')
call s:hi('Title', 'keyword', 'NONE', 'NONE')
call s:hi('Question', 'ok', 'NONE', '')
call s:hi('MoreMsg', 'ok', 'NONE', '')
call s:hi('ErrorMsg', 'error', 'NONE', '')
call s:hi('WarningMsg', 'warn', 'NONE', '')
call s:hi('WildMenu', 'black', 'keyword', '')
call s:hi('Cursor', 'black', 'br_white', '')
call s:hi('EndOfBuffer', 'border', 'NONE', '')

call s:hi('Statement', 'keyword', 'NONE', 'NONE')
call s:hi('Conditional', 'keyword', 'NONE', 'NONE')
call s:hi('Repeat', 'keyword', 'NONE', 'NONE')
call s:hi('Label', 'keyword', 'NONE', 'NONE')
call s:hi('Keyword', 'keyword', 'NONE', 'NONE')
call s:hi('Exception', 'keyword', 'NONE', 'NONE')
call s:hi('Structure', 'keyword', 'NONE', 'NONE')
call s:hi('Typedef', 'type', 'NONE', 'NONE')
call s:hi('StorageClass', 'type', 'NONE', 'NONE')
call s:hi('Type', 'type', 'NONE', 'NONE')
call s:hi('Function', 'func', 'NONE', 'NONE')
call s:hi('Identifier', 'lvar', 'NONE', 'NONE')
call s:hi('String', 'string', 'NONE', 'NONE')
call s:hi('Character', 'string', 'NONE', 'NONE')
call s:hi('Number', 'number', 'NONE', 'NONE')
call s:hi('Float', 'number', 'NONE', 'NONE')
call s:hi('Boolean', 'number', 'NONE', 'NONE')
call s:hi('Constant', 'number', 'NONE', 'NONE')
call s:hi('Operator', 'operator', 'NONE', 'NONE')
call s:hi('Delimiter', 'operator', 'NONE', 'NONE')
call s:hi('Comment', 'comment', 'NONE', 'italic')
call s:hi('SpecialComment', 'func', 'NONE', 'italic')
call s:hi('PreProc', 'preproc', 'NONE', 'NONE')
call s:hi('Include', 'preproc', 'NONE', 'NONE')
call s:hi('Define', 'preproc', 'NONE', 'NONE')
call s:hi('Macro', 'br_black', 'NONE', 'NONE')
call s:hi('PreCondit', 'preproc', 'NONE', 'NONE')
call s:hi('Special', 'special', 'NONE', 'NONE')
call s:hi('SpecialChar', 'number', 'NONE', 'NONE')
call s:hi('Tag', 'func', 'NONE', 'NONE')
call s:hi('Debug', 'error', 'NONE', 'NONE')
call s:hi('Underlined', 'func', 'NONE', 'underline')
call s:hi('Ignore', 'br_black', 'NONE', 'NONE')
call s:hi('Error', 'error', 'NONE', 'NONE')
call s:hi('Todo', 'warn', 'NONE', 'italic')

call s:hi('cppBoolean', 'number', 'NONE', 'NONE')
call s:hi('cIncluded', 'br_yellow', 'NONE', 'NONE')
call s:hi('Namespace', 'br_white', 'NONE', 'NONE')
call s:hi('cCustomNamespace', 'br_white', 'NONE', 'NONE')
call s:hi('cppModifier', 'br_white', 'NONE', 'NONE')
call s:hi('ScopedIdentifier', 'br_white', 'NONE', 'NONE')
call s:hi('cType', 'type', 'NONE', 'NONE')
call s:hi('cCustomType', 'type', 'NONE', 'NONE')

call s:hi('CocErrorSign', 'error', 'NONE', '')
call s:hi('CocWarningSign', 'warn', 'NONE', '')
call s:hi('CocInfoSign', 'info', 'NONE', '')
call s:hi('CocHintSign', 'hint', 'NONE', '')
call s:hi('CocErrorHighlight', '', 'NONE', 'undercurl')
call s:hi('CocWarningHighlight', '', 'NONE', 'undercurl')
call s:hi('CocInfoHighlight', '', 'NONE', 'undercurl')
call s:hi('CocHintHighlight', '', 'NONE', 'undercurl')
call s:hi('CocErrorVirtualText', 'error', 'NONE', 'italic')
call s:hi('CocWarningVirtualText', 'warn', 'NONE', 'italic')
call s:hi('CocInfoVirtualText', 'info', 'NONE', 'italic')
call s:hi('CocHintVirtualText', 'hint', 'NONE', 'italic')
call s:hi('CocFloating', 'br_white', 'bg_popup', '')
call s:hi('CocFloatSbar', '', 'border', '')
call s:hi('CocFloatThumb', '', 'br_black', '')
call s:hi('CocFloatDivider', 'border', 'bg_popup', '')
call s:hi('CocMenuSel', 'black', 'keyword', '')
call s:hi('CocSearch', 'func', 'NONE', 'NONE')
call s:hi('CocInlayHint', 'br_black', 'bg_popup', 'italic')
call s:hi('CocFadeOut', 'br_black', 'NONE', 'italic')
call s:hi('CocCodeLens', 'br_black', 'NONE', 'italic')

call s:hi('CocSemTypeClass', 'br_cyan', 'NONE', 'NONE')
call s:hi('CocSemTypeStruct', 'br_cyan', 'NONE', 'NONE')
call s:hi('CocSemTypeClassModDefaultLibrary', 'br_cyan', 'NONE', 'NONE')
call s:hi('CocSemTypeFunctionModDefaultLibrary', 'br_yellow', 'NONE', 'NONE')
call s:hi('CocSemTypeEnum', 'br_cyan', 'NONE', 'NONE')
call s:hi('CocSemTypeEnumMember', 'br_green', 'NONE', 'NONE')
call s:hi('CocSemTypeString', 'br_magenta', 'NONE', 'NONE')
call s:hi('CocSemTypeNumber', 'br_green', 'NONE', 'NONE')
call s:hi('CocSemTypeInterface', 'br_cyan', 'NONE', 'NONE')
call s:hi('CocSemTypeTypeParameter', 'br_cyan', 'NONE', 'NONE')
call s:hi('CocSemTypeType', 'type', 'NONE', 'NONE')
call s:hi('CocSemTypeTypedef', 'type', 'NONE', 'NONE')
call s:hi('CocSemTypeNamespace', 'br_white', 'NONE', 'NONE')
call s:hi('CocSemTypeFunction', 'func', 'NONE', 'NONE')
call s:hi('CocSemTypeMethod', 'func', 'NONE', 'NONE')
call s:hi('CocSemTypeParameter', 'br_black', 'NONE', 'NONE')
call s:hi('CocSemTypeVariable', 'lvar', 'NONE', 'NONE')
call s:hi('CocSemTypeProperty', 'lvar', 'NONE', 'NONE')
call s:hi('CocSemTypeVariableModGlobalScope', 'br_white', 'NONE', 'NONE')
call s:hi('CocSemTypeVariableModGlobalScopeDeclaration', 'br_white', 'NONE', 'NONE')
call s:hi('CocSemTypeVariableModFileScope', 'br_white', 'NONE', 'NONE')
call s:hi('CocSemTypeVariableModFileScopeDeclaration', 'br_white', 'NONE', 'NONE')
call s:hi('CocSemTypeVariableModStatic', 'br_white', 'NONE', 'NONE')
call s:hi('CocSemTypeVariableModStaticDeclaration', 'br_white', 'NONE', 'NONE')
call s:hi('CocSemTypeModVariableGlobalScope', 'br_white', 'NONE', 'NONE')
call s:hi('CocSemTypeModVariableGlobalScopeDeclaration', 'br_white', 'NONE', 'NONE')
call s:hi('CocSemTypeModVariableFileScope', 'br_white', 'NONE', 'NONE')
call s:hi('CocSemTypeModVariableStatic', 'br_white', 'NONE', 'NONE')
call s:hi('CocSemTypeModPropertyStatic', 'br_white', 'NONE', 'NONE')
call s:hi('CocSemTypeMacro', 'br_magenta', 'NONE', 'NONE')
call s:hi('CocSemTypeKeyword', 'keyword', 'NONE', 'NONE')
call s:hi('CocSemTypeComment', 'comment', 'NONE', 'italic')
call s:hi('CocSemTypeOperator', 'operator', 'NONE', 'NONE')
call s:hi('CocSemTypeOperatorModKeyword', 'br_white', 'NONE', 'NONE')
call s:hi('CocSemTypeModOperatorKeyword', 'br_white', 'NONE', 'NONE')

call s:hi('DiffAdd', 'ok', 'diff_add_bg', '')
call s:hi('DiffChange', 'warn', 'diff_change_bg', '')
call s:hi('DiffDelete', 'error', 'diff_delete_bg', '')
call s:hi('DiffText', 'br_white', 'diff_text_bg', 'NONE')

call s:hi('SpellBad', '', '', 'undercurl')
call s:hi('SpellCap', '', '', 'undercurl')
call s:hi('SpellRare', '', '', 'undercurl')
call s:hi('SpellLocal', '', '', 'undercurl')

call s:hi('CocTarget', 'br_white', 'visual', '')

" Fix LSP / CoC document highlights (word under cursor matching)
call s:hi('LspReferenceText', 'br_white', 'visual', '')
call s:hi('LspReferenceRead', 'br_white', 'visual', '')
call s:hi('LspReferenceWrite', 'br_white', 'visual', '')

" Fix QuickFix active selection line
call s:hi('QuickFixLine', 'br_white', 'visual', '')
call s:hi('CocHighlightText', 'br_white', 'visual', '')

" If using CoC, ensure its internal target highlights match too
highlight! link CocHighlightText Visual
