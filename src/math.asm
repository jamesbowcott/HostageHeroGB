INCLUDE "hardware.inc"

SECTION "math", ROM0

; http://www.msxdev.com/sources/external/z80bits.html

; Classic 8bit * 8bit Unsigned
; Input: H = Multiplier, E = Multiplicand, L = 0, D = 0
; Output: HL = Product
Mul8::
   ld l, 0
   ld d, 0

   sla h  ; optimised 1st iteration
   jr nc, @+3
   ld l,e

   rept 7
   add hl,hl  ; unroll 7 times
   jr nc, @+3  ; ...
   add hl,de  ; ...
   endr
   ret

; Input: D = Dividend, E = Divisor, A = 0
; Output: D = Quotient, A = Remainder
Div88::
   xor a
   rept 8
   sla d
   rla 
   cp e
   jr c,@+4
   sub e
   inc d
   endr
   ret

SineTable::
ANGLE SET 256.0 * 128.0
   REPT 256
   DB MUL(SIN(ANGLE), 255.0) >> 16
ANGLE SET ANGLE+128.0
   ENDR