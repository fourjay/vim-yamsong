let s:path = expand('<sfile>:p:h:h')

function! yamsong#split() abort
    let l:original_filename = expand('%')
    let l:original_filetype = &filetype

    " copy buffer to non-buffer
    silent vsplit __yamsong__ | put =getbufline('#',1,'$') | 1d

    let b:yamsong = {
                \       'original_filename': l:original_filename,
                \       'original_filetype': l:original_filetype,
                \ }
    " Convert Toggle
    command! -buffer Toggle call yamsong#toggle()
    " final commit
    command! -buffer Write call yamsong#write()

    " initial conversion
    call yamsong#to_yaml()
    nnoremap <buffer> <Cr> :Toggle<Cr>
    nnoremap <buffer> <nowait> q :call yamsong#close()<cr>
    " setup write override
    augroup yamsong
        autocmd!
        autocmd BufWriteCmd,FileWriteCmd __yamsong__ call yamsong#write()
    augroup end
endfunction
 
function! yamsong#toggle() abort
    if &filetype =~# 'yaml'
        call yamsong#to_json()
    " account for compound filetype
    elseif  &filetype =~# 'json'
        call yamsong#to_yaml()
    else
        echom &filetype . ' is unexpected'
    endif
endfunction

function! yamsong#write() abort
    if &filetype =~# 'yaml'
        echom 'converting to json for final approval'
        call yamsong#to_json()
        return
    endif
    " else put file
    %diffput
    diffoff
    set buftype=nofile
    bwipe
endfunction

function! yamsong#close() abort
    set buftype=nofile
    bwipe
endfunction

function! yamsong#convert(direction) abort
    silent execute '%! ' . s:path . '/bin/' .a:direction . '.py'
endfunction

function! yamsong#to_yaml() abort
    if &filetype =~# 'yaml' | return | endif
    call yamsong#convert('j2y')
    setlocal filetype=yaml
    diffoff
    g/^\S/normal O
endfunction

function! yamsong#to_json() abort
    if &filetype =~# 'json' | return | endif
    call yamsong#convert('y2j')
    execute 'setlocal filetype=' . b:yamsong.original_filetype
    windo diffthis
endfunction
