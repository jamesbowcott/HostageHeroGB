INCLUDE "hardware.inc"
INCLUDE "globals.inc"

MAP_VRAM_ORIGIN EQU $8800

MAP_WHITE_TILE_INDEX EQU $80
MAP_BLACK_TILE_INDEX EQU $81

SECTION "Map", ROM0

MapTiles:
   ; White tile
   REPT 8
   DW `00000000
   ENDR
   ; Black tile
   REPT 8
   DW `33333333
   ENDR

MapTiles_End:


Map_Load::
   ld hl, MapTiles
   ld de, MAP_VRAM_ORIGIN
   ld bc, MapTiles_End - MapTiles
   call mem_CopyVRAM
   ret

Map_Clear::
   ld	a, MAP_WHITE_TILE_INDEX
   ld	hl, _SCRN0
   ld	bc, SCRN_VX_B * SCRN_VY_B
   call	mem_SetVRAM
   ret

Map_Draw::
   call Map_Clear
   ; Load into HL the left tile of the top of the floor
   ld hl, $9A40 - (MAP_FLOOR_HEIGHT * 32)
   ; Count floor height in b
   ld b, MAP_FLOOR_HEIGHT
.draw_floor_line:
   ; Countdown 32 tile width of background map in c
   ld c, 32
.draw_floor_line_loop:
   ; Set tile pointed to by hl to be the black tile
   ld [hl], MAP_BLACK_TILE_INDEX
   inc hl
   dec c
   jr nz, .draw_floor_line_loop
   ; Finished drawing line, do we need to draw another?
   dec b
   jr nz, .draw_floor_line

   ; Draw the Obstacle
   ld hl, $9A54 - ((MAP_FLOOR_HEIGHT + MAP_OBSTACLE_HEIGHT) * 32)
   ld de, 32 - MAP_OBSTACLE_WIDTH
   ld b, MAP_OBSTACLE_HEIGHT
.draw_obstacle_line:
   ld c, MAP_OBSTACLE_WIDTH
.draw_obstacle_line_loop:
   ld [hl], MAP_BLACK_TILE_INDEX
   inc hl
   dec c
   jr nz, .draw_obstacle_line_loop
   add hl, de
   dec b
   jr nz, .draw_obstacle_line

   ; done
   ret


