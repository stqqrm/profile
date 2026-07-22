" my-theme.vim - Gruvbox Material Muted Pastel Edition
" 16-color palette only - no guifg/guibg, no termguicolors required.
" The actual displayed hues come entirely from your terminal/console's own
" 16-slot ANSI palette (Alacritty config, /etc/vtrgb, etc.) - configure the
" palette there to match Gruvbox Material; this file only assigns names.

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
" Bright-set codes (8-15) are used explicitly by number, since Vim's named
" colors (Red, Green, ...) map to its own historical cterm table rather
" than the standard terminal ANSI bright slots - using the numbers directly
" guarantees we hit the real bright colors 8-15 in your terminal palette.
let s:tokens = {
      \ 'black': 0,
      \ 'red': 9,
      \ 'green': 10,
      \ 'yellow': 11,
      \ 'blue': 12,
      \ 'magenta': 13,
      \ 'cyan': 14,
      \ 'white': 15,
      \ 'br_black': 8,
      \
      \ 'bg': g:my_theme_transparent ? 'NONE' : 'Black',
      \ 'bg_alt': 'DarkGray',
      \ 'bg_float': 'DarkGray',
      \ 'bg_popup': 'Black',
      \ 'border': 'DarkGray',
      \ 'line_nr': 'DarkGray',
      \ 'visual': 'DarkBlue',
      \
      \ 'diff_add_bg': 'DarkGreen',
      \ 'diff_change_bg': 'DarkYellow',
      \ 'diff_delete_bg': 'DarkRed',
      \ 'diff_text_bg': 'DarkCyan',
      \
      \ 'NONE': 'NONE'
      \ }

" Semantic Aliases
let s:tokens['keyword']   = s:tokens['red']
let s:tokens['func']      = s:tokens['yellow']
let s:tokens['type']      = s:tokens['blue']
let s:tokens['lvar']      = s:tokens['white']
let s:tokens['string']    = s:tokens['magenta']
let s:tokens['number']    = s:tokens['green']
let s:tokens['comment']   = s:tokens['br_black']
let s:tokens['operator']  = s:tokens['cyan']
let s:tokens['preproc']   = s:tokens['br_black']
let s:tokens['special']   = s:tokens['cyan']
let s:tokens['error']     = s:tokens['red']
let s:tokens['warn']      = s:tokens['yellow']
let s:tokens['info']      = s:tokens['blue']
let s:tokens['hint']      = s:tokens['cyan']
let s:tokens['ok']        = s:tokens['green']

" 16-color tty fix: distinct cterm name from br_black (DarkGray), used
" where text would otherwise sit on a DarkGray background and vanish
let s:tokens['muted_alt'] = 'Black'

" No g:terminal_ansi_colors here anymore - that variable needs hex RGB
" values to program Neovim/Vim's :terminal palette, which this theme no
" longer carries. Configure your terminal emulator (e.g. Alacritty) and/or
" /etc/vtrgb directly with the Gruvbox Material palette instead.

