;;=============================================================
;; CS 2110 - Spring 2025
;; Homework 4 - Leapfrog
;;=============================================================
;; Name: 
;;=============================================================

.orig x3000
SETUP
    LD R3, VALUE     ; R3 = x0100
    LEA R2, SETUP    ; R2 = address
    ADD R4, R2, R3   ; R4 = R2 + R3

    LD R5, STOP      ; R5 = xFE00
    ADD R1, R4, #0   ; R1 = R4

    NOT R6, R5
    ADD R6, R6, #1
    ADD R6, R1, R6
    BRnp SKIP
    HALT

SKIP
    AND R0, R0, #0 

LOOP
    LDR R7, R2, #0
    BRz DONE

    STR R7, R4, #0
    ADD R2, R2, #1
    ADD R4, R4, #1
    BR LOOP

DONE
    AND R7, R7, #0
    STR R7, R4, #0
    JMP R1

VALUE   .FILL x0100
PLACE   .FILL x3000
STOP    .FILL xFE00
        .FILL x0000

.end
