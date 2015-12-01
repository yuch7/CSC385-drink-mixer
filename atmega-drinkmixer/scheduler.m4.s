include(`macros.m4')
.include "./atmega328.inc"

.section .absolute

.org 0x00

;; PROGRAM STATICS, STORED AT RAM START ;;

interrupts_table:
jmp main; 0x0 RESET
jmp noint ; 0x2 INT0
jmp noint ; 0x4 INT1
jmp noint ; 0x6 PCINT0
jmp noint ; 0x8 PCINT1
jmp noint ; 0xA PCINT2
jmp noint ; 0xC WDT
jmp noint ; 0xE TIMER2 COMPA
jmp noint ; 0x10 TIMER2 COMPB
jmp noint ; 0x12 TIMER2 OVF
jmp noint ; 0x14 TIMER2CAPT
jmp noint ; 0x16 TIMER1 COMPA
jmp noint ; 0x18 TIMER1 COMPB
jmp noint ; 0x1A TIMER1 OVF
jmp SCHEDULER ; 0x1C TIMER0 COMPA
jmp noint ; 0x1E TIMER0 COMPB
jmp noint ; 0x20 TIMER0 OVF
jmp noint ; SPI / STC
jmp noint ; USART, RX
jmp noint ; USART, URDE
jmp noint ; USART, TX
jmp noint ; ADC
jmp noint ; EE READY
jmp noint ; ANALOG COMP
jmp noint ; TWI
jmp noint ; SPM READY


TASKLIST_OFFSET = 0x400
.org TASKLIST_OFFSET

;; TASK LIST ;;

;; initial memory of each task ;;
; struct task {
;   addr to resume at
;   scheduler cycles since last execution
;   maximum execution period in scheduler cycles
;   cache of r5-r25
; }
; priority determined by order in list

NUM_TASKS = 2
TASK_SIZE = 25
TASK_LIST: 
    ;; task MOTOR_ACTION
    .word MOTOR_ACTION
    .short 0
    .short 1
    .skip 22

    ;; task QUERY_ISP
    .word QUERY_ISP
    .short 0
    .short 5
    .skip 22

TASK_addrlow      = 0
TASK_addrhigh     = 1
TASK_cyclecounter = 2
TASK_maxcycles    = 3
TASK_registers    = 4








;; PROGRAM LOGIC ;;
.section text

noint:
    reti

;; reserved scheduler registers
curtask = r16
stmp1   = r17
stmp2   = r18

tmp = r16 ;; temporary working register

TWI_slaveAddress = 2

;; MAIN ;;
main:
    ;; initialize the stack pointer
    ldi tmp, low(RAMEND)
    out SPL, tmp
    ldi tmp, high(RAMEND)
    out SPH, tmp

    ;; initialize as i2c slave (TODO)
    ldi arg1l, (TWI_slaveAddress<<TWI_ADR_BITS) | (1<<TWI_GEN_BIT)
    call TWI_Slave_Initialise

    ;; configure the global timer

    ldi tmp, 0b00000000 ; TCCR0A deals with output compare mode
    out TCCR0A, tmp     ; for now we ignore this

    ldi tmp, 0b00000101 ; we set CS02 - CS00 to 001 to enable
    out TCCR0B, tmp     ; the internal timer with no prescaling

    ;; configure port B for all output
    ldi tmp, 0b11111111
    out DDRB, tmp

    ;; enable interrupts

    ldi tmp, 0b00000001 ; enable timer 0 overflow intnointupt by
    sts TIMSK0, tmp     ; setting TOIE0 high

    ldi tmp, 0b10       ; configure external interrupt 0
    sts EICRA, tmp           ; to trigger on falling edge

    ldi tmp, 0b01       ; enable external interrupt 0
    sts EIMSK, tmp     ; for the panic/stop button
 
    ldi tmp, 0b01
    out PORTB, tmp

    sei ; enable interrupts generally


; spin and wait for the magic to happen in interrupts
spin:
    rjmp    spin


;; TASKS ;;


SCHEDULER:
    ; get offset to current task into r1:r0
    mov stmp1, curtask
    ldi stmp2, TASK_SIZE
    mul stmp1, stmp2

    ; add that to the task list locatiom, store in pointer Y
    ldi Yl, low(TASKLIST_OFFSET)
    ldi Yh, high(TASKLIST_OFFSET)
    add Yl, r0
    adc Yh, r1

    ; pop return address from the stack, write to task's 
    ; "resume" address
    pop stmp1
    std Y+TASK_addrlow, stmp1
    pop stmp1
    std Y+TASK_addrhigh, stmp1

    ; reset time since last execution
    ldi stmp1, 0
    std Y+1, stmp1

    ; cache all program space registers
    std Y+(TASK_registers + 0),  r5
    std Y+(TASK_registers + 1),  r6
    std Y+(TASK_registers + 2),  r7
    std Y+(TASK_registers + 3),  r8
    std Y+(TASK_registers + 4),  r9
    std Y+(TASK_registers + 5),  r10
    std Y+(TASK_registers + 6),  r11
    std Y+(TASK_registers + 7),  r12
    std Y+(TASK_registers + 8),  r13
    std Y+(TASK_registers + 9),  r14
    std Y+(TASK_registers + 1),  r15
    std Y+(TASK_registers + 11), r16
    std Y+(TASK_registers + 12), r17
    std Y+(TASK_registers + 13), r18
    std Y+(TASK_registers + 14), r19
    std Y+(TASK_registers + 15), r20
    std Y+(TASK_registers + 16), r21
    std Y+(TASK_registers + 17), r22
    std Y+(TASK_registers + 18), r23
    std Y+(TASK_registers + 19), r24
    std Y+(TASK_registers + 20), r25


    ; step to the next task, zero if we walk past list
    inc curtask
    cpi curtask, NUM_TASKS
    brlt start_next_task
    ldi curtask, 0

    start_next_task:

    ; get the offset to the new task
    mov stmp1, curtask
    ldi stmp2, TASK_SIZE
    mul stmp1, stmp2

    ; add that to the task list locatiom, store in pointer Y
    ldi Yl, low(TASKLIST_OFFSET)
    ldi Yh, high(TASKLIST_OFFSET)
    add Yl, stmp2
    adc Yh, r0

    ; push that to the stack as the new return address and return
    push Yh
    push Yl
    reti


MOTOR_ACTION:
    ; only store 1 MOTOR_ACTION at a time
    ; if a timer1 cycle has been completed, turn off the 
    ; notification bit & decrement MOTOR_CYCLES
    call interp_motor_action

    jmp MOTOR_ACTION

QUERY_ISP:
    jmp QUERY_ISP
