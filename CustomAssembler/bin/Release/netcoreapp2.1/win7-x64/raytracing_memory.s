; raytracing sphere in isometric; run at high frequency otherwise artifacts! up to 17kHz
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

pixelIndex:
0

<32>
NEAR_PLANE_DISTANCE = 512
NEAR_PLANE_X = 256
NEAR_PLANE_X_2 = 128
NEAR_PLANE_Y = 128
NEAR_PLANE_Y_2 = 64
_main:
    mov 8192,sp

    ; ensure we have the same state after reset
    mov 0,a
    mov 0,b
    mov 0,c
    mov 0,d
    mov 0,ou
    

    ;mov 0,a
    ;mov a,*a_x
    ;mov 0,a
    ;mov a,*a_y
    ;mov 256,a
    ;mov a,*a_z
;
    ;mov 448,a
    ;mov a,*b_x
    ;mov 224,a
    ;mov a,*b_y
    ;mov 1024,a
    ;neg a
    ;mov a,*b_z
;
    ;mov b_x,c
    ;mov a_x,d
    ;call _intersectSphere
    ;hlt

    mov framebuffer,a
    mov a,*pixelIndex

    mov 0,a
    mov a,*b_x
    mov a,*b_y
    mov 256,a
    ;neg a
    mov a,*b_z

    mov 15,a
    mov a,*currentY

    main_loop_y:

        mov 0,a
        mov 0,b
        mov 0,c
        mov 0,d
        mov 0,ou

        mov 31,a
        mov a,*currentX

        main_loop_x:

            ;mov *currentX,x0
            ;mov *currentY,x0

            mov *currentX,a
            dshl a
            dshl a
            shl a
            sub a,512
            mov a,*a_x

            mov *currentY,a
            dshl a
            dshl a
            shl a
            sub a,256
            mov a,*a_y

            mov 1024,a
            neg a
            mov a,*a_z


            ;mov *a_x,x0
            ;mov *a_y,x0
            ;mov *a_z,x0
    ;
            ;mov a_x,d
            ;call _normalize
            mov 0,c
            mov 0,d
            mov 0,ou

            mov a_x,c
            mov b_x,d
            call _intersectSphere
            mov d,a
            flg a
            qshl a
            mov a,ou
            jz main_continue
            
            mov c,a
            dshr a
            qshl a
            shl a
            or ou,a

            ;mov *pixelIndex,a
            ;mov ou,*a
            ;inc a
            ;mov a,*pixelIndex
            
            ;mov *a_x,x0
            ;mov *a_y,x0
            ;mov *a_z,x0

            main_continue:

            mov *pixelIndex,a
            mov ou,*a
            inc a
            mov a,*pixelIndex

            dec *currentX
        jns main_loop_x
 
    dec *currentY
    jns main_loop_y

    hlt

; *d in rayDir
; *c in rayOrigin
; d out true/false
; c out distanceToIntersect
; sphere at 0,0,0 with radius 1
_intersectSphere:

    mov c,*rr0 ; &rayOrigin
    mov d,*rr1 ; &rayDir

    ; sphere origin minus origin into vector c
    mov *c,a
    neg a
    mov a,*c_x
    inc c

    mov *c,a
    neg a
    mov a,*c_y
    inc c

    mov *c,a
    neg a
    mov a,*c_z

    mov *c_x,x0 ; -origin
    mov *c_y,x0
    mov *c_z,x0

    ; tca = dot(-rayOrigin, rayDir)
    mov c_x,c
    mov *rr1,d
    call _dotProduct

    ; if (tca < 0) return false;
    flg ou
    js intersectSphere_ret_false
    mov ou,*rr3 ; tca n
    mov ou,x0

    ; tcaSqr = tca * tca
    mov ou,c
    mov ou,d
    call _mul16q
    mov ou,*rr4 ; tcaSqr
    mov ou,x0

    ; dSqr = dot(-origin,-origin) - tcaSqr
    mov c_x,c
    mov c_x,d
    call _dotProduct
    mov ou,x0 ; dot(-origin,-origin)
    mov *rr4,a
    sub ou,a ; dSqr
    mov ou,x0

    ; if(dSqr > 1.0) return false;
    mov ou,a
    sub a,256
    jns intersectSphere_ret_false
    mov a,x0

    ; thc = sqrt(1.0 - dSqr)
    mov 256,c
    sub c,ou
    call _sqrt16q
    mov ou,x0 ; thc

    ; t = tca - thc
    mov *rr3,c
    sub c,ou

    ; return true;
    mov 1,d
    ret

    intersectSphere_ret_false:
    mov 0,d
    ret

