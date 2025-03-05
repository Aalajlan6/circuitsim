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
    LD R0, STRING
    STR R0, R6, 0
    
    ADD R6, R6, -1
    LD R0, SHIFT
    STR R0, R6, 0
    
    JSR ENCRYPT 
    
    ADD R6, R6, 2
    HALT

STACK_PTR .fill xF000
STRING    .fill x4000
SHIFT     .fill 5
ALPHA     .fill 26

MOD  
    ADD R6, R6, -1 
    STR R7, R6, 0  
    ADD R6, R6, -1  
    STR R5, R6, 0  
    
    LDR R0, R6, #4
    LDR R1, R6, #5 
    
LOOP:
    ADD R3, R0, R1  
    BRzp END  
    ADD R0, R0, #-1  
    BR LOOP  

END:  
    STR R0, R5, #3  
    ADD R6, R6, 1  
    LDR R7, R6, 0  
    ADD R6, R6, 1  
    RET  

ENCRYPT 
    ADD R6, R6, -1  
    STR R7, R6, 0  
    
    LDR R0, R6, #4  
    LDR R1, R6, #5  
    
LENGTH:  
    ADD R3, R0, #0  
    BRz DONE  
    ADD R0, R0, #1  
    BR LENGTH  
    
DONE:
    LDR R7, R6, 0  
    ADD R6, R6, 1  
    RET  

.end

.orig x4000
    .stringz "hello"
.end
