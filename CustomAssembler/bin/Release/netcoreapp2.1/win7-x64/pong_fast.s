; adding 32-bit
jmp 32
xve:
0

yve:
0

xpo:
0

ypo:
0

leftPaddle:
0

rightPaddle:
0

<32>
_main:
    mov 16384,sp

    mov 1,*xpo
    mov 15,*ypo

    mov 1,*xve
    mov 1,*yve

    mov 0,a
    mov a,*rightPaddle
    mov a,*leftPaddle

    main_loop:
        mov *xve,a
        add *xpo,a

        mov *yve,a
        add *ypo,a

        call _handleInput




        mov *xpo,a
        flg a
        jns main_x_low

            mov *ypo,a
            mov *leftPaddle,b
            sub a,b
            js main_halt1
            sub a,4
            js main_continue1
                main_halt1:
                hlt
            main_continue1:
            neg *xve
            neg *xpo
        main_x_low:


        mov *xpo,a
        sub a,30
        js main_x_high

            mov *ypo,a
            mov *rightPaddle,b
            sub a,b
            js main_halt1
            sub a,4
            js main_continue2
                main_halt1:
                hlt
            main_continue2:

            neg *xve
            mov 29,a
            mov a,*xpo ; cheating :)
        main_x_high:



        mov *ypo,a
        flg a
        jns main_y_low
            ;mov 1,x0
            neg *yve
            neg *ypo
        main_y_low:
        
        mov *ypo,a
        sub a,15
        js main_y_high
            ;mov 2,x0
            neg *yve
            mov 15,a
            mov a,*ypo ; cheating :)
        main_y_high:

        ; right paddle ai
        mov *ypo,a
        sub a,12
        js ai_sign
            mov 12,a
            mov a,*rightPaddle
            jmp ai_end
        ai_sign:
        mov *ypo,a
        mov a,*rightPaddle
        ai_end:


        call _outputGamestate
        jmp main_loop
    hlt

_handleInput:
    mov x1,a
    flg a
    jz handleInput_ret
    mov a,c
    dshr a
    dshr a
    mov a,d
    and d,15
    and c,15

    mov d,*leftPaddle
    mov c,*rightPaddle

    handleInput_ret:
    ret

_outputGamestate:
    mov 0,ou
    mov *xpo,a
    inc a
    qshl a
    qshl a
    dshl a
    shl a
    or ou,a

    mov *ypo,a
    qshl a
    dshl a
    shl a
    or ou,a

    mov *rightPaddle,a
    and a,14
    dshl a
    shl a
    or ou,a

    mov *leftPaddle,a
    or ou,a

    mov ou,x0
    ret

    

;shift_table:
;1
;2
;4
;8
;16
;32
;64
;128
;256
;512
;1024
;2048
;4096
;8192
;16384
;32768
;; c: x; d: y
;_setPixel:
;
;    push c
;    mov shift_table,a
;    add a,d
;    mov *a,a
;    push a
;
;    add c,fb_0
;
;    pop b
;    mov *c,a
;    or a,b
;    mov a,*c
;    pop c
;
;    ret

; c: x
;_unsetRow:
;
;    mov c,b
;    add b,fb_0
;
;    mov 0,a
;    mov a,*b
;    ret
;
;fb_0:
;0
;fb_1:
;0
;fb_2:
;0
;fb_3:
;0
;fb_4:
;0
;fb_5:
;0
;fb_6:
;0
;fb_7:
;0
;fb_8:
;0
;fb_9:
;0
;fb_10:
;0
;fb_11:
;0
;fb_12:
;0
;fb_13:
;0
;fb_14:
;0
;fb_15:
;0
;fb_16:
;0
;fb_17:
;0
;fb_18:
;0
;fb_19:
;0
;fb_20:
;0
;fb_21:
;0
;fb_22:
;0
;fb_23:
;0
;fb_24:
;0
;fb_25:
;0
;fb_26:
;0
;fb_27:
;0
;fb_28:
;0
;fb_29:
;0
;fb_30:
;0
;fb_31:
;0
;; the constants are the framebuffer; the code is modified by setPixel
;_outFramebuffer:
;    mov *fb_0,x0
;    mov *fb_1,x0
;    mov *fb_2,x0
;    mov *fb_3,x0
;    mov *fb_4,x0
;    mov *fb_5,x0
;    mov *fb_6,x0
;    mov *fb_7,x0
;    mov *fb_8,x0
;    mov *fb_9,x0
;    mov *fb_10,x0
;    mov *fb_11,x0
;    mov *fb_12,x0
;    mov *fb_13,x0
;    mov *fb_14,x0
;    mov *fb_15,x0
;    mov *fb_16,x0
;    mov *fb_17,x0
;    mov *fb_18,x0
;    mov *fb_19,x0
;    mov *fb_20,x0
;    mov *fb_21,x0
;    mov *fb_22,x0
;    mov *fb_23,x0
;    mov *fb_24,x0
;    mov *fb_25,x0
;    mov *fb_26,x0
;    mov *fb_27,x0
;    mov *fb_28,x0
;    mov *fb_29,x0
;    mov *fb_30,x0
;    mov *fb_31,x0
;    ret
