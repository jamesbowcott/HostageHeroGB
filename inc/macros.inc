include "hardware.inc"

   IF !DEF(MACROS_INC)
MACROS_INC SET 1

WaitForVBlank: MACRO
   ld a, [rLY]
   cp a, 144   ; Start of VBlank is line 144
   jr nz, @-4  ; Each instruction is 2 bytes
ENDM

TestZero: MACRO
   inc \1
   dec \1
ENDM

ENDC