; bit-shifting
_main:
    mov 1,a
    left:
        shl a
        jns left
        jmp right
    right:
        shr a
        jnp right
        jmp left