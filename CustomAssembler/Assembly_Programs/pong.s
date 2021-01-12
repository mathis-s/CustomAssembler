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



<32>
_main:
    mov 16384,sp

    mov 1,*xpo
    mov 31,*ypo

    mov 8,*xve
    mov 4,*yve
    ;neg *yve

    main_loop:
        mov *xve,a
        add *xpo,a

        mov *yve,a
        add *ypo,a

        mov *xpo,a
        flg a
        jns main_x_low
            neg *xve
            neg *xpo
        main_x_low:
        
        mov *xpo,a
        sub a,243
        js main_x_high
            neg *xve
            mov 248,a
            mov a,*xpo ; cheating :)
        main_x_high:

        mov *ypo,a
        flg a
        jns main_y_low
            neg *yve
            neg *ypo
        main_y_low:
        
        mov *ypo,a
        sub a,115
        js main_y_high
            neg *yve
            mov 120,a
            mov a,*ypo ; cheating :)
        main_y_high:


        mov *ypo,c
        dshr c
        shr c
        mov c,d

        mov *xpo,c
        dshr c
        shr c

        call _setPixel
        call _outFramebuffer
        call _unsetRow

        ;mov *xve,ou

        jmp main_loop
    hlt

; c in and out : fixed16
_roundToIntFixed16:
    mov c,a
    dshr c
    shr c
    flg a
    jns roundToIntFixed16_positive
    or a,57344
    roundToIntFixed16_positive:
    and a,7
    sub a,4
    js roundToIntFixed16_return
    inc c
    roundToIntFixed16_return:
    ret

shift_table:
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
; c: x; d: y
_setPixel:

    push c
    mov shift_table,a
    add a,d
    mov *a,a
    push a
    ;mov 1,b
    ;mov d,a
    ;shl b,a
    ;push b


    add c,fb_0

    pop b
    mov *c,a
    or a,b
    mov a,*c
    pop c

    ret

; c: x
_unsetRow:

    mov c,b
    add b,fb_0

    mov 0,a
    mov a,*b
    ret

fb_0:
0
fb_1:
0
fb_2:
0
fb_3:
0
fb_4:
0
fb_5:
0
fb_6:
0
fb_7:
0
fb_8:
0
fb_9:
0
fb_10:
0
fb_11:
0
fb_12:
0
fb_13:
0
fb_14:
0
fb_15:
0
fb_16:
0
fb_17:
0
fb_18:
0
fb_19:
0
fb_20:
0
fb_21:
0
fb_22:
0
fb_23:
0
fb_24:
0
fb_25:
0
fb_26:
0
fb_27:
0
fb_28:
0
fb_29:
0
fb_30:
0
fb_31:
0
; the constants are the framebuffer; the code is modified by setPixel
_outFramebuffer:
    mov *fb_0,x0
    mov *fb_1,x0
    mov *fb_2,x0
    mov *fb_3,x0
    mov *fb_4,x0
    mov *fb_5,x0
    mov *fb_6,x0
    mov *fb_7,x0
    mov *fb_8,x0
    mov *fb_9,x0
    mov *fb_10,x0
    mov *fb_11,x0
    mov *fb_12,x0
    mov *fb_13,x0
    mov *fb_14,x0
    mov *fb_15,x0
    mov *fb_16,x0
    mov *fb_17,x0
    mov *fb_18,x0
    mov *fb_19,x0
    mov *fb_20,x0
    mov *fb_21,x0
    mov *fb_22,x0
    mov *fb_23,x0
    mov *fb_24,x0
    mov *fb_25,x0
    mov *fb_26,x0
    mov *fb_27,x0
    mov *fb_28,x0
    mov *fb_29,x0
    mov *fb_30,x0
    mov *fb_31,x0
    ret
