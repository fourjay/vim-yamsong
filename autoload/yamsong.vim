let s:path = expand('<sfile>:p:h:h')

function! yamsong#split() abort
    let l:file = tempname()
    let l:original_file = expand('%')
    let l:original_filetype = &filetype
    echom 'l:file is ' . l:file
    let l:save_modified = &modified
    execute 'w ' . l:file
    execute '!chmod +x ' . l:file
    let &modified = l:save_modified
    execute 'vsplit ' . l:file
    command! -buffer Toggle call yamsong#toggle()
    nnoremap <buffer> <Cr> :Toggle<Cr>
    let b:yamsong = {
                \       'original_file':     l:original_file,
                \       'original_filetype': l:original_filetype,
                \}
    call yamsong#to_yaml()
endfunction

function! yamsong#toggle() abort
    if &filetype ==# 'yaml'
        call yamsong#to_json()
    elseif  &filetype =~# 'json'
        call yamsong#to_yaml()
    else
        echom &filetype . ' is unexpected'
    endif
endfunction

function! yamsong#to_yaml() abort
    silent execute '%!' . s:path . '/bin/j2y.py'
    setlocal filetype=yaml
    diffoff
endfunction

function! yamsong#to_json() abort
    echom 'silent execute' .  '%!' . s:path . '/bin/y2j.py'
    silent execute '%!' . s:path . '/bin/y2j.py'
    execute 'setlocal filetype=' . b:yamsong.original_filetype
    windo diffthis
endfunction
