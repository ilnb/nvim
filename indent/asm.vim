if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetAsmIndent()
setlocal indentkeys=o,O,<Return>

" Label matcher: lines like main:
function! s:is_label(line)
  return a:line =~ '^\s*[A-Za-z_][A-Za-z0-9_]*:\s*$'
endfunction

" Directives that should NOT be indented (metadata)
let s:no_indent_directives = [
  \ 'global', 'section', 'text', 'data', 'bss', 'equ', 'extern', 'include'
  \ ]

" Data directives that should be indented under a label
let s:data_directives = [
  \ 'byte', 'word', 'long', 'quad',
  \ 'ascii', 'asciz', 'string',
  \ 'int', 'short', 'float', 'double'
  \ ]

" Extract directive name from a line (e.g., .string "hello" => string)
function! s:get_directive(line)
  let match = matchlist(a:line, '^\s*\.\(\w\+\)\>')
  return empty(match) ? '' : match[1]
endfunction

function! GetAsmIndent()
  let lnum = v:lnum
  let line = getline(lnum)

  " Label lines always unindented
  if s:is_label(line)
    return 0
  endif

  " Global metadata directives (e.g., .section) never indented
  let directive = s:get_directive(line)
  if index(s:no_indent_directives, directive) >= 0
    return 0
  endif

  " Data-type lines may be indented under a label
  let prev_lnum = lnum - 1
  while prev_lnum >= 1
    let prev_line = getline(prev_lnum)

    " Skip blank lines
    if prev_line =~ '^\s*$'
      let prev_lnum -= 1
      continue
    endif

    if s:is_label(prev_line)
      return shiftwidth()
    endif

    " Stop climbing if we hit a global directive
    let prev_directive = s:get_directive(prev_line)
    if index(s:no_indent_directives, prev_directive) >= 0
      return 0
    endif

    let prev_lnum -= 1
  endwhile
endfunction
