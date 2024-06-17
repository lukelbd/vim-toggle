"------------------------------------------------------------------------------
" Vim Toggle Plugin
" Author: Timo Teifel (timo at teifel-net dot de)
" Forked: Luke Davis (lukelbd at gmail dot com)
" Licence: GPL v2.0
"------------------------------------------------------------------------------
" Standardize settings
function! s:toggle_validate() abort
  let chars = [g:toggle_chars_off, g:toggle_chars_on]
  let words = [g:toggle_words_off, g:toggle_words_on]
  for name in ['toggle_chars', 'toggle_words']
    let name0 = name . '_off'
    let name1 = name . '_on'
    let opts0 = get(g:, name0, [])
    let opts1 = get(g:, name1, [])
    for opts in [opts0, opts1]
      call map(opts, {idx, val -> type(val) == 1 ? val : string(val)})
    endfor
    if len(opts0) > len(opts1)
      let [name0, name1, opts0, opts1] = [name1, name0, opts1, opts0]
    endif
    if len(opts1) > len(opts0)
      let delta = len(opts1) - len(opts0)
      echohl WarningMsg
      echom 'Warning: Truncating ' . name1 . ' (has ' . delta . ' more entries than ' . name0 . ')'
      echohl None
      call remove(opts1, len(opts0), len(opts1) - 1)
    endif
  endfor
endfunction

" Private driver fucntion
function! s:toggle_cursor(...) abort
  " Toggle sign of integers and floats under cursor
  " This skips non-float sequences of zeros and ones
  let strict = a:0 ? a:1 : 0  " strict range restriction
  let regex = '\([+-]\s*\)\?\(\<[0-9_]\+\(\.[0-9_]*\)\?\|\.[0-9_]\+\>\)'
  let line = getline('.')
  let [idx0, idx1] = [0, 0]
  let [lnum, cnum] = [line('.'), col('.')]
  while idx0 != -1
    let [float, idx0, idx1] = matchstrpos(line, regex, idx1)
    if cnum < idx0 + 1 || cnum > idx1  " note 'idx1' is the end plus one
      continue
    endif
    if empty(float) || float =~# '^[01]\+$'
      continue
    endif
    let sign = float[0] ==# '-' ? '+' : '-'
    let head = strpart(line, 0, idx0)
    let tail = strpart(line, idx0 + (float[0] =~# '[+-]'))
    let offset = 2 * len(head . sign . tail) - len(float)
    call setline(lnum, head . sign . tail)
    call cursor(lnum, cnum + offset + 1)
    return 0
  endwhile

  " Toggle sign of keyword under cursor
  " This is used for e.g. true/false yes/no on/off words
  call s:toggle_validate()
  let word = expand('<cword>')
  let ion = index(g:toggle_words_on, word, 0, 1)  " 1 == case insensitive
  let ioff = index(g:toggle_words_off, word, 0, 1)
  if ioff != -1 || ion != -1
    if ioff != -1
      let other = g:toggle_words_on[ioff]
    else
      let other = g:toggle_words_off[ion]
    endif
    if word =~# '^\u\+$'  " upper case
      let other = substitute(other, '\(.\)', '\u\1', 'g')
    elseif word =~# '^\u'  " title case
      let other = substitute(other, '^\(.\)\(.*\)$', '\u\1\l\2', '')
    else  " lower case
      let other = substitute(other, '\(.\)', '\l\1', 'g')
    endif
    exe 'normal! ciw' . other
    let offset = 2 * len(other) - len(word)
    call cursor(lnum, cnum + offset + 1)
    return 0
  endif

  " Toggle consecutive on-off characters under cursor
  " This is used to translate &/|/+/-/0/1 sequences
  let char = strcharpart(line, charidx(line, cnum - 1), 1)
  let ioff = index(g:toggle_chars_off, char, 0, 1)
  let ion = index(g:toggle_chars_on, char, 0, 1)
  if ioff != -1 || ion != -1
    let chars = []
    if ioff != -1
      let other = strcharpart(g:toggle_chars_on[ioff], 0, 1)
    else
      let other = strcharpart(g:toggle_chars_off[ion], 0, 1)
    endif
    let part = '[' . char . other . ']'
    let regex = '\%' . cnum . 'c' . part
    let regex = strict ? regex : part . '*' . regex . '\+'
    let [ichars, idx0, idx1] = matchstrpos(line, '\c' . regex)
    for ichar in split(ichars, '\zs')
      let jchar = ichar ==? char ? other : char
      let jchar = ichar =~# '\u' ? toupper(jchar) : tolower(jchar)
      call add(chars, jchar)
    endfor
    let other = join(chars, '')
    let head = strpart(line, 0, idx0)
    let tail = strpart(line, idx1)
    call setline(lnum, head . other . tail)
    call cursor(lnum, idx1 + 1)  " idx1 is index after match
    return 0
  else  " toggle failed
    let status = char =~# '\_s' ? -1 : 1
    call cursor(lnum, cnum + 1)
    return status
  endif
endfunction

" Public driver function
function! toggle#toggle(...) abort range
  " Initial stuff
  let range = a:0 > 1 ? a:2 : 0
  let repeat = a:0 > 0 ? a:1 : 0
  let count0 = 0  " toggle succeeded
  let count1 = 0  " failed for non-space under cursor
  let count2 = 0  " failed for space under cursor
  if empty(range)
    let lnums = [line('.'), line('.')]
  elseif type(range)  " visual selection
    let lnums = [line("'<"), line("'>")]
  else  " command range
    let lnums = [a:firstline, a:lastline]
  endif

  " Toggle over range
  let winview = winsaveview()
  for lnum in sort(call('range', lnums))
    if empty(range)  " cursor only
      let [col1, col2, strict] = [col('.'), col('.'), 0]
    elseif !type(range) || range ==# 'V'  " visual line
      let [col1, col2, strict] = [1, col([lnum, '$']), 0]
    elseif range ==# 'v'  " visual non-line
      let col1 = lnum == lnums[0] ? col("'<") : 1
      let col2 = lnum == lnums[-1] ? col("'>") : col([lnum, '$'])
      let strict = lnum == lnums[0] || lnum == lnums[-1]  " cursor characters only
    else  " visual block
      let col1 = min([col("'<"), col("'>")])
      let col2 = max([col("'<"), col("'>")])
      let strict = 1  " cursor charactrers only
    endif
    let cnum = -1
    call cursor(lnum, col1)
    while col('.') > cnum && col('.') <= col2
      let cnum = col('.')  " record column
      let status = s:toggle_cursor(strict)
      let count0 += status ? 0 : 1
      let count1 += status > 0 ? status : 0
      let count2 -= status < 0 ? status : 0
    endwhile
  endfor

  " Repeat and provide message
  if repeat && exists('*repeat#set')
    call repeat#set("\<Plug>Toggle")
  endif
  call winrestview(winview)
  redraw
  let label = count0 ? 'Warning' : 'Error'
  let icount = count1 ? count1 : count2
  let ncount = count0 + icount
  let status = count1 || !count0 ? icount : 0
  if status  " error or warning message
    let msg = label . ': Toggle failed for '
    let msg .= ncount > 1 ? icount . '/' . ncount . ' items' : 'item'
    let msg .= empty(range) ? ' under the cursor.' : ' in the range.'
    exe 'echohl ' . label . 'Msg' | echom msg | echohl None
  endif
  return status
endfunction
