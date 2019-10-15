# Toggle
This is a fork of [toggle.vim](https://www.vim.org/scripts/script.php?script_id=895).
This plugin provides a tool for toggling the sign of numbers and
"boolean-ish" things on and off. See below.

# Documentation
| Option | Description |
| ---- | ---- |
| `g:toggle_map` | The map used to "toggle" things on and off. The default is `<Leader>b`. |
| `g:toggle_chars_on`, `g:toggle_chars_off` | Equal length vim lists of characters containing the "on" and "off" values for characters under the cursor. The defaults are, respectively, `["+", ">", "1"]` and `["-", "<", "0"]`. |
| `g:toggle_consecutive_on`, `g:toggle_consecutive_off` |  As with `g:toggle_chars_on`, `g:toggle_chars_off`, but this time we will try to look for consecutive characters and toggle them all at once. The defaults are, respectively, `["&"]` and `["|"]`. |
| `g:toggle_words_on`, `g:toggle_words_off` | Equal length vim lists of strings containing the  "on" and "off" values for words under the cursor. When toggling, the case of the words are preserved (all-lowercase, all-caps, or title-case). The defaults are, respectively `["true", "on", "yes", "define", "in", "up", "left", "north", "east"]` and `["false", "off", "no", "undef", "out", "down", "right", "south", "west"]`. |

# Installation
Install with your favorite [plugin manager](https://vi.stackexchange.com/questions/388/what-is-the-difference-between-the-vim-plugin-managers).
I highly recommend the [`vim-plug`](https://github.com/junegunn/vim-plug) manager,
in which case you can install this plugin by adding
```
Plug 'lukelbd/vim-toggle'
```
to your `~/.vimrc`.

