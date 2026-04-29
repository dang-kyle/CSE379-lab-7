; ==============
;  GLOBAL STUFF
; ==============
	.data

	.global prompt
	.global lookup_color
	.global lookup_char
	.global board
	.global lives
	.global pm_x
	.global pm_y
	.global score
	.global dir
	.global pause
	.global state
	.global cursor_row
	.global cursor_col
	.global redraw_flag
	.global old_x
	.global old_y
	.global new_x
	.global new_y
	.global remove_cursor
	.global ansi_home
	.global ansi_clear
	.global ansi_black
	.global score_flag
	.global score_string
	.global ghost1_x
	.global ghost1_y
	.global ghost1_dir
	.global ghost1_old_x
	.global ghost1_old_y
	.global ghost1_new_x
	.global ghost1_new_y
	.global ghost_redraw_flag
	.global xor_in
	.global ghost_valid_dirs
	.global ghost1_under
	.global ghost2_x
	.global ghost2_y
	.global ghost2_dir
	.global ghost2_old_x
	.global ghost2_old_y
	.global ghost2_new_x
	.global ghost2_new_y
	.global ghost2_under
	.global ghost2_active
	.global ghost3_x
	.global ghost3_y
	.global ghost3_dir
	.global ghost3_old_x
	.global ghost3_old_y
	.global ghost3_new_x
	.global ghost3_new_y
	.global ghost3_under
	.global ghost3_active
	.global ghost4_x
	.global ghost4_y
	.global ghost4_dir
	.global ghost4_old_x
	.global ghost4_old_y
	.global ghost4_new_x
	.global ghost4_new_y
	.global ghost4_under
	.global ghost4_active
	.global pellets_eaten
	.global powerup_timer
	.global state_save
	.global pellets_total
	.global level
	.global level_flag
	.global board_init
	.global prompt_game_over
	.global prompt_play_again
	.global prompt_quit
	.global prompt_level_clear
	.global fredraw_flag
	.global ghosts_eaten_count
	.global ghost1_eaten
	.global ghost2_eaten
	.global ghost3_eaten
	.global ghost4_eaten


; ==============
;  ANSI STRINGS
; ==============
ansi_black:		.string 27, "[37;40m", 0		; foreground white, background black
ansi_blue:		.string 27, "[37;48;5;68m", 0		; foreground white, background blue
ansi_pacman:	.string 27, "[38;5;226;48;5;68m", 0		; foreground yellow, background blue
ansi_blinky:	.string 27, "[31;48;5;68m", 0		; foreground red, background blue
ansi_pinky:		.string 27, "[35;48;5;68m", 0		; foreground magenta, background blue
ansi_inky:		.string 27, "[36;48;5;68m", 0		; foreground cyan, background blue
ansi_clyde:		.string 27, "[38;5;208;48;5;68m", 0	; foreground orange, background blue
ansi_door:		.string 27, "[106m",0			; background bright cyan
remove_cursor:	.string 27, "[?25l", 0			; makes the cursor not visible
ansi_home:		.string 27, "[H", 0				; moves cursor to top left
ansi_clear:		.string 27, "[2J", 0			; clears the screen


; ===============
;  LOOKUP TABLES
; ===============
lookup_color:	.word ansi_black		; 0x00 - wall
				.word ansi_blue			; 0x01 - pellet
				.word ansi_blue			; 0x02 - power pellet
				.word ansi_blue			; 0x03 - empty path
				.word ansi_pacman		; 0x04 - pacman
				.word ansi_blinky		; 0x05 - ghost 1
				.word ansi_pinky		; 0x06 - ghost 2
				.word ansi_inky			; 0x07 - ghost 3
				.word ansi_clyde		; 0x08 - ghost 4
				.word ansi_door			; 0x09 - ghost room door

lookup_char:	.byte 0x20	; 0x00 - wall = ' '
				.byte 0x2E	; 0x01 - pellet = '.'
				.byte 0x4F	; 0x02 - power pellet = 'O'
				.byte 0x20	; 0x03 - empty path = ' '
				.byte 0x3C	; 0x04 - pacman = '<'
				.byte 0x41	; 0x05 - ghost = 'A'
				.byte 0x41	; 0x06 - ghost = 'A'
				.byte 0x41	; 0x07 - ghost = 'A'
				.byte 0x41	; 0x08 - ghost = 'A'
				.byte 0x20	; 0x09 - door = ' '


; =====================
;  STARTING GAME BOARD
; =====================
board_init:
		.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	; 1
		.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		.byte 0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0
		.byte 0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0	; 5
		.byte 0,2,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,2,0
		.byte 0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0
		.byte 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
		.byte 0,1,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,1,0
		.byte 0,1,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,1,0	; 10
		.byte 0,1,1,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1,1,1,1,0
		.byte 0,0,0,0,0,0,1,0,0,0,0,0,3,0,0,3,0,0,0,0,0,1,0,0,0,0,0,0
		.byte 0,0,0,0,0,0,1,0,0,3,3,3,3,5,3,3,3,3,3,0,0,1,0,0,0,0,0,0
		.byte 0,0,0,0,0,0,1,0,0,3,0,0,0,9,9,0,0,0,3,0,0,1,0,0,0,0,0,0
		.byte 0,0,0,0,0,0,1,0,0,3,0,3,3,3,3,3,3,0,3,0,0,1,0,0,0,0,0,0	; 15
		.byte 0,0,0,0,0,0,1,0,0,3,0,3,7,3,3,3,3,0,3,0,0,1,0,0,0,0,0,0
		.byte 3,3,3,3,3,3,1,3,3,3,0,3,3,3,3,8,3,0,3,3,3,1,3,3,3,3,3,3
		.byte 0,0,0,0,0,0,1,0,0,3,0,3,3,6,3,3,3,0,3,0,0,1,0,0,0,0,0,0
		.byte 0,0,0,0,0,0,1,0,0,3,0,3,3,3,3,3,3,0,3,0,0,1,0,0,0,0,0,0
		.byte 0,0,0,0,0,0,1,0,0,3,0,0,0,0,0,0,0,0,3,0,0,1,0,0,0,0,0,0	; 20
		.byte 0,0,0,0,0,0,1,0,0,3,3,3,3,3,3,3,3,3,3,0,0,1,0,0,0,0,0,0
		.byte 0,0,0,0,0,0,1,0,0,3,0,0,0,0,0,0,0,0,3,0,0,1,0,0,0,0,0,0
		.byte 0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0
		.byte 0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0
		.byte 0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0	; 25
		.byte 0,2,1,1,0,0,1,1,1,1,1,1,1,1,4,1,1,1,1,1,1,1,0,0,1,1,2,0
		.byte 0,0,0,1,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,0,0,0
		.byte 0,0,0,1,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,0,0,0
		.byte 0,1,1,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1,1,1,1,0
		.byte 0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0	; 30
		.byte 0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0
		.byte 0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0
		.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

board:
		.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	; 1
		.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		.byte 0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0
		.byte 0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0	; 5
		.byte 0,2,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,2,0
		.byte 0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0
		.byte 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
		.byte 0,1,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,1,0
		.byte 0,1,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,1,0	; 10
		.byte 0,1,1,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1,1,1,1,0
		.byte 0,0,0,0,0,0,1,0,0,0,0,0,3,0,0,3,0,0,0,0,0,1,0,0,0,0,0,0
		.byte 0,0,0,0,0,0,1,0,0,3,3,3,3,5,3,3,3,3,3,0,0,1,0,0,0,0,0,0
		.byte 0,0,0,0,0,0,1,0,0,3,0,0,0,9,9,0,0,0,3,0,0,1,0,0,0,0,0,0
		.byte 0,0,0,0,0,0,1,0,0,3,0,3,3,3,3,3,3,0,3,0,0,1,0,0,0,0,0,0	; 15
		.byte 0,0,0,0,0,0,1,0,0,3,0,3,7,3,3,3,3,0,3,0,0,1,0,0,0,0,0,0
		.byte 3,3,3,3,3,3,1,3,3,3,0,3,3,3,3,8,3,0,3,3,3,1,3,3,3,3,3,3
		.byte 0,0,0,0,0,0,1,0,0,3,0,3,3,6,3,3,3,0,3,0,0,1,0,0,0,0,0,0
		.byte 0,0,0,0,0,0,1,0,0,3,0,3,3,3,3,3,3,0,3,0,0,1,0,0,0,0,0,0
		.byte 0,0,0,0,0,0,1,0,0,3,0,0,0,0,0,0,0,0,3,0,0,1,0,0,0,0,0,0	; 20
		.byte 0,0,0,0,0,0,1,0,0,3,3,3,3,3,3,3,3,3,3,0,0,1,0,0,0,0,0,0
		.byte 0,0,0,0,0,0,1,0,0,3,0,0,0,0,0,0,0,0,3,0,0,1,0,0,0,0,0,0
		.byte 0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0
		.byte 0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0
		.byte 0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0	; 25
		.byte 0,2,1,1,0,0,1,1,1,1,1,1,1,1,4,1,1,1,1,1,1,1,0,0,1,1,2,0
		.byte 0,0,0,1,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,0,0,0
		.byte 0,0,0,1,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,1,0,0,0
		.byte 0,1,1,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1,1,1,1,0
		.byte 0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0	; 30
		.byte 0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0
		.byte 0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0
		.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

prompt:			.string "placeholder", 0
lives:			.byte 0x04
pm_x:			.byte 14	; 0 indexed
pm_y:			.byte 25
score:			.word 0x00000000
dir:			.byte 0x00	; 0 = up, 1 = left, 2 = down, 3 = right
pause:			.byte 0x01	; 1 = pause, 0 = not pause, starts paused
state:			.byte 0x00	; state of game, initialized to 0, game starts paused

; game states:
;	0 = paused
; 	1 = normal
;	2 = powerup
; 	3 = end round
; 	4 = game over

cursor_row:			.string "placeholder string", 0
cursor_col:			.string "placeholder string", 0
score_string:		.string "00000000", 0
redraw_flag:		.byte 0x00
score_flag:			.byte 0x00
old_x:				.byte 14
old_y:				.byte 25
new_x:				.byte 0
new_y:				.byte 0
ghost1_x:			.byte 13	; starting position, 0 indexed grid
ghost1_y:			.byte 12
ghost1_dir:			.byte 0		; starts moving up (invalid bc i want first movement right or left to be random)
ghost1_old_x:		.byte 13
ghost1_old_y:		.byte 12
ghost1_new_x:		.byte 0
ghost1_new_y:		.byte 0
ghost_redraw_flag:	.byte 0
ghost_valid_dirs:	.word 0x00000000		; temporary, up to 3 valid directions
xor_in:				.word 0x1234ABCD
ghost1_under:		.byte 3		; starts on an empty path
pellets_eaten:		.byte 0

ghost2_x:			.byte 13
ghost2_y:			.byte 17
ghost2_dir:			.byte 0
ghost2_old_x:		.byte 13
ghost2_old_y:		.byte 17
ghost2_new_x:		.byte 0
ghost2_new_y:		.byte 0
ghost2_under:		.byte 3
ghost2_active:		.byte 0

ghost3_x:			.byte 12
ghost3_y:			.byte 15
ghost3_dir:			.byte 0
ghost3_old_x:		.byte 12
ghost3_old_y:		.byte 15
ghost3_new_x:		.byte 0
ghost3_new_y:		.byte 0
ghost3_under:		.byte 3
ghost3_active:		.byte 0

ghost4_x:			.byte 15
ghost4_y:			.byte 16
ghost4_dir:			.byte 0
ghost4_old_x:		.byte 15
ghost4_old_y:		.byte 16
ghost4_new_x:		.byte 0
ghost4_new_y:		.byte 0
ghost4_under:		.byte 3
ghost4_active:		.byte 0

powerup_timer:		.word 0x0
state_save:			.byte 1
pellets_total:		.byte 0
level_flag:			.byte 0
fredraw_flag:		.byte 0
level:				.byte 1

