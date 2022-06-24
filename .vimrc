" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	1999 Feb 02
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"             for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc

set nocompatible	" Use Vim defaults (much better!)
set bs=2		" allow backspacing over everything in insert mode
set ai			" always set autoindenting on
set nobackup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler
set showcmd
set ts=4	" 4 spaces for 1 tab
set incsearch	" incremental search (последовательный показ искомого)
set smartcase
set list
set listchars=tab:>-,trail:-,eol:$
set laststatus=2
"set keymap=russian-jcukenwin
set helplang=ru
set langmap=ж;;
set langmap+=йq,ЙQ,цw,ЦW,уe,УE,кr,КR,еt,нy,HY,гu,ГU,шi,ШI,щo,ЩO,зp,ЗP,х[,Х{,ъ],Ъ},фa,ФA,ыs,ЫS,вd,ВD,аf,АF,пg,ПG,рh,РH,оj,ОJ,лk,ЛK,дl,ДL,э',яz,ЯZ,Э\",чx,ЧX,сc,СC,мv,МV,иb,ИB,тn,ТN,ьm,б\\,,Б<,ю.,Ю>,ё`,Ё~,Ж:
set langmenu=russian
"set number
syntax on
highlight Comment ctermfg=darkgreen guifg=darkgreen
"highlight Comment ctermfg=darkblue guifg=darkblue
highlight vimComment ctermfg=darkgreen guifg=darkgreen
"colorscheme mycolors
"filetype on
"filetype plugin on
"set grepprg=grep\ -nH\ $*
"filetype indent on
"helptags ~/.vim/doc
"use_enhcomment_plugin

" Вариации на тему смены русского/английского набора
vmap ,rus !tr "\`qwertyuiop[]asdfghjkl;'zxcvbnm,.~QWERTYUIOP{}ASDFGHJKL:\"ZXCVBNM<>" "ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕHГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ"<CR>

vmap ,eng !tr "ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕHГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ" "\`qwertyuiop[]asdfghjkl;'zxcvbnm,.~QWERTYUIOP{}ASDFGHJKL:\"ZXCVBNM<>"<CR>

" Работа стрелочек и т.п. по перенесенным строкам
map <Up> gk
imap <Up> <C-O><Up>
map <Down> gj
imap <Down> <C-O><Down>
map <Home> g0
imap <Home> <C-O><Home>
map <End> g$
imap <End> <C-O><End>

" переключение кодировок
"set encoding=koi8-r
"set termencoding=koi8-r
set encoding=utf-8
set termencoding=utf-8


map <F8> :execute RotateEnc()<CR>
map <F7> :let &fileencoding=&encoding<CR>

" some functions -- ротация кодировок

let b:encindex=0
function! RotateEnc()
        let y = -1
        while y == -1
                let encstring = "#8bit-cp1251#8bit-cp866#utf-8#koi8-r#"
                let x = match(encstring,"#",b:encindex)
                let y = match(encstring,"#",x+1)
                let b:encindex = x+1
                if y == -1
                        let b:encindex = 0
                else
                        let str = strpart(encstring,x+1,y-x-1)
                        return ":set encoding=".str
                endif
        endwhile
endfunction

" если хочется чтобы текущая кодировка в статусной строке отображалась, то

set statusline=%<%f%h%m%r%=%b\ %{&encoding}\ 0x%B\ \ %l,%c%V\ %P

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

" In text files, always limit the width of text to 76 characters
autocmd BufRead *.txt set tw=76	
" То же для ТеХа
autocmd BufRead *.tex set tw=76	
" То же для почты
au FileType mail set tw=76

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
  set mousemodel=popup
endif

if $TERM == 'xterm'
  set t_Co=256
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
  highlight Comment ctermfg=darkgreen guifg=darkgreen
endif

augroup cprog
  " Remove all cprog autocommands
  au!

  " When starting to edit a file:
  "   For *.c and *.h files set formatting of comments and set C-indenting on.
  "   For other files switch it off.
  "   Don't change the order, it's important that the line with * comes first.
  autocmd BufRead *       set formatoptions=tcql nocindent comments&
  autocmd BufRead *.c,*.h set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
augroup END

