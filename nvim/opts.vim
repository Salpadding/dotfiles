" highlight search result, enable relative line number
set numberwidth=3 nu rnu hlsearch incsearch termguicolors
" indent = 4, tab -> 4 space
set expandtab tabstop=4 shiftwidth=4
" yank -> system clipboard -> paste
" disable .swp file, enable undo local logs
set noswapfile undofile
set signcolumn=yes scrolloff=32 colorcolumn=120

" 
" - Without it: This is a long sen|tence (breaks anywhere)
" - With it: This is a long |sentence (breaks at spaces/punctuation)
set wrap nofoldenable linebreak
" fix statusline and tabline
set laststatus=3 showtabline=2
" let :vs :sp open new window right/below
set splitright splitbelow
set timeoutlen=3000 ttimeoutlen=1
set cursorline nofileignorecase
let g:mapleader=' '
tno <C-j><C-k> <C-\><C-n>
nn > >>
nn < <<
nn j gj|nn k gk|nn gj j|nn gk k
nn Q gq
" use plus default register|
nn p "+p|nn P "+P|nn y "+y|nn yy "+yy
nn d "+d|nn dd "+dd
vn p "_dp|vn P "_dP|vn y "+y|vn d "+d
nn <C-x> <C-\><C-n>
nn <C-a> <C-\><C-n>
command -nargs=* -complete=help H :vert help <args>
" command line abbrev :h -> :H
cabbrev h H
au TermOpen * startinsert

