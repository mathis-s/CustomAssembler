; adding 32-bit
jmp 32
<32>
_main:
    mov 1024,sp
    
    mov 65535,a
    mov a,*a_low
    mov 32767,a
    mov a,*a_high

    mov 1,*b_low
    mov 0,*b_high

    call _addInt32
    mov *a_low,ou
    mov *a_high,c
    hlt


a_low:
0
a_high:
0
b_low:
0
b_high:
0
_addInt32:
    mov *b_low,b
    add *a_low,b
    mov *b_high,b
    jnc not_carry
        inc *a_high
    not_carry:
    add *a_high,b
    
    ret

        

    
