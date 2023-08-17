for %i run (1 10)
    FS%i:
    if exist recovery.nsh then
        goto start
    endif
endfor

:start
recovery.nsh
