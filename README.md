Toggle
======

This is a fork of [toggle.vim](https://www.vim.org/scripts/script.php?script_id=895).
This plugin provides a tool for toggling the signs
of numbers and states of "boolean-ish" keywords.

Documentation
=============

| Option | Description |
| ---- | ---- |
| `g:toggle_map` | The normal mode mapping used to "toggle" things on and off. The default is `<Leader>b`. Set this to an empty string to disable the mapping altogether. |
| `g:toggle_chars_on`, `g:toggle_chars_off` | Equal length vim lists of characters containing the "on" and "off" values for (possibly consecutive) characters under the cursor. The defaults are `['+', '>', '&', '1']` and `['-', '<', '\|', '0']` (respectively). Note that zero and one are only toggled if they are in sequences of binary digits and not part of float or non-binary integer strings. |
| `g:toggle_words_on`, `g:toggle_words_off` | Equal length vim lists of strings containing the "on" and "off" values for words under the cursor. The cases of words are always preserved (lowercase, uppercase, or title-case). The defaults are  `['true', 'on', 'yes', 'define', 'in', 'up', 'left', 'north', 'east']` and `['false', 'off', 'no', 'undef', 'out', 'down', 'right', 'south', 'west']` (respectively). |

Installation
============

Install with your favorite [plugin manager](https://vi.stackexchange.com/q/388/8084).
I highly recommend the [vim-plug](https://github.com/junegunn/vim-plug) manager.
To install with vim-plug, add
```
Plug 'lukelbd/vim-toggle'
```
to your `~/.vimrc`.
