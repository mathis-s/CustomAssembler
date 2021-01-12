_main:
    xor a
    mov a,b
    inc a
    loopd:
    mov a,c
    add a,b
    mov c,b
    mov a,ou
    jnc loopd
    hlt