augroup gzip
  " Remove all gzip autocommands
  au!

  " Enable editing of gzipped files
  "	  read:	set binary mode before reading the file
  "		uncompress text in buffer after reading
  "	 write:	compress file after writing
  "	append:	uncompress file, append, compress file
  autocmd BufReadPre,FileReadPre	*.gz set bin
  autocmd BufReadPost,FileReadPost	*.gz let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost	*.gz '[,']!gunzip
  autocmd BufReadPost,FileReadPost	*.gz set nobin
  autocmd BufReadPost,FileReadPost	*.gz let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost	*.gz execute ":doautocmd BufReadPost " . expand("%:r")

  autocmd BufWritePost,FileWritePost	*.gz !mv <afile> <afile>:r
  autocmd BufWritePost,FileWritePost	*.gz !gzip <afile>:r

  autocmd FileAppendPre			*.gz !gunzip <afile>
  autocmd FileAppendPre			*.gz !mv <afile>:r <afile>
  autocmd FileAppendPost		*.gz !mv <afile> <afile>:r
  autocmd FileAppendPost		*.gz !gzip <afile>:r
augroup END

augroup bzip2
  " Remove all bzip2 autocommands
  au!

  " Enable editing of bzipped files
  "	  read:	set binary mode before reading the file
  "		uncompress text in buffer after reading
  "	 write:	compress file after writing
  "	append:	uncompress file, append, compress file
  autocmd BufReadPre,FileReadPre	*.bz2 set bin
  autocmd BufReadPost,FileReadPost	*.bz2 let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost	*.bz2 '[,']!bunzip2
  autocmd BufReadPost,FileReadPost	*.bz2 set nobin
  autocmd BufReadPost,FileReadPost	*.bz2 let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost	*.bz2 execute ":doautocmd BufReadPost " . expand("%:r")

  autocmd BufWritePost,FileWritePost	*.bz2 !mv <afile> <afile>:r
  autocmd BufWritePost,FileWritePost	*.bz2 !bzip2 <afile>:r

  autocmd FileAppendPre			*.bz2 !bunzip2 <afile>
  autocmd FileAppendPre			*.bz2 !mv <afile>:r <afile>
  autocmd FileAppendPost		*.bz2 !mv <afile> <afile>:r
  autocmd FileAppendPost		*.bz2 !bzip2 <afile>:r
augroup END

augroup git
  " Remove all git autocommands
  au!

  autocmd BufNewFile,BufRead *.git/COMMIT_EDITMSG    setf gitcommit
  autocmd BufNewFile,BufRead *.git/config,.gitconfig setf gitconfig
  autocmd BufNewFile,BufRead git-rebase-todo         setf gitrebase
  autocmd BufNewFile,BufRead .msg.[0-9]*
          \ if getline(1) =~ '^From.*# This line is ignored.$' |
          \   setf gitsendemail |
          \ endif
  autocmd BufNewFile,BufRead *.git/**
          \ if getline(1) =~ '^\x\{40\}\>\|^ref: ' |
          \   setf git |
          \ endif
augroup END

" This is on-the-fly spellchecking support module for Vim
" Author: Andrew Rodionoff <arnost@mail.ru> Copyleft (x) 2000
" Disclaimer: ->Insert your favourite disclaimer here<-
"
" Usage:
" Source this file from your vimrc.
" Adjust autocommands and filetypes below to suit your preferences.
" Use IspellDict command to change custom dictionaries,
" e.g.: IspellDict russian
"
" TODO:
" Dictionary menu for GUI version of Vim

" tclfile ~/.vim/packages/ispell.tcl

" command! -nargs=1 IspellDict tcl Ispell_Dict <args>
" fun! IspellLine()
"    tcl Ispell_Line [::vim::expr line(".")]
"    return ""
" endfun

" hi link IspellCombo Special
" hi IspellCombo  cterm=NONE  ctermfg=Yellow  ctermbg=DarkRed
" hi link IspellError Error
" hi IspellError  cterm=NONE  ctermfg=White   ctermbg=DarkRed

" fun! Ispell_on()
"    inoremap <Space> <Space><C-R>=IspellLine()<CR>
" endfun

" fun! Ispell_off()
"    if mapcheck("<Space>", "i") == " <C-R>=IspellLine()<CR>"
"        iunmap <space>
"    endif
" endfun

" augroup ispell
"   au!
"   au FileType mail call Ispell_on()
"   au FileType golded call Ispell_on()
"   au FileType tex call Ispell_on()
"   au FileType text call Ispell_on()
"   au WinEnter,BufEnter * call Ispell_off()
"   au WinEnter,BufEnter *.tex call Ispell_on()
" augroup END

