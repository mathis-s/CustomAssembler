; c left hand
; d right hand
; ou out
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

    mov *rr1,a
    flg a
    jnp mulFixed16_ret
        neg ou
    mulFixed16_ret:

    mov ou,a
    qshr a
    qshr a
    mov a,ou

    ret



; c left hand
; d right hand
; ou out
_mul16q:

    ;mov 0,*rr2

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

    ;mov 1,c ; mask
    mov 0,a
    mov 0,ou ; result
    mov 16,b

    mul16q_loop:
        shl a
        shl c

        jnc mul16q_nc
            add a,d
            ;jnc mul16q_nc
            ;    inc c
        mul16q_nc:
        dec b
        jnz mul16q_loop

    mov a,ou
    ;mov *rr1,a
    ;flg a
    ;jnp mul16q_ret
    ;    neg ou
    ;mul16q_ret:

    ;mov ou,a
    ;qshr a
    ;qshr a
    ;mov a,ou

    ret

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