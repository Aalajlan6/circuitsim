;;=============================================================
;; CS 2110 - Spring 2025
;; Homework 4 - Caesar Cipher
;;=============================================================
;; Name: Abdulaziz Alajlan
;;=============================================================

.orig x3000

    ; -------------------------------
    ; Main: Push arguments for ENCRYPT
    ; -------------------------------
    LD   R6, STACK_PTR       ; R6 = top of stack

    ADD  R6, R6, -1          ; push SHIFT
    LD   R0, SHIFT
    STR  R0, R6, 0
    
    ADD  R6, R6, -1          ; push STRING
    LD   R0, STRING
    STR  R0, R6, 0
    
    JSR  ENCRYPT             ; call ENCRYPT(string, shift)
    
    ADD  R6, R6, 2           ; pop 2 arguments off stack
    HALT

; --------------------------------------------------------------
STACK_PTR         .fill xF000
STRING            .fill x4000
SHIFT             .fill 5
ALPHA             .fill 26
ASCII_UPPER_A     .fill 65
ASCII_UPPER_Z     .fill 90
ASCII_LOWER_A     .fill 97
ASCII_LOWER_Z     .fill 122

; --------------------------------------------------------------

MOD  
    ; ------ BUILD UP ------
    ADD  R6, R6, -1  
    STR  R7, R6, 0       ; save return address
    ADD  R6, R6, -1
    STR  R5, R6, 0       ; save old FP
    ADD  R5, R6, 0       ; set R5 as new FP

    ; allocate space for return value
    ADD  R6, R6, -1

    ; load arguments from caller's stack frame
    LDR  R0, R5, #2      ; a
    LDR  R1, R5, #3      ; b

MOD_LOOP:
    NOT  R2, R1
    ADD  R2, R2, #1      ; R2 = -b
    ADD  R3, R0, R2      ; R3 = a - b
    BRn  MOD_DONE
    ADD  R0, R3, #0      ; a = a - b
    BR   MOD_LOOP

MOD_DONE:
    ; store the result at FP+3
    STR  R0, R5, #3

    ; ------ TEAR DOWN ------
    ADD  R6, R6, #1      ; pop return-value slot (unused, since we stored at FP+3)

    LDR  R5, R6, #0      ; restore old FP
    ADD  R6, R6, #1      

    LDR  R7, R6, #0      ; restore return address
    ADD  R6, R6, #1      
    RET

; --------------------------------------------------------------
; ENCRYPT(str, k) --> modifies str in-place with Caesar shift
; --------------------------------------------------------------
ENCRYPT
    ; ------ BUILD UP ------
    ADD  R6, R6, -1
    STR  R7, R6, 0        ; save return address
    ADD  R6, R6, -1
    STR  R5, R6, 0        ; save old FP
    ADD  R5, R6, 0        ; set R5 as new FP

    ; allocate space for local variable(s)
    ADD  R6, R6, -1

    ; save caller registers if needed
    ADD  R6, R6, -1
    STR  R0, R6, 0
    ADD  R6, R6, -1
    STR  R1, R6, 0
    ADD  R6, R6, -1
    STR  R2, R6, 0
    ADD  R6, R6, -1
    STR  R3, R6, 0
    ADD  R6, R6, -1
    STR  R4, R6, 0

    ; load arguments
    LDR  R0, R5, #2       ; str
    LDR  R1, R5, #3       ; k

    ; R2 = pointer used to find length
    ADD  R2, R0, #0

FIND_LEN:
    LDR  R3, R2, #0
    BRz  GOT_LEN
    ADD  R2, R2, #1
    BR   FIND_LEN

GOT_LEN:
    ; R2 now points to the null terminator
    ; We'll do a for-loop from str to str+(length-1)

    ; R4 = current pointer as we loop
    ADD  R4, R0, #0

ENC_LOOP:
    LDR  R3, R4, #0
    BRz  ENC_DONE         ; if char == 0, done

    ; check if 'a' <= char <= 'z'
    LD   R7, ASCII_LOWER_A
    NOT  R7, R7
    ADD  R7, R7, #1
    ADD  R5, R3, R7       ; R5 = char - 'a'
    BRn  CHECK_UPPER
    LD   R7, ASCII_LOWER_Z
    ADD  R7, R7, #1
    NOT  R7, R7
    ADD  R5, R3, R7       ; R5 = char - 'z'
    BRp  CHECK_UPPER

    ; 'a' <= char <= 'z', so shift
    LD   R7, ASCII_LOWER_A
    NOT  R7, R7
    ADD  R7, R7, #1
    ADD  R3, R3, R7       ; R3 = char - 'a'
    ADD  R3, R3, R1       ; R3 += k

    ; call MOD(R3, 26)
    LD   R7, ALPHA
    ADD  R6, R6, -1
    STR  R7, R6, #0       ; push 2nd arg
    ADD  R6, R6, -1
    STR  R3, R6, #0       ; push 1st arg
    JSR  MOD
    LDR  R3, R6, #0
    ADD  R6, R6, #2

    LD   R7, ASCII_LOWER_A
    ADD  R3, R3, R7
    BR   WRITE_CHAR

CHECK_UPPER:
    ; check if 'A' <= char <= 'Z'
    LD   R7, ASCII_UPPER_A
    NOT  R7, R7
    ADD  R7, R7, #1
    ADD  R5, R3, R7       ; R5 = char - 'A'
    BRn  WRITE_CHAR
    LD   R7, ASCII_UPPER_Z
    ADD  R7, R7, #1
    NOT  R7, R7
    ADD  R5, R3, R7       ; R5 = char - 'Z'
    BRp  WRITE_CHAR

    ; 'A' <= char <= 'Z', so shift
    LD   R7, ASCII_UPPER_A
    NOT  R7, R7
    ADD  R7, R7, #1
    ADD  R3, R3, R7       ; R3 = char - 'A'
    ADD  R3, R3, R1       ; R3 += k

    ; call MOD(R3, 26)
    LD   R7, ALPHA
    ADD  R6, R6, -1
    STR  R7, R6, #0
    ADD  R6, R6, -1
    STR  R3, R6, #0
    JSR  MOD
    LDR  R3, R6, #0
    ADD  R6, R6, #2

    LD   R7, ASCII_UPPER_A
    ADD  R3, R3, R7

WRITE_CHAR:
    STR  R3, R4, #0

    ; move to next character
    ADD  R4, R4, #1
    BR   ENC_LOOP

ENC_DONE:
    ; ------ TEAR DOWN ------
    STR  R0, R5, #3  ; store return value if needed

    ; restore caller registers
    LDR  R4, R6, #0
    ADD  R6, R6, #1
    LDR  R3, R6, #0
    ADD  R6, R6, #1
    LDR  R2, R6, #0
    ADD  R6, R6, #1
    LDR  R1, R6, #0
    ADD  R6, R6, #1
    LDR  R0, R6, #0
    ADD  R6, R6, #1

    ADD  R6, R6, #1  ; pop local variable

    LDR  R5, R6, #0  ; restore old FP
    ADD  R6, R6, #1

    LDR  R7, R6, #0  ; restore return address
    ADD  R6, R6, #1
    RET

.end

.orig x4000
    .stringz "hello"
.end
