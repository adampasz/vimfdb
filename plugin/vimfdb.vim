if exists('g:loadedVIMFDB')
	finish
endif

let g:loadedVIMFDB = 1
let s:defaultFDBInitPath = '~/.fdbinit'
let g:fdbPluginPath = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let s:shCommand = '!' . g:fdbPluginPath . '/vimfdb.sh'

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
	" in my .vrimrc:
	" autocmd VimEnter * let g:launchFDBCommand = 'AsyncCommand ' . g:fdbPluginPath . '/start_fdb.sh
endif

function! s:setBreakPoint()
	if !filereadable(expand(g:fdbInitPath))
       		call s:reset()	
	endif
	call APZExeShellSilent('setBreakPoint',  expand('%:t'), line('.'))
	call s:drawBreakPoint(line("."))
endfunction
"TODO: Deal with duplicate BPs...

function! s:unsetBreakPoint()
	call APZExeShellSilent('unsetBreakPoint', expand('%:t'), line('.'))
	call s:eraseBreakPoint(line("."))
endfunction

" Load breakpoints for current file
function! s:loadBreakPoints()
	if !filereadable(expand(g:fdbInitPath))
       		call s:reset()	
	endif
	redir => output 
	call APZExeShellSilent('loadBreakPoints', expand('%:t'))
	redir END
	let result = split(output, '\n')
	"need to pull last line from result, since it's picking up all shell output
	let a = split(result[len(result)-1],',')
	for i in a
		if i != -1
			call s:drawBreakPoint(i)
		endif
	endfor
endfunction

" Clear all breakpoints
function! s:reset()
	call APZExeShell('reset')
	exe 'sign unplace *'
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

"UTILITIES
function! APZExeShell(fName, ...)
	let cmd = s:shCommand . ' ' . a:fName . ' ' . g:fdbInitPath
	for i in a:000
		let cmd = cmd . ' ' . i	
	endfor
	exe cmd
endfunction

function! APZExeShellSilent(fName, ...)
	let cmd = 'silent ' . s:shCommand . ' ' . a:fName . ' ' . g:fdbInitPath
	for i in a:000
		let cmd = cmd . ' ' . i	
	endfor
	exe cmd
endfunction

"TODO: We'll probably need a sign dictionary soon...

