INCLUDE "hardware.inc"
INCLUDE "macros.inc"

SECTION "VBlankInterrupt", ROM0[$0040]
   jp VblankHandler
SECTION "LCDCInterrupt", ROM0[$0048]
   jp LcdcHandler
SECTION "TimerInterrupt", ROM0[$0050]
   reti
SECTION "SerialInterrupt", ROM0[$0058]
   reti
SECTION "JoypadInterrupt", ROM0[$0060]
   reti

SECTION "RomHeader", ROM0[$0100]
   nop
   jp	main
   NINTENDO_LOGO              ; $104 - Nintendo Logo
DB "HostageHero",0,0,0,0      ; $134 - Cart name (15 bytes)
DB 0                          ; $143 - Manufacturer Code
DB 0,0                        ; $144 - Licensee code (not important)
DB 0                          ; $146 - SGB Support indicator
DB CART_ROM                   ; $147 - Cart type
DB CART_ROM                   ; $148 - ROM Size
DB CART_RAM_NONE              ; $149 - RAM Size
DB 1                          ; $14a - Destination code
DB $33                        ; $14b - Old licensee code
DB 0                          ; $14c - Mask ROM version
DB 0                          ; $14d - Complement check (important)
DW 0                          ; $14e - Checksum (not important)

main:
   di                ; Disable Interrupts
   ld	sp, $ffff      ; Set stack pointer to top of HRAM
   
   ; First thing we want to do is turn off the LCD
   ; so we can quickly and easily access VRAM while
   ; we're setting everything up.
   ; With the screen on, VRAM can only be accessed during
   ; HBlank and VBlank intervals.
   ; By turning the screen off, we (the CPU) have exclusive
   ; access to VRAM and dont have to worry about the timing.
   ; It also avoids graphical glitches while we're setting
   ; everything up.

   ; But first we need to ensure that we are currently in VBLANK
   ; mode before turning off the LCD, as apparently turning
   ; off the LCD outside of VBLANK can damage real hardware.
   WaitForVBlank

   ld hl, rLCDC
   ld [hl], LCDCF_OFF

   ; Setup LCD
   ld	a, %11100100      ; Standard palette: Lightest to darkest
   ld	[rBGP], a         ; Use as background palette
   ld	a, 0              ; Set screen scroll position to 0, 0
   ld	[rSCX], a
   ld	[rSCY], a

   call Map_Load
   call Map_Draw

   call Sprite_Load
   call DrawPlayerSprite

   ; Setup done
   ; Turn the LCD back on with the settings that we want
   ld	a, LCDCF_ON|LCDCF_BG8000|LCDCF_BG9800|LCDCF_BGON|LCDCF_OBJ8|LCDCF_OBJON
   ld	[rLCDC], a
   
   ; Clear any pending interrupt flags
   ; and (re)enable the interrupts we want
   ld hl, rIF
   ld [hl], 0
   ld hl, rIE
   ld [hl], IEF_VBLANK
   ei

   ; Now we just put the CPU to sleep in an infinite loop
   ; The game code will run from interrupts
wait:
   halt        ; Turn off the CPU. Will be woken by interrupts.
   nop         ; Need this
   jr	wait
   

VblankHandler:
   ; Increment the background X scroll
   ld hl, rSCX
   inc [hl]

   call UpdatePlayerSprite
   call DrawPlayerSprite
   reti

LcdcHandler:
   ; PPU will be in OAM mode
   ; Wait for Pixel Transfer mode
; .wait_for_transfer_mode
; 	ld a, [rSTAT]
; 	and a, STATF_LCD
; 	xor a, STATF_LCD
; 	jp nz, .wait_for_transfer_mode

   rept 16
   nop
   endr

   ld hl, rBGP
   ld a, [hl]
   ld [hl], $ff
   ld [hl], a
   reti
