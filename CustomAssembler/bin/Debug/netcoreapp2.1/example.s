; adding 32-bit
jmp 32
rr0:
0
rr1:
0
rr2:
0
rr3:
0
rr4:
0
rr5:
0
rr6:
0
<32>
_main:
    inc *rr0
    mov 87,d
    call _mulFixed16
    mov b,ou
    hlt

; c left hand
; d right hand
; b out
_mulFixed16:

    mov 0,*rr1

    add c,0
    jns mulFixed16_ns0
        neg c
        inc *rr1
    mulFixed16_ns0:

    add d,0
    jns mulFixed16_ns1
        neg d
        inc *rr1
    mulFixed16_ns1:
    
    mov c,b
    mov 1,c ; mask
    mov 0,*rr0 ; result

    loop:
        mov d,a
        and a,b
        clf
        jz zero
            add *rr0,b
        zero:
        shl b
        shl c
        jnc loop

    ;mov *rr0,a
    ;qshr a
    ;qshr a
    ;mov a,b
    mov *rr1,a
    mov *rr0,b
    
    afl
    jnp mulFixed16_ret
        neg b
    mulFixed16_ret:

    ret


_div:
    ;c dividend n
    ;d divisor d

    mov 32768,a
    mov a,*rr0
    mov 0,a
    mov a,*rr1
    mov 0,b

    div_loop:
        mov *rr1,a
        shl a
        and a,65534
        mov a,*rr1

        mov c,a
        and a,*rr0
        jz div_zero
            inc *rr1
        div_zero:

        mov *rr1,a
        sub a,d
        js div_r_smaller_d
            mov *rr1,a
            sub a,d
            mov a,*rr1
        
            mov b,a
            or a,*rr0
            mov a,b

        div_r_smaller_d:
        shr *rr0
        mov *rr0,a
        afl
        jnz div_loop

    ;mov *result,c
    mov *rr1,c
    ret



_f16Div:
    ;c dividend n
    ;d divisor d

    mov 32768,a
    mov a,*rr0
    mov 0,a
    mov a,*rr1
    mov 0,b

    f16Div_loop:
        mov *rr1,a
        shl a
        and a,65534
        mov a,*rr1

        mov c,a
        and a,*rr0
        jz f16Div_z
            inc *rr1
        f16Div_z:

        mov *rr1,a
        sub a,d
        js f16Div_s
            mov *rr1,a
            sub a,d
            mov a,*rr1
        
            mov b,a
            or a,*rr0
            mov a,b
        f16Div_s:

        shr *rr0
        mov *rr0,a
        afl
        jnz f16Div_loop

    ;mov *result,c
    mov *rr1,c
    ret



        

    
