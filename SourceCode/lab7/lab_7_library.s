	.text
	.global uart_init
	.global gpio_btn_and_LED_init
	.global output_character
	.global read_character
	.global read_string
	.global output_string
	.global read_from_push_btns
	.global illuminate_LEDs
	.global illuminate_RGB_LED
	.global read_tiva_push_button
	.global str2int
	.global int2str
	.global unsigned_division
	.global signed_division
	.global mod
	.global timer_interrupt_init
	.global uart_interrupt_init
	.global gpio_interrupt_init

U0FR: 				.equ 0x18  ; UART0 Flag Register
SYSCTL_RCGC_UART:   .equ 0x618 ;
PRUART: 			.equ 0xA18 ;

SYSCTL_RCGC_GPIO:   .equ 0x608 ; Controls & Enables a Clock for Various Components
PRGPIO: 			.equ 0xA08 ; GPIO Peripheral Ready, Indicates whether GPIO Ports are ready after power up

GPIODIR: 			.equ 0x400 ; Data Direction Register
GPIODEN:			.equ 0x51C ; Digital Enable Register
GPIODATA:           .equ 0x3FC ; Data Register
GPIOPUR: 			.equ 0x510 ; Pull-Up Select Register

; =================
;  INITIALIZE UART
; =================

uart_init:
	PUSH {r4-r12,lr} 	; Store any registers in the range of r4 through r12
					; that are used in your routine.  Include lr if this
					; routine calls another routine.

		; Your code for your uart_init routine is placed here

	; Provide clock to UART0
	; (*((volatile uint32_t *)(0x400FE618))) = 1;
	MOV  r4, #0xE618
	MOVT r4, #0x400F
	MOV  r5, #1
	STR  r5, [r4]

WAIT_UART0:
	; Wait for UART0 Power Up
	; while (! (*((volatile uint32_t *)(0x400FEA18))) & 1);
	MOV  r4, #0xEA18
	MOVT r4, #0x400F
	LDR  r5, [r4]
	AND  r5, r5, #1
	CMP  r5, #0
	BEQ  WAIT_UART0

	; Enable clock to PortA
	; (*((volatile uint32_t *)(0x400FE608))) = 1;
	MOV  r4, #0xE608
	MOVT r4, #0x400F
	MOV  r5, #1
	STR  r5, [r4]

	; Disable UART0 Control
	; (*((volatile uint32_t *)(0x4000C030))) = 0;
	MOV  r4, #0xC030
	MOVT r4, #0x4000
	MOV  r5, #0
	STR  r5, [r4]

	; Set UART0_IBRD_R for 115,200 baud
	; (*((volatile uint32_t *)(0x4000C024))) = 8;
	MOV  r4, #0xC024
	MOVT r4, #0x4000
	MOV  r5, #8
	STR  r5, [r4]

	; Set UART0_FBRD_R for 115,200 baud */
	; (*((volatile uint32_t *)(0x4000C028))) = 44;
	MOV  r4, #0xC028
	MOVT r4, #0x4000
	MOV  r5, #44
	STR  r5, [r4]

	; Use System Clock
	; (*((volatile uint32_t *)(0x4000CFC8))) = 0;
	MOV  r4, #0xCFC8
	MOVT r4, #0x4000
	MOV  r5, #0
	STR  r5, [r4]

	; Use 8-bit word length, 1 stop bit, no parity
	; (*((volatile uint32_t *)(0x4000C02C))) = 0x60;
	MOV  r4, #0xC02C
	MOVT r4, #0x4000
	MOV  r5, #0x60
	STR  r5, [r4]

	; Enable UART0 Control
	; (*((volatile uint32_t *)(0x4000C030))) = 0x301;
	MOV  r4, #0xC030
	MOVT r4, #0x4000
	MOV  r5, #0x301
	STR  r5, [r4]

	; Make PA0 and PA1 as Digital Ports
	; (*((volatile uint32_t *)(0x4000451C))) |= 0x03;
	MOV  r4, #0x451C
	MOVT r4, #0x4000
	LDR  r5, [r4]
	ORR  r5, r5, #0x03
	STR  r5, [r4]

	; Change PA0,PA1 to Use an Alternate Function
	; (*((volatile uint32_t *)(0x40004420))) |= 0x03;
	MOV  r4, #0x4420
	MOVT r4, #0x4000
	LDR  r5, [r4]
	ORR  r5, r5, #0x03
	STR  r5, [r4]

	; Configure PA0 and PA1 for UART
	; (*((volatile uint32_t *)(0x4000452C))) |= 0x11;
	MOV  r4, #0x452C
	MOVT r4, #0x4000
	LDR  r5, [r4]
	ORR  r5, r5, #0x11
	STR  r5, [r4]

	POP {r4-r12,lr}   ; Restore registers all registers preserved in the
						; PUSH at the top of this routine from the stack.
	mov pc, lr

