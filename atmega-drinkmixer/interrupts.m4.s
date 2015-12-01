#include macros.m4
.include "./atmega328.inc"

; aliases
tmp         = r16 ;; temporary working register
tmp2        = r17
light_flash = r19 ;; current status of the light
light_hold  = r20 ;; status of the red light
LIGHT_GREEN = 0b10
LIGHT_RED   = 0b01

;.org 0x00
;jmp main

;.org 0x20
;jmp activate_light

.org 0x00
interrupts_table:
jmp main; 0x0 RESET
jmp err ; 0x2 INT0
jmp err ; 0x4 INT1
jmp err ; 0x6 PCINT0
jmp err ; 0x8 PCINT1
jmp err ; 0xA PCINT2
jmp err ; 0xC WDT
jmp err ; 0xE TIMER2 COMPA
jmp err ; 0x10 TIMER2 COMPB
jmp err ; 0x12 TIMER2 OVF
jmp err ; 0x14 TIMER2CAPT
jmp err ; 0x16 TIMER1 COMPA
jmp err ; 0x18 TIMER1 COMPB
jmp err ; 0x1A TIMER1 OVF
jmp err ; 0x1C TIMER0 COMPA
jmp err ; 0x1E TIMER0 COMPB
jmp activate_light ; 0x20 TIMER0 OVF
jmp err ; SPI / STC
jmp err ; USART, RX
jmp err ; USART, URDE
jmp err ; USART, TX
jmp err ; ADC
jmp err ; EE READY
jmp err ; ANALOG COMP
jmp err ; TWI
jmp err ; SPM READY


err:
    
    reti

;; MAIN ;;
main:
    ; initialize the stack pointer for interrupts and such
    ldi tmp, 0xff; (0xFF & RAMEND) ; ram end low
    out SPL, tmp
    ldi tmp, 0x08;(0xFF & (RAMEND >> 8)) ; ram end high
    out SPH, tmp
    
    ; setup output for port B
    ldi tmp, 0b00000011
    out DDRB, tmp

    ; initialize light & turn on
    ldi light_flash, 0b11;
    out PORTB, light_flash
 

    ;; configuring the global timer

    ldi tmp, 0b00000000 ; TCCR0A deals with output compare mode
    out TCCR0A, tmp     ; for now we ignore this

    ldi tmp, 0b00000101 ; we set CS02 - CS00 to 001 to enable
    out TCCR0B, tmp     ; the internal timer with no prescaling

    ;; enabling interrupts

    ldi tmp, 0b00000001 ; enable timer 0 overflow interrupt by
    sts TIMSK0, tmp     ; setting TOIE0 high
 
    sei ; enable interrupts generally


; spin and wait for the magic to happen in interrupts
loop:
    rjmp    loop


;; INTERRUPT HANDLERS ;;
activate_light:
    ; toggle the flash light
    com light_flash
    andi light_flash, 0b10

    out PORTB, light_flash

    reti