prompt_game_over:	.string "     GAME  OVER    ", 0
prompt_play_again:	.string "   P = PLAY AGAIN  ", 0
prompt_quit:		.string "   Q = QUIT        ", 0
prompt_level_clear:	.string "    LEVEL  CLEAR   ", 0
prompt_clear:		.string "                   ", 0
ghosts_eaten_count:	.byte 0
ghost1_eaten:		.byte 0
ghost2_eaten:		.byte 0
ghost3_eaten:		.byte 0
ghost4_eaten:		.byte 0

	.text

	.global UART0_Handler			; updated for lab 7
	.global Switch_Handler			; updated for lab 7
	.global Timer_Handler			; updated for lab 7
	.global simple_read_character	; read_character modified for interrupts
	.global output_character		; This is from your Lab #4 Library
	.global read_string				; This is from your Lab #4 Library
	.global output_string			; This is from your Lab #4 Library
	.global uart_init				; This is from your Lab #4 Library
	.global read_character			; added
	.global illuminate_RGB_LED		; added
	.global illuminate_LEDs			; added for lab 7 lives
	.global gpio_btn_and_LED_init	; added
	.global int2str					; added
	.global unsigned_division		; added for lab 7 score logic
	.global mod						; added for lab 7 score logic
	.global timer_interrupt_init	; moved to library to keep main file clean, changed to 0.25 s for lab 7
	.global uart_interrupt_init		; moved to library for clean
	.global gpio_interrupt_init		; moved to library for clean
	.global lab7


; ==========
;  POINTERS
; ==========


ghost_table:
	.word ghost1_x, ghost1_y, ghost1_dir, ghost1_old_x, ghost1_old_y, ghost1_new_x, ghost1_new_y, ghost1_under
	.word ghost2_x, ghost2_y, ghost2_dir, ghost2_old_x, ghost2_old_y, ghost2_new_x, ghost2_new_y, ghost2_under
	.word ghost3_x, ghost3_y, ghost3_dir, ghost3_old_x, ghost3_old_y, ghost3_new_x, ghost3_new_y, ghost3_under
	.word ghost4_x, ghost4_y, ghost4_dir, ghost4_old_x, ghost4_old_y, ghost4_new_x, ghost4_new_y, ghost4_under



;
; -=-=-=-=-=-=- notes -=-=-=-=-=-=-
;
;	- 238 normal pellets in total
;
; bugs/issues:
;	- prng implementation not actually random ?
;		- the ghosts choose the same "random" direction every time you run the game
;		- so the path is always the same because the starting xorshift value is always the same
;		- not sure what to do about this or how to make it different each time
;		- the xorshift start value cannot be hardcoded for true random every game run
;		- maybe involve the score with the xorshift input ? or maybe time somehow ?
;	- issues with ghosts movement
;		- when two ghosts intersect, an 'A' is sometimes left at the collision tile
;		- after losing a life, if multiple ghosts reenter the game, they are on the same path and leave behind a trail of 'A's
;
; next to do:
;	- lose life logic
;		- game over logic
;	- powerup pellet logic
;		- lasts 15 (?) seconds
;		- ghosts turn to 'W'
;		- ghost movement ai does not change
;		- eaten ghosts sent back to home, not sure how they reenter after powerup is over
;


; ============
;  LAB 7 MAIN
; ============
lab7:								; This is your main routine which is called from your C wrapper.
	PUSH {r4-r12,lr}   		; Preserve registers to adhere to the AAPCS

	bl uart_init
	bl gpio_btn_and_LED_init
	bl uart_interrupt_init
	bl gpio_interrupt_init
	bl timer_interrupt_init

; 	game code start below here

	; enable all 4 leds, 4 lives
	MOV r0, #0x0F
	BL illuminate_LEDs

	; set black bg white fg
	LDR r0, ptr_ansi_black
	BL output_string

	; clear the screen
	LDR r0, ptr_ansi_clear
	BL output_string

	; move cursor to top left
	LDR r0, ptr_ansi_home
	BL output_string

	; make the cursor invisible
	LDR r0, ptr_remove_cursor
	BL output_string

	BL print_board
	BL print_score		; show 000000 on start

