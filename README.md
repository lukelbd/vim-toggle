# Toggle
This is a fork of [toggle.vim](https://www.vim.org/scripts/script.php?script_id=895).
This plugin provides a tool for toggling the sign of numbers and
"boolean-ish" things on and off. See below.

## Global options
* `g:toggle_map`: The map used to "toggle" the word or character under the cursor
  on and off. By default, this is `<Leader>b`.
* `g:toggle_chars_on`, `g:toggle_chars_off`: Equal-length lists of characters containing the "on" and "off" values for characters under the cursor. Example pairs include `1, 0` and `+, -`.
* `g:toggle_consecutive_on`, `g:toggle_consecutive_off`: As with `g:toggle_chars_on`, `g:toggle_chars_off`, but this time we will try to look for **consecutive** characters and
  toggle them all at once. By default this is just `&` and `|`.
* `g:toggle_words_on`, `g:toggle_words_off`: Equal-length lists of strings containing the  "on" and "off" values for words under the cursor. Example pairs include `true, false`, and `on, off`. When toggling, the case of the words are preserved.

# Installation
Install with your favorite [plugin manager](https://vi.stackexchange.com/questions/388/what-is-the-difference-between-the-vim-plugin-managers).
I highly recommend the [`vim-plug`](https://github.com/junegunn/vim-plug) manager,
in which case you can install this plugin by adding
```
Plug 'lukelbd/vim-toggle'
```
to your `~/.vimrc`.