" 2. Refactored Highlight Function (cterm/16-color only)
function! s:hi(group, fg_token, bg_token, attr)
  let l:cmd = 'highlight ' . a:group

  " Handle Foreground
  if a:fg_token != '' && has_key(s:tokens, a:fg_token)
    let l:cmd .= ' ctermfg=' . s:tokens[a:fg_token]
  endif

  " Handle Background
  if a:bg_token != '' && has_key(s:tokens, a:bg_token)
    let l:cmd .= ' ctermbg=' . s:tokens[a:bg_token]
  endif

  " Handle Attributes
  if a:attr != ''
    " Many terminals/multiplexers don't support italic (SGR 3) and
    " silently substitute reverse video instead - a full fg/bg swap,
    " which is far more jarring than just losing the slant.
    let l:cterm_attr = (a:attr ==# 'italic') ? 'NONE' : a:attr
    let l:cmd .= ' cterm=' . l:cterm_attr
  endif

  execute l:cmd
endfunction

" 3. Highlighting Definitions
set cursorline

call s:hi('Normal', 'white', 'bg', 'NONE')
call s:hi('NormalFloat', 'white', 'bg_popup', '')
call s:hi('SignColumn', 'br_black', 'bg', '')
call s:hi('ColorColumn', '', 'bg_float', '')
call s:hi('CursorLine', '', 'bg', 'NONE')
call s:hi('CursorLineNr', 'yellow', 'bg', 'NONE')
call s:hi('LineNr', 'line_nr', 'bg', '')
call s:hi('Visual', 'white', 'visual', '')
call s:hi('VisualNOS', 'white', 'visual', '')
call s:hi('Search', 'white', 'visual', '')
call s:hi('IncSearch', 'white', 'visual', '')
call s:hi('MatchParen', 'red', 'NONE', 'NONE')
call s:hi('Pmenu', 'white', 'bg_popup', '')
call s:hi('PmenuSel', 'black', 'keyword', '')
call s:hi('PmenuSbar', '', 'border', '')
call s:hi('PmenuThumb', '', 'br_black', '')
call s:hi('StatusLine', 'white', 'bg_alt', 'bold')
call s:hi('StatusLineNC', 'muted_alt', 'bg_alt', '')
call s:hi('VertSplit', 'border', 'bg', '')
call s:hi('TabLine', 'muted_alt', 'bg_alt', '')
call s:hi('TabLineSel', 'white', 'bg', '')
call s:hi('TabLineFill', '', 'bg_alt', '')
call s:hi('Folded', 'muted_alt', 'bg_float', 'italic')
call s:hi('FoldColumn', 'br_black', 'bg', '')
call s:hi('NonText', 'border', 'NONE', '')
call s:hi('SpecialKey', 'border', 'NONE', '')
call s:hi('Directory', 'func', 'NONE', '')
call s:hi('Title', 'keyword', 'NONE', 'NONE')
call s:hi('Question', 'ok', 'NONE', '')
call s:hi('MoreMsg', 'ok', 'NONE', '')
call s:hi('ErrorMsg', 'error', 'NONE', '')
call s:hi('WarningMsg', 'warn', 'NONE', '')
call s:hi('WildMenu', 'black', 'keyword', '')
call s:hi('Cursor', 'black', 'white', '')
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
call s:hi('cIncluded', 'yellow', 'NONE', 'NONE')
call s:hi('Namespace', 'white', 'NONE', 'NONE')
call s:hi('cCustomNamespace', 'white', 'NONE', 'NONE')
call s:hi('cppModifier', 'white', 'NONE', 'NONE')
call s:hi('ScopedIdentifier', 'white', 'NONE', 'NONE')
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
call s:hi('CocFloating', 'white', 'bg_popup', '')
call s:hi('CocFloatSbar', '', 'border', '')
call s:hi('CocFloatThumb', '', 'br_black', '')
call s:hi('CocFloatDivider', 'border', 'bg_popup', '')
call s:hi('CocMenuSel', 'black', 'keyword', '')
call s:hi('CocSearch', 'func', 'NONE', 'NONE')
call s:hi('CocInlayHint', 'br_black', 'bg_popup', 'italic')
call s:hi('CocFadeOut', 'br_black', 'NONE', 'italic')
call s:hi('CocCodeLens', 'br_black', 'NONE', 'italic')

call s:hi('CocSemTypeClass', 'cyan', 'NONE', 'NONE')
call s:hi('CocSemTypeStruct', 'cyan', 'NONE', 'NONE')
call s:hi('CocSemTypeClassModDefaultLibrary', 'cyan', 'NONE', 'NONE')
call s:hi('CocSemTypeFunctionModDefaultLibrary', 'yellow', 'NONE', 'NONE')
call s:hi('CocSemTypeEnum', 'green', 'NONE', 'NONE')
call s:hi('CocSemTypeEnumMember', 'green', 'NONE', 'NONE')
call s:hi('CocSemTypeString', 'magenta', 'NONE', 'NONE')
call s:hi('CocSemTypeNumber', 'green', 'NONE', 'NONE')
call s:hi('CocSemTypeInterface', 'cyan', 'NONE', 'NONE')
call s:hi('CocSemTypeTypeParameter', 'cyan', 'NONE', 'NONE')
call s:hi('CocSemTypeType', 'type', 'NONE', 'NONE')
call s:hi('CocSemTypeTypedef', 'type', 'NONE', 'NONE')
call s:hi('CocSemTypeNamespace', 'white', 'NONE', 'NONE')
call s:hi('CocSemTypeFunction', 'func', 'NONE', 'NONE')
call s:hi('CocSemTypeMethod', 'func', 'NONE', 'NONE')
call s:hi('CocSemTypeParameter', 'lvar', 'NONE', 'NONE')
call s:hi('CocSemTypeVariable', 'lvar', 'NONE', 'NONE')
call s:hi('CocSemTypeProperty', 'lvar', 'NONE', 'NONE')
call s:hi('CocSemTypeVariableModGlobalScope', 'white', 'NONE', 'NONE')
call s:hi('CocSemTypeVariableModGlobalScopeDeclaration', 'white', 'NONE', 'NONE')
call s:hi('CocSemTypeVariableModFileScope', 'white', 'NONE', 'NONE')
call s:hi('CocSemTypeVariableModFileScopeDeclaration', 'white', 'NONE', 'NONE')
call s:hi('CocSemTypeVariableModStatic', 'white', 'NONE', 'NONE')
call s:hi('CocSemTypeVariableModStaticDeclaration', 'white', 'NONE', 'NONE')
call s:hi('CocSemTypeModVariableGlobalScope', 'white', 'NONE', 'NONE')
call s:hi('CocSemTypeModVariableGlobalScopeDeclaration', 'white', 'NONE', 'NONE')
call s:hi('CocSemTypeModVariableFileScope', 'white', 'NONE', 'NONE')
call s:hi('CocSemTypeModVariableStatic', 'white', 'NONE', 'NONE')
call s:hi('CocSemTypeModPropertyStatic', 'white', 'NONE', 'NONE')
call s:hi('CocSemTypeMacro', 'magenta', 'NONE', 'NONE')
call s:hi('CocSemTypeKeyword', 'keyword', 'NONE', 'NONE')
call s:hi('CocSemTypeComment', 'comment', 'NONE', 'italic')
call s:hi('CocSemTypeOperator', 'operator', 'NONE', 'NONE')
call s:hi('CocSemTypeOperatorModKeyword', 'white', 'NONE', 'NONE')
call s:hi('CocSemTypeModOperatorKeyword', 'white', 'NONE', 'NONE')

call s:hi('DiffAdd', 'ok', 'diff_add_bg', '')
call s:hi('DiffChange', 'warn', 'diff_change_bg', '')
call s:hi('DiffDelete', 'error', 'diff_delete_bg', '')
call s:hi('DiffText', 'white', 'diff_text_bg', 'NONE')

call s:hi('SpellBad', '', '', 'undercurl')
call s:hi('SpellCap', '', '', 'undercurl')
call s:hi('SpellRare', '', '', 'undercurl')
call s:hi('SpellLocal', '', '', 'undercurl')

call s:hi('CocTarget', 'white', 'visual', '')

" Fix LSP / CoC document highlights (word under cursor matching)
call s:hi('LspReferenceText', 'white', 'visual', '')
call s:hi('LspReferenceRead', 'white', 'visual', '')
call s:hi('LspReferenceWrite', 'white', 'visual', '')

" Fix QuickFix active selection line
call s:hi('QuickFixLine', 'white', 'visual', '')
call s:hi('CocHighlightText', 'white', 'visual', '')

" If using CoC, ensure its internal target highlights match too
highlight! link CocHighlightText Visual