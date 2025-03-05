;;=============================================================
;; CS 2110 - Spring 2025
;; Homework 4 - Merge Sort
;;=============================================================
;; Name: Abdulaziz Alajlan
;;=============================================================
;; In this file, you must implement the 'MERGESORT', 'MERGE', and 'DIVIDE' subroutines.

.orig x3000

    ; You do not need to write anything here
    LD   R6, STACK_PTR

    ; Push arguments for MERGESORT
    LD   R0, ARRAY
    LD   R1, BUF
    AND  R2, R2, #0      ; start = 0
    LD   R3, LENGTH      ; end = length

    ; Put them on stack in reverse order
    ADD  R6, R6, #-1
    STR  R3, R6, #0
    ADD  R6, R6, #-1
    STR  R2, R6, #0
    ADD  R6, R6, #-1
    STR  R1, R6, #0
    ADD  R6, R6, #-1
    STR  R0, R6, #0

    JSR  MERGESORT
    HALT

ARRAY     .fill x4000
BUF       .fill x5000
LENGTH    .fill 4
STACK_PTR .fill xF000

; -----------------------------------------------------------
MERGESORT  ;; Do not change this label!
; Mergesort pseudocode in comments:
; MERGESORT(arr, buf, start, end):
;   if (start >= end - 1) return;
;   mid = DIVIDE(start + end, 2);
;   MERGESORT(arr, buf, start, mid);
;   MERGESORT(arr, buf, mid, end);
;   MERGE(arr, buf, start, mid, end);

    ; Build-up: Reserve space for RV, RA, old FP, local vars
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

    ; Load arguments from stack
    LDR  R0, R5, #4       ; arr
    LDR  R1, R5, #5       ; buf
    LDR  R2, R5, #6       ; start
    LDR  R3, R5, #7       ; end

    ; if (start >= end - 1) return
    ADD  R4, R3, #-1
    NOT  R4, R4
    ADD  R4, R4, #1       ; -(end - 1)
    ADD  R4, R2, R4       ; start - (end - 1)
    BRzp MERGESORT_END

    ; mid = DIVIDE(start + end, 2)
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

    ; MERGESORT(arr, buf, start, mid)
    ADD  R6, R6, #-4
    STR  R4, R6, #0       ; mid
    STR  R2, R6, #1       ; start
    STR  R1, R6, #2       ; buf
    STR  R0, R6, #3       ; arr
    JSR  MERGESORT
    ADD  R6, R6, #4

    ; MERGESORT(arr, buf, mid, end)
    ADD  R6, R6, #-4
    STR  R3, R6, #0       ; end
    STR  R4, R6, #1       ; mid
    STR  R1, R6, #2       ; buf
    STR  R0, R6, #3       ; arr
    JSR  MERGESORT
    ADD  R6, R6, #4

    ; MERGE(arr, buf, start, mid, end)
    ADD  R6, R6, #-5
    STR  R3, R6, #0       ; end
    STR  R4, R6, #1       ; mid
    STR  R2, R6, #2       ; start
    STR  R1, R6, #3       ; buf
    STR  R0, R6, #4       ; arr
    JSR  MERGE
    ADD  R6, R6, #5

MERGESORT_END
    ; Teardown
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

; -----------------------------------------------------------
DIVIDE  ;; Do not change this label!
; DIVIDE(a, b):
;   if (b == 0) return 0;
;   q = 0;
;   while (a >= b) { a -= b; q++; }
;   return q;

    ; Build-up
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
    BRnp  DIVIDE_NOTZERO
    AND  R2, R2, #0
    STR  R2, R5, #3
    BR    DIVIDE_END

DIVIDE_NOTZERO
    ; q = 0
    AND  R2, R2, #0

DIVIDE_LOOP
    NOT  R3, R1
    ADD  R3, R3, #1   ; -b
    ADD  R4, R0, R3   ; a - b
    BRn  DIVIDE_END
    ADD  R0, R0, R3   ; a -= b
    ADD  R2, R2, #1   ; q++
    BR   DIVIDE_LOOP

