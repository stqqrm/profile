" base16.vim

set background=dark
highlight clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "base16"

if !exists('g:my_theme_transparent')
  let g:my_theme_transparent = 1
endif

" 1. Token Definition Registry (0-15 ANSI Indices)
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
      \ 'bg': g:my_theme_transparent && !has('gui_running') ? 'NONE' : 0,
      \ 'bg_alt': 8,
      \ 'bg_float': 8,
      \ 'bg_popup': 0,
      \ 'border': 8,
      \ 'line_nr': 8,
      \ 'visual': 4,
      \
      \ 'diff_add_bg': 2,
      \ 'diff_change_bg': 6,
      \ 'diff_delete_bg': 4,
      \ 'diff_text_bg': 3,
      \
      \ 'NONE': 'NONE'
      \ }

let g:base16_gui_black      = 'Black'
let g:base16_gui_red        = 'Red'
let g:base16_gui_green      = 'Green'
let g:base16_gui_yellow     = 'Yellow'
let g:base16_gui_blue       = 'Blue'
let g:base16_gui_magenta    = 'Magenta'
let g:base16_gui_cyan       = 'Cyan'
let g:base16_gui_white      = 'LightGray'
let g:base16_gui_br_black   = 'DarkGray'
let g:base16_gui_br_red     = 'LightRed'
let g:base16_gui_br_green   = 'LightGreen'
let g:base16_gui_br_yellow  = 'LightYellow'
let g:base16_gui_br_blue    = 'LightBlue'
let g:base16_gui_br_magenta = 'LightMagenta'
let g:base16_gui_br_cyan    = 'LightCyan'
let g:base16_gui_br_white   = 'White'

let s:gui_colors = [
      \ g:base16_gui_black,
      \ g:base16_gui_red,
      \ g:base16_gui_green,
      \ g:base16_gui_yellow,
      \ g:base16_gui_blue,
      \ g:base16_gui_magenta,
      \ g:base16_gui_cyan,
      \ g:base16_gui_white,
      \ g:base16_gui_br_black,
      \ g:base16_gui_br_red,
      \ g:base16_gui_br_green,
      \ g:base16_gui_br_yellow,
      \ g:base16_gui_br_blue,
      \ g:base16_gui_br_magenta,
      \ g:base16_gui_br_cyan,
      \ g:base16_gui_br_white,
      \ ]

let s:use_gui_colors = has('gui_running')

" Semantic Aliases
let s:tokens['keyword']   = s:tokens['br_red']
let s:tokens['func']      = s:tokens['br_yellow']
let s:tokens['type']      = s:tokens['br_blue']
let s:tokens['lvar']      = s:tokens['br_white']
let s:tokens['string']    = s:tokens['br_magenta']
let s:tokens['number']    = s:tokens['br_green']
let s:tokens['comment']   = s:tokens['white']
let s:tokens['operator']  = s:tokens['br_white']
let s:tokens['preproc']   = s:tokens['white']
let s:tokens['special']   = s:tokens['br_cyan']
let s:tokens['error']     = s:tokens['br_red']
let s:tokens['warn']      = s:tokens['br_yellow']
let s:tokens['info']      = s:tokens['br_blue']
let s:tokens['hint']      = s:tokens['br_cyan']
let s:tokens['ok']        = s:tokens['br_green']

