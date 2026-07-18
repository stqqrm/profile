" my-theme.vim - Gruvbox Material Muted Pastel Edition
" Requires: set termguicolors in vimrc

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
" Each token contains [gui_color, cterm_color]
let s:tokens = {
\ 'black':       ['#32302f', 'Black'],
\ 'red':         ['#ea6962', 'Red'],
\ 'green':       ['#a9b665', 'Green'],
\ 'yellow':      ['#d8a657', 'Yellow'],
\ 'blue':        ['#7daea3', 'Blue'],
\ 'magenta':     ['#d3869b', 'Magenta'],
\ 'cyan':        ['#89b482', 'Cyan'],
\ 'white':       ['#d4be98', 'White'],
\ 'br_black':    ['#52504f', 'DarkGray'],
\
\ 'bg':          [g:my_theme_transparent ? 'NONE' : '#030000', g:my_theme_transparent ? 'NONE' : 'Black'],
\ 'bg_alt':      ['#2a2827', 'DarkGray'],
\ 'bg_float':    ['#252322', 'DarkGray'],
\ 'bg_popup':    ['#212020', 'Black'],
\ 'border':      ['#3e3c3b', 'DarkGray'],
\ 'line_nr':     ['#555352', 'DarkGray'],
\ 'visual':      ['#243142', 'Black'],
\
\ 'diff_add_bg':    ['#25331f', 'DarkGreen'],
\ 'diff_change_bg': ['#382f1d', 'DarkYellow'],
\ 'diff_delete_bg': ['#361f1f', 'DarkRed'],
\ 'diff_text_bg':   ['#213333', 'DarkCyan'],
\
\ 'NONE':        ['NONE', 'NONE']
\ }

" Semantic Aliases
let s:tokens['keyword']  = s:tokens['red']
let s:tokens['func']     = s:tokens['yellow']
let s:tokens['type']     = s:tokens['blue']
let s:tokens['lvar']     = s:tokens['white']
let s:tokens['string']   = s:tokens['magenta']
let s:tokens['number']   = s:tokens['green']
let s:tokens['comment']  = s:tokens['br_black']
let s:tokens['operator'] = s:tokens['cyan']
let s:tokens['preproc']  = s:tokens['br_black']
let s:tokens['special']  = s:tokens['cyan']
let s:tokens['error']    = s:tokens['red']
let s:tokens['warn']     = s:tokens['yellow']
let s:tokens['info']     = s:tokens['blue']
let s:tokens['hint']     = s:tokens['cyan']
let s:tokens['ok']       = s:tokens['green']

" Terminal colors
let g:terminal_ansi_colors = [
\ s:tokens['black'][0], s:tokens['red'][0], s:tokens['green'][0], s:tokens['yellow'][0],
\ s:tokens['blue'][0], s:tokens['magenta'][0], s:tokens['cyan'][0], s:tokens['white'][0],
\ s:tokens['br_black'][0], s:tokens['red'][0], s:tokens['green'][0], s:tokens['yellow'][0],
\ s:tokens['blue'][0], s:tokens['magenta'][0], s:tokens['cyan'][0], s:tokens['white'][0]
\ ]

" 2. Refactored Highlight Function
function! s:hi(group, fg_token, bg_token, attr)
	let l:cmd = 'highlight ' . a:group

	" Handle Foreground
	if a:fg_token != '' && has_key(s:tokens, a:fg_token)
		let l:cmd .= ' guifg=' . s:tokens[a:fg_token][0] . ' ctermfg=' . s:tokens[a:fg_token][1]
	endif

	" Handle Background
	if a:bg_token != '' && has_key(s:tokens, a:bg_token)
		let l:cmd .= ' guibg=' . s:tokens[a:bg_token][0] . ' ctermbg=' . s:tokens[a:bg_token][1]
	endif

	" Handle Attributes
	if a:attr != ''
		let l:cmd .= ' gui=' . a:attr . ' cterm=' . a:attr
	endif

	execute l:cmd
