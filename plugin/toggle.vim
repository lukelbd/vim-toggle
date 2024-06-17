"------------------------------------------------------------------------------
" Vim Toggle Plugin
" Author: Timo Teifel (timo at teifel-net dot de)
" Forked: Luke Davis (lukelbd at gmail dot com)
" Licence: GPL v2.0
"------------------------------------------------------------------------------
" Command and mapping
exe exists('g:loaded_toggle') ? 'finish' : ''
let g:loaded_toggle = 1
let g:toggle_map = get(g:, 'toggle_map', '<Leader>b')  " default mapping
command! -range Toggle <line1>,<line2>call toggle#toggle(0, <count>)
nnoremap <Plug>Toggle <Cmd>call toggle#toggle(1)<CR>
xnoremap <Plug>Toggle <Esc><Cmd>call toggle#toggle(1, visualmode())<CR>
if !empty(g:toggle_map)
  exe 'nmap ' . g:toggle_map . ' <Plug>Toggle'
  exe 'xmap ' . g:toggle_map . ' <Plug>Toggle'
endif

" Global settings
if !exists('g:toggle_chars_off')  " [] is allowed
  let g:toggle_chars_off = ['-', '<', '&', '0'] + get(g:, 'toggle_consecutive_off', [])
endif
if !exists('g:toggle_chars_on')  " [] is allowed
  let g:toggle_chars_on  = ['+', '>', '|', '1'] + get(g:, 'toggle_consecutive_on', [])
endif
if !exists('g:toggle_words_off')  " [] is allowed
  let g:toggle_words_off = ['false', 'off', 'no', 'undef', 'out', 'down', 'right', 'south', 'west']
endif
if !exists('g:toggle_words_on')  " [] is allowed
  let g:toggle_words_on  = ['true', 'on', 'yes', 'define', 'in', 'up', 'left', 'north', 'east']
endif
