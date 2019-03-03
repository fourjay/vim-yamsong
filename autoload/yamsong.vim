let s:path = expand('<sfile>:p:h:h')

function! yamsong#split() abort
    let l:original_filename = expand('%')
    let l:original_filetype = &filetype

    silent vsplit __yamsong__ | put =getbufline('#',1,'$') | 1d
    setlocal buftype=nofile

    let b:yamsong = {
                \       'original_filename': l:original_filename,
                \       'original_filetype': l:original_filetype,
                \}
    command! -buffer Toggle call yamsong#toggle()
    command! -buffer Copy :%diffput
    call yamsong#to_yaml()
    nnoremap <buffer> <Cr> :Toggle<Cr>
    nnoremap <buffer> <nowait> q :q<cr>
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

function! yamsong#convert(direction) abort
    silent execute '%! ' . s:path . '/bin/' .a:direction . '.py'
endfunction

function! yamsong#to_yaml() abort
    call yamsong#convert('j2y')
    setlocal filetype=yaml
    diffoff
endfunction

function! yamsong#to_json() abort
    call yamsong#convert('y2j')
    execute 'setlocal filetype=' . b:yamsong.original_filetype
    windo diffthis
endfunction
