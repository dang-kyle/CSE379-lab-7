; ============
; GLOBAL STUFF
; ============

	.data

	.global prompt
	.global mydata
	.global datahalf
	.global dataword
	.global lookup_color
	.global lookup_char
	.global row1
	.global row2
	.global row3
	.global row4
	.global row5
	.global row6
	.global row7
	.global row8
	.global row9
	.global row10
	.global board

; ============
; ANSI STRINGS
; ============

ansi_black:		.string 27, "[37;40m", 0		; foreground white, background black
ansi_blue:		.string 27, "[37;44m", 0		; foreground white, background blue
ansi_pacman:	.string 27, "[33;44m", 0		; foreground yellow, background blue
ansi_blinky:	.string 27, "[31m", 0			; foreground red
ansi_pinky:		.string 27, "[35m", 0			; foreground magenta
ansi_inky:		.string 27, "[36m", 0			; foreground cyan
ansi_clyde:		.string 27, "[38;5;208m", 0		; foreground orange
ansi_door:		.string 27, "[106m",0			; background bright cyan

; =============
; LOOKUP TABLES
; =============

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

; ===================
; STARTING GAME BOARD
; ===================
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
databyte:		.byte 0x00
datahalf:		.half 0x0000
dataword:		.word 0x00000000

	.text

	.global UART0_Handler			; updated for lab 7
	.global Switch_Handler			; updated for lab 7
	.global Timer_Handler			; updated for lab 7
;	.global simple_read_character	; read_character modified for interrupts
	.global output_character		; This is from your Lab #4 Library
	.global read_string				; This is from your Lab #4 Library
	.global output_string			; This is from your Lab #4 Library
	.global uart_init				; This is from your Lab #4 Library
	.global read_character			; added
	.global illuminate_RGB_LED		; added
	.global gpio_btn_and_LED_init	; added
	.global int2str					; added
	.global timer_interrupt_init	; moved to library to keep main file clean
	.global uart_interrupt_init		; moved to library for clean
	.global gpio_interrupt_init		; moved to library for clean
	.global lab7

ptr_prompt:			.word prompt
ptr_databyte:		.word databyte
ptr_datahalf:		.word datahalf
ptr_dataword:		.word dataword
ptr_lookup_color:	.word lookup_color
ptr_lookup_char:	.word lookup_char
ptr_board:			.word board

; ==========
; LAB 7 MAIN
; ==========

lab7:								; This is your main routine which is called from your C wrapper.
	PUSH {r4-r12,lr}   		; Preserve registers to adhere to the AAPCS

 	bl uart_init
 	bl gpio_btn_and_LED_init
	bl uart_interrupt_init
	bl gpio_interrupt_init

	; game code start below here

	BL print_board

MAIN_END:

	POP {r4-r12,lr}		; Restore registers to adhere to the AAPCS
	MOV pc, lr

; ==================
; PRINT ENTIRE BOARD
; ==================

print_board:
	PUSH {r4-r7,lr}   		; Preserve registers to adhere to the AAPCS

	LDR r4, ptr_board	; board base address
	MOV r5, #33		; 10 rows

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

; =====================
; PRINT INDIVIDUAL ROWS
; =====================

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

; ======================
; UART INTERRUPT HANDLER
; ======================

UART0_Handler:
	PUSH {r4-r12,lr}	; Spill registers to stack
	; Your code for your UART handler goes here.
	; Remember to preserver registers r4-r12 by pushing then popping
	; them to & from the stack at the beginning & end of the handler

	BL read_character



UART_HANDLER_END:
	; clear UART interrupt
    MOV r4, #0xC044
    MOVT r4, #0x4000
    MOV r5, #0x10
    STR r5,[r4]

	POP {r4-r12,lr}  	; Restore registers from stack
	BX lr       	; Return

; ========================
; SWITCH INTERRUPT HANDLER
; ========================

Switch_Handler:
	PUSH {r4-r12,lr}	; Spill registers to stack
	; Your code for your UART handler goes here.
	; Remember to preserver registers r4-r12 by pushing then popping
	; them to & from the stack at the beginning & end of the handler



SWITCH_HANDLER_END:
    ; clear interrupt
	MOV r4, #0x5000
    MOVT r4, #0x4002
    MOV r5, #0x10
    STR r5, [r4, #0x41C]

	POP {r4-r12,lr}  	; Restore registers from stack
	BX lr       	; Return

; =======================
; TIMER INTERRUPT HANDLER
; =======================

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
	LDR r5, [r4, #0x024]
	ORR r5, r5, #1
	STR r5, [r4, #0x024]



TIMER_HANDLER_END:

	POP {r4-r12,lr}  	; Restore registers from stack
	BX lr       	; Return
