; e
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
    mov 0,*rr4 ; result = 0
    mov a,*rr1 ; denominator = 1.0
    mov 1,*rr2 ; factorial counter
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

; c left hand
; d right hand
; ou out
_div:
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
    ret
            
        



        

    
