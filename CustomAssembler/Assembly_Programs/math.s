; adding 32-bit
jmp 32
<32>
_main:
    mov 8192,sp

    mov 804,c
    mov 804,d
    call _mul16q


    hlt
        

//in c,d
//out ou
_mul16q:

    mov 0,b
    flg c
    jns mul16q_ns0
        neg c
        inc b
    mul16q_ns0:

    flg d
    jns mul16q_ns1
        neg d
        inc b
    mul16q_ns1:
    push b

    mov c,b
    mov 0,c
    mov 0,a
    
    mulst d
    mulst d
    mulst d
    mulst d

    mulst d
    mulst d
    mulst d
    mulst d

    swp a,b

    mstf d
    mstfs d
    mstf d
    mstfs d
    mstf d
    mstfs d
    mstf d
    mstfs d

    mstf d
    mstfs d
    mstf d
    mstfs d
    mstf d
    mstfs d
    mstf d
    mstfs d

    mov 0,ou

    mov b,d

    qshl a
    qshl a
    or ou,a

    mov d,a
    qshr a
    qshr a
    or ou,a

    pop a
    flg a
    jnp mul16q_ret
        neg ou
    mul16q_ret:
    ret


//in c,d
//out ou(low), c(high)
_mul32:

    mov c,a
    mov 0,b
    mov 0,c
    
    mstf d
    mstfs d
    mstf d
    mstfs d
    mstf d
    mstfs d
    mstf d
    mstfs d
    mstf d
    mstfs d
    mstf d
    mstfs d
    mstf d
    mstfs d
    mstf d
    mstfs d
    mstf d
    mstfs d
    mstf d
    mstfs d
    mstf d
    mstfs d
    mstf d
    mstfs d
    mstf d
    mstfs d
    mstf d
    mstfs d
    mstf d
    mstfs d
    mstf d
    mstfs d

    mov b,ou
    mov a,c

    ret


//in c,d
//out ou = c*d
_mul16:
    mov c,b
    mov 0,c
    mov 0,a

    mulst d
    mulst d
    mulst d
    mulst d
    mulst d
    mulst d
    mulst d
    mulst d
    mulst d
    mulst d
    mulst d
    mulst d
    mulst d
    mulst d
    mulst d
    mulst d

    mov a,ou
    ret


//in c,d
//out ou = c/d
_div16:
    
    mov c,b
    ;mov 7,d
    mov 0,a
    mov 0,c

    divst d
    swp a,b
    divst d
    swp a,b
    divst d
    swp a,b
    divst d
    swp a,b
    
    divst d
    swp a,b
    divst d
    swp a,b
    divst d
    swp a,b
    divst d
    swp a,b

    divst d
    swp a,b
    divst d
    swp a,b
    divst d
    swp a,b
    divst d
    swp a,b

    divst d
    swp a,b
    divst d
    swp a,b
    divst d
    swp a,b
    divst d
    swp a,b

    mov b,ou
    hlt

//in c
//out ou = 1/c
_inv16q:
    
    mov 0,b
    flg c
    jns inv16q_ns0
        neg c
        inc b
    inv16q_ns0:
    push b


    mov 32768,b
    mov c,d
    mov 0,a
    mov 0,c

    divst d
    swp a,b

    divst d
    swp a,b
    divst d
    swp a,b
    divst d
    swp a,b
    divst d
    swp a,b
    
    divst d
    swp a,b
    divst d
    swp a,b
    divst d
    swp a,b
    divst d
    swp a,b

    divst d
    swp a,b
    divst d
    swp a,b
    divst d
    swp a,b
    divst d
    swp a,b

    divst d
    swp a,b
    divst d
    swp a,b
    divst d
    swp a,b
    divst d
    swp a,b

    mov b,ou


    pop a
    flg a
    jnp inv16q_ret
        neg ou
    inv16q_ret:

    hlt

; d in
; ou out
_sqrt:
    mov sp,*rr0
    mov 0,b
    mov 0,ou
    mov 0,c
    mov 8,sp

    sqrt_loop:
        shl ou
        mov ou,c
        shl c
        incnf c

        shl d
        cmovc 1,a
        shl b
        add b,a

        shl d
        cmovc 1,a
        shl b
        add b,a

        cmp b,c
        jc sqrt_nc
            inc ou
            sub b,c
        sqrt_nc:

        dec sp
        jnz sqrt_loop
        
    mov *rr0,sp
    ret