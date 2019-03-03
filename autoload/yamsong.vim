let s:path = expand('<sfile>:p:h:h')

function! yamsong#split() abort
    let l:file = tempname()
    let l:original = expand('%')
    echom 'l:file is ' . l:file
    let l:save_modified = &modified
    execute 'w ' . l:file
    execute '!chmod +x ' . l:file
    let &modified = l:save_modified
    execute 'e ' . l:file
    let b:original_file = l:original
    command! -buffer Toggle call yamsong#toggle()
    call yamsong#to_yaml()
endfunction

function! yamsong#toggle() abort
    if &filetype ==# 'yaml'
        call yamsong#to_json()
    elseif  &filetype ==# 'json'
        call yamsong#to_yaml()
    else
        echom &filetype . ' is unexpected'
    endif
endfunction

function! yamsong#to_yaml() abort
    silent execute '%!' . s:path . '/bin/j2y.py'
    setlocal filetype=yaml
endfunction

function! yamsong#to_json() abort
    echom 'silent execute' .  '%!' . s:path . '/bin/y2j.py'
    silent execute '%!' . s:path . '/bin/y2j.py'
    setlocal filetype=json
endfunction
