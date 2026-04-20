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


; ==============
;  ANSI STRINGS
; ==============
ansi_black:		.string 27, "[37;40m", 0		; foreground white, background black
ansi_blue:		.string 27, "[37;44m", 0		; foreground white, background blue
ansi_pacman:	.string 27, "[33;44m", 0		; foreground yellow, background blue
ansi_blinky:	.string 27, "[31m", 0			; foreground red
ansi_pinky:		.string 27, "[35m", 0			; foreground magenta
ansi_inky:		.string 27, "[36m", 0			; foreground cyan
ansi_clyde:		.string 27, "[38;5;208m", 0		; foreground orange
ansi_door:		.string 27, "[106m",0			; background bright cyan
remove_cursor:	.string 27, "[?25l", 0
ansi_home:		.string 27, "[H", 0			; moves cursor to top left
ansi_clear:		.string 27, "[2J", 0		; clears the screen


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

cursor_row:		.string "placeholder string", 0
cursor_col:		.string "placeholder string", 0
score_string:	.string "00000000", 0
redraw_flag:	.byte 0x00
score_flag:		.byte 0x00
old_x:			.byte 14
old_y:			.byte 25
new_x:			.byte 0
new_y:			.byte 0
ghost1_x:			.byte 13	; starting position, 0 indexed grid
ghost1_y:			.byte 12
ghost1_dir:			.byte 0		; starts moving up (invalid bc i want first movement right or left to be random)
ghost1_old_x:		.byte 13
ghost1_old_y:		.byte 12
ghost1_new_x:		.byte 0
ghost1_new_y:		.byte 0
ghost_redraw_flag:	.byte 0
ghost_valid_dirs:	.word 0x00000000		; temporary, up to 3 valid directions
xor_in:				.word 0x1AB2BEEF

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
	.global gpio_btn_and_LED_init	; added
	.global int2str					; added
	.global unsigned_division		; added for lab 7 score logic
	.global mod						; added for lab 7 score logic
	.global timer_interrupt_init	; moved to library to keep main file clean
	.global uart_interrupt_init		; moved to library for clean
	.global gpio_interrupt_init		; moved to library for clean
	.global lab7

ptr_prompt:			.word prompt
ptr_lookup_color:	.word lookup_color
ptr_lookup_char:	.word lookup_char
ptr_board:			.word board
ptr_lives:			.word lives
ptr_pm_x:			.word pm_x
ptr_pm_y:			.word pm_y
ptr_score:			.word score
ptr_dir:			.word dir
ptr_pause:			.word pause
ptr_state:			.word state
ptr_cursor_row:		.word cursor_row
ptr_cursor_col:		.word cursor_col
ptr_redraw_flag:	.word redraw_flag
ptr_old_x:			.word old_x
ptr_old_y:			.word old_y
ptr_new_x:			.word new_x
ptr_new_y:			.word new_y
ptr_remove_cursor:	.word remove_cursor
ptr_ansi_home:		.word ansi_home
ptr_ansi_clear:		.word ansi_clear
ptr_ansi_black:		.word ansi_black
ptr_score_flag:		.word score_flag
ptr_score_string:	.word score_string
ptr_ghost1_x:		.word ghost1_x
ptr_ghost1_y:		.word ghost1_y
ptr_ghost1_dir:		.word ghost1_dir
ptr_ghost1_old_x:	.word ghost1_old_x
ptr_ghost1_old_y:	.word ghost1_old_y
ptr_ghost1_new_x:	.word ghost1_new_x
ptr_ghost1_new_y:	.word ghost1_new_y
ptr_ghost_redraw_flag:	.word ghost_redraw_flag
ptr_ghost_valid_dirs:	.word ghost_valid_dirs
ptr_xor_in:			.word xor_in


; check
; -=-=-=-=-=-=- kyle notes -=-=-=-=-=-=-
; bugs/issues:
;	- prng implementation not actually random ?
;		- the ghosts choose the same "random" direction every time you run the game
;		- so the path is always the same because the starting xorshift value is always the same
;		- not sure what to do about this or how to make it different each time
;		- the xorshift start value cannot be hardcoded for true random every game run
;
; next to do:
;	- keep working on ghost movement
;		- save pellets under ghosts movement (rn they turn into empty path)
;		- add wraparound movement for the two ends of the middle row (pacman + ghosts)
;		- implement movement for the other three ghosts
;		- how do the rest of the ghosts leave their home ? preset movement path ?
;		- when do the other three ghosts leave their home ?
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
	; check for redraw
	LDR r0, ptr_redraw_flag
	LDRB r1, [r0]
	CMP r1, #1
	BNE CHECK_SCORE_FLAG

	; clear the redraw flag
	MOV r1, #0
	STRB r1, [r0]

	; redraw
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
	LDR r0, ptr_ghost_redraw_flag
	LDRB r1, [r0]
	CMP r1, #1
	BNE MAIN_LOOP

	MOV r1, #0
	STRB r1, [r0]
	BL update_ghost_tiles

	B MAIN_LOOP

	POP {r4-r12,lr}		; Restore registers to adhere to the AAPCS
	MOV pc, lr