; ================================
;  INITIALIZE GPIO BUTTON AND LED
; ================================

gpio_btn_and_LED_init:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here

	; ==============================
	; enable clock for ports B, D, F
	; ==============================

	MOV r4, #0xE000
	MOVT r4, #0x400F		; base address
	LDR r5, [r4, #SYSCTL_RCGC_GPIO]	; + offset
	ORR r5, r5, #0x2A	; set port B, D, F to 1 - B=1, D=3, F=5 (0b00101010 -> 0x2A)
	STR r5, [r4, #SYSCTL_RCGC_GPIO]

	; wait for clock to be enabled
WAIT_CLK:
	;MOV r4, #0xE000			; base address
	;MOVT r4, #0x400F
	LDR r5, [r4, #PRGPIO]	; + offset
	AND r6, r5, #0x2A		; read ports B, D, F
	CMP r6, #0x2A
	BNE WAIT_CLK			; loop until port f is ready

	; ===================================================
	; port B initialize (daughter board LEDs on pins 0-3)
	; ===================================================

	; copy port B base address
	MOV r4, #0x5000
	MOVT r4, #0x4000

	; set direction, all LEDs to 1 for output
	LDR r5, [r4, #GPIODIR] ; + direction register offset
	ORR r5, r5, #0xF		; 0b1111 -> 0xF
	STR r5, [r4, #GPIODIR]

	; enable digital use, all LEDs to 1
	LDR r5, [r4, #GPIODEN] ; + digital enable register offset
	ORR r5, r5, #0xF		; 0b1111 -> 0xF
	STR r5, [r4, #GPIODEN]

	; ===========================================================
	; port D initialize (daughter board push buttons on pins 0-3)
	; ===========================================================

	; copy port D base address
	MOV r4, #0x7000
	MOVT r4, #0x4000

	; set direction, all buttons to 0 for input
	LDR r5, [r4, #GPIODIR] ; + direction register offset
	BIC r5, r5, #0xF		; bit clear (set to 0)
	STR r5, [r4, #GPIODIR]

	; enable digital use, all buttons to 1
	LDR r5, [r4, #GPIODEN] ; + digital enable register offset
	ORR r5, r5, #0xF		; 0b1111 -> 0xF
	STR r5, [r4, #GPIODEN]

	; enable pull-up resistor for buttons
;	LDR r5, [r4, #GPIOPUR] ; + pull-up select offset
;	ORR r5, r5, #0xF
;	STR r5, [r4, #GPIOPUR]

	; ==============================================================
	; port F initialize (Tiva SW1 on pin 4 and RGB LEDs on pins 1-3)
	; ==============================================================

	; copy port F base address
	MOV r4, #0x5000
	MOVT r4, #0x4002

	; set direction, SW1 to 0 for input, LEDs to 1 for output
	LDR r5, [r4, #GPIODIR]
	ORR r5, r5, #0xE		; pins 1-3 to 1 for output (0b1110 -> 0xE)
	BIC r5, r5, #0x10		; pin 4 to 0 for input (0b00010000 -> 0x10)
	STR r5, [r4, #GPIODIR]

	; enable digital use, SW1 and RGB LEDs to 1
	LDR r5, [r4, #GPIODEN]
	ORR r5, r5, #0x1E		; pins 1-4 to 1 (0b00011110 -> 0x1E)
	STR r5, [r4, #GPIODEN]

	; enable pull-up resistor for SW1 (pin 4)
	LDR r5, [r4, #GPIOPUR] ; + pull-up select offset
	ORR r5, r5, #0x10
	STR r5, [r4, #GPIOPUR]

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

; ==================
;  OUTPUT CHARACTER
; ==================

output_character:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here

    MOV r4, #0xC000			; copy lower half of UART data register to r4
	MOVT r4, #0x4000		; copy upper half of UART data register to r4
OUTPUT_LOOP:
	LDRB r5, [r4, #U0FR]	; load contents of UART flag register to r5
	LSR r5, r5, #5			; shift TxFF bit to 0th bit
	AND r5, r5, #0x1		; isolate TxFF bit
	CMP r5, #0				; compare TxFF bit and 0
	BNE OUTPUT_LOOP			; load UART flag register again

	STRB r0, [r4]			; store character from r0 into the data register

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

; ================
;  READ CHARACTER
; ================

read_character:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here

    MOV	 r4, #0xC000		; copy lower half of UART data register to r4
	MOVT r4, #0x4000		; copy upper half of UART data register to r4
READ_LOOP:
	LDRB r5, [r4, #U0FR]	; load contents of UART flag register to r5
	LSR	 r5, r5, #4			; shift RxFE bit to 0th bit
	AND  r5, r5, #0x1		; isolate RxFE bit
	CMP  r5, #0				; compare RxFE bit and 0
	BGT	 READ_LOOP			; load UART flag register again

	LDRB r0, [r4]			; store character from data register into r0

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

; =============
;  READ STRING
; =============

read_string:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here

    	MOV r4, r0			; move pointer to r4

READ_CHAR_LOOP:
	BL read_character	; call read character, returned in r0

	CMP r0, #13			; compare current char with CR
	BEQ DONE_READ_CHAR	; end if current char is CR
	CMP r0, #10			; compare current char with LF
	BEQ DONE_READ_CHAR	; end if current char is LF

	BL output_character	; echo character

	CMP r0, #44			; compare current char with ','
	BEQ READ_CHAR_LOOP	; dont store comma in memory

	STRB r0, [r4]		; store current character in memory
	ADD r4, r4, #1		; increment pointer
	B READ_CHAR_LOOP	; get next character, loop

DONE_READ_CHAR:
	MOV r0, #0			; store null character to r0
	STRB r0, [r4]		; null terminate

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

; ===============
;  OUTPUT STRING
; ===============

output_string:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here

    MOV r4, r0			; move pointer to r4

OUT_STRING_LOOP:
	LDRB r5, [r4]		; load character
	ADD  r4, r4, #1		; increment pointer
	CMP  r5, #0			; compare current character to 0 (null)
	BEQ  DONE_OUT_STRING ; null terminate found, end
	MOV r0, r5
	BL   output_character ; call output character
	B    OUT_STRING_LOOP	; loop again, next char

DONE_OUT_STRING:

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

; ========================
;  READ FROM PUSH BUTTONS
; ========================

read_from_push_btns:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here

	; copy port D base address
	MOV r4, #0x7000
    MOVT r4, #0x4000

    LDR r5, [r4, #GPIODATA]
    MOV r6, #0x0F
    AND r5, r5, r6	; isolate bits 0-3
;  	EOR r5, r5, r6	; flip, low active
    MOV r0, r5

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

; =================
;  ILLUMINATE LEDS
; =================

illuminate_LEDs:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here

    ; copy port B base address
    MOV r4, #0x5000
    MOVT r4, #0x4000

    AND r0, r0, #0x0F
    LDR r5, [r4, #GPIODATA]

    AND r5, r5, #0xF0
    ORR r5, r5, r0

    STR r5, [r4, #GPIODATA]

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

; ====================
;  ILLUMINATE RGB LED
; ====================

illuminate_RGB_LED:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here

    ; copy port F base address
    MOV r4, #0x5000
    MOVT r4, #0x4002

    CMP r0, #49		; ascii '1'
    BEQ RED
    CMP r0, #50		; ascii '2'
    BEQ GREEN
    CMP r0, #51		; ascii '3'
    BEQ BLUE
    CMP r0, #52		; ascii '4'
    BEQ PURPLE
    CMP r0, #53		; ascii '5'
    BEQ YELLOW
    CMP r0, #54		; ascii '6'
    BEQ WHITE
    CMP r0, #48		; ascii '0'

    MOV r5, #0
    B   WRITE

RED:
	MOV r5, #0x2	; 0b0010
	B	WRITE
GREEN:
	MOV r5, #0x8	; 0b1000
	B	WRITE
BLUE:
	MOV r5, #0x4	; 0b0100
	B	WRITE
PURPLE:
	MOV r5, #0x6	; 0b0110
	B	WRITE
YELLOW:
	MOV r5, #0xA	; 0b1010
	B	WRITE
WHITE:
	MOV r5, #0xE	; 0b1110

WRITE:
	LDR r6, [r4, #GPIODATA]
	BIC r6, r6, #0xE
	ORR r6, r6, r5
	STR r6, [r4, #GPIODATA]

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

; =======================
;  READ TIVA PUSH BUTTON
; =======================

read_tiva_push_button:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here

	; port F base address
	MOV r4, #0x5000
	MOVT r4, #0x4002

	LDR r5, [r4, #GPIODATA]
	AND r5, r5, #0x10	; isolate pin 4 (bit 5)
	CMP r5, #0
	BEQ SW_PRESSED		; active low

	MOV r0, #0
	B	SW_DONE

SW_PRESSED:
	MOV r0, #1
SW_DONE:

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

; ===================
;  STRING TO INTEGER
; ===================

str2int:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here

    MOV r4, r0			; initialize the pointer to the start of the string
	MOV r5, #0			; initialize value to 0
	MOV r6, #0			; accumulator for negative check, assuming its + initially

	LDRB r7, [r4]		; get the first character from the string
	CMP r7, #45
	BNE ST_LOOP
	MOV r6, #1			; accumulator for negative check =1
	ADD r4, r4, #1		; pointer += 1 to the next char to skip -

ST_LOOP:
	LDRB r7, [r4]		; get the current character
	CMP r7, #0			; check if its NULL
	BEQ LAST
	CMP r7, #44			; check if its comma
	BEQ STEP			; if yes, branch to step

	SUB r7, r7, #48		; converting ascii to digit
	MOV r8, r5			; temporaryValue = Value
	MOV r9, #9			; initialize the counter to 9

MULTIPLY_LOOP:
	CMP r9, #0
	BEQ ADD_DIGIT
	ADD r5, r5, r8		; value += temporaryvalue
	SUB r9, r9, #1		; decrementing counter
	B MULTIPLY_LOOP

ADD_DIGIT:
	ADD r5, r5, r7		; adding the digit to value

STEP:
	ADD r4, r4, #1 		; incrementing pointer pointer += 1
	B ST_LOOP			; Loop back

LAST:
	CMP r6, #0			; is acc = 0;
	BEQ S2I_END				; END return value
	MOV r0, #0
	SUB r5, r0, r5

S2I_END:
	MOV r0, r5

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

; ===================
;  INTEGER TO STRING
; ===================

int2str:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here

    MOV r4, r0			; copy base pointer to string into r4
	MOV r12, r0			; copy write pointer into r12
	MOV r5, r1			; copy integer value into r5
	MOV r6, #0			; initialize negative flag to 0 in r6
	MOV r7, #0			; initialize digit counter to 0

	CMP r5, #0			; compare integer to 0
	BGE I2S_LOOP		; skip negatve flag if positive

	MOV r6, #1			; set negative flag to 1
	MOV r0, #0			; initialize a register to 0
	SUB r5, r0, r5		; value = 0 - value

I2S_LOOP:
	; quotient = value / 10
	MOV r1, r5			; copy integer to dividend
	MOV r0, #10			; copy 10 to divisor
	BL unsigned_division ; r0 = value / 10
	MOV r8, r0			; copy quotient to r8

	; remainder = value % 10
	MOV r1, r5			; copy integer to quotient
	MOV r0, #10			; copy 10 to divisor
	BL  mod				; r0 = value % 10
	ADD r0, r0, #48		; convert remainder to ascii

	STRB r0, [r12]		; store character in memory
	ADD r12, r12, #1	; increment pointer
	ADD r7, r7, #1		; increment digit counter

	MOV r5, r8			; value = quotient
	CMP r5, #0			; compare new value to 0
	BNE I2S_LOOP		; loop again if value not 0

	CMP r6, #1			; compare negative flag with 0
	BNE I2S_REVERSE_INIT ; branch if negative

	MOV r0, #45			; copy '-' in r0
	STRB r0, [r12]		; store '-' in memory
	ADD r12, r12, #1	; increment pointer
	ADD r7, r7, #1		; increment digit counter

I2S_REVERSE_INIT:
	MOV r10, #0			; initialize start variable to 0
	SUB r11, r7, #1		; initialize end variable to digit counter - 1

I2S_REVERSE_LOOP:
	CMP r10, r11		; compare start and end
	BGE I2S_END			; end if start >= end

	ADD r1, r4, r10		; r1 = start address
	ADD r2, r4, r11		; r2 = end address

	; swap chars at start and end
	LDRB r0, [r1]
	LDRB r3, [r2]
	STRB r3, [r1]
	STRB r0, [r2]

	ADD r10, r10, #1	; increment start
	SUB r11, r11, #1	; decrement end

	B   I2S_REVERSE_LOOP

I2S_END:
	MOV r0, #0
	STRB r0, [r12]		; null terminate

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

; ===================
;  UNSIGNED DIVISION
; ===================

unsigned_division:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here

    MOV r3, #15		; initialize counter to 15
	MOV r4, #0		; initialize quotient to 0
	LSL r0, #15		; logical left shift divisor 15 places
	MOV r5, r1		; initialize remainder to dividend
	B	FIRST_PASS
UNS_LOOP:			; loop for unsigned division
	SUB r3, r3, #1	; decrement counter
FIRST_PASS:
	SUB r5, r5, r0  ; remainder = remainder - divisor
	CMP r5, #0		; compare remainder with 0
	BLT	EXTRA		; remainder < 0
	LSL r4, #1		; logical left shft quotient
	ORR r4, #0x1	; set quotient LSB to 1
UNS_LOOP_END:
	LSR r0, #1		; logical right shift divisor (MSB = 0)
	CMP r3, #0		; compare counter with 0
	BGT UNS_LOOP	; counter > 0, loop again
	B 	UNS_STOP
EXTRA:
	ADD r5, r5, r0	; remainder = remainder + divisor
	LSL r4, #1		; logical left shift quotient
	B	UNS_LOOP_END
UNS_STOP:
	MOV r0, r4		; copy quotient to r0

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

; =================
;  SIGNED DIVISION
; =================

signed_division:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here

    CMP r0, #0		; compare divisor with 0
	BLT FLAG_INIT	; divisor < 0, jump to flag init
	MOV r11, #0		; initialize negative flag to 0
	B	SIGN_ONE	; jump past flag init
FLAG_INIT:
	MOV r11, #1		; initialize negative flag to 1
	MOV r12, #0		; set a register to 0
	SUB r0, r12, r0	; divisor = 0 - divisor
SIGN_ONE:
	CMP r1, #0		; compare dividend with 0
	BLT SIGN_TWO	; dividend < 0, jump to sign two
	B	FLAG_END	; jump to flag end
SIGN_TWO:
	EOR r11, r11, #1; flip negative flag
	MOV r12, #0		; set a register to 0
	SUB r1, r12, r1 ; dividend = 0 - dividend
FLAG_END:
	MOV r4, #0		; initialize quotient to 0

	BL  unsigned_division ; use unsigned_division for magnitude

	CMP r11, #0		; compare negative flag with 0
	BGT NEG_FLAG	; negative flag > 0, ans is negative
	B	SIGN_STOP
NEG_FLAG:
	SUB r0, r12, r0 ; quotient = 0 - quotient
SIGN_STOP:

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

; ===============
;  MODULUS (mod)
; ===============

mod:
	PUSH {r4-r12,lr}	; Spill registers to stack

          ; Your code is placed here

MOD_LOOP:
	SUB r1, r1, r0	; dividend = dividend - divisor
	CMP r1, #0		; compare dividend with 0
	BGT MOD_LOOP	; dividend > 0, loop again
	CMP r1, #0		; compare dividend with 0 (i do not think this is required again)
	BLT ZERO_REM	; dividend < 0, jump to zero rem
	B	MOD_END
ZERO_REM:
	ADD r1, r1, r0	; dividend = dividend + divisor
MOD_END:
	MOV r0, r1

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

; ==========================
; TIMER INTERRUPT INITIALIZE
; ==========================

timer_interrupt_init:
	PUSH {r4-r12,lr}	; Spill registers to stack
	; Your code to initialize the timer interrupt goes here

	; Connect Clock to Timer
	MOV r4, #0xE000
	MOVT r4, #0x400F
	LDR r5, [r4, #0x604]	; RCGCTIMER
	ORR r5, r5, #0x1
	STR r5, [r4, #0x604]

	; wait for clock to be ready
WAIT_TIMER:
	LDR r5, [r4, #0xA04]	; PRTIMER
	AND r5, r5, #0x1
	CMP r5, #0x1
	BNE WAIT_TIMER

	; disable timer during setup
	MOV r4, #0x0000
	MOVT r4, #0x4003
	LDR r5, [r4, #0x00C]	; GPTMCTL Offset
	BIC r5, r5, #0x1
	STR r5, [r4, #0x00C]

	; Put Timer in 32-Bit Mode
	MOV r5, #0
	STR r5, [r4, #0x000]	; GPTMCFG

	; Put Timer in Periodic Mode
	MOV r5, #0x2
	STR r5, [r4, #0x004]	; GPTMTAMR

	; Setup Interval Period
	MOV r5, #0x2400
	MOVT r5, #0x00F4	; 1 sec = 16,000,000 = 0x00F42400
	STR r5, [r4, #0x028]	; GPTMTAILR

	; Enable Timer to Interrupt Processor
	MOV r5, #0x1
	STR r5, [r4, #0x018]	; GPTMIMR

	; Configure Processor to Allow Timer to Interrupt Processor
	MOV r6, #0xE000
	MOVT r6, #0xE000
	LDR r7, [r6, #0x100]	; EN0 Offset
	MOV r8, #0x1
	LSL r8, r8, #19
	ORR r7, r7, r8
	STR r7, [r6, #0x100]

	; Enable Timer
	LDR r5, [r4, #0x00C]	; GPTMCTL Offset
	ORR r5, r5, #0x1
	STR r5, [r4, #0x00C]

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

; =========================
; UART INTERRUPT INITIALIZE
; =========================

uart_interrupt_init:
	PUSH {r4-r12,lr}	; Spill registers to stack
	; Your code to initialize the UART0 interrupt goes here

	; enable UART RX interrupt
    MOV r4,#0xC000
    MOVT r4,#0x4000
    LDR r5,[r4, #0x038]
    ORR r5,r5,#0x10
    STR r5,[r4, #0x038]

    ; en0 enable register
    MOV r4,#0xE100
    MOVT r4,#0xE000
    LDR r5,[r4]
    ORR r5,r5,#0x20
    STR r5, [r4]

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr

; =========================
; GPIO INTERRUPT INITIALIZE
; =========================

gpio_interrupt_init:
	PUSH {r4-r12,lr}	; Spill registers to stack
	; Your code to initialize the SW1 interrupt goes here
	; Don't forget to follow the procedure you followed in Lab #4
	; to initialize SW1.

	; turn the clock on for portF
	MOV r4, #0xE000
	MOVT r4, #0x400F
	LDR r5, [r4,#0x608]
	ORR r5, r5, #0x20	; portF
	STR r5, [r4, #0x608]

GPIO_WAIT_CLK:
	;MOV r4, #0xE000			; base address
	;MOVT r4, #0x400F
	LDR r5, [r4, #0xA08]	; + offset
	;AND r6, r5, #0x2A		; read ports B, D, F
	AND r6, r5, #0x20
	CMP r6, #0x20
	BNE GPIO_WAIT_CLK			; loop until port f is ready

	MOV r4, #0x5000
	MOVT r4, #0x4002

	; set PF4 as input
	LDR r5, [r4, #0x400]      ; GPIODIR
	BIC r5, r5, #0x10
	STR r5, [r4, #0x400]

	; enable digital use
	LDR r5, [r4, #0x51C]      ; GPIODEN
	ORR r5, r5, #0x10
	STR r5, [r4, #0x51C]

	; enable pull-up resistor
	LDR r5, [r4, #0x510]      ; GPIOPUR
	ORR r5, r5, #0x10
	STR r5, [r4, #0x510]

	; nterrupt setup edge-sensitive
	LDR r5, [r4, #0x404]      ; GPIOIS
	BIC r5, r5, #0x10
	STR r5, [r4, #0x404]

	; single edge
	LDR r5, [r4, #0x408]      ; GPIOIBE
	BIC r5, r5, #0x10
	STR r5, [r4, #0x408]

	; falling edge
	LDR r5, [r4, #0x40C]      ; GPIOIEV
	BIC r5, r5, #0x10
	STR r5, [r4, #0x40C]

	; clear prior interrupts
	MOV r5, #0x10
	STR r5, [r4, #0x41C]      ; GPIOICR

	; unmask interrupt
	LDR r5, [r4, #0x410]      ; GPIOIM
	ORR r5, r5, #0x10
	STR r5, [r4, #0x410]

	; EN0
	MOV r5, #0xE100
	MOVT r5, #0xE000
	LDR r6, [r5]
	MOV r7, #1
	LSL r7, r7, #30		; shift to bit 30
	ORR r6, r6, r7
	STR r6, [r5]

	POP {r4-r12,lr}  	; Restore registers from stack
	MOV pc, lr


	.end
