#ifndef _M328PDEF_INC_

    #define low(x)   ((x) & 0xFF)
    #define high(x)   (((x)>>8) & 0xFF)

    #define _M328PDEF_INC_
    #pragma partinc 0

    r1 = 1
    r2 = 2
    r3 = 3
    r4 = 4
    r5 = 5
    r6 = 6
    r7 = 7
    r8 = 8
    r9 = 9
    r10 = 10
    r11 = 11
    r12 = 12
    r13 = 13
    r14 = 14
    r15 = 15
    r16 = 16
    r17 = 17
    r18 = 18
    r19 = 19
    r20 = 20
    r21 = 21
    r22 = 22
    r23 = 23
    r24 = 24
    r25 = 25
    r26 = 26
    r27 = 27
    r28 = 28
    r29 = 29
    r30 = 30
    r31 = 31
    r32 = 32

    Xh = r27
    Xl = r26
    Yh = r29
    Yl = r28
    Zh = r31
    Zl = r30

    arg1l = r18
    arg1h = r19
    arg2l = r20
    arg2h = r21
    arg3l = r22
    arg3h = r23
    arg4l = r24
    arg4h = r25


    #pragma AVRPART ADMIN PART_NAME ATmega328P
    SIGNATURE_000   = 0x1e
    SIGNATURE_001   = 0x95
    SIGNATURE_002   = 0x0f

    #pragma AVRPART CORE CORE_VERSION V2E


    ; ***** I/O REGISTER DEFINITIONS *****************************************
    ; NOTE:
    ; Definitions marked "MEMORY MAPPED"are extended I/O ports
    ; and cannot be used with IN/OUT instructions
    UDR0    = 0xc6  ; MEMORY MAPPED
    UBRR0L  = 0xc4  ; MEMORY MAPPED
    UBRR0H  = 0xc5  ; MEMORY MAPPED
    UCSR0C  = 0xc2  ; MEMORY MAPPED
    UCSR0B  = 0xc1  ; MEMORY MAPPED
    UCSR0A  = 0xc0  ; MEMORY MAPPED
    TWAMR   = 0xbd  ; MEMORY MAPPED
    TWCR    = 0xbc  ; MEMORY MAPPED
    TWDR    = 0xbb  ; MEMORY MAPPED
    TWAR    = 0xba  ; MEMORY MAPPED
    TWSR    = 0xb9  ; MEMORY MAPPED
    TWBR    = 0xb8  ; MEMORY MAPPED
    ASSR    = 0xb6  ; MEMORY MAPPED
    OCR2B   = 0xb4  ; MEMORY MAPPED
    OCR2A   = 0xb3  ; MEMORY MAPPED
    TCNT2   = 0xb2  ; MEMORY MAPPED
    TCCR2B  = 0xb1  ; MEMORY MAPPED
    TCCR2A  = 0xb0  ; MEMORY MAPPED
    OCR1BL  = 0x8a  ; MEMORY MAPPED
    OCR1BH  = 0x8b  ; MEMORY MAPPED
    OCR1AL  = 0x88  ; MEMORY MAPPED
    OCR1AH  = 0x89  ; MEMORY MAPPED
    ICR1L   = 0x86  ; MEMORY MAPPED
    ICR1H   = 0x87  ; MEMORY MAPPED
    TCNT1L  = 0x84  ; MEMORY MAPPED
    TCNT1H  = 0x85  ; MEMORY MAPPED
    TCCR1C  = 0x82  ; MEMORY MAPPED
    TCCR1B  = 0x81  ; MEMORY MAPPED
    TCCR1A  = 0x80  ; MEMORY MAPPED
    DIDR1   = 0x7f  ; MEMORY MAPPED
    DIDR0   = 0x7e  ; MEMORY MAPPED
    ADMUX   = 0x7c  ; MEMORY MAPPED
    ADCSRB  = 0x7b  ; MEMORY MAPPED
    ADCSRA  = 0x7a  ; MEMORY MAPPED
    ADCH    = 0x79  ; MEMORY MAPPED
    ADCL    = 0x78  ; MEMORY MAPPED
    TIMSK2  = 0x70  ; MEMORY MAPPED
    TIMSK1  = 0x6f  ; MEMORY MAPPED
    TIMSK0  = 0x6e  ; MEMORY MAPPED
    PCMSK1  = 0x6c  ; MEMORY MAPPED
    PCMSK2  = 0x6d  ; MEMORY MAPPED
    PCMSK0  = 0x6b  ; MEMORY MAPPED
    EICRA   = 0x69  ; MEMORY MAPPED
    PCICR   = 0x68  ; MEMORY MAPPED
    OSCCAL  = 0x66  ; MEMORY MAPPED
    PRR = 0x64  ; MEMORY MAPPED
        PRTIM0 = 5;
    CLKPR   = 0x61  ; MEMORY MAPPED
    WDTCSR  = 0x60  ; MEMORY MAPPED
    SREG    = 0x3f
    SPL = 0x3d
    SPH = 0x3e
    SPMCSR  = 0x37
    MCUCR   = 0x35
    MCUSR   = 0x34
    SMCR    = 0x33
    ACSR    = 0x30
    SPDR    = 0x2e
    SPSR    = 0x2d
    SPCR    = 0x2c
    GPIOR2  = 0x2b
    GPIOR1  = 0x2a
    OCR0B   = 0x28
    OCR0A   = 0x27
    TCNT0   = 0x26
    TCCR0B  = 0x25
    TCCR0A  = 0x24
    GTCCR   = 0x23
    EEARH   = 0x22
    EEARL   = 0x21
    EEDR    = 0x20
    EECR    = 0x1f
    GPIOR0  = 0x1e
    EIMSK   = 0x1d
    EIFR    = 0x1c
    PCIFR   = 0x1b
    TIFR2   = 0x17
    TIFR1   = 0x16
    TIFR0   = 0x15
    PORTD   = 0x0b
    DDRD    = 0x0a
    PIND    = 0x09
    PORTC   = 0x08
    DDRC    = 0x07
    PINC    = 0x06
    PORTB   = 0x05
    DDRB    = 0x04
    PINB    = 0x03


    ; ***** BIT DEFINITIONS **************************************************

    ; ***** USART0 ***********************
    ; UDR0 - USART I/O Data Register
    UDR0_0  = 0 ; USART I/O Data Register bit 0
    UDR0_1  = 1 ; USART I/O Data Register bit 1
    UDR0_2  = 2 ; USART I/O Data Register bit 2
    UDR0_3  = 3 ; USART I/O Data Register bit 3
    UDR0_4  = 4 ; USART I/O Data Register bit 4
    UDR0_5  = 5 ; USART I/O Data Register bit 5
    UDR0_6  = 6 ; USART I/O Data Register bit 6
    UDR0_7  = 7 ; USART I/O Data Register bit 7

    ; UCSR0A - USART Control and Status Register A
    MPCM0   = 0 ; Multi-processor Communication Mode
    U2X0    = 1 ; Double the USART transmission speed
    UPE0    = 2 ; Parity Error
    DOR0    = 3 ; Data overRun
    FE0 = 4 ; Framing Error
    UDRE0   = 5 ; USART Data Register Empty
    TXC0    = 6 ; USART Transmitt Complete
    RXC0    = 7 ; USART Receive Complete

    ; UCSR0B - USART Control and Status Register B
    TXB80   = 0 ; Transmit Data Bit 8
    RXB80   = 1 ; Receive Data Bit 8
    UCSZ02  = 2 ; Character Size
    TXEN0   = 3 ; Transmitter Enable
    RXEN0   = 4 ; Receiver Enable
    UDRIE0  = 5 ; USART Data register Empty Interrupt Enable
    TXCIE0  = 6 ; TX Complete Interrupt Enable
    RXCIE0  = 7 ; RX Complete Interrupt Enable

    ; UCSR0C - USART Control and Status Register C
    UCPOL0  = 0 ; Clock Polarity
    UCSZ00  = 1 ; Character Size
    UCPHA0  = UCSZ00    ; For compatibility
    UCSZ01  = 2 ; Character Size
    UDORD0  = UCSZ01    ; For compatibility
    USBS0   = 3 ; Stop Bit Select
    UPM00   = 4 ; Parity Mode Bit 0
    UPM01   = 5 ; Parity Mode Bit 1
    UMSEL00 = 6 ; USART Mode Select
    UMSEL0  = UMSEL00   ; For compatibility
    UMSEL01 = 7 ; USART Mode Select
    UMSEL1  = UMSEL01   ; For compatibility

    ; UBRR0H - USART Baud Rate Register High Byte
    UBRR8   = 0 ; USART Baud Rate Register bit 8
    UBRR9   = 1 ; USART Baud Rate Register bit 9
    UBRR10  = 2 ; USART Baud Rate Register bit 10
    UBRR11  = 3 ; USART Baud Rate Register bit 11

    ; UBRR0L - USART Baud Rate Register Low Byte
    _UBRR0  = 0 ; USART Baud Rate Register bit 0
    _UBRR1  = 1 ; USART Baud Rate Register bit 1
    UBRR2   = 2 ; USART Baud Rate Register bit 2
    UBRR3   = 3 ; USART Baud Rate Register bit 3
    UBRR4   = 4 ; USART Baud Rate Register bit 4
    UBRR5   = 5 ; USART Baud Rate Register bit 5
    UBRR6   = 6 ; USART Baud Rate Register bit 6
    UBRR7   = 7 ; USART Baud Rate Register bit 7


    ; ***** TWI **************************
    ; TWAMR - TWI (Slave) Address Mask Register
    TWAM0   = 1 ; 
    TWAMR0  = TWAM0 ; For compatibility
    TWAM1   = 2 ; 
    TWAMR1  = TWAM1 ; For compatibility
    TWAM2   = 3 ; 
    TWAMR2  = TWAM2 ; For compatibility
    TWAM3   = 4 ; 
    TWAMR3  = TWAM3 ; For compatibility
    TWAM4   = 5 ; 
    TWAMR4  = TWAM4 ; For compatibility
    TWAM5   = 6 ; 
    TWAMR5  = TWAM5 ; For compatibility
    TWAM6   = 7 ; 
    TWAMR6  = TWAM6 ; For compatibility

    ; TWBR - TWI Bit Rate register
    TWBR0   = 0 ; 
    TWBR1   = 1 ; 
    TWBR2   = 2 ; 
    TWBR3   = 3 ; 
    TWBR4   = 4 ; 
    TWBR5   = 5 ; 
    TWBR6   = 6 ; 
    TWBR7   = 7 ; 

    ; TWCR - TWI Control Register
    TWIE    = 0 ; TWI Interrupt Enable
    TWEN    = 2 ; TWI Enable Bit
    TWWC    = 3 ; TWI Write Collition Flag
    TWSTO   = 4 ; TWI Stop Condition Bit
    TWSTA   = 5 ; TWI Start Condition Bit
    TWEA    = 6 ; TWI Enable Acknowledge Bit
    TWINT   = 7 ; TWI Interrupt Flag

    ; TWSR - TWI Status Register
    TWPS0   = 0 ; TWI Prescaler
    TWPS1   = 1 ; TWI Prescaler
    TWS3    = 3 ; TWI Status
    TWS4    = 4 ; TWI Status
    TWS5    = 5 ; TWI Status
    TWS6    = 6 ; TWI Status
    TWS7    = 7 ; TWI Status

    ; TWDR - TWI Data register
    TWD0    = 0 ; TWI Data Register Bit 0
    TWD1    = 1 ; TWI Data Register Bit 1
    TWD2    = 2 ; TWI Data Register Bit 2
    TWD3    = 3 ; TWI Data Register Bit 3
    TWD4    = 4 ; TWI Data Register Bit 4
    TWD5    = 5 ; TWI Data Register Bit 5
    TWD6    = 6 ; TWI Data Register Bit 6
    TWD7    = 7 ; TWI Data Register Bit 7

    ; TWAR - TWI (Slave) Address register
    TWGCE   = 0 ; TWI General Call Recognition Enable Bit
    TWA0    = 1 ; TWI (Slave) Address register Bit 0
    TWA1    = 2 ; TWI (Slave) Address register Bit 1
    TWA2    = 3 ; TWI (Slave) Address register Bit 2
    TWA3    = 4 ; TWI (Slave) Address register Bit 3
    TWA4    = 5 ; TWI (Slave) Address register Bit 4
    TWA5    = 6 ; TWI (Slave) Address register Bit 5
    TWA6    = 7 ; TWI (Slave) Address register Bit 6


    ; ***** TIMER_COUNTER_1 **************
    ; TIMSK1 - Timer/Counter Interrupt Mask Register
    TOIE1   = 0 ; Timer/Counter1 Overflow Interrupt Enable
    OCIE1A  = 1 ; Timer/Counter1 Output CompareA Match Interrupt Enable
    OCIE1B  = 2 ; Timer/Counter1 Output CompareB Match Interrupt Enable
    ICIE1   = 5 ; Timer/Counter1 Input Capture Interrupt Enable

    
    ; missing constants cribbed from avr/io.h

    SPM_PAGESIZE = 128
    RAMSTART     = (0x100)
    RAMEND       = 0x8FF
    XRAMSIZE     = 0
    XRAMEND      = RAMEND
    E2END        = 0x3FF
    E2PAGESIZE   = 4
    FLASHEND     = 0x7FFF


