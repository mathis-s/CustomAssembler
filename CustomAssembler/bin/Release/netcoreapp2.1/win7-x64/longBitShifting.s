; adding 32-bit
jmp 32
1
2
4
8
16
32
64
128
256
512
1024
2048
4096
8192
16384
32768

<32>
_main:
    mov 0,ou
    mov 0,c
    mov 0,b
    mov 0,a
    loop:
        mov *2,ou
        mov *3,ou
        mov *4,ou
        mov *5,ou
        mov *6,ou
        mov *7,ou
        mov *8,ou
        mov *9,ou
        mov *10,ou
        mov *11,ou
        mov *12,ou
        mov *13,ou
        mov *14,ou
        mov *15,ou
        mov *16,ou
        mov *17,ou
        nop
        mov 0,ou

        mov *2,c
        mov *3,c
        mov *4,c
        mov *5,c
        mov *6,c
        mov *7,c
        mov *8,c
        mov *9,c
        mov *10,c
        mov *11,c
        mov *12,c
        mov *13,c
        mov *14,c
        mov *15,c
        mov *16,c
        mov *17,c
        nop
        mov 0,c

        mov *16,b
        mov *15,b
        mov *14,b
        mov *13,b
        mov *12,b
        mov *11,b
        mov *10,b
        mov *9,b
        mov *8,b
        mov *7,b
        mov *6,b
        mov *5,b
        mov *4,b
        mov *3,b
        mov *2,b
        nop
        mov 0,b

        mov *2,a
        mov *3,a
        mov *4,a
        mov *5,a
        mov *6,a
        mov *7,a
        mov *8,a
        mov *9,a
        mov *10,a
        mov *11,a
        mov *12,a
        mov *13,a
        mov *14,a
        mov *15,a
        mov *16,a
        mov *17,a
        nop

        mov *16,a
        mov *15,a
        mov *14,a
        mov *13,a
        mov *12,a
        mov *11,a
        mov *10,a
        mov *9,a
        mov *8,a
        mov *7,a
        mov *6,a
        mov *5,a
        mov *4,a
        mov *3,a
        mov *2,a
        mov 0,a

        mov *2,b
        mov *3,b
        mov *4,b
        mov *5,b
        mov *6,b
        mov *7,b
        mov *8,b
        mov *9,b
        mov *10,b
        mov *11,b
        mov *12,b
        mov *13,b
        mov *14,b
        mov *15,b
        mov *16,b
        mov *17,b
        mov 0,b

        mov *16,c
        mov *15,c
        mov *14,c
        mov *13,c
        mov *12,c
        mov *11,c
        mov *10,c
        mov *9,c
        mov *8,c
        mov *7,c
        mov *6,c
        mov *5,c
        mov *4,c
        mov *3,c
        mov *2,c
        mov 0,c

        mov *16,ou
        mov *15,ou
        mov *14,ou
        mov *13,ou
        mov *12,ou
        mov *11,ou
        mov *10,ou
        mov *9,ou
        mov *8,ou
        mov *7,ou
        mov *6,ou
        mov *5,ou
        mov *4,ou
        mov *3,ou
        jmp loop

        

        

    
