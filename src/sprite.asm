INCLUDE "hardware.inc"
INCLUDE "globals.inc"
INCLUDE "macros.inc"

SPRITE_VRAM_ORIGIN EQU $8000

SPRITE_NORMAL_Y_POSITION EQU SCRN_Y - (MAP_FLOOR_HEIGHT * 8) - 16
SPRITE_MAX_JUMP_HEIGHT EQU 60

SPRITE_JUMP_HEIGHT EQU 64


SECTION "SpriteCode",rom0
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
   ld [SpriteJumpPhase], a
   ld [SpriteWalkPhase], a
   ret

ClearOam:
   ld a, 0
   ld hl, _OAMRAM
   ld bc, $A0
   call mem_Set
   ret


DrawPlayerSprite::

   ; Select the approtiate sprite sheet
   ld a, [SpriteJumpPhase]
   inc a
   jr z, .select_sprite_not_jumping
   dec a
   jr z, .select_sprite_not_jumping
.select_sprite_is_jumping:
   ld c, 0
   jr .end_select_sprite
.select_sprite_not_jumping:
   ld a, [SpriteWalkPhase]
   bit 6, a
   jr nz, .select_sprite_walking_2
.select_sprite_walking_1:
   ld c, 16
   jr .end_select_sprite
.select_sprite_walking_2:
   ld c, 32
.end_select_sprite:


   ld hl, SpritePosY ; Point HL register to sprite's Y position in RAM 
   ld b, [hl]        ; Load sprite's Y position from RAM into B register
   ld hl, _OAMRAM    ; Point HL register to OAM


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
   ld a, [SpriteWalkPhase]
   add a, 3
   ld [SpriteWalkPhase], a

   ld a, [SpriteJumpPhase] ; A = Jump phase (0 - 255)
   ; Exit if not jumping (0 = not jumping, FF = end of jump)
   ret z
   inc a
   ret z
   dec a

   ld hl, SineTable        ; HL = Pointer to Sine wave table
   ; Sine table is rising edge only, so we double stride the table,
   ; and go top-down after 128
   sla a                   ; Shift A left
   jr nc, @+4              ; If there was no carry, continue
   cpl                     ; Did carry, complement (1s)
   dec a                   ; Decrement for 2's complement
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

   ; Increment the jump phase if mid-jump
   ld hl, SpriteJumpPhase
   ld a, [hl]
   TestZero a     ; Dont increment if 0 (not jumping)
   ret z          ; .
   add a, 3       ; Add the jump speed
   jr nc, @+4     ; Dont exceed FF
   ld a, $FF      ; .
   ld [hl], a     ; Store to SpriteJumpPhase

   ret

SECTION "SpriteData",rom0[$2000]
SpriteData:
   INCBIN "../assets/HeroSprites.tiles"
SpriteData_End:

SECTION "SpriteRam",wram0
SpritePosY: DS 1
SpriteJumpPhase:: DS 1
SpriteWalkPhase: DS 1

SECTION "SpriteOam",oam
SpriteOam: DS 4