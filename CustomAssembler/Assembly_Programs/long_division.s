; long division
jmp 32

<32>
_main:
    mov 128,sp

    mov 5,a
    push a

    mov 42,a
    push a

    call _div
    pop 2
    mov c,ou
    hlt


result:
0
remainder:
0
mask:
0
_div:
    peek 2,c ; dividend n -- "peeks" behind the stack pointer to load function parameters, load value at sp-2 into a
    peek 3,d ; divisor d

    mov 32768,a
    mov a,*mask
    mov 0,a
    mov a,*result
    mov a,*remainder

    mov 0,b

    div_loop:
        shl *remainder
        

        mov *remainder,a
        and a,65534
        mov a,*remainder

        mov c,a
        and a,*mask
        jz div_zero
            inc *remainder
        div_zero:

        mov *remainder,a
        sub a,d
        js div_r_smaller_d
            mov *remainder,a
            sub a,d
            mov a,*remainder
        
            mov *result,a
            or a,*mask
            mov a,*result

        div_r_smaller_d:
        shr *mask
        mov *mask,a
        afl
        jnz div_loop

    mov *result,c
    mov *remainder,d
    ret
        

    
