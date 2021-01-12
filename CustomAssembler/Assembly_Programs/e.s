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
    mov 8192,sp
    mov 256,a
    mov 0,*rr4 ; result = 1.0q
    mov a,*rr1 ; denominator = 1.0q
    mov 1,*rr2 ; factorial counter = 1.0q
    mov 6,*rr3 ; iterator

    main_loop:
        ; calculate current fraction, add to result
        mov 65535,c
        mov *rr1,d
        call _div
        add *rr4,ou

        ; calculate next denominator
        mov *rr1,c
        mov *rr2,d
        call _mulI16
        mov ou,*rr1


        inc *rr2
        dec *rr3
        jnz main_loop

    mov *rr4,ou ; display result

    hlt


; c left hand
; d right hand
; ou out
_mulI16:

    mov 0,*rr1

    add c,0
    jns mulI16_ns0
        neg c
        inc *rr1
    mulI16_ns0:

    add d,0
    jns mulI16_ns1
        neg d
        inc *rr1
    mulI16_ns1:
    
    mov c,b
    mov 1,c ; mask
    mov 0,ou ; result

    mulI16_loop:
        mov c,a
        and a,d
        jz mulI16_zero
            add ou,b
        mulI16_zero:
        shl b
        shl c
        jns mulI16_loop

    mov *rr1,a
    flg a
    jnp mulI16_ret
        neg ou
    mulI16_ret:

    ret


; c left hand
; d right hand
; ou out
_mulFixed16:

    ;mov 0,*rr1
;
    ;add c,0
    ;jns mulFixed16_ns0
    ;    neg c
    ;    inc *rr1
    ;mulFixed16_ns0:
;
    ;add d,0
    ;jns mulFixed16_ns1
    ;    neg d
    ;    inc *rr1
    ;mulFixed16_ns1:
    

    mov c,a
    qshr a
    mov a,b

    mov d,a
    qshr a
    mov a,d

    mov 1,c ; mask
    mov 0,ou ; result

    mulFixed16_loop:
        mov c,a
        and a,d
        jz zero0
            add ou,b
        zero0:
        shl b
        shl c
        jns mulFixed16_loop

    ;mov *rr1,a
    ;flg a
    ;jnp mulFixed16_ret
    ;    neg ou
    ;mulFixed16_ret:

    ;mov ou,a
    ;qshr a
    ;qshr a
    ;mov a,ou

    ret

; c left hand
; d right hand
; ou out
_div:
    mov sp,*rr0
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
    mov *rr0,sp    
    ret
            
        



;_div:
;    ;c dividend n
;    ;d divisor d
;
;    mov 32768,a
;    mov a,*rr0
;    mov 0,a
;    mov a,*rr1
;    mov 0,b
;
;    div_loop:
;        mov *rr1,a
;        shl a
;        and a,65534
;        mov a,*rr1
;
;        mov c,a
;        and a,*rr0
;        jz div_zero
;            inc *rr1
;        div_zero:
;
;        mov *rr1,a
;        sub a,d
;        js div_r_smaller_d
;            mov *rr1,a
;            sub a,d
;            mov a,*rr1
;        
;            mov b,a
;            or a,*rr0
;            mov a,b
;
;        div_r_smaller_d:
;        shr *rr0
;        mov *rr0,a
;        afl
;        jnz div_loop
;
;    ;mov *result,c
;    mov *rr1,c
;    ret



        

    
