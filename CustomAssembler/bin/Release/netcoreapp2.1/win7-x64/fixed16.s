; adding 32-bit
jmp 32
rr0:
0
rr1:
0
rr2:
0
rr3:
0
rr4:
0
rr5:
0
rr6:
0
rr7:
0
currentX:
0
currentY:
0

a_x:
0
a_y:
0
a_z:
0

b_x:
0
b_y:
0
b_z:
0

c_x:
0
c_y:
0
c_z:
0

c_x:
0
c_y:
0
c_z:
0

d_x:
0
d_y:
0
d_z:
0

e_x:
0
e_y:
0
e_z:
0

<32>
_main:
    mov 8192,sp

    ; ensure we have the same state after reset
    mov 0,a
    mov 0,b
    mov 0,c
    mov 0,d
    mov 0,ou
    
    
    mov 15,*currentY

    main_loop_y:
        mov 31,*currentX
        main_loop_x:
        
        mov *currentX,a
        dshl a
        shl a
        mov a,*a_x

        mov *currentY,a
        dshl a
        shl a
        mov a,*a_y

        mov a_x,d
        call _vectorToColor

        mov ou,x0

        dec *currentX
        jns main_loop_x
    dec *currentY
    jns main_loop_y

    hlt

; *d in (rgb, normalized)
; ou in
_vectorToColor:
   
    mov *d,b
    dshr b
    shr b
    or a,b
    qshl a
    shl a


    inc d
    mov *d,b
    dshr b
    or a,b
    qshl a
    dshl a

    inc d
    mov *d,b
    dshr b
    shr b
    or a,b

    mov a,ou

    ret



; c left hand
; d right hand
; ou out
_mul16fast:

    mov 0,a
    mov 16,b

    mul16fast_loop:
        shl a
        shl c
        jnc mul16fast_nc
            add a,d
        mul16fast_nc:
        dec b
        jnz mul16fast_loop

    mov a,ou
    ret


; c left hand
; d right hand
; ou,c out
_mul16:

    mov 0,a
    mov 16,ou

    mul16_loop:
        shl a
        cmovc 1,b
        shl c
        
        jnc mul16_nc
            add a,d
            jnc mul16_nc
                inc c
        mul16_nc:
        add c,b
        dec ou
        jnz mul16_loop

    mov a,ou
    ret


; c left hand
; d right hand
; ou out
_mul16q:

    mov 0,b

    flg c
    jns mulFixed16_ns0
        neg c
        inc b
    mulFixed16_ns0:

    flg d
    jns mulFixed16_ns1
        neg d
        inc b
    mulFixed16_ns1:

    push b

    ;mov 1,c ; mask
    mov 0,a
    mov 0,ou ; result

    mul16q_unfold:
        shl a
        shl c
        jnc mul16q_nc0
            add a,d
        mul16q_nc0:


        shl a
        shl c
        jnc mul16q_nc1
            add a,d
        mul16q_nc1:


        shl a
        shl c
        jnc mul16q_nc2
            add a,d
        mul16q_nc2:


        shl a
        shl c
        jnc mul16q_nc3
            add a,d
        mul16q_nc3:


        shl a
        shl c
        jnc mul16q_nc4
            add a,d
        mul16q_nc4:


        shl a
        shl c
        jnc mul16q_nc5
            add a,d
        mul16q_nc5:


        shl a
        shl c
        jnc mul16q_nc6
            add a,d
        mul16q_nc6:


        shl a
        shl c
        jnc mul16q_nc7
            add a,d
        mul16q_nc7:



        shl a
        cmovc 1,b
        shl c
        jnc mul16_nc8
            add a,d
            jnc mul16_nc8
                inc c
        mul16_nc8:
        add c,b


        shl a
        cmovc 1,b
        shl c
        jnc mul16_nc9
            add a,d
            jnc mul16_nc9
                inc c
        mul16_nc9:
        add c,b


        shl a
        cmovc 1,b
        shl c
        jnc mul16_nc10
            add a,d
            jnc mul16_nc10
                inc c
        mul16_nc10:
        add c,b


        shl a
        cmovc 1,b
        shl c
        jnc mul16_nc11
            add a,d
            jnc mul16_nc11
                inc c
        mul16_nc11:
        add c,b


        shl a
        cmovc 1,b
        shl c
        jnc mul16_nc12
            add a,d
            jnc mul16_nc12
                inc c
        mul16_nc12:
        add c,b


        shl a
        cmovc 1,b
        shl c
        jnc mul16_nc13
            add a,d
            jnc mul16_nc13
                inc c
        mul16_nc13:
        add c,b


        shl a
        cmovc 1,b
        shl c
        jnc mul16_nc14
            add a,d
            jnc mul16_nc14
                inc c
        mul16_nc14:
        add c,b


        shl a
        cmovc 1,b
        shl c
        jnc mul16_nc15
            add a,d
            jnc mul16_nc15
                inc c
        mul16_nc15:
        add c,b


    qshr a
    qshr a
    mov a,ou

    mov c,a
    qshl a
    qshl a
    or ou,a

    pop a
    flg a
    jnp mul16q_ret
        neg ou
    mul16q_ret:
    ret

