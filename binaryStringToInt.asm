;;=============================================================
;; CS 2110 - Spring 2025
;; Homework 4 - Binary String to Int 
;;=============================================================
;; Name: 
;;=============================================================

.orig x3000
;; Suggested Pseudocode (see PDF for explanation)
;;
;; int length = 0;
;;  while (BINARYSTRING[length] != 0) {
;;      length++;
;;  }
;;  int result = 0;
;;  for (int i = 0; i < length; i++) {
;;      result = result << 1;
;;      result += BINARYSTRING[i] - 48;
;;  }
;;  mem[mem[RESULTADDR]] = result;

    AND R0, R0, #0; R0 = 0
    LD R1, BINARYSTRING; R1 = start
WHILE ;We haven't hit a null operator
    LDR R2, R1, #0; R2 = mem[R1]
    BRz END_LEN; If char is null terminator, skip
    
    ADD R0, R0, #1; Increment length
    ADD R1, R1, #1
    BR WHILE
    
END_LEN 
    AND R2, R2, #0; result = 0
    AND R3, R3, #0; i = 0
    
FOR ADD R4, R3, #0
    NOT R5, R0
    ADD R4, R4, R5
    ADD R4, R4, #1; R4 = i - len
    BRzp END
    ADD R2, R2, R2; result = result << 1
    
    ADD R7, R6, R3
    LDR R5, R7, #0
    LD R7, ASCIIDIG
    NOT R7, R7
    ADD R5, R5, R7
    ADD R5, R5, #1
    ADD R2, R2, R5
    
    ADD R3, R3, #1; i++
    BR FOR
END LD R4, RESULTADDR
    STR R2, R4, #0
    HALT

;; Do not rename or remove any existing labels
;; You may change the value of LENGTH for debugging
BINARYSTRING .fill x5000
RESULTADDR .fill x4000
ASCIIDIG .fill 48
.end

.orig x4000
    .blkw 1
.end

;; You may change the value of the string for debugging
.orig x5000
    .stringz "11001"
.end
