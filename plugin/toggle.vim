"------------------------------------------------------------------------------"
" Vim Toggle Plugin
" Author: Timo Teifel (timo at teifel-net dot de)
" Modified By: Luke Davis (lukelbd at gmail dot com)
" Licence: GPL v2.0
"------------------------------------------------------------------------------"
" Usage:
" Drop into your plugin directory, the 'map' below toggles values under cursor.
" Currently known values are:
"  true     <->     false
"  on       <->     off
"  yes      <->     no
"  +        <->     -
"  >        <->     <
"  0        <->     1
"  define   <->     undef
"  ||       <->     &&
"  &&       <->     ||
"
"  If cursor is positioned on a number, the function looks for a + 
"  or - sign in front of that number and toggels it. If the number
"  doesn't have a sign, one is inserted (- of course).
"
"  On unknown values, nothing happens.
"------------------------------------------------------------------------------"
" Settings
if !exists('g:toggle_map')
  let g:toggle_map = '<Leader>b'
endif
" Mapping and command
exe 'nnoremap '.g:toggle_map.' :Toggle<CR>'
command! Toggle call <sid>toggle()

" Some global settings
if !exists('g:toggle_chars_on')
  let g:toggle_chars_on  = ["+", ">", "1"]
endif
if !exists('g:toggle_chars_off')
  let g:toggle_chars_off = ["-", "<", "0"]
endif
if !exists('g:toggle_consecutive_on')
  let g:toggle_consecutive_on  = ["&"]
endif
if !exists('g:toggle_consecutive_off')
  let g:toggle_consecutive_off = ["|"]
endif
if !exists('g:toggle_words_on')
  let g:toggle_words_on  = ["true", "on", "yes", "define", "in", "up", "left", "north", "east"]
endif
if !exists('g:toggle_words_off')
  let g:toggle_words_off = ["false", "off", "no", "undef", "out", "down", "right", "south", "west"]
endif

" some Helper functions
function! s:Toggle_changeChar(string, pos, char)
  return strpart(a:string, 0, a:pos) . a:char . strpart(a:string, a:pos+1)
endfunction

function! s:Toggle_insertChar(string, pos, char)
  return strpart(a:string, 0, a:pos) . a:char . strpart(a:string, a:pos)
endfunction

function! s:Toggle_changeString(string, beginPos, endPos, newString)
  return strpart(a:string, 0, a:beginPos) . a:newString . strpart(a:string, a:endPos+1)
endfunction