_inv16q:

    mov 0,b
    flg c
    jns inv16q_ns0
        neg c
        inc b
    inv16q_ns0:
    push b
    mov 0,b

    mov sp,*rr0
    mov 16,sp ; 16 + 1 iterations, emulating 17-bit number so we can represent 65536
    mov 0,ou

    mov 32768,d

    shl d
    cmovc 1,b
    shl ou
    or ou,b

    mov ou,a
    sub a,c
    jc inv16q_nc0
        inc d
        sub ou,c
    inv16q_nc0:

    inv16q_loop:
        shl d
        shl ou

        mov ou,a
        sub a,c
        jc inv16q_nc1
            inc d
            sub ou,c
        inv16q_nc1:
        dec sp
        jnz inv16q_loop

    mov d,ou
    mov *rr0,sp

    pop a
    flg a
    jnp inv16q_ret
        neg ou
    inv16q_ret:

    ret


; c left hand
; d right hand
; ou out
_div:
    swp c,d
    mov sp,*rr0
    mov 16,sp
    mov 0,ou
    div_loop:
        shl d
        cmovc 1,b
        shl ou
        or ou,b
        ;cmp ou,d
        mov ou,a
        sub a,c
        jc div_nc
            inc d
            sub ou,c
        div_nc:
        dec sp
        jnz div_loop

    mov d,ou
    mov *rr0,sp    
    ret


; d in
; ou out
_sqrt:
    mov sp,*rr0
    mov 0,b
    mov 0,ou
    mov 0,c
    mov 8,sp

    sqrt_loop:
        shl ou
        mov ou,c
        shl c
        incnf c

        shl d
        cmovc 1,a
        shl b
        add b,a

        shl d
        cmovc 1,a
        shl b
        add b,a

        cmp b,c
        jc sqrt_nc
            inc ou
            sub b,c
        sqrt_nc:

        dec sp
        jnz sqrt_loop
        
    mov *rr0,sp
    ret

; d in
; ou out
;_sqrt16q:
;    mov sp,*rr0
;    mov c,d
;    mov 0,b
;    mov 0,ou
;    mov 0,c
;    mov 8,sp
;
;    sqrt16q_loop:
;        shl ou
;        mov ou,c
;        shl c
;        incnf c
;
;        shl d
;        cmovc 1,a
;        shl b
;        add b,a
;
;        shl d
;        cmovc 1,a
;        shl b
;        add b,a
;
;        cmp b,c
;        jc sqrt16q_nc
;            inc ou
;            sub b,c
;        sqrt16q_nc:
;
;        dec sp
;        jnz sqrt16q_loop
;        
;    mov *rr0,sp
;    mov ou,a
;    qshr a
;    mov a,ou
;    ret

