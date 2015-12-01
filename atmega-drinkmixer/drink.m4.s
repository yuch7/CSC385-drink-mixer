.include "./attiny45.inc"

; aliases
tmp        = r16
tmp2       = r17
inp_data   = r18
shouldread = r19
command    = r20
command_ct = r21
loop_ct = r22
last_data = r23
waiting_on_command = r24

STABLE_LOOP_AMT = 0b01111111

.org 0x00
rjmp    main

main:
    ; set pins 0, 1, 2 as output and 3,4 as input
    ; 0: motor 0
    ; 1: motor 1
    ; 2: motor 2
    ; 3: input data
    ; 4: input clock
    
    ldi tmp, 0b00111
    out DDRB, tmp

    ; initialize state
    ldi shouldread, 1
    ldi command, 0b0000
    ldi command_ct, 0
    ldi waiting_on_command, 1

	ldi loop_ct, 0
	ldi last_data, 0

	out PORTB, command

; while the command is zero
COLLECT_I2C:
	CLOCK_DENOISE:
        ; get data into inp_data
        in inp_data, PINB
        lsr inp_data
        lsr inp_data
        lsr inp_data
		andi inp_data, 0b11

		; if the input has not stabilized, reset ct and resample
		cp last_data, inp_data
		brne RESET_CLOCK
		inc loop_ct

		ldi tmp2, STABLE_LOOP_AMT
		cp loop_ct, tmp2
		brge CLOCK_SPLIT

		rjmp CLOCK_DENOISE

	RESET_CLOCK:
		mov last_data, inp_data
		ldi loop_ct, 0
		rjmp CLOCK_DENOISE

	CLOCK_SPLIT:
		ldi loop_ct, 0
		ldi tmp, 0
		mov tmp2, last_data
		lsr tmp2
		cp tmp2, tmp
		breq CLOCK_LOW
		rjmp CLOCK_HIGH
		
	CLOCK_LOW:
        ; get the clock state into tmp
        mov tmp, inp_data
        lsr tmp

        ; set shouldread high
		ldi shouldread, 1

        ; continue looping
        rjmp CLOCK_DENOISE ; loop while clock is low

    CLOCK_HIGH: 
        ; if we have not seen zero, since last loop, continue looping
        ldi tmp2, 0
        cp tmp2, shouldread
        breq CLOCK_DENOISE

        ; we have already read this clock cycle
        ldi shouldread, 0

        ; pull the data line out the input data 
        andi inp_data, 0b01

        ; if we are currently waiting for a 1 to start a command,
        ; and this data is 1, start said command
        tst waiting_on_command
        breq COLLECT_COMMAND
        tst inp_data
        breq CLOCK_DENOISE

        ldi waiting_on_command, 0

        COLLECT_COMMAND:
        ; add it as the least significant bit of the command
        lsl command
        or command, inp_data
        ; out PORTB, command
        inc command_ct

        ; if we have read 4 digits, fall through to interpret command
        ldi tmp, 4
        cp command_ct, tmp
        brlt CLOCK_DENOISE

    INTERP_COMMAND:
        ;; output value of command
        out PORTB, command

        ; reset command
        ldi command_ct, 0
        ldi command, 0
        ldi waiting_on_command, 1
        
        rjmp COLLECT_I2C ; return to waiting
