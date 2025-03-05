;;=============================================================
;; CS 2110 - Spring 2025
;; Homework 4 - Find Min Index
;;=============================================================
;; Name: Abdulaziz Alajlan
;;=============================================================

.orig x3000

SETUP
    AND R4, R4, #0  ;; R4 = 0
    LD R2, ARRAY  
    ADD R5, R2, #0  ;; R5 = ARRAY address
    LDR R6, R5, #0  ;; R6 = ARRAY[0]
    AND R7, R7, #0  
    ADD R7, R7, #1  ;; R7 = 1
    LD R1, LENGTH   ;; R1 = LENGTH

LOOP
    NOT R3, R1
    ADD R3, R3, #1  
    ADD R3, R7, R3  ;; R3 = i - LENGTH
    BRzp END_LOOP   ;; if (i >= LENGTH), exit loop
    ADD R0, R5, R7  
    LDR R0, R0, #0  ;; R0 = ARRAY[i]

CHECK
    NOT R6, R6
    ADD R6, R6, #1
    ADD R6, R0, R6  ;; ARRAY[i] - minValue
    BRn UPDATE      ;; if ARRAY[i] < minValue, update

NEXT
    ADD R7, R7, #1  ;; i++
    BRnzp LOOP

UPDATE
    ADD R6, R0, #0  ;; minValue = ARRAY[i]
    ADD R4, R7, #0  ;; minIndex = i
    BRnzp NEXT

END_LOOP
    LD R3, RESULT  
    STR R4, R3, #0  ;; Store result
    HALT

RESULT .fill x4000
ARRAY .fill x5000
LENGTH .fill 5
.end

.orig x4000
    ANSWER .blkw 1
.end

.orig x5000
    .fill -1
    .fill 2 
    .fill 7 
    .fill 3 
    .fill -8 
.end