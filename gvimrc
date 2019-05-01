  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  " .gvimrc for MacVim
  " See also .vimrc
  "
  " 1032--2031 Thursday, 21 Tevet 5770 (7 January 2010)
  "
  " Modified:
  "   0234 Friday, 17 Elul 5770 (27 August 2010) [1193]
  "   1534 Sunday, 19 Elul 5770 (29 August 2010) [1195]
  "
  " Technion -- Israel Institute of Technology
  " Austin Kim
  "
  " Modified:
  "   2119 Wednesday, 13 February 2019 (EST) [17940]
  "   1900 Thursday, 14 February 2019 (EST) [17941]
  "   0148 Wednesday, 27 February 2019 (EST) [17954]
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set lines=50
set go-=T
set bg=dark
if &background == "dark"
   hi normal guibg=black
   set transp=25
endif

colorscheme murphy

" Use same font used by Apple Xcode, but bigger.
set guifont=Menlo:h14

" Expand tabs to spaces.
set expandtab

" Set autoindent.
set autoindent
