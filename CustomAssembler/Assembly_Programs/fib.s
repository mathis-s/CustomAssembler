_main:
    mov 1,a
    mov 0,ou
    loop:
        mov a,c ; moves contents of a to c
        add a,ou ; adds ou to a, result in a
        mov c,ou ; moves c to ou
    jnc loop
    hlt