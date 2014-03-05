if exists('g:loaded_vimfdb')
	finish
endif
let g:loaded_vimfdb = 1

function! SetFDBBreakPoint()
	let l = 'b ' . expand('%:t') . ":" . line(".")
	echo 'ADDING: ' . l . ' to ' . g:fdbInitPath
	let b = "'/run/{print; print \"" . l . "\"; next}1' " . g:fdbInitPath
	exe '!awk ' . b . ' > tmp && mv tmp ' . g:fdbInitPath	
endfunction

function! ResetFDBInit()
	exe '!echo -e "run\ncontinue" > ' . g:fdbInitPath
	exe 'echo "done"'	
endfunction

function! LaunchFDB()
	exe 'silent !cp ' . g:proj . g:currentProject . '/fdbinit.txt ~/.fdbinit'
	exe 'AsyncCommand start_fdb.sh'	
endfunction
