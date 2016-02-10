" jekyll.vim
" Author:  Denis Evsyukov <denis@evsyukov.org>
" URL:     https://github.com/Juev/vim-jekyll
" Version: 0.1.0
" License: Same as Vim itself (see :help license)

if exists('g:loaded_jekyll') || &cp || v:version < 700
  finish
endif
let g:loaded_jekyll = 1

" Configuration {{{

if ! exists('g:jekyll_path')
  let g:jekyll_path = "~/blog/source"
endif

if !exists('g:jekyll_post_suffix')
  let g:jekyll_post_suffix = "markdown"
endif

if !exists('g:jekyll_title_pattern')
  let g:jekyll_title_pattern = "[ '\"]"
endif

" }}}

" Utility functions {{{

function! s:esctitle(str)
  let str = a:str
  let str = tolower(str)
  let str = substitute(str, g:jekyll_title_pattern, '-', 'g')
  let str = substitute(str, '\(--\)\+', '-', 'g')
  let str = substitute(str, '\(^-\|-$\)', '', 'g')
  return str
endfunction

function! s:error(str)
  echohl ErrorMsg
  echomsg a:str
  echohl None
  let v:errmsg = a:str
endfunction

" }}}

" Post functions {{{

function! JekyllPost(title)
  let created = strftime("%Y-%m-%d %H:%M")
  let title = a:title
  if title == ''
    let title = input("Post title: ")
  endif
  if title != ''
    let file_name = strftime("%Y-%m-%d-") . s:esctitle(title) . "." . g:jekyll_post_suffix
    echo "Making that post " . file_name
    exe "e " . g:jekyll_path . "/_posts/" . file_name

    let template = ["---", "layout: post", "title: \"" . title . "\"", "date: " . created, "image: ", "tags: ", "  - "]
    call extend(template,["---", ""])

    let err = append(0, template)
  else
    call s:error("You must specify a title")
  endif
endfunction
command! -nargs=? JekyllPost :call JekyllPost(<q-args>)

" }}}

" vim:ft=vim:fdm=marker:ts=2:sw=2:sts=2:et