; ====================
;  UPDATE GHOST TILES
; ====================
update_ghost_tiles:
	PUSH {r4-r5, lr}

	; update the old position to match whats in memory
	LDR r0, ptr_ghost1_old_x
	LDRB r4, [r0]
	LDR r0, ptr_ghost1_old_y
	LDRB r5, [r0]
	MOV r0, r4
	MOV r1, r5
	BL draw_tile

	; update the new position to match whats in memory
	LDR r0, ptr_ghost1_new_x
	LDRB r4, [r0]
	LDR r0, ptr_ghost1_new_y
	LDRB r5, [r0]
	MOV r0, r4
	MOV r1, r5
	BL draw_tile

	POP {r4-r5, lr}
	MOV pc, lr


; =============
;  PRINT SCORE
; =============
print_score:
	PUSH {r4-r7,lr}

	; move cursor to score location, starts row 1 col 11
	MOV r0, #1
	MOV r1, #11
	BL move_cursor

	; switch to black bg, white fg
	LDR r0, ptr_ansi_black
	BL output_string

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
	LDR r1, ptr_lookup_char
	ADD r1, r1, r2		; both bytes, so just add base + offset
	LDRB r0, [r1]
	BL output_character

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

	B UART_HANDLER_END

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
	B UART_HANDLER_END

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
	EOR r5, r5, #1		; flip pause flag
	STRB r5, [r4]

	MOV r4, #0x0000
	MOVT r4, #0x4003

	LDR r6, ptr_state

	CMP r5, #1
	BEQ DISABLE_TIMER

	B ENABLE_TIMER

