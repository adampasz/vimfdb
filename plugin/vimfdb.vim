if exists('g:loadedVIMFDB')
	finish
endif

let g:loadedVIMFDB = 1
let s:defaultFDBInitPath = '~/.fdbinit'
let s:pluginPath = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let s:shCommand = '!' . s:pluginPath . '/vimfdb.sh'

" BreakPointColor ctermfg=white btermbg=lightblue cterm=bold
sign define fdb_breakpoint text=* texthl=Special

command! -nargs=0 FDBLaunch call s:launch()
command! -nargs=0 FDBReset call s:reset()
command! -nargs=0 FDBSetBreakPoint call s:setBreakPoint()
command! -nargs=0 FDBUnsetBreakPoint call s:unsetBreakPoint()
command! -nargs=0 FDBLoadBreakPoints call s:loadBreakPoints()
"TODO: FDBToggleBreakPoint

if !exists('g:fdbInitPath')
	let g:fdbInitPath = s:defaultFDBInitPath
endif

if !exists('g:launchFDBCommand')
	let g:launchFDBCommand = '!fdb'
endif

function! s:setBreakPoint()
	call s:exeShellSilent('setBreakPoint',  expand('%:t'), line('.'))
	call s:drawBreakPoint(line("."))
endfunction
"TODO: Deal with duplicate BPs...

function! s:unsetBreakPoint()
	call s:exeShellSilent('unsetBreakPoint', expand('%:t'), line('.'))
	call s:eraseBreakPoint(line("."))
endfunction

" Load breakpoints for current file
function! s:loadBreakPoints()
	let filename = expand('%:t')
	let cmd = "'$1 ~/b/ $2 ~/" . filename . "/ {split($2, a, \":\"); ORS=\",\"; print a[2]}'"
	redir @a
	exe 'silent! !awk ' . cmd . ' ' . g:fdbInitPath
	redir END
	let result = split(@a, '\n')
	"need to pull last line from result. Not sure why awk command gets added to result. :/
	let a = split(result[len(result)-1],',')
	for i in a
		call s:drawBreakPoint(i)
	endfor
	"TODO: Use var instead of register
endfunction

" Clear all breakpoints
function! s:reset()
	call s:exeShell('reset')
	exe 'sign unplace *'
	exe 'echo "done"'	
endfunction

function! s:launch()
	if g:fdbInitPath != s:defaultFDBInitPath
		exe 'silent !cp ' . g:fdbInitPath . ' ' . s:defaultFDBInitPath
	endif
	exe g:launchFDBCommand
endfunction

function! s:drawBreakPoint(lineNumber)
   	exe 'sign place ' . a:lineNumber . ' name=fdb_breakpoint line=' . a:lineNumber . ' buffer=' . bufnr('%')	
endfunction

function! s:eraseBreakPoint(lineNumber)
	exe 'sign unplace ' . a:lineNumber . ' buffer=' . bufnr('%')
endfunction

function! s:exeShell(fName, ...)
	let cmd = s:shCommand . ' ' . a:fName . ' ' . g:fdbInitPath
	for i in a:000
		let cmd = cmd . ' ' . i	
	endfor
	exe cmd
endfunction

function! s:exeShellSilent(fName, ...)
	let cmd = 'silent ' . s:shCommand . ' ' . a:fName . ' ' . g:fdbInitPath
	for i in a:000
		let cmd = cmd . ' ' . i	
	endfor
	exe cmd
endfunction

"TODO: We'll probably need a sign dictionary soon...

" echo "$(awk '!/OzMain.as\:90/' fdbinit.txt)" > fdbinit.txt
" http://stackoverflow.com/questions/8019617/how-to-write-finding-output-to-same-file-using-awk-command
