_main:
    mov 15421,c
    mov 321,d

    mov 16,sp
    mov 0,ou
    loop:
        shl c
        cmovc 1,b
        shl ou
        or ou,b
        ;cmp ou,d
        mov ou,a
        sub a,d
        jc main_nc
            inc c
            sub ou,d
        main_nc:
        dec sp
        jnz loop

    mov c,ou    
    hlt