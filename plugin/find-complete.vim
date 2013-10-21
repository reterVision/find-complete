" Adds command (:F) that tab auto-completes files on your path.
"
" Maintainer:       stegtmeyer <seanblack7777@gmail.com>
" Customized by:    reterVision <reterclose@gmail.com>

fun! FindFileNameComplete(ArgLead, CmdLine, CursorPos)
    let cmdLineList = split(a:CmdLine)
    if (len(cmdLineList) >= 3)
        let searchPath = get(cmdLineList, 1)
    else
        let searchPath = &path
    endif
    let newArg = a:ArgLead . "*"
    let dirList = split(globpath(searchPath, newArg), "\n")
    let fileList = []
    for n in dirList
        call add(fileList, strpart(n, strridx(searchPath, "/") + 1)) 
    endfor
    " Remove the duplicated results from the list
    let dict = {}
    for l in fileList
        let dict[l] = ''
    endfor
    return keys(dict)
endfun
com! -nargs=+ -complete=customlist,FindFileNameComplete
            \ F call FindArgFilter(<f-args>)

fun! FindArgFilter(...)
    let origPath = &path
    let findArg = a:000[a:0-1]
    if (a:0 > 1)
        let &path = a:000[0]
    endif
    exe "grep -r --include " + findArg + "\"\"" + "./"
    let &path = origPath
endfun
