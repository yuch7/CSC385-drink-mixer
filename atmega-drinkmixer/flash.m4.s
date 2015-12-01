.include "./attiny45.inc"

; aliases
tmp        = r16
tmp2       = r17
inp_data   = r18
shouldread = r19
command    = r20
command_ct = r21


.section .text
.org 0x00
rjmp    main

.global main
main:
    ; set pins 0, 1, 2 as output and 3,4 as input
    ; 0: motor 0
    ; 1: motor 1
    ; 2: motor 2
    ; 3: input data
    ; 4: input clock
    
    ldi tmp, 0b111
    out DDRB, tmp

    ; set shouldread high
    ldi shouldread, 1
    ldi command_ct, 0

    ldi command, 0b0000
    ldi command_ct, 0
    ldi shouldread, 1

    ldi tmp, 0b111
    out PORTB, tmp

; while the command is zero
COLLECT_I2C:
    CLOCK_LOW:
        ; get data into inp_data
        in inp_data, PORTB
        lsr inp_data
        lsr inp_data
        lsr inp_data

        ; get the clock state into tmp
        mov tmp, inp_data
        lsr tmp

        ; set shouldread high if the clock state is zero
        mov tmp2, tmp
        com tmp2
        and tmp2, 1
        or shouldread, tmp2
 
        ; if we have not seen zero, continue looping
        mov tmp2, 0
        cpi tmp2, shouldread
        breq CLOCK_LOW

        ; if the clock is low, continue looping
        cpi tmp2, tmp
        breq CLOCK_LOW ; loop while clock is low

    CLOCK_HIGH:
        ; we have already read this clock cycle
        ldi shouldread, 0

        ; pull the data line out the input data 
        andi inp_data, 0b01

        ; add it as the least significant bit of the thing
        lsr command
        or command, inp_data
        inc command_ct

        ; if we have read 4 digits, fall through to interpret command
        ldi tmp, 4
        cpi command_ct, tmp
        brlt CLOCK_LOW

    INTERP_COMMAND:
        ;; output value of command
        out PORTB, command

        ; reset command
        ldi command_ct, 0
        ldi command, 0
        
        rjmp COLLECT_I2C ; return to waiting
