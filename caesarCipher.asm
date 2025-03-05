;;=============================================================
;; CS 2110 - Spring 2025
;; Homework 4 - Caesar Cipher
;;=============================================================
;; Name: Abdulaziz Alajlan
;;=============================================================

;;  In this file, you must implement the 'MOD' and 'ENCRYPT' subroutines.

.orig x3000

    LD   R6, STACK_PTR

    ; Push SHIFT onto stack
    LD   R0, SHIFT
    ADD  R6, R6, -1
    STR  R0, R6, 0

    ; Push STRING onto stack
    LD   R0, STRING
    ADD  R6, R6, -1
    STR  R0, R6, 0

    ; Call ENCRYPT
    JSR  ENCRYPT

    ; Cleanup and exit
    LDR  R0, R6, 0
    ADD  R6, R6, 3
    HALT

    ;; Do not rename or remove any existing labels
    ;; You may change the value of STRING, LENGTH, SHIFT for debugging
    STACK_PTR     .fill xF000
    STRING        .fill x4000
    SHIFT         .fill 7
    ASCIIUPPERA   .fill 65
    ASCIILOWERA   .fill 97
    ALPHABETLEN   .fill 26

; ---------------------------------------------------------
MOD ;; Do not change this label! Treat this as like the name of the function in a function header
    ;; Slightly reordered build-up and tear-down, same logic
    ADD  R6, R6, -1            ; Reserve space for return value
    ADD  R6, R6, -1            ; Save return address
    STR  R7, R6, 0
    ADD  R6, R6, -1            ; Save old frame pointer
    STR  R5, R6, 0
    ADD  R6, R6, -1            ; Allocate local variable
    ADD  R5, R6, 0             ; R5 = new FP

    ; Save registers
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

    ; Load arguments
    LDR  R0, R5, #4   ; a
    LDR  R1, R5, #5   ; b

WHILE:
    NOT  R2, R1       ; R2 = -b
    ADD  R2, R2, #1
    ADD  R3, R0, R2   ; R3 = a - b
    BRn  FINISH
    ADD  R0, R3, #0   ; a = a - b
    BR   WHILE

FINISH
    STR  R0, R5, #3   ; store return value at FP+3

    ; ------ TEARDOWN ------
    LDR  R4, R6, #0   ; restore R4
    ADD  R6, R6, #1
    LDR  R3, R6, #0
    ADD  R6, R6, #1
    LDR  R2, R6, #0
    ADD  R6, R6, #1
    LDR  R1, R6, #0
    ADD  R6, R6, #1
    LDR  R0, R6, #0
    ADD  R6, R6, #1

    ADD  R6, R6, #1   ; pop local variable

    LDR  R5, R6, #0   ; old FP
    ADD  R6, R6, #1

    LDR  R7, R6, #0   ; return address
    ADD  R6, R6, #1
    RET

; ---------------------------------------------------------
ENCRYPT ;; Do not change this label! Treat this as like the name of the function in a function header
    ;; Code your implementation for the ENCRYPT subroutine here, with a slight reorder

    ; ------ BUILDUP ------
    ADD  R6, R6, -1
    STR  R7, R6, 0      ; Save return address
    ADD  R6, R6, -1
    STR  R5, R6, 0      ; Save old frame pointer
    ADD  R6, R6, -1     ; Allocate space for a local var
    ADD  R5, R6, 0      ; R5 = new FP

    ADD  R6, R6, -1     ; Save R4
    STR  R4, R6, 0
    ADD  R6, R6, -1     ; Save R3
    STR  R3, R6, 0
    ADD  R6, R6, -1     ; Save R2
    STR  R2, R6, 0
    ADD  R6, R6, -1     ; Save R1
    STR  R1, R6, 0
    ADD  R6, R6, -1     ; Save R0
    STR  R0, R6, 0

    LDR  R0, R5, #4     ; str
    LDR  R1, R5, #5     ; k

    AND  R3, R3, #0     ; length = 0

WHILE_LOOP:
    ADD  R4, R0, R3     ; address = &str[length]
    LDR  R4, R4, #0     ; char = str[length]
    BRz  FOR_LOOP
    ADD  R3, R3, #1     ; length++
    BR   WHILE_LOOP

FOR_LOOP:
    AND  R2, R2, #0     ; i = 0

FOR_LOOP_CHECK:
    NOT  R4, R3
    ADD  R4, R4, #1     ; (i - length) compare
    ADD  R4, R2, R4
    BRzp AFTER_FOR

    ADD  R4, R0, R2     ; address of str[i]
    LDR  R4, R4, #0     ; R4 = str[i]

IF_STATMENT:
    LD   R7, ASCIILOWERA
    NOT  R7, R7
    ADD  R7, R7, #1     ; R7 = -'a'
    ADD  R7, R4, R7     ; char - 'a'
    BRn  ELSE_IF

    LD   R7, ASCIILOWERA
    ADD  R7, R7, #10
    ADD  R7, R7, #15    ; 'z'
    NOT  R7, R7
    ADD  R7, R7, #1     ; -char
    ADD  R7, R4, R7     ; 'z' - char
    BRp  ELSE_IF

    LD   R7, ASCIILOWERA
    NOT  R7, R7
    ADD  R7, R7, #1
    ADD  R4, R4, R7     ; char -= 'a'
    ADD  R4, R4, R1     ; char += k

    LD   R7, ALPHABETLEN
    ADD  R6, R6, -1
    STR  R7, R6, #0     ; push second arg
    ADD  R6, R6, -1
    STR  R4, R6, #0     ; push first arg
    JSR  MOD

    LDR  R4, R6, #0     ; R4 = result
    ADD  R6, R6, #3

    LD   R7, ASCIILOWERA
    ADD  R4, R4, R7
    BR   STORING_CHAR

ELSE_IF:
    LD   R7, ASCIIUPPERA
    NOT  R7, R7
    ADD  R7, R7, #1
    ADD  R7, R4, R7     ; char - 'A'
    BRn  STORING_CHAR

    LD   R7, ASCIIUPPERA
    ADD  R7, R7, #10
    ADD  R7, R7, #15
    NOT  R7, R7
    ADD  R7, R7, #1
    ADD  R7, R4, R7     ; 'Z' - char
    BRp  STORING_CHAR

    LD   R7, ASCIIUPPERA
    NOT  R7, R7
    ADD  R7, R7, #1
    ADD  R4, R4, R7     ; char -= 'A'
    ADD  R4, R4, R1     ; char += k

    LD   R7, ALPHABETLEN
    ADD  R6, R6, -1
    STR  R7, R6, #0
    ADD  R6, R6, -1
    STR  R4, R6, #0
    JSR  MOD
    LDR  R4, R6, #0
    ADD  R6, R6, #3

    LD   R7, ASCIIUPPERA
    ADD  R4, R4, R7

STORING_CHAR:
    ADD  R7, R0, R2
    STR  R4, R7, #0
    ADD  R2, R2, #1     ; i++
    BR   FOR_LOOP_CHECK

AFTER_FOR:
    STR  R0, R5, #3     ; if we want to store a return val

    ; ------ TEARDOWN ------
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

    ADD  R6, R6, #1     ; pop local var

    LDR  R5, R6, #0
    ADD  R6, R6, #1

    LDR  R7, R6, #0
    ADD  R6, R6, #1
    RET

.end

;; You may change the value of the string for debugging
.orig x4000
    .stringz "hello"
.end