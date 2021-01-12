; adding 32-bit
jmp 32
<32>
_main:
    mov 1024,sp
    
    mov 29482,a
    push a
    mov 13234,a
    push a
    mov 21331,a
    push a
    mov 12334,a
    push a
    
    call _addInt32
    pop ou
    pop c
    pop 2
    hlt

_addInt32:
    peek 2,a
    peek 4,b
    add a,b
    put a,2
    peek 3,a
    peek 5,b
    jnc not_carry
        inc a
    not_carry:
    add a,b
    put a,3
    
    ret

        

    
