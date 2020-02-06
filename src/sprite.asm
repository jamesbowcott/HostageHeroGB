INCLUDE "hardware.inc"
INCLUDE "globals.inc"

SPRITE_VRAM_ORIGIN EQU $8000

SPRITE_NORMAL_Y_POSITION EQU SCRN_Y - (MAP_FLOOR_HEIGHT * 8) - 16
SPRITE_MAX_JUMP_HEIGHT EQU 60

SPRITE_JUMP_HEIGHT EQU 64


SECTION "SpriteRom",rom0

SpriteData:
   INCBIN "../assets/HeroSprites.tiles"
SpriteData_End:

Sprite_Load::
   call ClearOam
   ld hl, SpriteData
   ld de, SPRITE_VRAM_ORIGIN
   ld bc, SpriteData_End - SpriteData
   call mem_CopyVRAM

   ; Init variables
   ld hl, SpritePosY
   ld [hl], SPRITE_NORMAL_Y_POSITION
   ld a, 0
   ld [SpritePosY], a
   ld [SpriteJumpPhase], a
   ret

ClearOam:
   ld a, 0
   ld hl, _OAMRAM
   ld bc, $9F
   call mem_Set
   ret


DrawPlayerSprite::

   ld hl, SpritePosY ; Point HL register to sprite's Y position in RAM 
   ld b, [hl]        ; Load sprite's Y position from RAM into B register
   ld hl, _OAMRAM    ; Point HL register to OAM

   ld c, 0           ; Load first sprite tile index into C register

   rept 4            ; REPEAT FOR 4 ROWS
   ld a, 40          ; Load starting X position into A register

   rept 4            ; REPEAT FOR 4 COLUMNS
   ld [hl], b        ; Y Position
   inc hl
   ld [hl+], a       ; X position
   add a, 8          ; X += 8 for next column
   ld [hl], c        ; Tile Number
   inc hl
   inc c             
   ld [hl], 0        ; Flags
   inc hl
   endr

   ld a, b           ; Load Y position into accumulator
   add a, 8          ; Y position += 8
   ld b, a           ; Load Y position back into B register
   endr

   ret


UpdatePlayerSprite::
   ld a, [SpriteJumpPhase] ; A = Jump phase (0 - 255)
   ld hl, SineTable        ; HL = Pointer to Sine wave table
   ld de, 0
   ld e, a
   add hl, de              ; Add phase to HL pointer
   ld a, [hl]              ; A = Sine value for jump phase

   ; Use sine value to scale the jump height
   ld h, a
   ld e, SPRITE_JUMP_HEIGHT
   call Mul8                  

   ; Y position = Normal Y pos - current jump height
   ld a, SPRITE_NORMAL_Y_POSITION
   sub a, h
   ld [SpritePosY], a

   ; Increment the jump phase
   ld hl, SpriteJumpPhase
   ld a, [hl]
   add a, 3
   ld [hl], a

   ret



SECTION "SpriteRam",wram0
SpritePosY: DS 1
SpriteJumpPhase: DS 1

SECTION "SpriteOam",oam
SpriteOam: DS 4