endfunction

" 3. Highlighting Definitions
set cursorline

call s:hi('Normal',			'white',	'bg',		'NONE')
call s:hi('NormalFloat',	'white',	'bg_popup',	'')
call s:hi('SignColumn',		'br_black',	'bg',		'')
call s:hi('ColorColumn',	'',			'bg_float',	'')
call s:hi('CursorLine',		'',			'bg',		'NONE')
call s:hi('CursorLineNr',	'yellow',	'bg',		'NONE')
call s:hi('LineNr',			'line_nr',	'bg',		'')
call s:hi('Visual',			'white',	'visual',	'')
call s:hi('VisualNOS',		'white',	'visual',	'')
call s:hi('Search',			'white',	'visual',	'')
call s:hi('IncSearch',		'white',	'visual',	'')
call s:hi('MatchParen',		'red',		'NONE',		'NONE')
call s:hi('Pmenu',			'white',	'bg_popup',	'')
call s:hi('PmenuSel',		'black',	'keyword',	'')
call s:hi('PmenuSbar',		'',			'border',	'')
call s:hi('PmenuThumb',		'',			'br_black',	'')
call s:hi('StatusLine',		'white',	'bg_alt',	'bold')
call s:hi('StatusLineNC',	'br_black',	'bg_alt',	'')
call s:hi('VertSplit',		'border',	'bg',		'')
call s:hi('TabLine',		'br_black',	'bg_alt',	'')
call s:hi('TabLineSel',		'white',	'bg',		'')
call s:hi('TabLineFill',	'',			'bg_alt',	'')
call s:hi('Folded',			'br_black',	'bg_float',	'italic')
call s:hi('FoldColumn',		'br_black',	'bg',		'')
call s:hi('NonText',		'border',	'NONE',		'')
call s:hi('SpecialKey',		'border',	'NONE',		'')
call s:hi('Directory',		'func',		'NONE',		'')
call s:hi('Title',			'keyword',	'NONE',		'NONE')
call s:hi('Question',		'ok',		'NONE',		'')
call s:hi('MoreMsg',		'ok',		'NONE',		'')
call s:hi('ErrorMsg',		'error',	'NONE',		'')
call s:hi('WarningMsg',		'warn',		'NONE',		'')
call s:hi('WildMenu',		'black',	'keyword',	'')
call s:hi('Cursor',			'black',	'white',	'')
call s:hi('EndOfBuffer',	'border',	'NONE',		'')

call s:hi('Statement',    'keyword',  'NONE', 'NONE')
call s:hi('Conditional',  'keyword',  'NONE', 'NONE')
call s:hi('Repeat',       'keyword',  'NONE', 'NONE')
call s:hi('Label',        'keyword',  'NONE', 'NONE')
call s:hi('Keyword',      'keyword',  'NONE', 'NONE')
call s:hi('Exception',    'keyword',  'NONE', 'NONE')
call s:hi('Structure',    'keyword',  'NONE', 'NONE')
call s:hi('Typedef',      'type',     'NONE', 'NONE')
call s:hi('StorageClass', 'type',     'NONE', 'NONE')
call s:hi('Type',         'type',     'NONE', 'NONE')
call s:hi('Function',     'func',     'NONE', 'NONE')
call s:hi('Identifier',   'lvar',     'NONE', 'NONE')
call s:hi('String',       'string',   'NONE', 'NONE')
call s:hi('Character',    'string',   'NONE', 'NONE')
call s:hi('Number',       'number',   'NONE', 'NONE')
call s:hi('Float',        'number',   'NONE', 'NONE')
call s:hi('Boolean',      'number',   'NONE', 'NONE')
call s:hi('Constant',     'number',   'NONE', 'NONE')
call s:hi('Operator',     'operator', 'NONE', 'NONE')
call s:hi('Delimiter',    'operator', 'NONE', 'NONE')
call s:hi('Comment',        'comment', 'NONE', 'italic')
call s:hi('SpecialComment', 'func',    'NONE', 'italic')
call s:hi('PreProc',   'preproc', 'NONE', 'NONE')
call s:hi('Include',   'preproc', 'NONE', 'NONE')
call s:hi('Define',    'preproc', 'NONE', 'NONE')
call s:hi('Macro',     'number',  'NONE', 'NONE')
call s:hi('PreCondit', 'preproc', 'NONE', 'NONE')
call s:hi('Special',     'special', 'NONE', 'NONE')
call s:hi('SpecialChar', 'number',   'NONE', 'NONE')
call s:hi('Tag',         'func',     'NONE', 'NONE')
call s:hi('Debug',       'error',    'NONE', 'NONE')
call s:hi('Underlined',  'func',     'NONE', 'underline')
call s:hi('Ignore',      'br_black', 'NONE', 'NONE')
call s:hi('Error',       'error',    'NONE', 'NONE')
call s:hi('Todo',        'warn',     'NONE', 'italic')

