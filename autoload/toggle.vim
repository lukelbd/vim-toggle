"------------------------------------------------------------------------------
" Vim Toggle Plugin
" Author: Timo Teifel (timo at teifel-net dot de)
" Forked: Luke Davis (lukelbd at gmail dot com)
" Licence: GPL v2.0
"------------------------------------------------------------------------------
" Usage:
" Drop into your plugin directory, the 'map' below toggles values under cursor.
" If cursor is positioned on a number, the function looks for a + or - sign in
" front of that number and toggles it. If the number doesn't have a sign, and
" is not a boolean 0/1 or binary 0/1 sequence, or minus sign is prepended.
"------------------------------------------------------------------------------
" Public driver function
function! toggle#toggle() abort
  let winview = winsaveview()
  let status = s:toggle_main()
  call winrestview(winview)
  if status
    echohl WarningMsg
    echom 'Cannot toggle word under cursor.'
    echohl None
  endif
endfunction

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
function! s:toggle_main() abort
  " Toggle sign of integers and floats under cursor
  " This skips non-float sequences of zeros and ones
  let regex = '[+-]\?\(\<[0-9_]\+\(\.[0-9_]*\)\?\|\.[0-9_]\+\>\)'
  let line = getline('.')
  let pos = col('.')
  let [idx0, idx1] = [0, 0]
  while idx0 != -1 && idx0 + 1 <= pos
    let [part, idx0, idx1] = matchstrpos(line, regex, idx1)
    if idx1 + 1 < pos
      continue
    endif
    if empty(part) || part =~# '^[01]\+$'
      continue
    endif
    let sign = part[0] ==# '-' ? '+' : '-'
    let head = strpart(line, 0, idx0)
    let tail = strpart(line, idx0 + (part[0] =~# '[+-]'))
    call setline('.', head . sign . tail)
    return 0
  endwhile

  " Toggle sign of keyword under cursor
  " This is used for e.g. true/false yes/no on/off words
  call s:toggle_validate()
  let word = expand('<cword>')
  let ioff = index(g:toggle_words_off, word, 0, 1)
  let ion = index(g:toggle_words_on, word, 0, 1)  " 1 == case insensitive
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
    return 0
  endif

  " Toggle consecutive on-off characters under cursor
  " This is used to translate &/|/+/-/0/1 sequences
  let char = strcharpart(line, charidx(line, pos - 1), 1)
  let ioff = index(g:toggle_chars_off, char, 0, 1)
  let ion = index(g:toggle_chars_on, char, 0, 1)
  if ioff != -1 || ion != -1
    if ioff != -1
      let other = strcharpart(g:toggle_chars_on[ioff], 0, 1)
    else
      let other = strcharpart(g:toggle_chars_off[ion], 0, 1)
    endif
    let chars = []
    let regex = '[' . char . other . ']'
    let regex = '\c' . regex . '*\%' . pos . 'c' . regex . '\+'
    let [part, idx0, idx1] = matchstrpos(line, regex)
    for ichar in split(part, '\zs')
      let jchar = ichar ==? char ? other : char
      let jchar = ichar =~# '\u' ? toupper(jchar) : tolower(jchar)
      call add(chars, jchar)
    endfor
    let other = join(chars, '')
    let head = strpart(line, 0, idx0)
    let tail = strpart(line, idx1)
    call setline('.', head . other . tail)
    return 0
  endif
  return 1
endfunction