MAIN_LOOP:
	; full redraw check
	LDR r0, ptr_fredraw_flag
	LDRB r1,[r0]
	CMP r1, #1
	BNE CHECK_RFLAG

	; clear da redraw flag
	MOV r1, #0
	STRB r1,[r0]

	; clear ghost and pacman redraw flags to not overwrite
	LDR r0, ptr_ghost_redraw_flag
	MOV r1, #0
	STRB r1, [r0]
	LDR r0, ptr_redraw_flag
	MOV r1, #0
	STRB r1, [r0]

	; stop timer for redraw
	MOV r0, #0x0000
	MOVT r0, #0x4003
	LDR r1, [r0, #0x00C]
	BIC r1, r1, #0x1
	STR r1, [r0, #0x00C]

	; redrawing the entire board
	LDR r0, ptr_ansi_home
	BL output_string
	BL print_board
	BL print_score

	; reenable timer after redraw if not paused
	LDR r0, ptr_pause
	LDRB r1, [r0]
	CMP r1, #1
	BEQ CHECK_RFLAG		; paused, leave timer off
	MOV r0, #0x0000
	MOVT r0, #0x4003
	LDR r1, [r0, #0x00C]
	ORR r1, r1, #0x1
	STR r1, [r0, #0x00C]

CHECK_RFLAG:
	; check for redraw
	LDR r0, ptr_redraw_flag
	LDRB r1, [r0]
	CMP r1, #1
	BNE CHECK_SCORE_FLAG

	; clear the redraw flag
	MOV r1, #0
	STRB r1, [r0]

	; only update tiles
	BL update_tiles

CHECK_SCORE_FLAG:
	; check for score update
	LDR r0, ptr_score_flag
	LDRB r1, [r0]
	CMP r1, #1
	BNE CHECK_GHOST_FLAG

	; clear the score update flag
	MOV r1, #0
	STRB r1, [r0]

	; update score on board
	BL print_score

CHECK_GHOST_FLAG:
	; check for ghost updates
	LDR r0, ptr_ghost_redraw_flag
	LDRB r1, [r0]
	CMP r1, #1
	BNE CHECK_LEVEL_FLAG

	; clear the ghost update flag
	MOV r1, #0
	STRB r1, [r0]

	; update ghosts on the board
	BL update_ghost_tiles

	; check for collision and update lives
	BL check_collisionAndLives

CHECK_LEVEL_FLAG:
	; check for level complete
	LDR r0, ptr_level_flag
	LDRB r1, [r0]
	CMP r1, #1
	BNE CHECK_GAME_OVER

	; clear level complete flag
	MOV r1, #0
	STRB r1, [r0]

	; do level up logic
	BL level_up

CHECK_GAME_OVER:
	; check for game over
	LDR r0, ptr_state
	LDRB r1, [r0]
	CMP r1, #4
	BNE MAIN_LOOP

	; do game over logic
	BL game_over

	; keep checking for updates
	B MAIN_LOOP

	POP {r4-r12,lr}		; Restore registers to adhere to the AAPCS
	MOV pc, lr


; ==========
;  LEVEL UP
; ==========
level_up:
	PUSH {r4-r9, lr}

	; increment level counter
	LDR r0, ptr_level
	LDRB r1, [r0]
	ADD r1, r1, #1
	STRB r1, [r0]

	; copy initial board to current board
	LDR r4, ptr_board_init
	LDR r5, ptr_board
	MOV r6, #924		; 33 rows * 28 cols = 924 bytes
LU_COPY:
	; copy next byte
	LDRB r7, [r4]
    STRB r7, [r5]
    ADD r4, r4, #1
    ADD r5, r5, #1
    SUB r6, r6, #1
    CMP r6, #0		; more bytes ?
    BGT LU_COPY

    ; reset pacman
    MOV r4, #14
    MOV r5, #25
    LDR r0, ptr_pm_x
    STRB r4, [r0]
    LDR r0, ptr_pm_y
    STRB r5, [r0]
    LDR r0, ptr_old_x
    STRB r4, [r0]
    LDR r0, ptr_old_y
	STRB r5, [r0]
    LDR r0, ptr_new_x
    STRB r4, [r0]
    LDR r0, ptr_new_y
    STRB r5, [r0]

    ; reset ghost 1
    MOV r4, #13
    MOV r5, #12
    LDR r0, ptr_ghost1_x
    STRB r4, [r0]
    LDR r0, ptr_ghost1_y
    STRB r5, [r0]
    LDR r0, ptr_ghost1_old_x
    STRB r4, [r0]
    LDR r0, ptr_ghost1_old_y
    STRB r5, [r0]
    LDR r0, ptr_ghost1_new_x
    STRB r4, [r0]
    LDR r0, ptr_ghost1_new_y
    STRB r5, [r0]
    LDR r0, ptr_ghost1_under
    MOV r1, #3
    STRB r1, [r0]
    LDR r0, ptr_ghost1_dir
    MOV r1, #0
    STRB r1, [r0]

    ; reset ghost 2
    MOV r4, #13
    MOV r5, #17
    LDR r0, ptr_ghost2_x
    STRB r4, [r0]
    LDR r0, ptr_ghost2_y
    STRB r5, [r0]
    LDR r0, ptr_ghost2_old_x
    STRB r4, [r0]
    LDR r0, ptr_ghost2_old_y
    STRB r5, [r0]
    LDR r0, ptr_ghost2_new_x
    STRB r4, [r0]
    LDR r0, ptr_ghost2_new_y
    STRB r5, [r0]
    LDR r0, ptr_ghost2_under
    MOV r1, #3
    STRB r1, [r0]
    LDR r0, ptr_ghost2_dir
    MOV r1, #0
    STRB r1, [r0]
    LDR r0, ptr_ghost2_active
    MOV r1, #0
    STRB r1, [r0]

    ; reset ghost 3
    MOV r4, #12
    MOV r5, #15
    LDR r0, ptr_ghost3_x
    STRB r4, [r0]
    LDR r0, ptr_ghost3_y
    STRB r5, [r0]
    LDR r0, ptr_ghost3_old_x
    STRB r4, [r0]
    LDR r0, ptr_ghost3_old_y
    STRB r5, [r0]
    LDR r0, ptr_ghost3_new_x
    STRB r4, [r0]
    LDR r0, ptr_ghost3_new_y
    STRB r5, [r0]
    LDR r0, ptr_ghost3_under
    MOV r1, #3
    STRB r1, [r0]
    LDR r0, ptr_ghost3_dir
    MOV r1, #0
    STRB r1, [r0]
    LDR r0, ptr_ghost3_active
    MOV r1, #0
    STRB r1, [r0]

    ; reset ghost 4
    MOV r4, #15
    MOV r5, #16
    LDR r0, ptr_ghost4_x
    STRB r4, [r0]
    LDR r0, ptr_ghost4_y
    STRB r5, [r0]
    LDR r0, ptr_ghost4_old_x
    STRB r4, [r0]
    LDR r0, ptr_ghost4_old_y
    STRB r5, [r0]
    LDR r0, ptr_ghost4_new_x
    STRB r4, [r0]
    LDR r0, ptr_ghost4_new_y
    STRB r5, [r0]
    LDR r0, ptr_ghost4_under
    MOV r1, #3
    STRB r1, [r0]
    LDR r0, ptr_ghost4_dir
    MOV r1, #0
    STRB r1, [r0]
    LDR r0, ptr_ghost4_active
    MOV r1, #0
    STRB r1, [r0]

    ; reset pellet counters
    LDR r0, ptr_pellets_eaten
    MOV r1, #0
    STRB r1, [r0]
    LDR r0, ptr_pellets_total
    MOV r1, #0
    STRB r1, [r0]

    ; reset powerup timer and state
    LDR r0, ptr_powerup_timer
    MOV r1, #0
    STR r1, [r0]
    LDR r0, ptr_state
    MOV r1, #0
    STRB r1, [r0]
    LDR r0, ptr_state_save
    MOV r1, #1
    STRB r1, [r0]

    ; turn off RGB LED
    MOV r0, #48
    BL illuminate_RGB_LED

    ; update timer interval
    LDR r0, ptr_level
    LDRB r1, [r0]
    SUB r1, r1, #1          ; completed level count
    MOV r2, #0x7100
    MOVT r2, #0x0002        ; 160,000 = 0x00027100
    MUL r3, r1, r2          ; decrease by number of completed levels * 160,000
    MOV r2, #0x0900
    MOVT r2, #0x003D        ; 4,000,000 = 0x003D0900 (0.25 s)
    SUB r2, r2, r3          ; new interval
    MOV r0, #0x0000
    MOVT r0, #0x4003
    STR r2, [r0, #0x028]	; update timer interval

    ; set to paused, sw1 press starts next level
    LDR r0, ptr_pause
    MOV r1, #1
    STRB r1, [r0]

    ; redraw board after reverting to original
    LDR r0, ptr_ansi_home
    BL output_string
    BL print_board
    BL print_score

    ; print level clear message on row 2
    MOV r0, #1
    MOV r1, #4
    BL move_cursor
    LDR r0, ptr_prompt_level_clear
    BL output_string

	POP {r4-r9, lr}
	MOV pc, lr


; ===========
;  GAME OVER
; ===========
game_over:
	PUSH {r4-r8, lr}

	; disable uart interrupt, poll directly instead
	MOV r4, #0xC000
    MOVT r4, #0x4000
    LDR r5, [r4, #0x038]
    BIC r5, r5, #0x10
    STR r5, [r4, #0x038]

    ; print game over message on row 16
    MOV r0, #15
    MOV r1, #4
    BL move_cursor
    LDR r0, ptr_ansi_black
    BL output_string
    LDR r0, ptr_prompt_game_over
    BL output_string

    ; ask play again or quit on rows 17, 18
    MOV r0, #17
    MOV r1, #4
    BL move_cursor
    LDR r0, ptr_prompt_play_again
    BL output_string
    MOV r0, #18
    MOV r1, #4
    BL move_cursor
    LDR r0, ptr_prompt_quit
    BL output_string

    ; wait for p or q
GO_WAIT:
	BL read_character
	CMP r0, #112		; ascii 'p'
	BEQ GO_REPLAY
	CMP r0, #80			; ascii 'P'
	BEQ GO_REPLAY
	CMP r0, #113		; ascii 'q'
	BEQ GO_QUIT
	CMP r0, #81			; ascii 'Q'
	BEQ GO_QUIT
	B GO_WAIT

GO_QUIT:
	; infinite loop of nothing, change later maybe if time
	B GO_QUIT

GO_REPLAY:
	; FULL RESET

	; reset lives and LEDs
	LDR r0, ptr_lives
    MOV r1, #4
    STRB r1, [r0]
    MOV r0, #0x0F
    BL illuminate_LEDs

    ; reset score
    LDR r0, ptr_score
    MOV r1, #0
    STR r1, [r0]

    ; reset level
    LDR r0, ptr_level
    MOV r1, #1
    STRB r1, [r0]

    ; reset pellet counters
    LDR r0, ptr_pellets_eaten
    MOV r1, #0
    STRB r1, [r0]
    LDR r0, ptr_pellets_total
    MOV r1, #0
    STRB r1, [r0]

    ; copy initital board to working board
    LDR r4, ptr_board_init
    LDR r5, ptr_board
    MOV r6, #924		; 33 cols * 28 rows = 924 bytes
GO_COPY:
    LDRB r7, [r4]
    STRB r7, [r5]
    ADD r4, r4, #1
    ADD r5, r5, #1
    SUB r6, r6, #1
    CMP r6, #0			; any bytes left ?
    BGT GO_COPY

    ; reset pacman
    MOV r4, #14
    MOV r5, #25
    LDR r0, ptr_pm_x
    STRB r4, [r0]
    LDR r0, ptr_pm_y
    STRB r5, [r0]
    LDR r0, ptr_old_x
    STRB r4, [r0]
    LDR r0, ptr_old_y
    STRB r5, [r0]
    LDR r0, ptr_new_x
    STRB r4, [r0]
    LDR r0, ptr_new_y
    STRB r5, [r0]
    LDR r0, ptr_dir
    MOV r1, #0
    STRB r1, [r0]

    ; reset ghost 1
    MOV r4, #13
    MOV r5, #12
    LDR r0, ptr_ghost1_x
    STRB r4, [r0]
    LDR r0, ptr_ghost1_y
    STRB r5, [r0]
    LDR r0, ptr_ghost1_old_x
    STRB r4, [r0]
    LDR r0, ptr_ghost1_old_y
    STRB r5, [r0]
    LDR r0, ptr_ghost1_new_x
    STRB r4, [r0]
    LDR r0, ptr_ghost1_new_y
    STRB r5, [r0]
    LDR r0, ptr_ghost1_under
    MOV r1, #3
    STRB r1, [r0]
    LDR r0, ptr_ghost1_dir
    MOV r1, #0
    STRB r1, [r0]

    ; reset ghost 2
    MOV r4, #13
    MOV r5, #17
    LDR r0, ptr_ghost2_x
    STRB r4, [r0]
    LDR r0, ptr_ghost2_y
    STRB r5, [r0]
    LDR r0, ptr_ghost2_old_x
    STRB r4, [r0]
    LDR r0, ptr_ghost2_old_y
    STRB r5, [r0]
    LDR r0, ptr_ghost2_new_x
    STRB r4, [r0]
    LDR r0, ptr_ghost2_new_y
    STRB r5, [r0]
    LDR r0, ptr_ghost2_under
    MOV r1, #3
    STRB r1, [r0]
    LDR r0, ptr_ghost2_dir
    MOV r1, #0
    STRB r1, [r0]
    LDR r0, ptr_ghost2_active
    MOV r1, #0
    STRB r1, [r0]

    ; reset ghost 3
    MOV r4, #12
    MOV r5, #15
    LDR r0, ptr_ghost3_x
    STRB r4, [r0]
    LDR r0, ptr_ghost3_y
    STRB r5, [r0]
    LDR r0, ptr_ghost3_old_x
    STRB r4, [r0]
    LDR r0, ptr_ghost3_old_y
    STRB r5, [r0]
    LDR r0, ptr_ghost3_new_x
    STRB r4, [r0]
    LDR r0, ptr_ghost3_new_y
    STRB r5, [r0]
    LDR r0, ptr_ghost3_under
    MOV r1, #3
    STRB r1, [r0]
    LDR r0, ptr_ghost3_dir
    MOV r1, #0
    STRB r1, [r0]
    LDR r0, ptr_ghost3_active
    MOV r1, #0
    STRB r1, [r0]

    ; reset ghost 4
    MOV r4, #15
    MOV r5, #16
    LDR r0, ptr_ghost4_x
    STRB r4, [r0]
    LDR r0, ptr_ghost4_y
    STRB r5, [r0]
    LDR r0, ptr_ghost4_old_x
    STRB r4, [r0]
    LDR r0, ptr_ghost4_old_y
    STRB r5, [r0]
    LDR r0, ptr_ghost4_new_x
    STRB r4, [r0]
    LDR r0, ptr_ghost4_new_y
    STRB r5, [r0]
    LDR r0, ptr_ghost4_under
    MOV r1, #3
    STRB r1, [r0]
    LDR r0, ptr_ghost4_dir
    MOV r1, #0
    STRB r1, [r0]
    LDR r0, ptr_ghost4_active
    MOV r1, #0
    STRB r1, [r0]

    ; reset powerup, state, pause
    LDR r0, ptr_powerup_timer
    MOV r1, #0
    STR r1, [r0]
    LDR r0, ptr_state
    MOV r1, #0
    STRB r1, [r0]
    LDR r0, ptr_state_save
    MOV r1, #1
    STRB r1, [r0]
	LDR r0, ptr_pause
	MOV r1, #1
	STRB r1, [r0]

	; reset timer interval back to 0.25 s
	MOV r0, #0x0000
    MOVT r0, #0x4003
    MOV r1, #0x0900
    MOVT r1, #0x003D
    STR r1, [r0, #0x028]

	; turn off RGB led
	MOV r0, #48
    BL illuminate_RGB_LED

    ; reenable UART to interrupt
    MOV r4, #0xC000
    MOVT r4, #0x4000
    LDR r5, [r4, #0x038]
    ORR r5, r5, #0x10
    STR r5, [r4, #0x038]

    ; clear screen and redraw
    LDR r0, ptr_ansi_clear
    BL output_string
    LDR r0, ptr_ansi_home
    BL output_string
    LDR r0, ptr_remove_cursor
    BL output_string
    BL print_board
    BL print_score

	POP {r4-r8, lr}
	MOV pc, lr


; ===========================
;  CHECK COLLISION AND LIVES
; ===========================
check_collisionAndLives:
    PUSH {r4-r11,lr}

	; updated after implementing all 4 ghosts

	; load pacman position
    LDR r0, ptr_pm_x
    LDRB r4, [r0]		; pacman x
    LDR r0, ptr_pm_y
    LDRB r5, [r0]		; pacman y
    ; load pacman old position
    LDR r0, ptr_old_x
    LDRB r8, [r0]		; pacman old x
    LDR r0, ptr_old_y
    LDRB r9, [r0]  		; pacman old y

    ; check ghost1, always active
    MOV r3, #5
    LDR r0, ptr_ghost1_x
    LDRB r6, [r0]
    LDR r0, ptr_ghost1_y
    LDRB r7, [r0]
    CMP r4, r6
    BNE CL_SWAP1
    CMP r5, r7
    BEQ CL_HIT
CL_SWAP1:
    LDR r0, ptr_ghost1_old_x
    LDRB r10, [r0]
    LDR r0, ptr_ghost1_old_y
    LDRB r11, [r0]
    CMP r4, r10
    BNE CL_CHECK_G2
    CMP r5, r11
    BNE CL_CHECK_G2
    CMP r6, r8
    BNE CL_CHECK_G2
    CMP r7, r9
    BEQ CL_HIT

    ; check ghost2
CL_CHECK_G2:
	MOV r3, #6
    LDR r0, ptr_ghost2_active
    LDRB r10, [r0]
    CMP r10, #1
    BNE CL_CHECK_G3
    LDR r0, ptr_ghost2_x
    LDRB r6, [r0]
    LDR r0, ptr_ghost2_y
    LDRB r7, [r0]
    CMP r4, r6
    BNE CL_SWAP2
    CMP r5, r7
    BEQ CL_HIT
CL_SWAP2:
    LDR r0, ptr_ghost2_old_x
    LDRB r10, [r0]
    LDR r0, ptr_ghost2_old_y
    LDRB r11, [r0]
    CMP r4, r10
    BNE CL_CHECK_G3
    CMP r5, r11
    BNE CL_CHECK_G3
    CMP r6, r8
    BNE CL_CHECK_G3
    CMP r7, r9
    BEQ CL_HIT

    ; check ghost3
CL_CHECK_G3:
	MOV r3, #7
    LDR r0, ptr_ghost3_active
    LDRB r10, [r0]
    CMP r10, #1
    BNE CL_CHECK_G4
    LDR r0, ptr_ghost3_x
    LDRB r6, [r0]
    LDR r0, ptr_ghost3_y
    LDRB r7, [r0]
    CMP r4, r6
    BNE CL_SWAP3
    CMP r5, r7
    BEQ CL_HIT
CL_SWAP3:
    LDR r0, ptr_ghost3_old_x
    LDRB r10, [r0]
    LDR r0, ptr_ghost3_old_y
    LDRB r11, [r0]
    CMP r4, r10
    BNE CL_CHECK_G4
    CMP r5, r11
    BNE CL_CHECK_G4
    CMP r6, r8
    BNE CL_CHECK_G4
    CMP r7, r9
    BEQ CL_HIT

    ; check ghost4
CL_CHECK_G4:
	MOV r3, #8
    LDR r0, ptr_ghost4_active
    LDRB r10, [r0]
    CMP r10, #1
    BNE CL_DONE
    LDR r0, ptr_ghost4_x
    LDRB r6, [r0]
    LDR r0, ptr_ghost4_y
    LDRB r7, [r0]
    CMP r4, r6
    BNE CL_SWAP4
    CMP r5, r7
    BEQ CL_HIT
CL_SWAP4:
    LDR r0, ptr_ghost4_old_x
    LDRB r10, [r0]
    LDR r0, ptr_ghost4_old_y
    LDRB r11, [r0]
    CMP r4, r10
    BNE CL_DONE
    CMP r5, r11
    BNE CL_DONE
    CMP r6, r8
    BNE CL_DONE
    CMP r7, r9
    BNE CL_DONE

CL_HIT:
	; powerup = eat da ghost insted
	LDR r0, ptr_state
	LDRB r1,[r0]
	CMP r1, #2
	BEQ CL_EAT_GHOST

    LDR r0, ptr_lives
    LDRB r1, [r0]
    CMP r1, #0
    BEQ CL_DONE

    SUB r1, r1, #1
    STRB r1, [r0]

    CMP r1, #3
    BEQ CL_L3
    CMP r1, #2
    BEQ CL_L2
    CMP r1, #1
    BEQ CL_L1
    B CL_L0

CL_L3:
	MOV r0, #0x07
	BL illuminate_LEDs
	B CL_RESET
CL_L2:
	MOV r0, #0x03
	BL illuminate_LEDs
	B CL_RESET
CL_L1:
	MOV r0, #0x01
	BL illuminate_LEDs
	B CL_RESET
CL_L0:
	; means the game over
   MOV r0, #0x00
   BL illuminate_LEDs
   LDR r0, ptr_state
   MOV r1, #4
   STRB r1, [r0]
    ; pause the game
    LDR r0, ptr_pause
    MOV r1, #1
    STRB r1, [r0]
    ; stop the timer
    MOV r0, #0x0000
    MOVT r0, #0x4003
    LDR r1, [r0, #0x00C]
    BIC r1, r1, #0x1
    STR r1, [r0, #0x00C]
    ; skip everything else
   B CL_DONE

CL_RESET:
   ; pause
   LDR r0, ptr_pause
   MOV r1, #1
   STRB r1, [r0]

   ; stop timer
   MOV r0, #0x0000
   MOVT r0, #0x4003
   LDR r1, [r0, #0x00C]
   BIC r1, r1, #0x1
   STR r1, [r0, #0x00C]

   ; clear all pacman and ghost tiles from board
   ; r4 = pm_x, r5 = pm_y
   MOV r0, #28
   MUL r2, r5, r0
   ADD r2, r2, r4
   LDR r0, ptr_board
   ADD r0, r0, r2
   MOV r2, #3
   STRB r2, [r0]

   ; ghost1
   LDR r0, ptr_ghost1_x
   LDRB r4, [r0]
   LDR r0, ptr_ghost1_y
   LDRB r5, [r0]
   MOV r0, #28
   MUL r2, r5, r0
   ADD r2, r2, r4
   LDR r0, ptr_board
   ADD r0, r0, r2
    LDR r2, ptr_ghost1_under
    LDRB r2, [r2]
   STRB r2, [r0]

   ; ghost2, if active
   LDR r0, ptr_ghost2_active
   LDRB r4, [r0]
   CMP r4, #1
   BNE CL_SKIP_CLEAR_G2
   LDR r0, ptr_ghost2_x
   LDRB r4, [r0]
   LDR r0, ptr_ghost2_y
   LDRB r5, [r0]
   MOV r0, #28
   MUL r2, r5, r0
   ADD r2, r2, r4
   LDR r0, ptr_board
   ADD r0, r0, r2
    LDR r2, ptr_ghost2_under
    LDRB r2, [r2]
   STRB r2, [r0]

CL_SKIP_CLEAR_G2:
	; ghost3 (if active)
   LDR r0, ptr_ghost3_active
   LDRB r4, [r0]
   CMP r4, #1
   BNE CL_SKIP_CLEAR_G3
   LDR r0, ptr_ghost3_x
   LDRB r4, [r0]
   LDR r0, ptr_ghost3_y
   LDRB r5, [r0]
   MOV r0, #28
   MUL r2, r5, r0
   ADD r2, r2, r4
   LDR r0, ptr_board
   ADD r0, r0, r2
    LDR r2, ptr_ghost3_under
    LDRB r2, [r2]
   STRB r2, [r0]

CL_SKIP_CLEAR_G3:
	; ghost4 (if active)
   LDR r0, ptr_ghost4_active
   LDRB r4, [r0]
   CMP r4, #1
   BNE CL_SKIP_CLEAR_G4
   LDR r0, ptr_ghost4_x
   LDRB r4, [r0]
   LDR r0, ptr_ghost4_y
   LDRB r5, [r0]
   MOV r0, #28
   MUL r2, r5, r0
   ADD r2, r2, r4
   LDR r0, ptr_board
   ADD r0, r0, r2
    LDR r2, ptr_ghost4_under
    LDRB r2, [r2]
   STRB r2, [r0]

CL_SKIP_CLEAR_G4:
	; write all entities back to their starting board positions
   MOV r0, #28

   ; pacman (14, 25)
   MOV r1, #25
   MUL r1, r1, r0
   ADD r1, r1, #14
   LDR r2, ptr_board
   ADD r2, r2, r1
   MOV r1, #4
   STRB r1, [r2]

   ; ghost1 (13, 12)
   MOV r1, #12
   MUL r1, r1, r0
   ADD r1, r1, #13
   LDR r2, ptr_board
   ADD r2, r2, r1
   MOV r1, #5
   STRB r1, [r2]

   ; ghost2 (13, 17)
   MOV r1, #17
   MUL r1, r1, r0
   ADD r1, r1, #13
   LDR r2, ptr_board
   ADD r2, r2, r1
   MOV r1, #6
   STRB r1, [r2]

   ; ghost3 (12, 15)
   MOV r1, #15
   MUL r1, r1, r0
   ADD r1, r1, #12
   LDR r2, ptr_board
   ADD r2, r2, r1
   MOV r1, #7
   STRB r1, [r2]

   ; ghost4 (15, 16)
   MOV r1, #16
   MUL r1, r1, r0
   ADD r1, r1, #15
   LDR r2, ptr_board
   ADD r2, r2, r1
   MOV r1, #8
   STRB r1, [r2]

   ; reset all ghost 1 globals
   MOV r4, #13
   MOV r5, #12
   LDR r0, ptr_ghost1_x
   STRB r4, [r0]
   LDR r0, ptr_ghost1_y
   STRB r5, [r0]
   LDR r0, ptr_ghost1_old_x
   STRB r4, [r0]
   LDR r0, ptr_ghost1_old_y
   STRB r5, [r0]
   LDR r0, ptr_ghost1_new_x
   STRB r4, [r0]
   LDR r0, ptr_ghost1_new_y
   STRB r5, [r0]
   LDR r0, ptr_ghost1_under
   MOV r1, #3
   STRB r1, [r0]
   LDR r0, ptr_ghost1_dir
   MOV r1, #0
   STRB r1, [r0]

   ; reset all ghost 2 globals
   MOV r4, #13
   MOV r5, #17
   LDR r0, ptr_ghost2_x
   STRB r4, [r0]
   LDR r0, ptr_ghost2_y
   STRB r5, [r0]
   LDR r0, ptr_ghost2_old_x
   STRB r4, [r0]
   LDR r0, ptr_ghost2_old_y
   STRB r5, [r0]
   LDR r0, ptr_ghost2_new_x
   STRB r4, [r0]
   LDR r0, ptr_ghost2_new_y
   STRB r5, [r0]
   LDR r0, ptr_ghost2_under
   MOV r1, #3
   STRB r1, [r0]
   LDR r0, ptr_ghost2_dir
   MOV r1, #0
   STRB r1, [r0]
   LDR r0, ptr_ghost2_active
   MOV r1, #0
   STRB r1, [r0]

   ; reset all ghost 3 globals
   MOV r4, #12
   MOV r5, #15
   LDR r0, ptr_ghost3_x
   STRB r4, [r0]
   LDR r0, ptr_ghost3_y
   STRB r5, [r0]
   LDR r0, ptr_ghost3_old_x
   STRB r4, [r0]
   LDR r0, ptr_ghost3_old_y
   STRB r5, [r0]
   LDR r0, ptr_ghost3_new_x
   STRB r4, [r0]
   LDR r0, ptr_ghost3_new_y
   STRB r5, [r0]
   LDR r0, ptr_ghost3_under
   MOV r1, #3
   STRB r1, [r0]
   LDR r0, ptr_ghost3_dir
   MOV r1, #0
   STRB r1, [r0]
   LDR r0, ptr_ghost3_active
   MOV r1, #0
   STRB r1, [r0]

   ; reset all ghost 4 globals
   MOV r4, #15
   MOV r5, #16
   LDR r0, ptr_ghost4_x
   STRB r4, [r0]
   LDR r0, ptr_ghost4_y
   STRB r5, [r0]
   LDR r0, ptr_ghost4_old_x
	STRB r4, [r0]
   LDR r0, ptr_ghost4_old_y
   STRB r5, [r0]
   LDR r0, ptr_ghost4_new_x
   STRB r4, [r0]
   LDR r0, ptr_ghost4_new_y
   STRB r5, [r0]
   LDR r0, ptr_ghost4_under
   MOV r1, #3
   STRB r1, [r0]
   LDR r0, ptr_ghost4_dir
   MOV r1, #0
   STRB r1, [r0]
   LDR r0, ptr_ghost4_active
   MOV r1, #0
   STRB r1, [r0]

   ; reset pacman
   MOV r4, #14
   MOV r5, #25
   LDR r0, ptr_pm_x
   STRB r4, [r0]
   LDR r0, ptr_pm_y
   STRB r5, [r0]
   LDR r0, ptr_old_x
   STRB r4, [r0]
   LDR r0, ptr_old_y
   STRB r5, [r0]
   LDR r0, ptr_new_x
   STRB r4, [r0]
   LDR r0, ptr_new_y
   STRB r5, [r0]

   ; reset pellets counter, yes ik thats not how the game is supposed to work but we're running out of time
   LDR r0, ptr_pellets_eaten
   MOV r1, #0
   STRB r1, [r0]

   ; signal full redraw
   LDR r0, ptr_fredraw_flag
   MOV r1, #1
   STRB r1, [r0]

CL_DONE:

	POP {r4-r11, lr}
	MOV pc, lr


ptr_prompt:				.word prompt
ptr_lookup_color:		.word lookup_color
ptr_lookup_char:		.word lookup_char
ptr_board:				.word board
ptr_lives:				.word lives
ptr_pm_x:				.word pm_x
ptr_pm_y:				.word pm_y
ptr_score:				.word score
ptr_dir:				.word dir
ptr_pause:				.word pause
ptr_state:				.word state
ptr_cursor_row:			.word cursor_row
ptr_cursor_col:			.word cursor_col
ptr_redraw_flag:		.word redraw_flag
ptr_old_x:				.word old_x
ptr_old_y:				.word old_y
ptr_new_x:				.word new_x
ptr_new_y:				.word new_y
ptr_remove_cursor:		.word remove_cursor
ptr_ansi_home:			.word ansi_home
ptr_ansi_clear:			.word ansi_clear
ptr_ansi_black:			.word ansi_black
ptr_score_flag:			.word score_flag
ptr_score_string:		.word score_string
ptr_ghost1_x:			.word ghost1_x
ptr_ghost1_y:			.word ghost1_y
ptr_ghost1_dir:			.word ghost1_dir
ptr_ghost1_old_x:		.word ghost1_old_x
ptr_ghost1_old_y:		.word ghost1_old_y
ptr_ghost1_new_x:		.word ghost1_new_x
ptr_ghost1_new_y:		.word ghost1_new_y
ptr_ghost_redraw_flag:	.word ghost_redraw_flag
ptr_ghost_valid_dirs:	.word ghost_valid_dirs
ptr_xor_in:				.word xor_in
ptr_ghost1_under:		.word ghost1_under
ptr_pellets_eaten:		.word pellets_eaten
ptr_ghost2_x:			.word ghost2_x
ptr_ghost2_y:			.word ghost2_y
ptr_ghost2_dir:			.word ghost2_dir
ptr_ghost2_old_x:		.word ghost2_old_x
ptr_ghost2_old_y:		.word ghost2_old_y
ptr_ghost2_new_x:		.word ghost2_new_x
ptr_ghost2_new_y:		.word ghost2_new_y
ptr_ghost2_under:		.word ghost2_under
ptr_ghost2_active:		.word ghost2_active
ptr_ghost3_x:			.word ghost3_x
ptr_ghost3_y:			.word ghost3_y
ptr_ghost3_dir:			.word ghost3_dir
ptr_ghost3_old_x:		.word ghost3_old_x
ptr_ghost3_old_y:		.word ghost3_old_y
ptr_ghost3_new_x:		.word ghost3_new_x
ptr_ghost3_new_y:		.word ghost3_new_y
ptr_ghost3_under:		.word ghost3_under
ptr_ghost3_active:		.word ghost3_active
ptr_ghost4_x:			.word ghost4_x
ptr_ghost4_y:			.word ghost4_y
ptr_ghost4_dir:			.word ghost4_dir
ptr_ghost4_old_x:		.word ghost4_old_x
ptr_ghost4_old_y:		.word ghost4_old_y
ptr_ghost4_new_x:		.word ghost4_new_x
ptr_ghost4_new_y:		.word ghost4_new_y
ptr_ghost4_under:		.word ghost4_under
ptr_ghost4_active:		.word ghost4_active
ptr_powerup_timer:		.word powerup_timer
ptr_state_save:			.word state_save
ptr_pellets_total:		.word pellets_total
ptr_level:				.word level
ptr_level_flag:			.word level_flag
ptr_prompt_game_over:	.word prompt_game_over
ptr_prompt_play_again:	.word prompt_play_again
ptr_prompt_quit:		.word prompt_quit
ptr_prompt_level_clear:	.word prompt_level_clear
ptr_board_init:			.word board_init
ptr_fredraw_flag: 		.word fredraw_flag
ptr_ghost_table:		.word ghost_table
ptr_ghosts_eaten_count:	.word ghosts_eaten_count
ptr_ghost1_eaten:		.word ghost1_eaten
ptr_ghost2_eaten:		.word ghost2_eaten
ptr_ghost3_eaten:		.word ghost3_eaten
ptr_ghost4_eaten:		.word ghost4_eaten
ptr_prompt_clear:		.word prompt_clear


; ==============
;  EAT DA GHOST
; ==============
CL_EAT_GHOST:
	; r3 = ghost tile value (5-8), r6 = ghost x, r7 = ghost y

    ; calculate score (100 * 2^ghosts eaten count)
    LDR r0, ptr_ghosts_eaten_count
    LDRB r1, [r0]
    ADD r1, r1, #1
    STRB r1, [r0]           ; increment eaten count

    ; score gained = 100 << (count-1): 1=100, 2=200, 3=400, 4=800
    MOV r2, #100
    SUB r1, r1, #1
    LSL r2, r2, r1          ; r2 = points gained

    LDR r0, ptr_score
    LDR r1, [r0]
    ADD r1, r1, r2
    STR r1, [r0]
    LDR r0, ptr_score_flag
    MOV r1, #1
    STRB r1, [r0]

    ; restore tile under ghost at its current position, compute which ghost table entry and get ghost_under
    SUB r12, r3, #5         ; r12 = ghost index (0-3)
    LSL r2, r12, #5
    LDR r0, ptr_ghost_table
    ADD r2, r2, r0          ; r2 = table entry base

    LDR r0, [r2, #28]       ; ptr ghost under
    LDRB r1, [r0]           ; tile under
    MOV r8, r1			; save ghost under for later
    MOV r0, #28
    MUL r11, r7, r0
    ADD r11, r11, r6
    LDR r0, ptr_board
    ADD r0, r0, r11
    STRB r1, [r0]           ; restore tile at ghost current pos

    ; send ghost back to home position
    CMP r3, #5
    BEQ EG_GHOST1HOME
    CMP r3, #6
    BEQ EG_GHOST2HOME
    CMP r3, #7
    BEQ EG_GHOST3HOME
    CMP r3, #8
    BEQ EG_GHOST4HOME
    B EG_DONE

EG_GHOST1HOME:
    MOV r4, #13
    MOV r5, #12
    LDR r0, ptr_ghost1_eaten
    MOV r1, #1
    STRB r1, [r0]
    B EG_SET_HOME
EG_GHOST2HOME:
    MOV r4, #13
    MOV r5, #17
    LDR r0, ptr_ghost2_eaten
    MOV r1, #1
    STRB r1, [r0]
    LDR r0, ptr_ghost2_active
    MOV r1, #0
    STRB r1, [r0]
    B EG_SET_HOME
EG_GHOST3HOME:
    MOV r4, #12
    MOV r5, #15
    LDR r0, ptr_ghost3_eaten
    MOV r1, #1
    STRB r1, [r0]
    LDR r0, ptr_ghost3_active
    MOV r1, #0
    STRB r1, [r0]
    B EG_SET_HOME
EG_GHOST4HOME:
    MOV r4, #15
    MOV r5, #16
    LDR r0, ptr_ghost4_eaten
    MOV r1, #1
    STRB r1, [r0]
    LDR r0, ptr_ghost4_active
    MOV r1, #0
    STRB r1, [r0]

EG_SET_HOME:
    ; set all position globals to home
    LDR r0, [r2, #0]
    STRB r4, [r0]   	; ghost x
    LDR r0, [r2, #4]
    STRB r5, [r0]   	; ghost y
    LDR r0, [r2, #8]
	MOV r1, #0
	STRB r1, [r0]  		; dir
    LDR r0, [r2, #12]
    STRB r4, [r0]   	; old x
    LDR r0, [r2, #16]
    STRB r5, [r0]   	; old y
    LDR r0, [r2, #20]
    STRB r4, [r0]   	; new x
    LDR r0, [r2, #24]
    STRB r5, [r0]   	; new y
    LDR r0, [r2, #28]
    MOV r1, #3
    STRB r1, [r0]  		; ghost_under = empty

    ; write ghost tile at home on board
    MOV r0, #28
    MUL r11, r5, r0
    ADD r11, r11, r4
    LDR r0, ptr_board
    ADD r0, r0, r11
    STRB r3, [r0]           ; r3 = ghost tile value

    ; write pacman at current pos
    LDR r0, ptr_pm_x
    LDRB r4, [r0]
    LDR r0, ptr_pm_y
    LDRB r5, [r0]
    MOV r0, #28
    MUL r11, r5, r0
    ADD r11, r11, r4
    LDR r0, ptr_board
    ADD r0, r0, r11
    MOV r1, #4
    STRB r1, [r0]

    ; signal full redraw
    LDR r0, ptr_fredraw_flag
    MOV r1, #1
    STRB r1, [r0]

EG_DONE:
	; only count pellet if pacman and ghost were on the exact same tile
	CMP r8, #1
	BNE EG_SKIP_PELLET
	LDR r0, ptr_pm_x
	LDRB r0, [r0]
    CMP r0, r6                  ; r6 = ghost_x
    BNE EG_SKIP_PELLET
    LDR r0, ptr_pm_y
    LDRB r0, [r0]
    CMP r0, r7                  ; r7 = ghost_y
    BNE EG_SKIP_PELLET

    ; same tile, count the hidden pellet
    LDR r0, ptr_pellets_total
    LDRB r1, [r0]
    ADD r1, r1, #1
    STRB r1, [r0]
    LDR r0, ptr_pellets_eaten
    LDRB r1, [r0]
    ADD r1, r1, #1
    STRB r1, [r0]
    LDR r0, ptr_score
    LDR r1, [r0]
    ADD r1, r1, #10
    STR r1, [r0]

    ; check for level complete
    LDR r0, ptr_pellets_total
    LDRB r1, [r0]
    CMP r1, #238
    BNE EG_SKIP_PELLET
    LDR r0, ptr_level_flag
    MOV r1, #1
    STRB r1, [r0]
    LDR r0, ptr_pause
    MOV r1, #1
    STRB r1, [r0]
    MOV r0, #0x0000
    MOVT r0, #0x4003
    LDR r1, [r0, #0x00C]
    BIC r1, r1, #0x1
    STR r1, [r0, #0x00C]

EG_SKIP_PELLET:

	POP {r4-r11, lr}
	MOV pc, lr


; ====================
;  UPDATE GHOST TILES
; ====================
update_ghost_tiles:
	PUSH {r4-r5, lr}

	; all 4 ghosts now implemented

	; ghost 1, always active
	LDR r0, ptr_ghost1_old_x
	LDRB r4, [r0]
	LDR r0, ptr_ghost1_old_y
	LDRB r5, [r0]
	MOV r0, r4
	MOV r1, r5
	BL draw_tile				; draw old tile
	LDR r0, ptr_ghost1_new_x
	LDRB r4, [r0]
	LDR r0, ptr_ghost1_new_y
	LDRB r5, [r0]
	MOV r0, r4
	MOV r1, r5
	BL draw_tile				; draw new tile

	; ghost 2
	LDR r0, ptr_ghost2_active
	LDRB r4, [r0]
	CMP r4, #1					; check if ghost 2 is active, skip if not
	BNE UGT_SKIP_G2
	LDR r0, ptr_ghost2_old_x
	LDRB r4, [r0]
	LDR r0, ptr_ghost2_old_y
	LDRB r5, [r0]
	MOV r0, r4
	MOV r1, r5
	BL draw_tile				; draw old tile
	LDR r0, ptr_ghost2_new_x
	LDRB r4, [r0]
	LDR r0, ptr_ghost2_new_y
	LDRB r5, [r0]
	MOV r0, r4
	MOV r1, r5
	BL draw_tile				; draw new tile

UGT_SKIP_G2:
	; ghost 3
	LDR r0, ptr_ghost3_active
	LDRB r4, [r0]
	CMP r4, #1					; check if ghost 3 is active, skip if not
	BNE UGT_SKIP_G3
	LDR r0, ptr_ghost3_old_x
	LDRB r4, [r0]
	LDR r0, ptr_ghost3_old_y
	LDRB r5, [r0]
	MOV r0, r4
	MOV r1, r5
	BL draw_tile				; draw old tile
	LDR r0, ptr_ghost3_new_x
	LDRB r4, [r0]
	LDR r0, ptr_ghost3_new_y
	LDRB r5, [r0]
	MOV r0, r4
	MOV r1, r5
	BL draw_tile				; draw new tile

UGT_SKIP_G3:
	; ghost 4
	LDR r0, ptr_ghost4_active
	LDRB r4, [r0]
	CMP r4, #1					; check if ghost 4 is active, skip if not
	BNE UGT_SKIP_G4
	LDR r0, ptr_ghost4_old_x
	LDRB r4, [r0]
	LDR r0, ptr_ghost4_old_y
	LDRB r5, [r0]
	MOV r0, r4
	MOV r1, r5
	BL draw_tile				; draw old tile
	LDR r0, ptr_ghost4_new_x
	LDRB r4, [r0]
	LDR r0, ptr_ghost4_new_y
	LDRB r5, [r0]
	MOV r0, r4
	MOV r1, r5
	BL draw_tile				; draw new tile

UGT_SKIP_G4:

	POP {r4-r5, lr}
	MOV pc, lr


; =============
;  PRINT SCORE
; =============
print_score:
	PUSH {r4-r7,lr}

	; switch to black bg, white fg
	LDR r0, ptr_ansi_black
	BL output_string

	; clear row (maybe level clear still there)
	MOV r0, #1
    MOV r1, #4
    BL move_cursor
    LDR r0, ptr_prompt_clear
    BL output_string

	; move cursor to score location, starts row 1 col 11
	MOV r0, #1
	MOV r1, #11
	BL move_cursor

	; load the score
	LDR r5, ptr_score
	LDR r4, [r5]

	; extract 6 digits into score string from right to left
	LDR r5, ptr_score_string
	ADD r5, r5, #5				; point at last digit
	MOV r6, #6					; digit counter

SCORE_EXTRACT_LOOP:
	MOV r0, #10
	MOV r1, r4
	BL mod				; r0 = r4 % 10
	ADD r0, r0, #48		; convert to ascii
	STRB r0, [r5]		; store next digit
	SUB r5, r5, #1		; move pointer left

	MOV r1, r4
	MOV r0, #10
	BL unsigned_division	; r0 = r4 / 10
	MOV r4, r0

	SUB r6, r6, #1		; decrement counter
	CMP r6, #0
	BGT SCORE_EXTRACT_LOOP

	; output 6 digits
	LDR r5, ptr_score_string
	MOV r6, #6

SCORE_OUTPUT_LOOP:
	LDRB r0, [r5]
	BL output_character
	ADD r5, r5, #1	; increment pointer
	SUB r6, r6, #1	; decrement counter
	CMP r6, #0
	BGT SCORE_OUTPUT_LOOP

	POP {r4-r7,lr}
	MOV pc, lr


; ==============
;  UPDATE_TILES
; ==============
update_tiles:
	PUSH {r4-r5,lr}

	; updates pacmans old and new tiles on putty

	; draw old tile
	LDR r0, ptr_old_x
	LDRB r4, [r0]
	LDR r0, ptr_old_y
	LDRB r5, [r0]
	MOV r0, r4
	MOV r1, r5
	BL draw_tile

	; draw new tile
	LDR r0, ptr_new_x
	LDRB r4, [r0]
	LDR r0, ptr_new_y
	LDRB r5, [r0]
	MOV r0, r4
	MOV r1, r5
	BL draw_tile

	POP {r4-r5,lr}
	MOV pc, lr


; ====================
;  PRINT ENTIRE BOARD
; ====================
print_board:
	PUSH {r4-r7,lr}   		; Preserve registers to adhere to the AAPCS

	LDR r4, ptr_board	; board base address
	MOV r5, #33		; 33 rows

row_loop:
	MOV r7, r4		; row pointer
	BL print_row

	; crlf
	MOV r0, #13
	BL output_character
	MOV r0, #10
	BL output_character

	ADD r4, r4, #28		; next row
	SUB r5, r5, #1
	CMP r5, #0
	BGT row_loop

	POP {r4-r7,lr}		; Restore registers to adhere to the AAPCS
	MOV pc, lr


; =======================
;  PRINT INDIVIDUAL ROWS
; =======================
print_row:
	PUSH {r4-r6,lr}   		; Preserve registers to adhere to the AAPCS

	MOV r6, #28		; 28 wide

print_row_loop:
	LDRB r2, [r7]
	ADD r7, r7, #1

	; color
	LDR r1, ptr_lookup_color
	LSL r3, r2, #2		; color lookup is words, tiles are bytes
	ADD r1, r1, r3		; base + offset
	LDR r0, [r1]
	BL output_string

	; char
	CMP r2, #5
	BLT normal_char
	CMP r2, #8
	BGT normal_char

	LDR r1, ptr_state
	LDRB r3, [r1]
	CMP r3, #2
	BNE normal_char
	MOV r0, #87		; ascii for W
	BL output_character
	B char_done
normal_char:
	LDR r1, ptr_lookup_char
	ADD r1, r1, r2		; both bytes, so just add base + offset
	LDRB r0, [r1]
	BL output_character
char_done:

	SUB r6, r6, #1
	CMP r6, #0			; tiles left in row ?
	BGT print_row_loop

	POP {r4-r6,lr}		; Restore registers to adhere to the AAPCS
	MOV pc, lr


; ========================
;  UART INTERRUPT HANDLER
; ========================
UART0_Handler:
	PUSH {r4-r12,lr}	; Spill registers to stack
	; Your code for your UART handler goes here.
	; Remember to preserver registers r4-r12 by pushing then popping
	; them to & from the stack at the beginning & end of the handler

	BL simple_read_character

	; if game paused, do nothing
	LDR r4, ptr_pause
	LDRB r5, [r4]
	CMP r5, #1
	BEQ UART_HANDLER_END

	; get direction variable
	LDR r4, ptr_dir
	LDRB r5, [r4]

	CMP r0, #119		; ascii 'w'
	BEQ SET_UP
	CMP r0, #97			; ascii 'a'
	BEQ SET_LEFT
	CMP r0, #115		; ascii 's'
	BEQ SET_DOWN
	CMP r0, #100		; ascii 'd'
	BEQ SET_RIGHT

	B UART_HANDLER_END		; ignore all non wasd inputs

; set new direction
SET_UP:
	MOV r6, #0
	STRB r6, [r4]
	B UART_HANDLER_END
SET_LEFT:
	MOV r6, #1
	STRB r6, [r4]
	B UART_HANDLER_END
SET_DOWN:
	MOV r6, #2
	STRB r6, [r4]
	B UART_HANDLER_END
SET_RIGHT:
	MOV r6, #3
	STRB r6, [r4]

UART_HANDLER_END:
	; clear UART interrupt
    MOV r4, #0xC044
    MOVT r4, #0x4000
    MOV r5, #0x10
    STR r5,[r4]

	POP {r4-r12,lr}  	; Restore registers from stack
	BX lr       	; Return


; ==========================
;  SWITCH INTERRUPT HANDLER
; ==========================
Switch_Handler:
	PUSH {r4-r12,lr}	; Spill registers to stack
	; Your code for your UART handler goes here.
	; Remember to preserver registers r4-r12 by pushing then popping
	; them to & from the stack at the beginning & end of the handler

	LDR r4, ptr_pause
	LDRB r5, [r4]
	EOR r5, r5, #1 ; flip pause flag
	STRB r5, [r4]

	MOV r4, #0x0000
	MOVT r4, #0x4003 ; base address for timer, need to enable or disable

	LDR r6, ptr_state

	CMP r5, #1 ; p
	BEQ DISABLE_TIMER

	B ENABLE_TIMER

DISABLE_TIMER:
	MOV r7, #0	; set state to paused
	LDRB r7,[r6]
	LDR r0, ptr_state_save
	STRB r7,[r0]
	MOV r7, #0 ; set state to paused
	STRB r7, [r6]

	; disable timer
	LDR r5, [r4, #0x00C]	; GPTMCTL Offset
	BIC r5, r5, #0x1
	STR r5, [r4, #0x00C]
	B SWITCH_HANDLER_END

ENABLE_TIMER:
	; restore previous state
	LDR r0, ptr_state_save
	LDRB r7, [r0]
	STRB r7, [r6]

	LDR r5, [r4, #0x00C]
	ORR r5, r5, #1
	STR r5, [r4, #0x00C]

SWITCH_HANDLER_END:
    ; clear interrupt
	MOV r4, #0x5000
    MOVT r4, #0x4002
    MOV r5, #0x10
    STR r5, [r4, #0x41C]

	POP {r4-r12,lr}  	; Restore registers from stack
	BX lr       	; Return


; =========================
;  TIMER INTERRUPT HANDLER
; =========================
Timer_Handler:
	PUSH {r4-r12,lr}	; Spill registers to stack
	; Your code for your Timer handler goes here.  It is not needed for
	; Lab #5, but will be used in Lab #6.  It is referenced here because
	; the interrupt enabled startup code has declared Timer_Handler.
	; This will allow you to not have to redownload startup code for
	; Lab #6.  Instead, you can use the same startup code as for Lab #5.
	; Remember to preserver registers r4-r12 by pushing then popping
	; them to & from the stack at the beginning & end of the handler.

	; clear timer interrupt
	MOV r4, #0x0000
	MOVT r4, #0x4003
	MOV r5, #1
	STR r5, [r4, #0x024]

	; pause check
	LDR r0, ptr_pause
	LDRB r1, [r0]
	CMP r1, #1
	BEQ MOVE_DONE

	; ---------
	; powerup timer
	; ---------
	LDR r0, ptr_state
	LDRB r1, [r0]
	CMP r1,#2
	BNE CONTINUE

	LDR r0, ptr_powerup_timer
	LDR r1, [r0]
	CMP r1,#0
	BEQ POWERUP_DONE

	SUB r1,r1, #1
	STR r1, [r0]
	CMP r1,#0
	BEQ POWERUP_DONE


	; 10 seconds = blue, 5 seconds = blinking red
	CMP r1, #20
	BGT PU_BLUE
	; blinking red
	AND r2, r1, #1
	CMP r2, #0
	BEQ PU_RED
	MOV r0, #48
	BL illuminate_RGB_LED
	B CONTINUE

PU_RED:
	MOV r0, #49
	BL illuminate_RGB_LED
	B CONTINUE
PU_BLUE:
	MOV r0, #51
	BL illuminate_RGB_LED
	B CONTINUE

POWERUP_DONE:
	LDR r0, ptr_state
	MOV r1, #1
	STRB r1, [r0]

	; clear tiner
	LDR r0, ptr_powerup_timer
	MOV r1, #0
	STR r1, [r0]

	; led off
	MOV r0, #48
	BL illuminate_RGB_LED

	; clear all eaten flags so ghosts come back
	LDR r0, ptr_ghost1_eaten
	MOV r1, #0
	STRB r1, [r0]
    LDR r0, ptr_ghost2_eaten
    MOV r1, #0
    STRB r1, [r0]
    LDR r0, ptr_ghost3_eaten
    MOV r1, #0
    STRB r1, [r0]
    LDR r0, ptr_ghost4_eaten
    MOV r1, #0
    STRB r1, [r0]

    ; ghosts 2-4, only reactivate if pellets threshold has been met
    LDR r11, ptr_pellets_eaten
    LDRB r11, [r11]

    CMP r11, #30
    BLT PD_SKIP_G2
    LDR r0, ptr_ghost2_active
    MOV r1, #1
    STRB r1, [r0]
PD_SKIP_G2:
	CMP r11, #60
	BLT PD_SKIP_G3
	LDR r0, ptr_ghost3_active
	MOV r1, #1
	STRB r1, [r0]
PD_SKIP_G3:
	CMP r11, #90
	BLT PD_SKIP_G4
	LDR r0, ptr_ghost4_active
	MOV r1, #1
	STRB r1, [r0]
PD_SKIP_G4:

	; reset eaten count
	LDR r0, ptr_ghosts_eaten_count
	MOV r1, #0
	STRB r1, [r0]

	; redraw for ghosts going back to normal
	LDR r0, ptr_ghost_redraw_flag
	MOV r1, #1
	STRB r1, [r0]

	; move all active ghosts
CONTINUE:

	; move blinky, (normally) always active, check eaten flag
	LDR r0, ptr_ghost1_eaten
	LDRB r1, [r0]
	CMP r1, #1
	BEQ SKIP_GHOST1_MOVE
	MOV r0, #0
	MOV r1, #5
	BL move_ghost

SKIP_GHOST1_MOVE:
	LDR r0, ptr_ghost2_active	; check if pinky is active
	LDRB r1, [r0]
	CMP r1, #1
	BNE SKIP_GHOST2_MOVE
	LDR r0, ptr_ghost2_eaten	; check if eaten
	LDRB r1, [r0]
	CMP r1, #1
	BEQ SKIP_GHOST2_MOVE
	MOV r0, #1		; pinky
	MOV r1, #6
	BL move_ghost

SKIP_GHOST2_MOVE:
	LDR r0, ptr_ghost3_active	; check if inky is active
	LDRB r1, [r0]
	CMP r1, #1
	BNE SKIP_GHOST3_MOVE
	LDR r0, ptr_ghost3_eaten	; check if eaten
	LDRB r1, [r0]
	CMP r1, #1
	BEQ SKIP_GHOST3_MOVE
	MOV r0, #2		; inky
	MOV r1, #7
	BL move_ghost

SKIP_GHOST3_MOVE:
	LDR r0, ptr_ghost4_active	; check if clyde is active
	LDRB r1, [r0]
	CMP r1, #1
	BNE SKIP_GHOST4_MOVE
	LDR r0, ptr_ghost4_eaten	; check if eaten
	LDRB r1, [r0]
	CMP r1, #1
	BEQ SKIP_GHOST4_MOVE
	MOV r0, #3		; clyde
	MOV r1, #8
	BL move_ghost

SKIP_GHOST4_MOVE:
	; load current position and direction
	LDR r0, ptr_pm_x
	LDRB r1, [r0]		; r1 = x
	LDR r0, ptr_pm_y
	LDRB r2, [r0]		; r2 = y
	LDR r0, ptr_dir
	LDRB r3, [r0]		; r3 = dir

	; new position
	MOV r4, r1	; new_x
	MOV r5, r2	; new_y

	; check movement
	CMP r3, #0		; up
	BEQ MOVE_UP
	CMP r3, #1		; left
	BEQ MOVE_LEFT
	CMP r3, #2		; down
	BEQ MOVE_DOWN
	CMP r3, #3		; right
	BEQ MOVE_RIGHT
	B MOVE_DONE

MOVE_UP:
	SUB r5, r5, #1	; y--
	B CHECK_MOVE
MOVE_LEFT:
	SUB r4, r4, #1	; x--
	B CHECK_MOVE
MOVE_DOWN:
	ADD r5, r5, #1	; y++
	B CHECK_MOVE
MOVE_RIGHT:
	ADD r4, r4, #1	; x++

CHECK_MOVE:
	; x < 0, wrap around to x = 27 on y = 16
	CMP r4, #0
	BGE PM_CHECK_X_MAX
	CMP r5, #16
	BNE MOVE_DONE
	MOV r4, #27
	B PM_CHECK_Y

PM_CHECK_X_MAX:
	; x > 27, wrap around to x = 0 on y = 16
	CMP r4, #27
	BLE PM_CHECK_Y
	CMP r5, #16
	BNE MOVE_DONE
	MOV r4, #0

PM_CHECK_Y:
	; check y bounds, should never happen
	CMP r5, #0
	BLT MOVE_DONE
	CMP r5, #32
	BGT MOVE_DONE

	; board index = y * 28 + x
	MOV r6, #28
	MUL r7, r5, r6
	ADD r7, r7, r4

	LDR r8, ptr_board
	ADD r8, r8, r7
	LDRB r9, [r8]

	CMP r9, #0		; wall ?
	BEQ MOVE_DONE	; dont move if wall
	CMP r9, #9		; door ?
	BEQ MOVE_DONE	; dont move if door

	; save old position
	LDR r0, ptr_old_x
	STRB r1, [r0]
	LDR r0, ptr_old_y
	STRB r2, [r0]

	; clear the old tile
	MOV r6, #28
	MUL r7, r2, r6
	ADD r7, r7, r1
	LDR r8, ptr_board
	ADD r8, r8, r7
	MOV r0, #3
	STRB r0, [r8]

	; update pacman position
	LDR r0, ptr_pm_x
	STRB r4, [r0]
	LDR r0, ptr_pm_y
	STRB r5, [r0]

	; save new position
	LDR r0, ptr_new_x
	STRB r4, [r0]
	LDR r0, ptr_new_y
	STRB r5, [r0]

	; write pacman to the board
	MOV r6, #28
	MUL r7, r5, r6
	ADD r7, r7, r4
	LDR r8, ptr_board
	ADD r8, r8, r7
	MOV r0, #4
	STRB r0, [r8]

	; signal redraw instead of drawing inside of interrupt
	LDR r0, ptr_redraw_flag
	MOV r1, #1
	STRB r1, [r0]

	; pellet check
	CMP r9, #1
	BEQ PELLET_CONT
	CMP r9, #2
	BEQ PU_PELLET
	B MOVE_DONE

PELLET_CONT:
	; add 10 to score
	LDR r0, ptr_score
	LDR r1, [r0]
	ADD r1, r1, #10
	STR r1, [r0]

	; increment pellets eaten
	LDR r0, ptr_pellets_eaten
	LDRB r1, [r0]
	ADD r1, r1, #1
	STRB r1, [r0]

	; increment total pellets eaten
	LDR r0, ptr_pellets_total
	LDRB r2, [r0]
	ADD r2, r2, #1
	STRB r2, [r0]

	; check for level complete, 238 normal pellets
	CMP r2, #238
	BNE SKIP_LEVEL_UP
	; set level up flag
	LDR r0, ptr_level_flag
    MOV r3, #1
    STRB r3, [r0]
    ; pause the game
    LDR r0, ptr_pause
    MOV r3, #1
    STRB r3, [r0]
    ; stop the timer
    MOV r0, #0x0000
    MOVT r0, #0x4003
    LDR r3, [r0, #0x00C]
    BIC r3, r3, #0x1
    STR r3, [r0, #0x00C]

    ; skip everything else
    B MOVE_DONE

SKIP_LEVEL_UP:

	; pinky should exit at 30 pellets eaten
	CMP r1, #30
	BLT CHECK_INKY_THRESHOLD
	LDR r0, ptr_ghost2_active
	LDRB r2, [r0]
	CMP r2, #1
	BEQ CHECK_INKY_THRESHOLD
	BL activate_ghost2

CHECK_INKY_THRESHOLD:
	; inky should exit at 60 pellets eaten
	LDR r0, ptr_pellets_eaten
	LDRB r1, [r0]
	CMP r1, #60
	BLT CHECK_CLYDE_THRESHOLD
	LDR r0, ptr_ghost3_active
	LDRB r2, [r0]
	CMP r2, #1
	BEQ CHECK_CLYDE_THRESHOLD
	BL activate_ghost3

CHECK_CLYDE_THRESHOLD:
	; clyde should exit at 90 pellets eaten
	LDR r0, ptr_pellets_eaten
	LDRB r1, [r0]
	CMP r1, #90
	BLT PELLET_DONE
	LDR r0, ptr_ghost4_active
	LDRB r2, [r0]
	CMP r2, #1
	BEQ PELLET_DONE
	BL activate_ghost4

PELLET_DONE:
	; signal score update
	LDR r0, ptr_score_flag
	MOV r1, #1
	STRB r1, [r0]
	B MOVE_DONE

PU_PELLET:
	LDR r0, ptr_state
	MOV r1,#2
	STRB r1, [r0]
	LDR r0, ptr_state_save
	MOV r1, #2
	STRB r1,[r0]

	LDR r0, ptr_powerup_timer
	MOV r1, #60
	STR r1, [r0]
	; increment pellets for powerups
	LDR r0, ptr_pellets_eaten
	LDRB r1,[r0]
	ADD r1,r1, #1
	STRB r1,[r0]
	; led to blue
	MOV r0,#51
	BL illuminate_RGB_LED
	; for ghosts to become W
	LDR r0, ptr_ghost_redraw_flag
	MOV r1, #1
	STRB r1, [r0]

	; reset ghosts eaten count
	LDR r0, ptr_ghosts_eaten_count
	MOV r1, #0
	STRB r1, [r0]

MOVE_DONE:

	POP {r4-r12,lr}  	; Restore registers from stack
	BX lr       	; Return


; ==========================
;  ACTIVATE GHOST 2 - PINKY
; ==========================
activate_ghost2:
	PUSH {r4-r5, lr}

	; move ghost 2 to above ghost door, row 11 col 12

	; clear old position on board
	MOV r0, #28
	MOV r1, #17
	MUL r1, r1, r0
	ADD r1, r1, #13
	LDR r0, ptr_board
	ADD r0, r0, r1
	MOV r1, #3
	STRB r1, [r0]

	; set ghost 2 position to exit position
	MOV r4, #12
	MOV r5, #11
	LDR r0, ptr_ghost2_x
	STRB r4, [r0]
	LDR r0, ptr_ghost2_y
	STRB r5, [r0]
	LDR r0, ptr_ghost2_old_x
	MOV r1, #13
	STRB r1, [r0]
	LDR r0, ptr_ghost2_old_y
	MOV r1, #17
	STRB r1, [r0]
	LDR r0, ptr_ghost2_new_x
	STRB r4, [r0]
	LDR r0, ptr_ghost2_new_y
	STRB r5, [r0]

	; set under ghost to empty path
	LDR r0, ptr_ghost2_under
	MOV r1, #3
	STRB r1, [r0]

	; write pinky tile to exit position
	MOV r0, #28
	MOV r1, #11
	MUL r1, r1, r0
	ADD r1, r1, #12
	LDR r0, ptr_board
	ADD r0, r0, r1
	MOV r1, #6
	STRB r1, [r0]

	; mark pinky as active
	LDR r0, ptr_ghost2_active
	MOV r1, #1
	STRB r1, [r0]

	; signal redraw
	LDR r0, ptr_ghost_redraw_flag
	MOV r1, #1
	STRB r1, [r0]

	POP {r4-r5, lr}
	MOV pc, lr


; =========================
;  ACTIVATE GHOST 3 - INKY
; =========================
activate_ghost3:
	PUSH {r4-r5, lr}

	; move ghost 3 to above ghost door, row 11 col 12

	; clear old position on board
	MOV r0, #28
	MOV r1, #15
	MUL r1, r1, r0
	ADD r1, r1, #12
	LDR r0, ptr_board
	ADD r0, r0, r1
	MOV r1, #3
	STRB r1, [r0]

	; set ghost 3 position to exit position
	MOV r4, #12
	MOV r5, #11
	LDR r0, ptr_ghost3_x
	STRB r4, [r0]
	LDR r0, ptr_ghost3_y
	STRB r5, [r0]
	LDR r0, ptr_ghost3_old_x
	MOV r1, #12
	STRB r1, [r0]
	LDR r0, ptr_ghost3_old_y
	MOV r1, #15
	STRB r1, [r0]
	LDR r0, ptr_ghost3_new_x
	STRB r4, [r0]
	LDR r0, ptr_ghost3_new_y
	STRB r5, [r0]

	; set under ghost to empty path
	LDR r0, ptr_ghost3_under
	MOV r1, #3
	STRB r1, [r0]

	; write inky tile to exit position
	MOV r0, #28
	MOV r1, #11
	MUL r1, r1, r0
	ADD r1, r1, #12
	LDR r0, ptr_board
	ADD r0, r0, r1
	MOV r1, #7
	STRB r1, [r0]

	; mark inky as active
	LDR r0, ptr_ghost3_active
	MOV r1, #1
	STRB r1, [r0]

	; signal redraw
	LDR r0, ptr_ghost_redraw_flag
	MOV r1, #1
	STRB r1, [r0]

	POP {r4-r5, lr}
	MOV pc, lr


; ==========================
;  ACTIVATE GHOST 4 - CLYDE
; ==========================
activate_ghost4:
	PUSH {r4-r5, lr}

	; move ghost 4 to above ghost door, row 11 col 12

	; clear old position on board
	MOV r0, #28
	MOV r1, #16
	MUL r1, r1, r0
	ADD r1, r1, #15
	LDR r0, ptr_board
	ADD r0, r0, r1
	MOV r1, #3
	STRB r1, [r0]

	; set ghost 2 position to exit position
	MOV r4, #12
	MOV r5, #11
	LDR r0, ptr_ghost4_x
	STRB r4, [r0]
	LDR r0, ptr_ghost4_y
	STRB r5, [r0]
	LDR r0, ptr_ghost4_old_x
	MOV r1, #15
	STRB r1, [r0]
	LDR r0, ptr_ghost4_old_y
	MOV r1, #16
	STRB r1, [r0]
	LDR r0, ptr_ghost4_new_x
	STRB r4, [r0]
	LDR r0, ptr_ghost4_new_y
	STRB r5, [r0]

	; set under ghost to empty path
	LDR r0, ptr_ghost4_under
	MOV r1, #3
	STRB r1, [r0]

	; write pinky tile to exit position
	MOV r0, #28
	MOV r1, #11
	MUL r1, r1, r0
	ADD r1, r1, #12
	LDR r0, ptr_board
	ADD r0, r0, r1
	MOV r1, #8
	STRB r1, [r0]

	; mark pinky as active
	LDR r0, ptr_ghost4_active
	MOV r1, #1
	STRB r1, [r0]

	; signal redraw
	LDR r0, ptr_ghost_redraw_flag
	MOV r1, #1
	STRB r1, [r0]

	POP {r4-r5, lr}
	MOV pc, lr


; ============
;  MOVE GHOST
; ============
move_ghost:
	PUSH {r4-r12, lr}

	; r0 = ghost index (0-3)
	; r1 = tile value (5-8)

	MOV r12, r1		; save tile value for later

	; calculate ghost table entry base and push it to the stack
	LSL r2, r0, #5		; index * 32
	LDR r3, ptr_ghost_table
	ADD r2, r2, r3
	PUSH {r2}		; sp contains ghost table entry base address

	; generate prng
	BL xorshift
	MOV r4, r0		; r4 = random number

	; load ghost state from the table
	LDR r2, [sp]
	LDR r0, [r2, #0]		; ptr x
	LDRB r5, [r0]			; r5 = ghost x
	LDR r0, [r2, #4]		; ptr y
	LDRB r6, [r0]			; r6 = ghost y
	LDR r0, [r2, #8]		; ptr dir
	LDRB r7, [r0]			; r7 = ghost dir

	; r2 is now free

	ADD r8, r7, #2
	AND r8, r8, #3			; r8 = reverse dir

	LDR r9, ptr_ghost_valid_dirs
	MOV r10, #0		; valid count
	MOV r11, #0		; direction iterator

MG_SCAN:
	CMP r11, #4
	BGE MG_SCAN_DONE
	CMP r11, r8
	BEQ MG_SCAN_NEXT

	MOV r0, r5		; potential dir x
	MOV r1, r6		; y

	; check direction
	CMP r11, #0
	BEQ MG_SCAN_UP
	CMP r11, #1
	BEQ MG_SCAN_LEFT
	CMP r11, #2
	BEQ MG_SCAN_DOWN
	CMP r11, #3
	BEQ MG_SCAN_RIGHT

MG_SCAN_UP:
	SUB r1, r1, #1
	B MG_SCAN_BOUNDS
MG_SCAN_LEFT:
	SUB r0, r0, #1
	B MG_SCAN_BOUNDS
MG_SCAN_DOWN:
	ADD r1, r1, #1
	B MG_SCAN_BOUNDS
MG_SCAN_RIGHT:
	ADD r0, r0, #1

; check bounds and wrap around
MG_SCAN_BOUNDS:
	CMP r0, #0
	BGE MG_SCAN_CHECK_XMAX
	CMP r1, #16
	BNE MG_SCAN_NEXT
	MOV r0, #27
	B MG_SCAN_CHECK_Y
MG_SCAN_CHECK_XMAX:
	CMP r0, #27
	BLE MG_SCAN_CHECK_Y
	CMP r1, #16
	BNE MG_SCAN_NEXT
	MOV r0, #0
MG_SCAN_CHECK_Y:
	CMP r1, #0
	BLT MG_SCAN_NEXT
	CMP r1, #32
	BGT MG_SCAN_NEXT

	; check tile
	MOV r2, #28
	MUL r2, r1, r2
	ADD r2, r2, r0
	LDR r3, ptr_board
	ADD r3, r3, r2
	LDRB r3, [r3]

	; check for wall and door
	CMP r3, #0
	BEQ MG_SCAN_NEXT
	CMP r3, #9
	BEQ MG_SCAN_NEXT

	; store in valid dirs
	STRB r11, [r9, r10]
	ADD r10, r10, #1	; increment valid count

MG_SCAN_NEXT:
	ADD r11, r11, #1	; increment direction iterator
	B MG_SCAN

MG_SCAN_DONE:
	CMP r10, #0			; no valid dirctions (how?)
	BEQ MG_MOVE_END
	CMP r10, #1			; only one valid direction
	BEQ MG_ONE_DIR

	AND r1, r4, #0xFF	; dividend = lower 8 bits of random
	MOV r0, r10			; divisor = valid directions count
	BL mod				; r0 = choice
	B MG_PICK_DIR

MG_ONE_DIR:
	MOV r0, #0

MG_PICK_DIR:
	LDRB r7, [r9, r0]		; chosen direction

	MOV r0, r5	; x
	MOV r1, r6	; y

	; check what direction was chosen
	CMP r7, #0
	BEQ MG_PICK_UP
	CMP r7, #1
	BEQ MG_PICK_LEFT
	CMP r7, #2
	BEQ MG_PICK_DOWN
	CMP r7, #3
	BEQ MG_PICK_RIGHT

MG_PICK_UP:
	SUB r1, r1, #1
	B MG_PICK_WRAP
MG_PICK_LEFT:
	SUB r0, r0, #1
	B MG_PICK_WRAP
MG_PICK_DOWN:
	ADD r1, r1, #1
	B MG_PICK_WRAP
MG_PICK_RIGHT:
	ADD r0, r0, #1

MG_PICK_WRAP:
	CMP r0, #0
	BGE MG_PICK_CHECK_XMAX
	CMP r1, #16
	BNE MG_PICK_DONE
	MOV r0, #27
	B MG_PICK_DONE
MG_PICK_CHECK_XMAX:
	CMP r0, #27
	BLE MG_PICK_DONE
	CMP r1, #16
	BNE MG_PICK_DONE
	MOV r0, #0

MG_PICK_DONE:
	; r0 = new_x, r1 = new_y, r5 = old_x, r6 = old_y, r7 = new_dir, r12 = tile
	LDR r2, [sp]	; reload table from stack

	; save old position
	LDR r3, [r2, #12]
	STRB r5, [r3]		; old x
	LDR r3, [r2, #16]
	STRB r6, [r3]		; old y

	; restore tile at old position
	LDR r3, [r2, #28]		; ptr under
	LDRB r8, [r3]			; tile under value
	MOV r4, #28
	MUL r9, r6, r4
	ADD r9, r9, r5
	LDR r4, ptr_board
	ADD r4, r4, r9
	STRB r8, [r4]			; restore tile underneath

	; update ghost position and direction
	LDR r3, [r2, #0]
	STRB r0, [r3]		; ghost x = new x
	LDR r3, [r2, #4]
	STRB r1, [r3]		; ghost y = new y
	LDR r3, [r2, #8]
	STRB r7, [r3]		; ghost dir

	; save new position
	LDR r3, [r2, #20]
	STRB r0, [r3]		; new x
	LDR r3, [r2, #24]
	STRB r1, [r3]		; new y

	; save tile under ghost at new pos
	MOV r4, #28
	MUL r9, r1, r4
	ADD r9, r9, r0
	LDR r4, ptr_board
	ADD r4, r4, r9
	LDRB r8, [r4]		; tile at new pos
	CMP r8, #5			; dont save other ghosts underneath
	BLT MG_SAVE_UNDER
	CMP r8, #8
	BGT MG_SAVE_UNDER
	; tile is another ghost, find what under that ghost
	SUB r3, r8, #5			; ghost index from tile value
	LSL r3, r3, #5			; * 32, 32 bytes per table entry
	LDR r8, ptr_ghost_table
	ADD r3, r3, r8			; ghosts base entry in table
	LDR r3, [r3, #28]		; ptr under ghost under
	LDRB r8, [r3]			; tile under ghost under
MG_SAVE_UNDER:
	LDR r3, [r2, #28]	; ptr under
	STRB r8, [r3]

	; write ghost tile
	STRB r12, [r4]

	; signal redraw
	LDR r0, ptr_ghost_redraw_flag
	MOV r1, #1
	STRB r1, [r0]

MG_MOVE_END:
	ADD sp, sp, #4		; pop table entry from stack

	POP {r4-r12, lr}
	MOV pc, lr


; =======================
;  32 BIT XOR SHIFT PRNG
; =======================
xorshift:
	PUSH {r4, lr}

	LDR r4, ptr_xor_in
	LDR r0, [r4]		; load the current start
	LSL r1, r0, #13
	EOR r0, r0, r1		; randum_num ^= randum_num << 13
	LSR r1, r0, #17
	EOR r0, r0, r1		; randum_num ^= randum_num >> 17
	LSL r1, r0, #5
	EOR r0, r0, r1		; randum_num ^= randum_num << 5

	; store new start
	STR r0, [r4]
	; return random num in r0

	POP {r4, lr}
	MOV pc, lr


; =============
;  MOVE CURSOR
; =============
move_cursor:
	PUSH {r4-r5,lr}	; Spill registers to stack

	; r0 = y
	; r1 = x

	MOV r4, r0				; row
	MOV r5, r1				; col

	ADD r4, r4, #1
	ADD r5, r5, #1

	MOV r0, #27				; 'ESC'
	BL output_character
	MOV r0, #91				; '['
	BL output_character

	LDR r0, ptr_cursor_row
	MOV r1, r4				; row
	BL int2str				; convert to ascii
	LDR r0, ptr_cursor_row
	BL output_string

	MOV r0, #59
	BL output_character		; ';'

	LDR r0, ptr_cursor_col
	MOV r1, r5				; col
	BL int2str				; convert to ascii
	LDR r0, ptr_cursor_col
	BL output_string

	MOV r0, #72				; 'H'
	BL output_character

	POP {r4-r5,lr}  	; Restore registers from stack
	MOV pc, lr       	; Return


; ======================
;  DRAW INDIVIDUAL TILE
; ======================
draw_tile:
	PUSH {r4-r8,lr}	; Spill registers to stack

	; r0 = x
	; r1 = y

	MOV r4, r0	; r4 = x
	MOV r5, r1	; r5 = y

	; index of board array = y * 28 + x
	MOV r6, #28
	MUL r7, r5, r6
	ADD r7, r7, r4

	LDR r8, ptr_board
	ADD r8, r8, r7
	LDRB r6, [r8]		; tile

	; move the cursor to the tile
	MOV r0, r5
	MOV r1, r4
	BL move_cursor

	; color
	LDR r1, ptr_lookup_color
	LSL r3, r6, #2
	ADD r1, r1, r3
	LDR r0, [r1]
	BL output_string

	; char
	CMP r6, #5
	BLT normal_charx
	CMP r6, #8
	BGT normal_charx

	LDR r1, ptr_state
	LDRB r3, [r1]
	CMP r3, #2
	BNE normal_charx
	MOV r0, #87		; ascii for W
	BL output_character
	B char_donex
normal_charx:
	LDR r1, ptr_lookup_char
	ADD r1, r1, r6
	LDRB r0, [r1]
	BL output_character
char_donex:

	POP {r4-r8,lr}  	; Restore registers from stack
	MOV pc, lr       	; Return


; =======================
;  SIMPLE READ CHARACTER
; =======================
simple_read_character:
	PUSH {r4, lr}

   MOV r1, #0xC000
   MOVT r1, #0x4000          ; UART0 base

WAIT_RX:
   LDR r2, [r1, #0x018]      ; UARTFR
   AND r2, r2, #0x10          ; RXFE bit
   CMP r2, #0
   BEQ RX_READY
   B WAIT_RX

RX_READY:
   LDRB r0, [r1]     ; read UARTDR

   POP {r4, lr}
	MOV pc, lr	; Return