call s:hi('cppBoolean',        'number',  'NONE', 'NONE')
call s:hi('cIncluded',         'yellow',  'NONE', 'NONE')
call s:hi('Namespace',         'white',   'NONE', 'NONE')
call s:hi('cCustomNamespace',  'white',   'NONE', 'NONE')
call s:hi('cppModifier',       'white',   'NONE', 'NONE')
call s:hi('ScopedIdentifier',  'white',   'NONE', 'NONE')
call s:hi('cType',             'type',    'NONE', 'NONE')
call s:hi('cCustomType',       'type',    'NONE', 'NONE')

call s:hi('CocErrorSign',    'error', 'NONE', '')
call s:hi('CocWarningSign',  'warn',  'NONE', '')
call s:hi('CocInfoSign',     'info',  'NONE', '')
call s:hi('CocHintSign',     'hint',  'NONE', '')

call s:hi('CocErrorHighlight',   '', 'NONE', 'undercurl')
call s:hi('CocWarningHighlight', '', 'NONE', 'undercurl')
call s:hi('CocInfoHighlight',    '', 'NONE', 'undercurl')
call s:hi('CocHintHighlight',    '', 'NONE', 'undercurl')

call s:hi('CocErrorVirtualText',   'error', 'NONE', 'italic')
call s:hi('CocWarningVirtualText', 'warn',  'NONE', 'italic')
call s:hi('CocInfoVirtualText',    'info',  'NONE', 'italic')
call s:hi('CocHintVirtualText',    'hint',  'NONE', 'italic')

call s:hi('CocFloating',     'white',    'bg_popup', '')
call s:hi('CocFloatSbar',    '',         'border',   '')
call s:hi('CocFloatThumb',   '',         'br_black', '')
call s:hi('CocFloatDivider', 'border',   'bg_popup', '')
call s:hi('CocMenuSel',      'black',    'keyword',  '')
call s:hi('CocSearch',       'func',     'NONE',     'NONE')
call s:hi('CocInlayHint',    'br_black', 'bg_popup', 'italic')
call s:hi('CocFadeOut',      'br_black', 'NONE',     'italic')
call s:hi('CocCodeLens',     'br_black', 'NONE',     'italic')

call s:hi('CocSemTypeClass',        'cyan',    'NONE', 'NONE')
call s:hi('CocSemTypeStruct',       'cyan',    'NONE', 'NONE')

call s:hi('CocSemTypeClassModDefaultLibrary',    'cyan',   'NONE', 'NONE')
call s:hi('CocSemTypeFunctionModDefaultLibrary', 'yellow', 'NONE', 'NONE')

call s:hi('CocSemTypeEnum',          'green',   'NONE', 'NONE')
call s:hi('CocSemTypeEnumMember',    'green',   'NONE', 'NONE')

