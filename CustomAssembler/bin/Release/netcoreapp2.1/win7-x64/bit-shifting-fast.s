; bit-shifting
_main:
    mov 1,a
    loop:
        qshl a
        qshl a
        qshl a
        dshl a
        shl a

        qshr a
        qshr a
        qshr a
        dshr a
        shr a
        jmp loop

