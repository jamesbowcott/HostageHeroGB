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

; ------------------------------------------------------------------------------
; 256 bytes of the upper half of the rising edge of a sine wave
; 0 = 0.0, FF = 1.0
; ------------------------------------------------------------------------------
SineTable::
; Use rgbasm's built in sin function, it's a bit weird though:
; int32_t math_Sin(int32_t i)
; {
;    return double2fx(sin(fx2double(i) * 2 * M_PI / 65536));
; }

ANGLE SET 0.0
   REPT 255
   ; PRINTT "ANGLE = "
   ; PRINTF ANGLE
   ; PRINTT ", SIN(ANGLE) = "
   ; PRINTF SIN(ANGLE)
   ; PRINTT ", MUL(SIN(ANGLE), 255.0) = "
   ; PRINTF MUL(SIN(ANGLE), 256.0)
   ; PRINTT ", MUL(SIN(ANGLE), 255.0) >> 16 = "
   ; PRINTV MUL(SIN(ANGLE), 255.0) >> 16
   ; PRINTT "\n"
   DB MUL(SIN(ANGLE), 255.0) >> 16
ANGLE SET ANGLE + DIV(258.0, 4.0)
   ENDR
   DB $FF ; Because of the lack of precision we cant get to 1.0,
          ; so hard code last byte to $FF