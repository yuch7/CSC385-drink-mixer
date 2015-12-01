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
hsync_timer_ct = r18
curline     = r19
sync_filter = r20

;; constants
HSYNC_FILTER_ON = 0b00000010
HSYNC_FILTER_OFF = ~HSYNC_FILTER_ON
HSYNC_TIMER_PERIOD = 0xFF
HSYNC_TIMER_CT_MAX = 10

VSYNC_FILTER_ON = 0b00000001
VSYNC_FILTER_OFF = ~HSYNC_FILTER_ON
VSYNC_TIMER_PERIOD = 0xFFFF

;; MAIN ;;
main:
    ; initialize the stack pointer for interrupts and such
    ldi tmp, low(RAMEND) ; ram end low
    out SPL, tmp
    ldi tmp, high(RAMEND) ; ram end high bit
    out SPH, tmp 

    ; setup output for port B
    ldi tmp, 0b00000011
    out DDRB, tmp

    ; initialize light & turn on
    ldi sync_filter, 0xff
    out PORTB, sync_filter
 
    ;; configuring the global timer

    ldi tmp, 0b00000010 ; set COM0A1:0 to 10 to cler OC0A on  
    out TCCR0A, tmp     ; compare match, as for COM0B1
    ldi tmp, 0b00000101 ; we set CS02 - CS00 to 101 in TCCR0B to enable
    out TCCR0B, tmp     ; the internal timer 0 with *1024 prescaling
    
    ldi tmp, 0b00000010 ; set COM0A1:0 to 10 to clear OC0B on  
    sts TCCR1A, tmp     ; compare match, as for COM0B1
    ldi tmp, 0b00000101 ; we set CS02 - CS00 to 101 in TCCR0B to enable
    sts TCCR1B, tmp     ; the internal timer 1 with *1024 prescaling

    ldi tmp, HSYNC_TIMER_PERIOD
    out OCR0A, tmp

    ldi tmp, low(VSYNC_TIMER_PERIOD)
    sts OCR1AL, tmp
    ldi tmp, high(VSYNC_TIMER_PERIOD)
    sts OCR1AH, tmp

    ;; enabling interrupts

    ldi tmp, 0b00000010 ; enable timer 1 match A interrupt by
    sts TIMSK1, tmp     ; setting TOIE1 high (vsync)

    ldi tmp, 0b00000010 ; disable timer 0 match A interrupt by
    sts TIMSK0, tmp     ; setting TOIE1 low (hsync) (unecessary)

    sei ; enable interrupts generally


; spin and wait for the magic to happen in interrupts
loop:
    rjmp    loop


;; INTERRUPT HANDLERS ;;
;; increment the count on the hsync_timer_check
;; and go to hsync if we should be hsyncing

vsync:
    ; reset hsync timer count and restart the timer
    ldi hsync_timer_ct, 0
    ldi curline, 0

    ; enable the timer 0 interrupt (hsync interrupt)
    ldi tmp, 0b00000010 
    sts TIMSK0, tmp
 
    out TCNT0, 0 ; reset timer 0  
    out TIFR0, 0 ; clear any queued timer 0 interrupts
 
    br hsync ; go to hsync

check_hsync:
    inc hsync_timer_ct
    
    // if we reach some 
    cmp hsync_timer_ct, HSYNC_TIMER_CT_MAX
    brge hsync
    
    reti

hsync:
    ; turn on the light
    ori sync_filter, HSYNC_FILTER_ON
    out PORTB, sync_filter

    ; stall for some prespecified amount
    for(`i', `0', `100',`
    nop')

    ; turn off the light
    andi sync_filter, HSYNC_FILTER_OFF
    out PORTB, sync_filter
    
    reti

err: 
    reti
