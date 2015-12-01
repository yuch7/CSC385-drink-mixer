; include m4 macros include(macros.m4)
.include "./atmega328.inc"

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
jmp toggle_l2 ; 0x16 TIMER1 COMPA
jmp err ; 0x18 TIMER1 COMPB
jmp err ; 0x1A TIMER1 OVF
jmp toggle_l1 ; 0x1C TIMER0 COMPA
jmp err ; 0x1E TIMER0 COMPB
jmp err ; 0x20 TIMER0 OVF
jmp err ; SPI / STC
jmp err ; USART, RX
jmp err ; USART, URDE
jmp err ; USART, TX
jmp err ; ADC
jmp err ; EE READY
jmp err ; ANALOG COMP
jmp err ; TWI
jmp err ; SPM READY


;; register assignments
tmp         = r16 ;; temporary working register
tmp2        = r17
counter     = r18
light_1     = r19 ;; current status of the light
light_2     = r20 ;; status of the red light


;; MAIN ;;
main:
    ; initialize the stack pointer for interrupts and such
    ldi tmp, 0xff; low(RAMEND) ; ram end low
    out SPL, tmp
    ldi tmp, 0x08; high(RAMEND) ; ram end high bit
    out SPH, tmp 

    ; setup output for port B
    ldi tmp, 0b00000011
    out DDRB, tmp

    ; initialize light & turn on
    ldi light_1, 0b11
    ldi light_2, 0b11
    out PORTB, light_1
 
    ;; configuring the global timer

    ldi tmp, 0b00000010 ; set COM0A1:0 to 10 to cler OC0A on  
    out TCCR0A, tmp     ; compare match, as for COM0B1
    ldi tmp, 0b00000101 ; we set CS02 - CS00 to 101 in TCCR0B to enable
    out TCCR0B, tmp     ; the internal timer 0 with *1024 prescaling
    
    ldi tmp, 0b00000010 ; set COM0A1:0 to 10 to clear OC0B on  
    sts TCCR1A, tmp     ; compare match, as for COM0B1
    ldi tmp, 0b00000101 ; we set CS02 - CS00 to 101 in TCCR0B to enable
    sts TCCR1B, tmp     ; the internal timer 1 with *1024 prescaling

    ldi tmp, 0xAA
    out OCR0A, tmp

    ldi tmp, 0xF0
    sts OCR1AH, tmp
    ldi tmp, 0x00
    sts OCR1AL, tmp

    ;; enabling interrupts

    ldi tmp, 0b00000010 ; enable timer 0 match A interrupt by
    sts TIMSK0, tmp     ; setting TOIE1 high
    ldi tmp, 0b00000010 ; enable timer 0 match A interrupt by
    sts TIMSK1, tmp     ; setting TOIE1 high
    
    sei ; enable interrupts generally


; spin and wait for the magic to happen in interrupts
loop:
    rjmp    loop


;; INTERRUPT HANDLERS ;;
toggle_l1:
    com light_1
    jmp disp_in_interrupt
    
toggle_l2:
    com light_2
    jmp disp_in_interrupt

disp_in_interrupt:
    mov tmp, light_1;
    andi tmp, 0b01

    mov tmp2, light_2
    andi tmp2, 0b10

    or tmp, tmp2
    out PORTB, tmp
    reti


err: 
    reti
