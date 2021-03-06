"=============================================================================
" FILE: changes.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Variables  "{{{
"}}}

function! unite#sources#change#define() abort "{{{
  return s:source
endfunction"}}}

let s:source = {
      \ 'name' : 'change',
      \ 'description' : 'candidates from changes',
      \ 'hooks' : {},
      \ }

let s:cached_result = []
function! s:source.hooks.on_init(args, context) abort "{{{
  let result = []
  for change in split(unite#util#redir('changes'), '\n')[1:]
    let list = split(change)
    if len(list) < 4
      continue
    endif

    let [linenr, col, text] = [list[1], list[2]+1, join(list[3:])]

    call add(result, {
          \ 'word' : printf('%4d-%-3d  %s', linenr, col, text),
          \ 'kind' : 'jump_list',
          \ 'action__path' : unite#util#substitute_path_separator(
          \         fnamemodify(expand('%'), ':p')),
          \ 'action__buffer_nr' : bufnr('%'),
          \ 'action__line' : linenr,
          \ 'action__col' : col,
          \ })
  endfor

  let a:context.source__result = reverse(result)
endfunction"}}}
function! s:source.gather_candidates(args, context) abort "{{{
  return a:context.source__result
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
