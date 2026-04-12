================================================================================
                              NVIM KEYBINDINGS
================================================================================

GENERAL
-------
<Esc><Esc>           Close quickfix window or terminal buffer
<Space><Space>x     Source current file
<Space>x             Run Lua for current line (normal mode)
<Space>x             Run Lua for selection (visual mode)

DIAGNOSTICS
------------
<Leader>k           Toggle inline diagnostics (virtual lines)
ge                  Next diagnostic
gE                  Previous diagnostic

TELESCOPE
----------
<Space>fh           Find help tags
<Space>ff           Find files
<Space>fs           Live grep
<Space>en           Find Neovim config files

LSP (when LSP attached)
-----------------------
K                    Hover
gd                   Go to definition
gr                   Find references
gI                   Go to implementation
gD                   Go to type definition
<Leader>cr          Rename
<Leader>ca          Code action

DAP (Debug)
-----------
<Leader>db          Toggle breakpoint
<Leader>dc          Continue
<Leader>ds          Step over
<Leader>di          Step into
<Leader>do          Step out
<Leader>dr          Restart debug session
<Leader>de          Terminate debug session
<Leader>dv          Toggle DAP UI

================================================================================
