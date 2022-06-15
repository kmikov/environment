"""" KMIKOV VIM """"
set nocompatible
syntax on
set enc=utf-8
set fenc=utf-8
set termencoding=utf-8
set showcmd
set autoindent
set cindent
set smartindent

"" Whitespace
""set nowrap
set tabstop=4 softtabstop=4 shiftwidth=4
set smarttab
""set expandtab
set backspace=indent,eol,start

"" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

"" Other
set background=light
set colorcolumn=120
set t_Co=256
set number
set relativenumber
set showmatch

"" Share clipboard with X
set clipboard=unnamedplus

"" Folding
nmap <leader>f zm%
nmap <leader>u zr%
set nofoldenable
set foldmethod=syntax

"" Pasting fix
set pastetoggle=<F2>

"" Show spaces
set list listchars=tab:→\ ,trail:·,eol:↲

"" Undo function after reopening
set undofile
set undodir=/tmp

"" Show the cursor position all the time
set ruler

"" Highlight the line the cursor is on.
set cursorline

"" In many terminal emulators the mouse works just fine, thus enable it.
"" set mouse=a

"" Visible tabs and navigation
set showtabline=2
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>

"" Better file manager
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 3
let g:netrw_altv = 1
let g:netrw_winsize = 25

"" Add make shortcut
:map <f9> :make<CR>

"" Add file manager shortcut
:map <f3> :Lex<CR>

"" TAG creation                                                                  
command! MakeTags !ctags -R .

"" No more annoying sounds
set visualbell

"" If hidden is not set, TextEdit might fail.
set hidden
set updatetime=300

"" Don't give |ins-completion-menu| messages.
set shortmess+=c

"" Always show signcolumns
set signcolumn=yes

"" Better autocomplete for filepaths
set wildmode=longest,list,full
set wildmenu

"" Turn on omni
filetype plugin on
set omnifunc=syntaxcomplete#Complete

"" Always show autocomplete
function! OpenCompletion()
    if !pumvisible() && ((v:char >= 'a' && v:char <= 'z') || (v:char >= 'A' && v:char <= 'Z'))
        call feedkeys("\<C-x>\<C-o>", "n")
    endif
endfunction

autocmd InsertCharPre * call OpenCompletion()
set completeopt+=longest,menuone,noselect,noinsert
set completeopt-=preview

"" Help Menu
call popup_notification("Press Ctrl-h for help!", #{ pos: 'center', time: 1000 })
let hkeys =<< trim END
        Custom hotkeys:

        <leader>f                       Fold code
        <leader>u                       Unfold code
        <leader>fs                      Fuzzy search strings
        <leader>ff                      Fuzzy search files
        <leader>fc                      Clang Format

        <F2>                            Fix long pasting
        <F3>                            Open file tree
        <F9>                            Run 'make'

        <C-Left>                        Previous tab
        <C-Right>                       Next tab
        <C-H>                           This help menu

        :MakeTags                       Create ctags file
END
command! -nargs=* GetHelp call popup_notification(hkeys, #{ pos: 'center', time: 5000 })

nnoremap <C-h> :GetHelp<CR>

"""" Windows Terminal """"

"" Better whitespace character color
hi SpecialKey ctermfg=7 ctermbg=256
hi NonText ctermfg=7 ctermbg=256
hi CursorLine ctermbg=Gray

"" Better Status Line
set laststatus=2 "" Always show status line
function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction
function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  ⎇'.l:branchname.' ':''
endfunction

let statusgit = StatuslineGit()

set statusline=
set statusline+=%#PmenuSel#
set statusline+=%{statusgit}
set statusline+=%#LineNr#
set statusline+=\ %f
set statusline+=%m\
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\

"" Add fuzzy search files

function! FZF() abort
    let l:tempname = tempname()
    " fzf | awk '{ print $1":1:0" }' > file
    execute 'silent !fzf --multi ' . '| awk ''{ print $1":1:0" }'' > ' . fnameescape(l:tempname)
    try
        execute 'cfile ' . l:tempname
        redraw!
    finally
        call delete(l:tempname)
    endtry
endfunction

" :Files
command! -nargs=* Files call FZF()

" \ff
nnoremap <leader>ff :Files<cr>

"" Add fuzzy search text
function! RG(args) abort
    let l:tempname = tempname()
    let l:pattern = '.'
    if len(a:args) > 0
        let l:pattern = a:args
    endif
    " rg --vimgrep <pattern> | fzf -m > file
    execute 'silent !rg --vimgrep ''' . l:pattern . ''' | fzf -m > ' . fnameescape(l:tempname)
    try
        execute 'cfile ' . l:tempname
        redraw!
    finally
        call delete(l:tempname)
    endtry
endfunction

" :Rg [pattern]
command! -nargs=* Rg call RG(<q-args>)

" \fs
nnoremap <leader>fs :Rg<cr>

"" Support clang-format
if has('python')
        nnoremap <leader>fc :pyf /usr/share/clang/clang-format-14/clang-format.py<cr>
elseif has('python3')
        nnoremap <leader>fc :py3f /usr/share/clang/clang-format-14/clang-format.py<cr>
endif
