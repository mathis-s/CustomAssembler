; recursive multiplication
_main:
    mov 128,sp ; stack starts at 128
    mov 321,c
    mov c,ou
    mov 123,d
    call _mul ; calculate 321 * 10
    hlt

_mul:
    dec d
    jz exit
    add ou,c
    call _mul
    exit:
        ret