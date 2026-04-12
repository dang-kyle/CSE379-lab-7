; ============
; GLOBAL STUFF
; ============

	.data

	.global prompt
	.global mydata
	.global datahalf
	.global dataword

prompt:			.string "placeholder", 0
databyte:		.byte 0x00
datahalf:		.half 0x0000
dataword:		.word 0x00000000

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
	.global timer_interrupt_init	; moved to library to keep main file clean
	.global uart_interrupt_init		; moved to library for clean
	.global gpio_interrupt_init		; moved to library for clean
	.global lab7

ptr_prompt:		.word prompt
ptr_databyte:	.word databyte
ptr_datahalf:	.word datahalf
ptr_dataword:	.word dataword

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



MAIN_END:

	POP {r4-r12,lr}		; Restore registers to adhere to the AAPCS
	MOV pc, lr

; ======================
; UART INTERRUPT HANDLER
; ======================

UART0_Handler:
	PUSH {r4-r12,lr}	; Spill registers to stack
	; Your code for your UART handler goes here.
	; Remember to preserver registers r4-r12 by pushing then popping
	; them to & from the stack at the beginning & end of the handler

	BL simple_read_character



UART_HANDLER_END:
	; clear UART interrupt
    MOV r4,#0xC044
    MOVT r4,#0x4000
    MOV r5,#0x10
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
	MOV r4,#0x5000
    MOVT r4,#0x4002
    MOV r5,#0x10
    STR r5,[r4,#0x41C]

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
