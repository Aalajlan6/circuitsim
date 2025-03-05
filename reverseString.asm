;;=============================================================
;; CS 2110 - Spring 2025
;; Homework 4 - Reverse String 
;;=============================================================
;; Name: Abdulaziz Alajlan
;;=============================================================

.orig x3000
;; Suggested Pseudocode (see PDF for explanation)
;;
;; int length = 0;
;; while (STRING[length] != 0) {
;;      length++;
;; }
;;
;;
;; int start = 0;
;; int end = length - 1;

;; while (start < end) {
;;      char temp = STRING[start];
;;      STRING[start] = STRING[end];
;;      STRING[end] = temp;

;;      start++;
;;      end--;
;;}

    AND R0, R0, #0; length = 0
    LD R1, STRING; Base pointer
    ADD R2, R1, #0; Rest of string pointer
WHILE
    LDR R3, R2, #0; R3 = mem[R2] current char
    BRz LEN_WHILE
    ADD R0, R0, #1; length++
    ADD R1, R1, #1; pointer++
    BR WHILE
LEN_WHILE
;R0 = length
    AND R4, R4, #0; START
    ADD R5, R0, #0; R5 = length
    ADD R5, R5, #-1; R5--
OTHERWAY
    ADD R6, R4, #0
    NOT R7, R5
    ADD R6, R6, R7
    ADD R6, R6, #1
    BRzp DONE
    
    ADD R2, R1, R4
    ADD R3, R1, R5
    
    LDR R6, R2, #0; temp = STRING[start]
    LDR R7, R3, #0; R7 = STRING[end]
    STR R7, R2, #0; STRING[start] = R7
    STR R6, R3, #0; STRING[end] = temp
    
    ADD R4, R4, #1
    ADD R5, R5, #-1
    
    BR OTHERWAY
DONE    HALT

;; Do not rename or remove any existing labels
;; You may change the value of LENGTH for debugging
STRING .fill x4000
.end

;; You may change the value of the string for debugging
.orig x4000
    .stringz "hello"
.end
