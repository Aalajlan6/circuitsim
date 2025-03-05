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
SHIFT     .fill 7
ALPHA     .fill 26

MOD  
    ADD R6, R6, -1 
    STR R7, R6, 0  
    ADD R6, R6, -1  
    STR R5, R6, 0  
    
    LDR R0, R5, 4  
    LDR R1, R5, 5  

WHILE:
    NOT R2, R1  
    ADD R2, R2, 1  
    ADD R3, R0, R2  
    BRn FINISH  
    ADD R0, R3, #0  
    BR WHILE  

FINISH:  
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
    
FIND_LEN:  
    ADD R2, R0, #0  
    LDR R2, R2, #0  
    BRz FOR_LOOP  
    ADD R0, R0, #1  
    BR FIND_LEN  
    
FOR_LOOP:
    ADD R2, R0, #0  
    LDR R3, R2, #0  
    BRz END_LOOP  
    ADD R3, R3, R1  
    JSR MOD  
    STR R3, R2, #0  
    ADD R0, R0, #1  
    BR FOR_LOOP  

END_LOOP:
    LDR R7, R6, 0  
    ADD R6, R6, 1  
    RET  

.end

.orig x4000
    .stringz "hello"
.end
