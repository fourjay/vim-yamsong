" setup known state
if exists('did_json') 
            \ || ! executable('python3')
      "  || version < 700}
    finish
endif
let g:did_json = '1'
let s:save_cpo = &cpoptions
set compatible&vim

command! -buffer Edityaml call yamsong#split()
"
" Return vim to users choice
let &cpoptions = s:save_cpo
