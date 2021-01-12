; adding 32-bit
jmp 32

<32>
_main:

    hlt


; c input
; b output
_f16ToInt:
    mov stack,sp

    mov c,b
    and b,1023 ; fraction in b

    mov c,a
    and a,31744
    qshr a
    qshr a
    dshr a ; exponent in a
    
    jz f16ToInt_z ; add leading bit to fraction only if not smallest possible exponent
        add b,1024
    f16ToInt_z:

    sub a,14

    jns f16ToInt_ns
        neg a
        shr b,a
        jmp f16ToInt_fin
    f16ToInt_ns:

    shl b,a

    f16ToInt_fin:

    mov c,a
    and a,32768
    jnz f16ToInt_ret
        neg b
    f16ToInt_ret:
    ret

; c, d input
; ou output
_f16Add:
    push c
    push d
    and c,31744
    mov c,a
    qshr a
    qshr a
    mov a,b

    and d,31744
    mov d,a
    qshr a
    qshr a

    sub a,b
    js f16_add_b_larger_a
    ; b_smaller_eq_a:



    f16_add_b_larger_a:






;_mul:
;    ; c left hand
;    ; d right hand
;    mov 1,b ; mask
;    mov 0,ou ; result
;
;    mul_loop:
;        mov d,a
;        and a,d
;        jz mul_zero
;            add ou,c
;        mul_zero:
;        shl c
;        shl b
;        jnc mul_loop
;    ret
;
;; c, d : fixed16; ou: fixed16
;_mulFixed16:
;    ; c left hand
;    ; d right hand
;    mov 1,b ; mask
;    mov 0,ou ; result
;
;    mulFixed_loop:
;        mov d,a
;        and a,d
;        jz mulFixed_zero
;            add ou,c
;        mulFixed_zero:
;        shl c
;        shl b
;        jnc mulFixed_loop
;
;    dshr ou
;    shr ou
;    ret

; c in and out : fixed16

stack:

;img
;<32768>