" Main function
function! s:Toggle_main()
  " save values which we have to change temporarily:
  let s:lineNo = line(".")
  let s:columnNo = col(".")

  " gather information needed later
  let s:cline = getline(".")
  let s:charUnderCursor = strpart(s:cline, s:columnNo-1, 1)

  " 1. Check if the single Character has to be toggled
  let s:index_on = index(g:toggle_chars_on, s:charUnderCursor, 0, 1) " case insensitive search
  let s:index_off = index(g:toggle_chars_off, s:charUnderCursor, 0, 1) " case insensitive search
  if s:index_on!=-1
    execute "normal r".g:toggle_chars_off[s:index_on]
    return 0
  elseif s:index_off!=-1
    execute "normal r".g:toggle_chars_on[s:index_off]
    return 0
  endif

  " 2. Check if cursor is on an number. If so, search & toggle sign
  if s:charUnderCursor =~ "\\d"
    " is a number!
    " search for the sign of the number
    let s:colTemp = s:columnNo-1
    let s:foundSpace = 0
    let s:spacePos = -1
    " disable looping through columns
    " while ((s:colTemp >= 0) && (s:toggleDone == 0))
    let s:cuc = strpart(s:cline, s:colTemp, 1)
    if (s:cuc == "+")
      let s:ncline = s:Toggle_changeChar(s:cline, s:colTemp, "-")
      call setline(s:lineNo, s:ncline)
      return 0
    elseif (s:cuc == "-")
      let s:ncline = s:Toggle_changeChar(s:cline, s:colTemp, "+")
      call setline(s:lineNo, s:ncline)
      return 0
    elseif (s:cuc == " ")
      let s:foundSpace = 1
      " save spacePos only if there wasn't one already, so sign
      " is directly before number if there are several spaces
      if (s:spacePos == -1) 
        let s:spacePos = s:colTemp
      endif
      return 0
    elseif (s:cuc !~ "\\s" && s:foundSpace == 1)
      " space already found earlier, now there's something other
      " than space
      " -> the number didn't have a sign. insert - and keep a space
      let s:ncline = s:Toggle_changeChar(s:cline, s:spacePos, " -")
      call setline(s:lineNo, s:ncline)
      return 0
    elseif (s:cuc !~ "\\d" && s:cuc !~ "\\s")
      " any non-digit, non-space character -> insert a - sign
      let s:ncline = s:Toggle_insertChar(s:cline, s:colTemp+1, "-")
      call setline(s:lineNo, s:ncline)
      return 0
    else
      return 1
    endif
    " disable this annoying stupid feature
    " if (s:toggleDone == 0)
    "     " no sign found. insert at beginning of line:
    "     let s:ncline = "-" . s:cline
    "     call setline(s:lineNo, s:ncline)
    "     let s:toggleDone = 1
    " endif
  endif " is a number under the cursor?

  " 3. Check if cursor is on one-or two-character symbol"
  "    Mostly used for && and ||
  let s:nextChar = strpart(s:cline, s:columnNo, 1)
  let s:prevChar = strpart(s:cline, s:columnNo-2, 1)
  let s:index_on = index(g:toggle_consecutive_on, s:charUnderCursor, 0, 1) " case insensitive search
  let s:index_off = index(g:toggle_consecutive_off, s:charUnderCursor, 0, 1) " case insensitive search
  if s:index_on!=-1
    let s:charOther = g:toggle_consecutive_off[s:index_on]
  elseif s:index_off!=-1
    let s:charOther = g:toggle_consecutive_on[s:index_off]
  else
    let s:charOther = ''
  endif
  if len(s:charOther)>0
    if s:prevChar == s:charUnderCursor
      execute "normal r".s:charOther."hr".s:charOther
      return 0
    elseif s:nextChar == s:charUnderCursor
      execute "normal r".s:charOther."lr".s:charOther
      return 0
    else
      execute "normal r".s:charOther
      return 0
    end
  endif

  " 4. Check if complete word can be toggled on
  let s:wordUnderCursor = expand("<cword>")
  let s:index_on = index(g:toggle_words_on, s:wordUnderCursor, 0, 1) " case insensitive search
  let s:index_off = index(g:toggle_words_off, s:wordUnderCursor, 0, 1) " case insensitive search
  if s:index_on!=-1
    let s:wordUnderCursor_tmp = g:toggle_words_off[s:index_on]
  elseif s:index_off!=-1
    let s:wordUnderCursor_tmp = g:toggle_words_on[s:index_off]
  else
    let s:wordUnderCursor_tmp = ''
  endif
  if len(s:wordUnderCursor_tmp)>0
    " preserve case
    if strpart (s:wordUnderCursor, 0) =~ '^\u*$'
      let s:wordUnderCursor = toupper(s:wordUnderCursor_tmp)
    elseif strpart (s:wordUnderCursor, 0, 1) =~ '^\u$'
      let s:wordUnderCursor = toupper(strpart (s:wordUnderCursor_tmp, 0, 1)).strpart (s:wordUnderCursor_tmp, 1)
    else
      let s:wordUnderCursor = s:wordUnderCursor_tmp
    endif
    " if wordUnderCursor is changed, set the new line
    execute "normal ciw" . s:wordUnderCursor
    return 0
  endif

  " If get to this part, we failed
  return 1
endfunction

" Primary function
function! s:toggle()
  " main function call
  let s:status = s:Toggle_main()
  " deliver error message
  if s:status
    echohl WarningMsg
    echo "Can't toggle word under cursor."
    echohl None
  endif
  " unlet used variables to save memory
  unlet! s:charUnderCursor
  unlet! s:cline
  unlet! s:foundSpace
  unlet! s:cuc
  " restore saved values
  call cursor(s:lineNo,s:columnNo)
  unlet! s:lineNo
  unlet! s:columnNo
endfunction
