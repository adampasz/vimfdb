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
command! -nargs=0 FDBLoadBreakPoints call FDBLoadBreakPoints()

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
	call FDBPlaceBreakPoint(line("."))
endfunction

" Load breakpoints for current file
function! FDBLoadBreakPoints()
	let filename = expand('%:t')
	let cmd = "'$1 ~/b/ $2 ~/" . filename . "/ {split($2, a, \":\"); ORS=\",\"; print a[2]}'"
	redir @a
	exe 'silent! !awk ' . cmd . ' ' . g:fdbInitPath
	redir END
	let result = split(@a, '\n')
	"need to pull last line from result. Not sure why awk command gets added to result. :/
	let a = split(result[len(result)-1],',')
	for i in a
		call FDBDrawBreakPoint(i)
	endfor
endfunction

" Clear all breakpoints
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

function! FDBDrawBreakPoint(lineNumber)
   	exe 'sign place 1 name=fdb_breakpoint line=' . a:lineNumber . ' buffer=' . bufnr('%')	
endfunction

