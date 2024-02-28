"------------------------------------------------------------------------------
" Vim Toggle Plugin
" Author: Timo Teifel (timo at teifel-net dot de)
" Forked: Luke Davis (lukelbd at gmail dot com)
" Licence: GPL v2.0
"------------------------------------------------------------------------------
" Command and mapping
command! Toggle call toggle#toggle()
if !exists('g:toggle_map')  " '' is allowed
  let g:toggle_map = '<Leader>b'
endif
if !empty(g:toggle_map)
  exe 'nnoremap ' . g:toggle_map . ' <Cmd>Toggle<CR>'
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
