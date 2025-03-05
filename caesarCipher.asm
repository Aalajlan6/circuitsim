;;=============================================================
;; CS 2110 - Spring 2025
;; Homework 4 - Caesar Cipher
;;=============================================================
;; Name: Abdulaziz Alajlan
;;=============================================================

;;  In this file, you must implement the 'MOD' and 'ENCRYPT' subroutines.

.orig x3000

    ; Main: Setup stack and call ENCRYPT
    LD   R6, STACK_PTR

    LD   R0, STRING       ; Push the string address
    ADD  R6, R6, -1
    STR  R0, R6, 0

    LD   R0, SHIFT        ; Push the shift value
    ADD  R6, R6, -1
    STR  R0, R6, 0

    JSR  ENCRYPT          ; Call ENCRYPT
    
    LDR  R0, R6, 0        ; Return value (not used here)
    ADD  R6, R6, 3        ; Pop arguments + return value
    HALT

; Data
STACK_PTR   .fill xF000
STRING      .fill x4000
SHIFT       .fill 7
ASCIIUPPERA .fill 65      ; 'A'
ASCIILOWERA .fill 97      ; 'a'
ALPHABETLEN .fill 26      ; 26 letters

; ------------------------------------------------------------
MOD
    ; MOD(a, b): a mod b
    ; a is at R5+4, b at R5+5, return in R5+3

    ; Stack build-up (reordered a bit)
    ADD  R6, R6, -4
    STR  R7, R6, 2         ; save RA
    STR  R5, R6, 1         ; save old FP
    ADD  R5, R6, 0         ; R5 = new FP
    ADD  R6, R6, -5        ; push R0-R4
    STR  R0, R5, -1
    STR  R1, R5, -2
    STR  R2, R5, -3
    STR  R3, R5, -4
    STR  R4, R5, -5

    ; Load arguments
    LDR  R0, R5, 4
    LDR  R1, R5, 5

WHILE
    NOT  R2, R1            ; R2 = ~b
    ADD  R2, R2, #1        ; R2 = -b
    ADD  R3, R0, R2        ; R3 = a - b
    BRn  ENDWHILE
    ADD  R0, R0, R2        ; a = a - b
    BR   WHILE

ENDWHILE
    STR  R0, R5, 3         ; store (a mod b)

    ; Teardown
    LDR  R4, R5, -5        ; restore R4
    LDR  R3, R5, -4
    LDR  R2, R5, -3
    LDR  R1, R5, -2
    LDR  R0, R5, -1
    ADD  R6, R5, #0
    LDR  R5, R6, 1         ; old FP
    LDR  R7, R6, 2         ; RA
    ADD  R6, R6, 3
    RET

; ------------------------------------------------------------
ENCRYPT
    ; ENCRYPT(str, k): modifies str in-place with Caesar shift

    ; Stack build-up
    ADD  R6, R6, -4
    STR  R7, R6, 2         ; save RA
    STR  R5, R6, 1         ; save old FP
    ADD  R5, R6, 0         ; R5 = new FP
    ADD  R6, R6, -5        ; push R0-R4
    STR  R0, R5, -1
    STR  R1, R5, -2
    STR  R2, R5, -3
    STR  R3, R5, -4
    STR  R4, R5, -5

    ; Get arguments
    LDR  R0, R5, 4         ; str
    LDR  R1, R5, 5         ; k

    ; length = 0
    AND  R2, R2, #0
LENGTH_LOOP
    ADD  R3, R0, R2
    LDR  R3, R3, 0
    BRz  END_LENGTH
    ADD  R2, R2, #1
    BR   LENGTH_LOOP
END_LENGTH

    ; for i in [0..length-1]
    AND  R3, R3, #0        ; i = 0
FOR_LOOP
    NOT  R4, R2            ; R4 = -length
    ADD  R4, R4, #1
    ADD  R4, R3, R4        ; R4 = i - length
    BRzp END_FOR           ; if i >= length, done

    ; Get str[i]
    ADD  R4, R0, R3
    LDR  R4, R4, 0

    ; Check if 'a' <= char <= 'z'
    LD   R7, ASCIILOWERA
    NOT  R7, R7
    ADD  R7, R7, #1
    ADD  R7, R4, R7        ; char - 'a'
    BRn  CHECK_UPPER

    LD   R7, ASCIILOWERA   ; compute 'z'
    ADD  R7, R7, #15
    ADD  R7, R7, #10
    NOT  R7, R7
    ADD  R7, R7, #1
    ADD  R7, R4, R7        ; char - 'z'
    BRp  CHECK_UPPER

    ; Lowercase transform
    LD   R7, ASCIILOWERA
    NOT  R7, R7
    ADD  R7, R7, #1
    ADD  R4, R4, R7        ; char -= 'a'
    ADD  R4, R4, R1        ; char += k
    LD   R7, ALPHABETLEN
    ADD  R6, R6, -1
    STR  R7, R6, 0
    ADD  R6, R6, -1
    STR  R4, R6, 0
    JSR  MOD
    LDR  R4, R6, 0
    ADD  R6, R6, 2
    LD   R7, ASCIILOWERA
    ADD  R4, R4, R7
    BR   WRITE_CHAR

CHECK_UPPER
    ; Check if 'A' <= char <= 'Z'
    LD   R7, ASCIIUPPERA
    NOT  R7, R7
    ADD  R7, R7, #1
    ADD  R7, R4, R7
    BRn  WRITE_CHAR

    LD   R7, ASCIIUPPERA
    ADD  R7, R7, #15
    ADD  R7, R7, #10
    NOT  R7, R7
    ADD  R7, R7, #1
    ADD  R7, R4, R7        ; char - 'Z'
    BRp  WRITE_CHAR

    ; Uppercase transform
    LD   R7, ASCIIUPPERA
    NOT  R7, R7
    ADD  R7, R7, #1
    ADD  R4, R4, R7        ; char -= 'A'
    ADD  R4, R4, R1        ; char += k
    LD   R7, ALPHABETLEN
    ADD  R6, R6, -1
    STR  R7, R6, 0
    ADD  R6, R6, -1
    STR  R4, R6, 0
    JSR  MOD
    LDR  R4, R6, 0
    ADD  R6, R6, 2
    LD   R7, ASCIIUPPERA
    ADD  R4, R4, R7

WRITE_CHAR
    ; Save new char
    ADD  R7, R0, R3
    STR  R4, R7, 0
    ADD  R3, R3, #1
    BR   FOR_LOOP

END_FOR
    ; Teardown
    LDR  R4, R5, -5
    LDR  R3, R5, -4
    LDR  R2, R5, -3
    LDR  R1, R5, -2
    LDR  R0, R5, -1
    ADD  R6, R5, 0
    LDR  R5, R6, 1
    LDR  R7, R6, 2
    ADD  R6, R6, 3
    RET

.end

.orig x4000
    .stringz "hello"
.end
