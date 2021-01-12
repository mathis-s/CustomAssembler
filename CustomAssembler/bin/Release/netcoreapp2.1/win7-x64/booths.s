; booths
jmp 32
; 2-31 for variables
<32>
_main:
    mov 111,sp ; left hand
    mov 22,c ; right hand
    mov 1,d ; mask
    
    mov 0,ou ; result

    loop:
        mov c,a
        and a,d
        jz zero
            add ou,sp
        zero:
        shl sp
        shl d
        jnc loop

    hlt
        



    
    
