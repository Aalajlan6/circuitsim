;;=============================================================
;; CS 2110 - Spring 2025
;; Homework 4 - Find Min Index
;;=============================================================
;; Name: 
;;=============================================================

.orig x3000
;; Suggested Pseudocode (see PDF for explanation)
;;
;;  int minIndex = 0;
;;  int minValue = ARRAY[0];
;;  for (int i = 1; i < LENGTH; i++) {
;;      if (ARRAY[i] < minValue) {
;;          minValue = ARRAY[i];
;;          minIndex = i;
;;      }
;;  }
;;  mem[mem[RESULT]] = minIndex;
    
    AND R0, R0, #0; min index
    LD R6, ARRAY
    LDR R1, R6, #0; min value
    AND R3, R3, #0
    ADD R3, R3, #1; i = 1
    LD R4, LENGTH
    NOT R4, R4
FOR 
    ADD R5, R3, R4
    BRzp END
    ADD R7, R6, R3
    LDR R7, R7, #0
    
    ADD R5, R7, #0
    NOT R1, R1
    ADD R5, R5, R1
    ADD R5, R5, #1
    NOT R1, R1
    
    BRzp SKIP
    ADD R1, R7, #0
    ADD R0, R3, #0
SKIP
    ADD R3, R3, #1
    BR FOR
END
    LD R7, RESULT
    STR R0, R7, #0

    
    HALT

;; Do not rename or remove any existing labels
;; You may change the value of LENGTH for debugging
RESULT .fill x4000
ARRAY .fill x5000
LENGTH .fill 5
.end

.orig x4000
    ANSWER .blkw 1
.end

;; You may change these values for debuggin
.orig x5000
    .fill -1
    .fill 2 
    .fill 7 
    .fill 3 
    .fill -8 
.end