" Highlight Function (Handles cterm, guifg/guibg=NONE, and 8-color fallback)
function! s:hi(group, fg_token, bg_token, attr)
  let l:cmd = 'highlight ' . a:group
  let l:attrs = []
  if a:attr != ''
    call add(l:attrs, (a:attr ==# 'italic') ? 'NONE' : a:attr)
  endif

  " Handle Foreground
  if a:fg_token != '' && has_key(s:tokens, a:fg_token)
    let l:fg = s:tokens[a:fg_token]
    if type(l:fg) == v:t_number
      " GUI: real hex from the array, indexed by the same ANSI number
      let l:cmd .= s:use_gui_colors
            \ ? (' guifg=' . s:gui_colors[l:fg])
            \ : ' guifg=NONE'
      " 8-color fallback (cterm only): fold bright tokens down, add bold
      if &t_Co < 16 && l:fg >= 8 && l:fg <= 15
        let l:fg = l:fg - 8
        if index(l:attrs, 'bold') < 0
          call add(l:attrs, 'bold')
        endif
      endif
      let l:cmd .= ' ctermfg=' . l:fg
    else
      " 'NONE' or other string token
      let l:cmd .= ' guifg=' . l:fg . ' ctermfg=' . l:fg
    endif
  endif

  " Handle Background
  if a:bg_token != '' && has_key(s:tokens, a:bg_token)
    let l:bg = s:tokens[a:bg_token]
    if type(l:bg) == v:t_number
      let l:cmd .= s:use_gui_colors
            \ ? (' guibg=' . s:gui_colors[l:bg])
            \ : ' guibg=NONE'
      if &t_Co < 16 && l:bg >= 8 && l:bg <= 15
        let l:bg = l:bg - 8
      endif
      let l:cmd .= ' ctermbg=' . l:bg
    else
      let l:cmd .= ' guibg=' . l:bg . ' ctermbg=' . l:bg
    endif
  endif

  " Handle Attributes
  if !empty(l:attrs)
    if len(l:attrs) > 1
      call filter(l:attrs, 'v:val !=# "NONE"')
    endif
    let l:cmd .= ' cterm=' . join(l:attrs, ',')
  endif

  execute l:cmd
endfunction

" 3. Highlighting Definitions
set cursorline

" Editor UI
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
call s:hi('PmenuSel', 'br_black', 'keyword', '')
call s:hi('PmenuSbar', '', 'border', '')
call s:hi('PmenuThumb', '', 'br_black', '')
call s:hi('StatusLine', 'br_white', 'bg_alt', '')
call s:hi('StatusLineNC', 'white', 'bg_alt', '')
call s:hi('VertSplit', 'border', 'bg', '')
call s:hi('TabLine', 'white', 'bg_alt', '')
call s:hi('TabLineSel', 'br_white', 'bg', '')
call s:hi('TabLineFill', '', 'bg_alt', '')
call s:hi('Folded', 'white', 'bg_float', 'italic')
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
call s:hi('WildMenu', 'br_black', 'keyword', '')
call s:hi('Cursor', 'br_black', 'br_white', '')
call s:hi('EndOfBuffer', 'border', 'NONE', '')

" Syntax Groups
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
call s:hi('Operator', 'keyword', 'NONE', 'NONE')
call s:hi('Delimiter', 'operator', 'NONE', 'NONE')
call s:hi('Comment', 'comment', 'NONE', 'italic')
call s:hi('SpecialComment', 'func', 'NONE', 'italic')
call s:hi('PreProc', 'preproc', 'NONE', 'NONE')
call s:hi('Include', 'preproc', 'NONE', 'NONE')
call s:hi('Define', 'preproc', 'NONE', 'NONE')
call s:hi('Macro', 'preproc', 'NONE', 'NONE')
call s:hi('PreCondit', 'preproc', 'NONE', 'NONE')
call s:hi('Special', 'special', 'NONE', 'NONE')
call s:hi('SpecialChar', 'number', 'NONE', 'NONE')
call s:hi('Tag', 'func', 'NONE', 'NONE')
call s:hi('Debug', 'error', 'NONE', 'NONE')
call s:hi('Underlined', 'func', 'NONE', 'underline')
call s:hi('Ignore', 'br_black', 'NONE', 'NONE')
call s:hi('Error', 'error', 'NONE', 'NONE')
call s:hi('Todo', 'warn', 'NONE', 'italic')

" C / C++ Specific
call s:hi('cppBoolean', 'number', 'NONE', 'NONE')
call s:hi('cIncluded', 'br_yellow', 'NONE', 'NONE')
call s:hi('Namespace', 'br_white', 'NONE', 'NONE')
call s:hi('cCustomNamespace', 'br_white', 'NONE', 'NONE')
call s:hi('cppModifier', 'br_white', 'NONE', 'NONE')
call s:hi('ScopedIdentifier', 'br_white', 'NONE', 'NONE')
call s:hi('cType', 'type', 'NONE', 'NONE')
call s:hi('cCustomType', 'type', 'NONE', 'NONE')

" CoC / LSP Diagnostics
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

" CoC Floating UI & Completion Menu
call s:hi('CocFloating', 'br_white', 'br_black', '')
call s:hi('CocPumFloat', 'br_white', 'br_black', '')
call s:hi('CocFloatSbar', '', 'br_black', '')
call s:hi('CocFloatThumb', '', 'br_black', '')
call s:hi('CocFloatDivider', 'white', 'br_black', '')
call s:hi('CocMenuSel', 'br_white', 'green', '')
call s:hi('CocPumMenu', 'white', 'NONE', '')
call s:hi('CocPumSearch', 'br_cyan', 'NONE', '')
call s:hi('CocPumShortcut', 'white', 'NONE', '')
call s:hi('CocPumDetail', 'white', 'NONE', '')
call s:hi('CocPumDeprecated', 'white', 'NONE', 'strikethrough')
call s:hi('CocSearch', 'func', 'NONE', 'NONE')
call s:hi('CocInlayHint', 'white', 'br_black', 'italic')
call s:hi('CocFadeOut', 'br_black', 'NONE', 'italic')
call s:hi('CocCodeLens', 'br_black', 'NONE', 'italic')

" CoC Semantic Tokens
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
call s:hi('CocSemTypeParameter', 'white', 'NONE', 'NONE')
call s:hi('CocSemTypeVariable', 'lvar', 'NONE', 'NONE')
call s:hi('CocSemTypeVariableModGlobalScope', 'br_white', 'NONE', 'NONE')
call s:hi('CocSemTypeVariableModFileScopeDeclaration', 'br_white', 'NONE', 'NONE')
call s:hi('CocSemTypeVariableModGlobalScopeDeclaration', 'br_white', 'NONE', 'NONE')
call s:hi('CocSemTypeVariableModStatic', 'br_white', 'NONE', 'NONE')
call s:hi('CocSemTypeVariableModFileScope', 'br_white', 'NONE', 'NONE')
call s:hi('CocSemTypeVariableModStaticDeclaration', 'br_white', 'NONE', 'NONE')
call s:hi('CocSemTypeModVariableGlobalScope', 'br_white', 'NONE', 'NONE')
call s:hi('CocSemTypeModVariableGlobalScopeDeclaration', 'br_white', 'NONE', 'NONE')
call s:hi('CocSemTypeProperty', 'lvar', 'NONE', 'NONE')
call s:hi('CocSemTypeModVariableFileScope', 'br_white', 'NONE', 'NONE')
call s:hi('CocSemTypeModVariableStatic', 'br_white', 'NONE', 'NONE')
call s:hi('CocSemTypeModPropertyStatic', 'br_white', 'NONE', 'NONE')
call s:hi('CocSemTypeMacro', 'br_magenta', 'NONE', 'NONE')
call s:hi('CocSemTypeKeyword', 'keyword', 'NONE', 'NONE')
call s:hi('CocSemTypeComment', 'comment', 'NONE', 'italic')
call s:hi('CocSemTypeOperator', 'operator', 'NONE', 'NONE')
call s:hi('CocSemTypeOperatorModKeyword', 'br_white', 'NONE', 'NONE')
call s:hi('CocSemTypeModOperatorKeyword', 'br_white', 'NONE', 'NONE')
call s:hi('CocSemVariableGlobalScope', 'white', 'NONE', 'NONE')

" Diff & Spell
call s:hi('DiffAdd', 'ok', 'diff_add_bg', '')
call s:hi('DiffChange', 'warn', 'diff_change_bg', '')
call s:hi('DiffDelete', 'error', 'diff_delete_bg', '')
call s:hi('DiffText', 'br_white', 'diff_text_bg', 'NONE')

call s:hi('SpellBad', '', '', 'undercurl')
call s:hi('SpellCap', '', '', 'undercurl')
call s:hi('SpellRare', '', '', 'undercurl')
call s:hi('SpellLocal', '', '', 'undercurl')

" QuickFix & Reference Highlights
call s:hi('CocTarget', 'br_white', 'visual', '')
call s:hi('LspReferenceText', 'br_white', 'visual', '')
call s:hi('LspReferenceRead', 'br_white', 'visual', '')
call s:hi('LspReferenceWrite', 'br_white', 'visual', '')
call s:hi('QuickFixLine', 'br_white', 'visual', '')
call s:hi('CocHighlightText', 'br_white', 'visual', '')

" ALE Diagnostics
call s:hi('ALEError', '', 'NONE', 'undercurl')
call s:hi('ALEWarning', '', 'NONE', 'undercurl')
call s:hi('ALEInfo', '', 'NONE', 'undercurl')
call s:hi('ALEErrorSign', 'error', 'NONE', '')
call s:hi('ALEWarningSign', 'warn', 'NONE', '')
call s:hi('ALEVirtualTextError', 'error', 'NONE', 'italic')
call s:hi('ALEVirtualTextWarning', 'warn', 'NONE', 'italic')

highlight! link CocHighlightText Visual
