" setup known state
if ! executable('python3')
    finish
endif
let s:save_cpo = &cpoptions
set compatible&vim

command! -buffer EditAsyaml call yamsong#split()

let &cpoptions = s:save_cpo