DISABLE_TIMER:
	MOV r7, #0	; set state to paused
	STRB r7, [r6]

	LDR r5, [r4, #0x00C]	; GPTMCTL Offset
	BIC r5, r5, #0x1
	STR r5, [r4, #0x00C]
	B SWITCH_HANDLER_END

ENABLE_TIMER:
	MOV r7, #1	; set state to normal
				; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1
				; needs to be changed to remember state before the game was paused
				; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
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

	; move ghost
	BL move_ghost

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
	B CHECK_MOVE

CHECK_MOVE:
	; bounds check
	CMP r4, #0
	BLT MOVE_DONE
	CMP r4, #27
	BGT MOVE_DONE
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
	; kept entering FaultISR infinite loop, nested BL calls was the problem me thinks idk tho
	LDR r0, ptr_redraw_flag
	MOV r1, #1
	STRB r1, [r0]

	; pellet check
	CMP r9, #1
	BNE MOVE_DONE

	; add 10 to score
	LDR r0, ptr_score
	LDR r1, [r0]
	ADD r1, r1, #10
	STR r1, [r0]

	; signal score update
	LDR r0, ptr_score_flag
	MOV r1, #1
	STRB r1, [r0]

MOVE_DONE:

	POP {r4-r12,lr}  	; Restore registers from stack
	BX lr       	; Return


; ============
;  MOVE GHOST
; ============
move_ghost:
	PUSH {r4-r11, lr}

	; generate pseudo random number
	BL xorshift			; r0 = random
	MOV r4, r0

	; load ghost pos and dir
	LDR r0, ptr_ghost1_x
	LDRB r5, [r0]
	LDR r0, ptr_ghost1_y
	LDRB r6, [r0]
	LDR r0, ptr_ghost1_dir
	LDRB r7, [r0]

	; get reverse direction, dir + 2 (2 bit unsigned addition, so & 3)
	ADD r8, r7, #2
	AND r8, r8, #3		; r8 = reverse dir

	; valid direction scan start
	LDR r9, ptr_ghost_valid_dirs
	MOV r10, #0		; r10 = valid count
	MOV r11, #0		; r11 = direction iterator

GHOST_SCAN:
	CMP r11, #4		; max potential directions is 3
	BGE GHOST_SCAN_DONE

	CMP r11, r8		; ghosts cannot reverse
	BEQ GHOST_SCAN_NEXT

	; compute potential next position
	MOV r1, r5			; r1 = potential x
	MOV r2, r6			; r2 = potential y

	CMP r11, #0
	BEQ GHOST_SCAN_UP
	CMP r11, #1
	BEQ GHOST_SCAN_LEFT
	CMP r11, #2
	BEQ GHOST_SCAN_DOWN
	CMP r11, #3
	BEQ GHOST_SCAN_RIGHT

GHOST_SCAN_UP:
	SUB r2, r2, #1	; up: y--
	B GHOST_SCAN_DIR_END
GHOST_SCAN_LEFT:
	SUB r1, r1, #1	; left: x--
	B GHOST_SCAN_DIR_END
GHOST_SCAN_DOWN:
	ADD r2, r2, #1	; down: y++
	B GHOST_SCAN_DIR_END
GHOST_SCAN_RIGHT:
	ADD r1, r1, #1	; right: x++

GHOST_SCAN_DIR_END:

	; bounds check
	CMP r1, #0
	BLT GHOST_SCAN_NEXT
	CMP r1, #27
	BGT GHOST_SCAN_NEXT
	CMP r2, #0
	BLT GHOST_SCAN_NEXT
	CMP r2, #33
	BGT GHOST_SCAN_NEXT

	; check tile at potential position
	MOV r0, #28
	MUL r3, r2, r0
	ADD r3, r3, r1		; tile in memory = (y*28)+x
	LDR r0, ptr_board
	ADD r0, r0, r3
	LDRB r0, [r0]

	CMP r0, #0		; wall ?
	BEQ GHOST_SCAN_NEXT
	CMP r0, #9		; door ?
	BEQ GHOST_SCAN_NEXT

	; tile is valid, store it
	STRB r11, [r9, r10]
	ADD r10, r10, #1	; increment valid count

GHOST_SCAN_NEXT:
	ADD r11, r11, #1	; increment direction iterator
	B GHOST_SCAN

GHOST_SCAN_DONE:
	CMP r10, #0			; no valid directions (shouldnt ever happen)
	BEQ MOVE_GHOST_END

	; if only one direction, skip random
	CMP r10, #1
	BEQ GHOST_ONE_DIR

	AND r1, r4, #0xFF	; dividend = lower 8 bits of random
	MOV r0, r10			; divisor = valid valid directions count
	BL mod		; r0 = choice
	B GHOST_PICK_DIR

GHOST_ONE_DIR:
	MOV r0, #0

GHOST_PICK_DIR:
	LDRB r7, [r9, r0]	; r7 = chosen direction

	; calculate new position
	MOV r1, r5		; x
	MOV r2, r6		; y

	CMP r7, #0
	BEQ GHOST_PICK_DIR_UP
	CMP r7, #1
	BEQ GHOST_PICK_DIR_LEFT
	CMP r7, #2
	BEQ GHOST_PICK_DIR_DOWN
	CMP r7, #3
	BEQ GHOST_PICK_DIR_RIGHT

GHOST_PICK_DIR_UP:
	SUB r2, r2, #1	; up: y--
	B GHOST_PICK_DIR_DONE
GHOST_PICK_DIR_LEFT:
	SUB r1, r1, #1	; left: x--
	B GHOST_PICK_DIR_DONE
GHOST_PICK_DIR_DOWN:
	ADD r2, r2, #1	; down: y++
	B GHOST_PICK_DIR_DONE
GHOST_PICK_DIR_RIGHT:
	ADD r1, r1, #1	; right: x++

GHOST_PICK_DIR_DONE:

	; save the old position
	LDR r0, ptr_ghost1_old_x
	STRB r5, [r0]
	LDR r0, ptr_ghost1_old_y
	STRB r6, [r0]

	; clear the old tile
	MOV r0, #28
	MUL r3, r6, r0
	ADD r3, r3, r5		; tile in memory = (y*28)+x
	LDR r0, ptr_board
	ADD r0, r0, r3
	MOV r3, #3		; 3 = empty path
	STRB r3, [r0]

	; update ghost position and direction
	LDR r0, ptr_ghost1_x
	STRB r1, [r0]
	LDR r0, ptr_ghost1_y
	STRB r2, [r0]
	LDR r0, ptr_ghost1_dir
	STRB r7, [r0]

	; save new position
	LDR r0, ptr_ghost1_new_x
	STRB r1, [r0]
	LDR r0, ptr_ghost1_new_y
	STRB r2, [r0]

	; write ghost to the board at new position
	MOV r0, #28
	MUL r3, r2, r0
	ADD r3, r3, r1		; tile in memory = (y*28)+x
	LDR r0, ptr_board
	ADD r0, r0, r3
	MOV r3, #5			; 5 = blinky
	STRB r3, [r0]

	; signal ghost redraw
	LDR r0, ptr_ghost_redraw_flag
	MOV r1, #1
	STRB r1, [r0]

MOVE_GHOST_END:

	POP {r4-r11, lr}
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
	LDR r1, ptr_lookup_char
	ADD r1, r1, r6
	LDRB r0, [r1]
	BL output_character

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