call s:hi('CocSemTypeString',        'magenta', 'NONE', 'NONE')
call s:hi('CocSemTypeNumber',        'green',   'NONE', 'NONE')

call s:hi('CocSemTypeInterface',     'cyan',    'NONE', 'NONE')
call s:hi('CocSemTypeTypeParameter', 'cyan',    'NONE', 'NONE')
call s:hi('CocSemTypeType',          'type',    'NONE', 'NONE')
call s:hi('CocSemTypeTypedef',       'type',    'NONE', 'NONE')
call s:hi('CocSemTypeNamespace',     'white',   'NONE', 'NONE')
call s:hi('CocSemTypeFunction',      'func',    'NONE', 'NONE')
call s:hi('CocSemTypeMethod',        'func',    'NONE', 'NONE')
call s:hi('CocSemTypeParameter',     'lvar',    'NONE', 'NONE')
call s:hi('CocSemTypeVariable',      'lvar',    'NONE', 'NONE')
call s:hi('CocSemTypeProperty',      'lvar',    'NONE', 'NONE')

call s:hi('CocSemTypeVariableModGlobalScope',            'white', 'NONE', 'NONE')
call s:hi('CocSemTypeVariableModGlobalScopeDeclaration', 'white', 'NONE', 'NONE')
call s:hi('CocSemTypeVariableModFileScope',              'white', 'NONE', 'NONE')
call s:hi('CocSemTypeVariableModFileScopeDeclaration',   'white', 'NONE', 'NONE')
call s:hi('CocSemTypeVariableModStatic',                 'white', 'NONE', 'NONE')
call s:hi('CocSemTypeVariableModStaticDeclaration',      'white', 'NONE', 'NONE')

call s:hi('CocSemTypeModVariableGlobalScope',            'white', 'NONE', 'NONE')
call s:hi('CocSemTypeModVariableGlobalScopeDeclaration', 'white', 'NONE', 'NONE')
call s:hi('CocSemTypeModVariableFileScope',              'white', 'NONE', 'NONE')
call s:hi('CocSemTypeModVariableStatic',                 'white', 'NONE', 'NONE')
call s:hi('CocSemTypeModPropertyStatic',                 'white', 'NONE', 'NONE')

call s:hi('CocSemTypeMacro',         'magenta', 'NONE', 'NONE')
call s:hi('CocSemTypeKeyword',       'keyword', 'NONE', 'NONE')
call s:hi('CocSemTypeComment',       'comment', 'NONE', 'italic')
call s:hi('CocSemTypeOperator',      'operator','NONE', 'NONE')

call s:hi('CocSemTypeOperatorModKeyword', 'white', 'NONE', 'NONE')
call s:hi('CocSemTypeModOperatorKeyword', 'white', 'NONE', 'NONE')

call s:hi('DiffAdd',    'ok',    'diff_add_bg', '')
call s:hi('DiffChange', 'warn',  'diff_change_bg', '')
call s:hi('DiffDelete', 'error', 'diff_delete_bg', '')
call s:hi('DiffText',   'white', 'diff_text_bg', 'NONE')

call s:hi('SpellBad',   '', '', 'undercurl')
call s:hi('SpellCap',   '', '', 'undercurl')
call s:hi('SpellRare',  '', '', 'undercurl')
call s:hi('SpellLocal', '', '', 'undercurl')
call s:hi('CocTarget',  'white', 'visual', '')

" Fix LSP / CoC document highlights (word under cursor matching)
call s:hi('LspReferenceText',  'white', 'visual', '')
call s:hi('LspReferenceRead',  'white', 'visual', '')
call s:hi('LspReferenceWrite', 'white', 'visual', '')

" Fix QuickFix active selection line
call s:hi('QuickFixLine',      'white', 'visual', '')
call s:hi('CocHighlightText',  'white', 'visual', '')

" If using CoC, ensure its internal target highlights match too
highlight! link CocHighlightText Visual
