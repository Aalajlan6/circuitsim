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

    HALT

;; Do not rename or remove any existing labels
;; You may change the value of LENGTH for debugging
STRING .fill x4000
.end

;; You may change the value of the string for debugging
.orig x4000
    .stringz "hello"
.end
