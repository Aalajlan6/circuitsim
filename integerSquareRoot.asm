;;=============================================================
;; CS 2110 - Spring 2025
;; Homework 4 - Integer Square Root
;;=============================================================
;; Name: Abdulaziz Alajlan
;;=============================================================


;; Suggested Pseudocode (see PDF for explanation)
;;
;;  int L = 0;
;;  int a = 1;
;;  int d = 3;
;;
;;  while (a <= N) {
;;      a = a + d;  // Compute the next perfect square
;;      d = d + 2;  // Increase the difference between squares
;;      L = L + 1;  // Increment L
;;  }
;;
;;  mem[mem[RESULT]] = L;
    
.orig x3000
    AND R1, R1, #0; L = 0
    AND R2, R2, #0; a = 0
    ADD R2, R2, #1; a = 1
    AND R3, R3, #0; d = 0
    ADD R3, R3, #3; d = 3
    LD R0, N; R0 = N
WHILE
    ADD R4, R2, #0; R4 = a
    NOT R5, R0    ; R5 = NOT N
    ADD R4, R4, R5; R4 = R4 + NOT N
    ADD R4, R4, #1; R4 = a - N
    BRp END; if a - N > 0, exit loop
    
    ;OTHERWISE:
    ADD R2, R2, R3 ;a = a + d
    ADD R3, R3, #2 ;d = d + 2
    ADD R1, R1, #1 ;L = L + 1
    BR WHILE
    
END LD R5, RESULT
    STR R1, R5, #0
    HALT

;; Do not rename or remove any existing labels
;; You may change the value of N for debugging
N .fill 20
RESULT .fill x4000
.end

.orig x4000
    .blkw 1
.end
