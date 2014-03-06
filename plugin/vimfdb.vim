if exists('g:loadedVIMFDB')
	finish
endif

let g:loadedVIMFDB = 1
let s:defaultFDBInitPath = '~/.fdbinit'

" BreakPointColor ctermfg=white btermbg=lightblue cterm=bold
sign define fdb_breakpoint text=* texthl=Special


command! -nargs=0 FDBLaunch call FDBLaunch()
command! -nargs=0 FDBReset call FDBReset()
command! -nargs=0 FDBSetBreakPoint call FDBSetBreakPoint()

if !exists('g:fdbInitPath')
	let g:fdbInitPath = s:defaultFDBInitPath
endif

if !exists('g:launchFDBCommand')
	let g:launchFDBCommand = '!fdb'
endif

function! FDBSetBreakPoint()
	let l = 'b ' . expand('%:t') . ":" . line(".")
	echo 'ADDING: ' . l . ' to ' . g:fdbInitPath
	let b = "'/run/{print; print \"" . l . "\"; next}1' " . g:fdbInitPath
	exe 'silent !awk ' . b . ' > tmp && mv tmp ' . g:fdbInitPath
	exe 'sign place 1 name=fdb_breakpoint line=' . line(".") . ' buffer=' . bufnr('%')	
endfunction

function! FDBReset()
	exe '!echo -e "run\ncontinue" > ' . g:fdbInitPath
	exe 'sign unplace 1'
	exe 'echo "done"'	
endfunction

function! FDBLaunch()
	if g:fdbInitPath != s:defaultFDBInitPath
		exe 'silent !cp ' . g:fdbInitPath . ' ' . s:defaultFDBInitPath
	endif
	exe g:launchFDBCommand
	
endfunction
