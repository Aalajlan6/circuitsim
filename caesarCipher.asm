;;=============================================================
;; CS 2110 - Spring 2025
;; Homework 4 - Caesar Cipher
;;=============================================================
;; Name: Abdulaziz Alajlan
;;=============================================================

;;  In this file, you must implement the 'MOD' and 'ENCRYPT' subroutines.
.orig x3000

    LD R6, STACK_PTR
    
    ADD R6, R6, -1
    LD R0, SHIFT
    STR R0, R6, 0
    
    ADD R6, R6, -1
    LD R0, STRING
    STR R0, R6, 0
    
    JSR ENCRYPT 
    
    ADD R6, R6, 2
    HALT

STACK_PTR .fill xF000
STRING    .fill x4000
SHIFT     .fill 5
ALPHA     .fill 26
ASCII_UPPER_A   .fill 65
ASCII_UPPER_Z   .fill 90
ASCII_LOWER_A   .fill 97
ASCII_LOWER_Z   .fill 122

MOD  
    ADD R6, R6, -1 
    STR R7, R6, 0  
    ADD R6, R6, -1  
    STR R5, R6, 0  
    
    LDR R0, R5, 4  
    LDR R1, R5, 5  

LOOP:
    NOT R2, R1  
    ADD R2, R2, 1  
    ADD R3, R0, R2  
    BRn DONE  
    ADD R0, R3, #0  
    BR LOOP  

DONE:  
    STR R0, R5, 3  
    ADD R6, R6, 1  
    LDR R5, R6, 0  
    ADD R6, R6, 1  
    LDR R7, R6, 0  
    ADD R6, R6, 1  
    RET  

ENCRYPT 
    ADD R6, R6, -1  
    STR R7, R6, 0  
    
    LDR R0, R5, 4  
    LDR R1, R5, 5  
    
LEN:
    LDR R2, R0, #0  
    BRz PROCESS  
    ADD R0, R0, #1  
    BR LEN  
    
PROCESS:
    ADD R2, R0, #0  
    LDR R3, R2, #0  
    BRz END  

    LD R7, ASCII_LOWER_A
    NOT R7, R7  
    ADD R7, R7, 1  
    ADD R4, R3, R7  
    BRn CHECK_UPPER  
    LD R7, ASCII_LOWER_Z
    ADD R7, R7, 1  
    NOT R7, R7  
    ADD R4, R3, R7  
    BRp CHECK_UPPER  

    LD R7, ASCII_LOWER_A  
    NOT R7, R7  
    ADD R7, R7, 1  
    ADD R3, R3, R7  
    ADD R3, R3, R1  
    LD R7, ALPHA  
    JSR MOD  
    LDR R3, R6, #0  
    ADD R6, R6, 1  
    LD R7, ASCII_LOWER_A  
    ADD R3, R3, R7  
    BR STORE  

CHECK_UPPER:
    LD R7, ASCII_UPPER_A  
    NOT R7, R7  
    ADD R7, R7, 1  
    ADD R4, R3, R7  
    BRn STORE  
    LD R7, ASCII_UPPER_Z  
    ADD R7, R7, 1  
    NOT R7, R7  
    ADD R4, R3, R7  
    BRp STORE  

    LD R7, ASCII_UPPER_A  
    NOT R7, R7  
    ADD R7, R7, 1  
    ADD R3, R3, R7  
    ADD R3, R3, R1  
    LD R7, ALPHA  
    JSR MOD  
    LDR R3, R6, #0  
    ADD R6, R6, 1  
    LD R7, ASCII_UPPER_A  
    ADD R3, R3, R7  

STORE:
    STR R3, R2, #0  
    ADD R0, R0, 1  
    BR PROCESS  

END:
    LDR R7, R6, 0  
    ADD R6, R6, 1  
    RET  

.end

.orig x4000
    .stringz "hello"
.end
