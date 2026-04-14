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
ansi_blinky:	.string 27, "[31;44m", 0		; foreground red, background blue
ansi_pinky:		.string 27, "[35;44m", 0		; foreground magenta, background blue
ansi_inky:		.string 27, "[36;44m", 0		; foreground cyan, background blue
ansi_clyde:		.string 27, "[38;5;208;44m", 0	; foreground orange, background blue

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
				.word ansi_black		; 0x09 - score digit

lookup_char:	.byte 0x20	; 0x00 - wall = ' '
				.byte 0x2E	; 0x01 - pellet = '.'
				.byte 0x4F	; 0x02 - power pellet = 'O'
				.byte 0x20	; 0x03 - empty path = ' '
				.byte 0x3C	; 0x04 - pacman = '<'
				.byte 0x41	; 0x05 - ghost = 'A'
				.byte 0x41	; 0x06 - ghost = 'A'
				.byte 0x41	; 0x07 - ghost = 'A'
				.byte 0x41	; 0x08 - ghost = 'A'
				.byte 0x30	; 0x09 - score digit = '0'

; ===================
; STARTING GAME BOARD
; ===================
board:
		.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0	; 1
		.byte 0,0,0,0,0,0,0,0,0,0,0,9,9,9,9,9,9,0,0,0,0,0,0,0,0,0,0,0
		.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		.byte 0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0
		.byte 0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0	; 5
		.byte 0,2,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,2,0
		.byte 0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0
		.byte 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0
		.byte 0,1,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,1,0
		.byte 0,1,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,1,0	; 10
		.byte 0,1,1,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1,1,0,0,1,1,1,1,1,1,0
		.byte
		.byte
		.byte
		.byte
		.byte
		.byte
		.byte
		.byte
		.byte


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

	LDR r4, ptr_board
	MOV r5, #10		; 10 rows so far (testing)

row_loop:
	LDR r6, [r4]
	ADD r4, r4, #4

	MOV r7, r6
	BL print_row

	; crlf
	MOV r0, #13
	BL output_character
	MOV r0, #10
	BL output_character

	SUB r5, r5, #1
	CMP r5, #0
	BGT row_loop

	POP {r4-r7,lr}		; Restore registers to adhere to the AAPCS
	MOV pc, lr

; ====================
; PRINT INDIVIDUAL ROW
; ====================

print_row:
	PUSH {r4-r6,lr}   		; Preserve registers to adhere to the AAPCS

row_loop_inner:
	LDRB r0, [r7]
	ADD r7, r7, #1

	CMP r0, #0x00
	BEQ row_done

	CMP r0, #0x10
	BGE handle_color

	B handle_char

handle_color:
	SUB r0, r0, #0x10
	LSL r0, r0, #2

	LDR r1, ptr_lookup_color
	ADD r1, r1, r0
	LDR r0, [r1]

	BL output_string
	B row_loop_inner

handle_char:
	SUB r0, r0, #1
	LDR r1, ptr_lookup_char
	ADD r1, r1, r0
	LDRB r0, [r1]

	BL output_character
	B row_loop_inner

row_done:
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
