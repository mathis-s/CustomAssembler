

_main:
    loop:
        mov x1,a
        flg a
        jz loop
        mov a,x0
        jmp loop