; c in
; ou out
_sqrt16q:
    
    mov c,b
    and b,255
    push b

    mov c,a
    qshr a
    qshr a

    ; lerp
    add a,sqrt_lookup
    mov *a,b ; x
    inc a
    mov *a,d ; y
    pop c

    push b
    sub d,b

    nop
    nop
    nop
    nop
    ;mov 36,c
    ;mov 69,d

    mov 0,a
    mov 0,ou ; result

    sqrt16q_unfold:
        shl a
        shl c
        jnc sqrt16q_nc0
            add a,d
        sqrt16q_nc0:


        shl a
        shl c
        jnc sqrt16q_nc1
            add a,d
        sqrt16q_nc1:


        shl a
        shl c
        jnc sqrt16q_nc2
            add a,d
        sqrt16q_nc2:


        shl a
        shl c
        jnc sqrt16q_nc3
            add a,d
        sqrt16q_nc3:


        shl a
        shl c
        jnc sqrt16q_nc4
            add a,d
        sqrt16q_nc4:


        shl a
        shl c
        jnc sqrt16q_nc5
            add a,d
        sqrt16q_nc5:


        shl a
        shl c
        jnc sqrt16q_nc6
            add a,d
        sqrt16q_nc6:


        shl a
        shl c
        jnc sqrt16q_nc7
            add a,d
        sqrt16q_nc7:



        shl a
        cmovc 1,b
        shl c
        jnc sqrt16q_nc8
            add a,d
            jnc sqrt16q_nc8
                inc c
        sqrt16q_nc8:
        add c,b


        shl a
        cmovc 1,b
        shl c
        jnc sqrt16q_nc9
            add a,d
            jnc sqrt16q_nc9
                inc c
        sqrt16q_nc9:
        add c,b


        shl a
        cmovc 1,b
        shl c
        jnc sqrt16q_nc10
            add a,d
            jnc sqrt16q_nc10
                inc c
        sqrt16q_nc10:
        add c,b


        shl a
        cmovc 1,b
        shl c
        jnc sqrt16q_nc11
            add a,d
            jnc sqrt16q_nc11
                inc c
        sqrt16q_nc11:
        add c,b


        shl a
        cmovc 1,b
        shl c
        jnc sqrt16q_nc12
            add a,d
            jnc sqrt16q_nc12
                inc c
        sqrt16q_nc12:
        add c,b


        shl a
        cmovc 1,b
        shl c
        jnc sqrt16q_nc13
            add a,d
            jnc sqrt16q_nc13
                inc c
        sqrt16q_nc13:
        add c,b


        shl a
        cmovc 1,b
        shl c
        jnc sqrt16q_nc14
            add a,d
            jnc sqrt16q_nc14
                inc c
        sqrt16q_nc14:
        add c,b


        shl a
        cmovc 1,b
        shl c
        jnc sqrt16q_nc15
            add a,d
            jnc sqrt16q_nc15
                inc c
        sqrt16q_nc15:
        add c,b
    
    qshr a
    qshr a
    mov a,ou
    
    mov c,a
    qshl a
    qshl a
    or ou,a

    pop a
    add ou,a
    
    ret

sqrt_lookup:
    0
    256
    362
    443
    512
    572
    627
    677
    724
    768
    810
    849
    887
    923
    958
    991
    1024
    1056
    1086
    1116
    1145
    1173
    1201
    1228
    1254
    1280
    1305
    1330
    1355
    1379
    1402
    1425
    1448
    1471
    1493
    1515
    1536
    1557
    1578
    1599
    1619
    1639
    1659
    1679
    1698
    1717
    1736
    1755
    1774
    1792
    1810
    1828
    1846
    1864
    1881
    1899
    1916
    1933
    1950
    1966
    1983
    1999
    2016
    2032
    2048
    2064
    2080
    2095
    2111
    2126
    2142
    2157
    2172
    2187
    2202
    2217
    2232
    2246
    2261
    2275
    2290
    2304
    2318
    2332
    2346
    2360
    2374
    2388
    2401
    2415
    2429
    2442
    2455
    2469
    2482
    2495
    2508
    2521
    2534
    2547
    2560
    2573
    2585
    2598
    2611
    2623
    2636
    2648
    2660
    2673
    2685
    2697
    2709
    2721
    2733
    2745
    2757
    2769
    2781
    2793
    2804
    2816
    2828
    2839
    2851
    2862
    2874
    2885





        

    
