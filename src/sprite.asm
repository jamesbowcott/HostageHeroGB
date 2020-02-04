INCLUDE "hardware.inc"
INCLUDE "globals.inc"

SPRITE_VRAM_ORIGIN EQU $8000

SPRITE_NORMAL_Y_POSITION EQU SCRN_Y - (MAP_FLOOR_HEIGHT * 8) - 16
SPRITE_MAX_JUMP_HEIGHT EQU 60

SPRITE_JUMP_VELOCITY EQU 20


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
   inc hl
   ld [hl], 0 ; velocity
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

   ; Load velocity into A and position into C
   ld a, [SpriteJumpVelocity]
   ld hl, SpritePosY
   ld c, [hl]
   ; Is the velocity 0?
   cp a, 0
   jr nz, .already_jumping
.new_jump
   ld a, (SPRITE_JUMP_VELOCITY - 1)
.already_jumping:

.update_jump:
   ; Copy velocity from A into B
   ld b, a
   ; Top half of max velocity = rise.
   ; Bottom half of max velocity = fall.
   cp a, (SPRITE_JUMP_VELOCITY / 2)   ; c flag = velocity > mv / 2
   jp c, .falling
   jp z, .top

.rising:
   sub a, (SPRITE_JUMP_VELOCITY / 2) ; Half the velocity to get the rising velocity
   ; Store rising velocity into D. Load position into A.
   ld d, a
   ld a, c
   ; Subtract velocity from position
   sub a, d
   jp .finish

.top:
   ; dec c

.falling:
   ; Falling velocity = (Max Velocity / 2) - Velocity
   ld a, (SPRITE_JUMP_VELOCITY / 2)
   sub a, b
   ; Store falling velocity into D. Load position into A.
   ld d, a
   ld a, c
   ; Add velocity to position
   add a, d

.finish:
   ; a = Y Pos
   ; b = Velocity
   ; hl = SpritePosY
   ld [hl+], a
   dec b
   ld [hl], b
   ret



SECTION "SpriteRam",wram0
SpritePosY: DS 1
SpriteJumpVelocity: DS 1

SECTION "SpriteOam",oam
SpriteOam: DS 4