DIVIDE_END
    STR  R2, R5, #3   ; return q

    ; Teardown
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

; -----------------------------------------------------------
MERGE  ;; Do not change this label!
; MERGE(arr, buf, start, mid, end)

    ; Build-up
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
    LDR  R0, R5, #4   ; arr
    LDR  R1, R5, #5   ; buf
    LDR  R2, R5, #6   ; start
    LDR  R3, R5, #7   ; mid
    LDR  R4, R5, #8   ; end

    ; i = start (R2), j = mid (R3), k = start => let's reuse R4 for k
    ADD  R4, R2, #0

MERGE_LOOP1
    ; while (i < mid && j < end)
    ; check i < mid
    LDR  R6, R5, #7   ; mid
    NOT  R7, R6
    ADD  R7, R7, #1
    ADD  R7, R2, R7   ; i - mid
    BRzp  MERGE_LOOP2

    ; check j < end
    LDR  R6, R5, #8   ; end
    NOT  R7, R6
    ADD  R7, R7, #1
    ADD  R7, R3, R7   ; j - end
    BRzp  MERGE_LOOP2

    ; if arr[i] <= arr[j]
    ADD  R6, R0, R2
    LDR  R7, R6, #0   ; arr[i]
    ADD  R6, R0, R3
    LDR  R6, R6, #0   ; arr[j]
    NOT  R6, R6
    ADD  R6, R6, #1
    ADD  R6, R7, R6   ; arr[i] - arr[j]
    BRp  MERGE_ELSE

    ; buf[k] = arr[i]
    ADD  R6, R0, R2
    LDR  R7, R6, #0
    ADD  R6, R1, R4
    STR  R7, R6, #0
    ADD  R4, R4, #1   ; k++
    ADD  R2, R2, #1   ; i++
    BR   MERGE_LOOP1

MERGE_ELSE
    ; buf[k] = arr[j]
    ADD  R6, R0, R3
    LDR  R7, R6, #0
    ADD  R6, R1, R4
    STR  R7, R6, #0
    ADD  R4, R4, #1   ; k++
    ADD  R3, R3, #1   ; j++
    BR   MERGE_LOOP1

MERGE_LOOP2
    ; while (i < mid)
    LDR  R6, R5, #7
    NOT  R7, R6
    ADD  R7, R7, #1
    ADD  R7, R2, R7   ; i-mid
    BRzp  MERGE_LOOP3

    ; buf[k] = arr[i]
    ADD  R6, R0, R2
    LDR  R7, R6, #0
    ADD  R6, R1, R4
    STR  R7, R6, #0
    ADD  R4, R4, #1
    ADD  R2, R2, #1
    BR   MERGE_LOOP2

MERGE_LOOP3
    ; while (j < end)
    LDR  R6, R5, #8
    NOT  R7, R6
    ADD  R7, R7, #1
    ADD  R7, R3, R7   ; j-end
    BRzp  MERGE_COPY

    ; buf[k] = arr[j]
    ADD  R6, R0, R3
    LDR  R7, R6, #0
    ADD  R6, R1, R4
    STR  R7, R6, #0
    ADD  R4, R4, #1
    ADD  R3, R3, #1
    BR   MERGE_LOOP3

MERGE_COPY
    ; for (i = start; i < end; i++)
    LDR  R2, R5, #6   ; i = start

MERGE_COPY_LOOP
    LDR  R6, R5, #8   ; end
    NOT  R7, R6
    ADD  R7, R7, #1
    ADD  R7, R2, R7   ; i-end
    BRzp  MERGE_END

    ; arr[i] = buf[i]
    ADD  R6, R1, R2
    LDR  R7, R6, #0
    ADD  R6, R0, R2
    STR  R7, R6, #0
    ADD  R2, R2, #1
    BR   MERGE_COPY_LOOP

MERGE_END
    ; Teardown
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

.end

;; You may change the values for debugging. 
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
