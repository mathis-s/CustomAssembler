; fibonacci 32-bit
jmp 32
; 2-31 for variables
<32>
_main:
    mov 1024,sp
    
    mov 0,*2 ;
    mov 0,*3 ; first uint32 (previous)

    mov 1,*4 ;
    mov 0,*5 ; second uint32 (current)

    mov 0,*6 ;
    mov 0,*7 ; third uint32 (sum)

    loop:
        call _addInt32

        ; current to previous via output and c
        mov *4,ou
        mov ou,*2
        mov *5,c
        mov c,*3

        ; sum to current
        mov *6,a
        mov a,*4
        mov *7,a
        mov a,*5
        
        jnc loop

    hlt

_addInt32:
    mov *2,a
    add a,*4
    mov a,*6

    mov *3,a
    jnc not_carry
        inc a
    not_carry:
    add a,*5
    mov a,*7
    ret

        

    
