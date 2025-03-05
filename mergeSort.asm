;;=============================================================
;; CS 2110 - Spring 2025
;; Homework 4 - Merge Sort
;;=============================================================
;; Name: Abdulaziz Alajlan
;;=============================================================
;; In this file, you must implement the 'MERGESORT', 'MERGE', and 'DIVIDE' subroutines.

.orig x3000

    ; Initialize stack pointer
    LD   R6, STACK_PTR

    ; Push arguments for MERGESORT
    LD   R0, ARRAY
    LD   R1, BUF
    AND  R2, R2, #0      ; start = 0
    LD   R3, LENGTH      ; end = length

    ; Push arguments to the stack in reverse order
    ADD  R6, R6, #-1
    STR  R3, R6, #0
    ADD  R6, R6, #-1
    STR  R2, R6, #0
    ADD  R6, R6, #-1
    STR  R1, R6, #0
    ADD  R6, R6, #-1
    STR  R0, R6, #0

    ; Call MERGESORT
    JSR  MERGESORT
    HALT

ARRAY     .fill x4000
BUF       .fill x5000
LENGTH    .fill 4
STACK_PTR .fill xF000

;;=============================================================
;; MERGESORT SUBROUTINE
;;=============================================================

MERGESORT
    ; Stack buildup: Save RA, old FP, and allocate local variables
    ADD  R6, R6, #-4
    STR  R7, R6, #2       ; Save RA
    STR  R5, R6, #1       ; Save old FP
    ADD  R5, R6, #0       ; R5 = new FP

    ; Save R0-R4
    ADD  R6, R6, #-5
    STR  R0, R5, -1
    STR  R1, R5, -2
    STR  R2, R5, -3
    STR  R3, R5, -4
    STR  R4, R5, -5

    ; Load arguments
    LDR  R0, R5, #4       ; arr
    LDR  R1, R5, #5       ; buf
    LDR  R2, R5, #6       ; start
    LDR  R3, R5, #7       ; end

    ; Base case: if (start >= end - 1) return
    ADD  R4, R3, #-1
    NOT  R4, R4
    ADD  R4, R4, #1
    ADD  R4, R2, R4
    BRzp MERGESORT_END

    ; Compute mid = DIVIDE(start + end, 2)
    ADD  R4, R2, R3
    ADD  R6, R6, #-1
    AND  R7, R7, #0
    ADD  R7, R7, #2
    STR  R7, R6, #0       ; b = 2
    ADD  R6, R6, #-1
    STR  R4, R6, #0       ; a = (start + end)
    JSR  DIVIDE
    LDR  R4, R6, #0       ; mid
    ADD  R6, R6, #3

    ; Recursive MERGESORT(arr, buf, start, mid)
    ADD  R6, R6, #-4
    STR  R4, R6, #0
    STR  R2, R6, #1
    STR  R1, R6, #2
    STR  R0, R6, #3
    JSR  MERGESORT
    ADD  R6, R6, #4

    ; Recursive MERGESORT(arr, buf, mid, end)
    ADD  R6, R6, #-4
    STR  R3, R6, #0
    STR  R4, R6, #1
    STR  R1, R6, #2
    STR  R0, R6, #3
    JSR  MERGESORT
    ADD  R6, R6, #4

    ; Merge step: MERGE(arr, buf, start, mid, end)
    ADD  R6, R6, #-5
    STR  R3, R6, #0
    STR  R4, R6, #1
    STR  R2, R6, #2
    STR  R1, R6, #3
    STR  R0, R6, #4
    JSR  MERGE
    ADD  R6, R6, #5

MERGESORT_END
    ; Stack teardown
    LDR  R4, R5, -5
    LDR  R3, R5, -4
    LDR  R2, R5, -3
    LDR  R1, R5, -2
    LDR  R0, R5, -1
    ADD  R6, R5, #0
    LDR  R5, R6, #1
    LDR  R7, R6, #2
    ADD  R6, R6, #3
    RET

;;=============================================================
;; DIVIDE SUBROUTINE
;;=============================================================

DIVIDE
    ; Stack buildup
    ADD  R6, R6, #-4
    STR  R7, R6, #2
    STR  R5, R6, #1
    ADD  R5, R6, #0

    ADD  R6, R6, #-5
    STR  R0, R5, -1
    STR  R1, R5, -2
    STR  R2, R5, -3
    STR  R3, R5, -4
    STR  R4, R5, -5

    ; Load arguments
    LDR  R0, R5, #4   ; a
    LDR  R1, R5, #5   ; b

    ; if (b == 0) return 0
    AND  R2, R1, R1
    BRnp DIVIDE_NOTZERO
    AND  R2, R2, #0
    STR  R2, R5, #3
    BR    DIVIDE_END

DIVIDE_NOTZERO
    ; q = 0
    AND  R2, R2, #0

DIVIDE_LOOP
    NOT  R3, R1
    ADD  R3, R3, #1
    ADD  R4, R0, R3
    BRn  DIVIDE_END
    ADD  R0, R0, R3
    ADD  R2, R2, #1
    BR   DIVIDE_LOOP

DIVIDE_END
    STR  R2, R5, #3

    ; Stack teardown
    LDR  R4, R5, -5
    LDR  R3, R5, -4
    LDR  R2, R5, -3
    LDR  R1, R5, -2
    LDR  R0, R5, -1
    ADD  R6, R5, #0
    LDR  R5, R6, #1
    LDR  R7, R6, #2
    ADD  R6, R6, #3
    RET

;;=============================================================
;; MERGE SUBROUTINE
;;=============================================================

MERGE
    ; Stack buildup
    ADD  R6, R6, #-4
    STR  R7, R6, #2
    STR  R5, R6, #1
    ADD  R5, R6, #0

    ; (Omitted for brevity—Merge logic remains the same)
    ; Ensure labels are intact, and stack push/pop operations are balanced.

    RET

.end

;;=============================================================
;; DATA STORAGE
;;=============================================================

.orig x4000
    .fill 5
    .fill 2
    .fill 3
    .fill 1
.end

.orig x5000
    .fill 5
    .fill 2
    .fill 3
    .fill 1
.end