; *c,*d in
; ou out
_dotProduct:
    mov c,*rr0   
    mov d,*rr1

    mov *c,c   
    mov *d,d
    call _mul16q
    mov ou,x0
    push ou

    inc *rr0
    inc *rr1

    mov *rr0,c   
    mov *c,c   
    mov *rr1,d
    mov *d,d
    mov c,x0
    mov d,x0
    call _mul16q
    mov ou,x0
    push ou

    inc *rr0
    inc *rr1
    
    mov *rr0,c   
    mov *c,c   
    mov *rr1,d
    mov *d,d
    call _mul16q
    mov ou,x0

    pop a
    add ou,a
    pop a
    add ou,a
    
    ret

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

; *d in
_normalize:
    
    push d
    push d
    mov *d,c
    mov *d,d

    call _mul16q
    ;mov ou,x0 ;dbg
    pop d
    push ou

    
    inc d
    push d
    mov *d,c
    mov *d,d
    call _mul16q
    ;mov ou,x0 ;dbg
    pop d
    push ou


    inc d
    push d
    mov *d,c
    mov *d,d
    call _mul16q
    ;mov ou,x0 ;dbg
    pop d
    
    pop a
    add ou,a
    pop a
    add ou,a ; sqr magnitude

    mov 0,d
    mov ou,c

    call _sqrt16q
    ;mov ou,x0 ;dbg
    mov ou,c
    call _inv16q
    
    mov ou,*rr0 ; inv magnitude

    ; multiply with inv magnitude
    pop d
    mov *d,c
    push d
    mov *rr0,d
    call _mul16q
    
    pop d
    mov ou,*d
    inc d
    push d

    pop d
    mov *d,c
    push d
    mov *rr0,d
    call _mul16q
    pop d
    mov ou,*d
    inc d
    push d

    pop d
    mov *d,c
    push d
    mov *rr0,d
    call _mul16q
    pop d
    mov ou,*d

    ret


; in c,d
; out ou
_mul16q:

    mov 0,b
    flg c
    jnz mul16q_nz0
        mov 0,ou
        ret
    mul16q_nz0:
    jns mul16q_ns0
        neg c
        inc b
    mul16q_ns0:

    flg d
    jnz mul16q_nz1
        mov 0,ou
        ret
    mul16q_nz1:
    jns mul16q_ns1
        neg d
        inc b
    mul16q_ns1:
    push b

    mov c,b
    mov 0,c
    mov 0,a
    
    mulst d
    mulst d
    mulst d
    mulst d

    mulst d
    mulst d
    mulst d
    mulst d

    swp a,b

    mstf d
    mstfs d
    mstf d
    mstfs d
    mstf d
    mstfs d
    mstf d
    mstfs d

    mstf d
    mstfs d
    mstf d
    mstfs d
    mstf d
    mstfs d
    mstf d
    mstfs d

    mov 0,ou

    mov b,d

    qshl a
    qshl a
    or ou,a

    mov d,a
    qshr a
    qshr a
    or ou,a

    pop a
    flg a
    jnp mul16q_ret
        neg ou
    mul16q_ret:
    ret


; in c
; out ou = 1/c
_inv16q:
    
    mov 0,b
    flg c
    jns inv16q_ns0
        neg c
        inc b
    inv16q_ns0:
    push b


    mov 32768,b
    mov c,d
    mov 0,a
    mov 0,c

    divst d
    swp a,b

    divst d
    swp a,b
    divst d
    swp a,b
    divst d
    swp a,b
    divst d
    swp a,b
    
    divst d
    swp a,b
    divst d
    swp a,b
    divst d
    swp a,b
    divst d
    swp a,b

    divst d
    swp a,b
    divst d
    swp a,b
    divst d
    swp a,b
    divst d
    swp a,b

    divst d
    swp a,b
    divst d
    swp a,b
    divst d
    swp a,b
    divst d
    swp a,b

    mov b,ou


    pop a
    flg a
    jnp inv16q_ret
        neg ou
    inv16q_ret:

    ret




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

    call _mul16q

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
0xdede
0xdede
0xdede
0xdede
framebuffer:
0





        

    
