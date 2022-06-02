"------------------------------------------------------------------------------"
" Vim Toggle Plugin
" Author: Timo Teifel (timo at teifel-net dot de)
" Modified By: Luke Davis (lukelbd at gmail dot com)
" Licence: GPL v2.0
"------------------------------------------------------------------------------"
" Options
if !exists('g:toggle_map')
  let g:toggle_map = '<Leader>b'
endif
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

" Mapping and command
exe 'nnoremap ' . g:toggle_map . ' <Cmd>Toggle<CR>'
command! Toggle call toggle#toggle()

