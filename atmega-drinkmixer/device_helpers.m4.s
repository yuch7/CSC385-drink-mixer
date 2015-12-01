include(`macros.m4')
.include "./atmega328.inc"


;; HELPER FUNCTIONS ;;


;; Motors on PortB
; pb0 -> motor 1
; pb1 -> motor 2
; pb2 -> motor 3
.global do_motor_action
do_motor_action:
    ;; get motor id in arg1
    ;; get motor action in arg2

    ; generate motor action filter (0xFF if on, 0x00 if off)
        ldi arg2h, 0
        cp arg2h, arg2l
        breq TURN_MOTOR_OFF

        TURN_MOTOR_ON:
        ldi arg2h, 0xFF
        rjmp GEN_MOTOR_ID_FILTER

        TURN_MOTOR_OFF:
        ldi arg2h, 0x00

    ; generate motor id filter (0b001, 0b010, 0b100)
    GEN_MOTOR_ID_FILTER:
        ldi arg1h, 1
        cp arg1h, arg1l
        breq SELECT_MOTOR_1

        ldi arg1h, 2
        cp arg1h, arg1l
        breq SELECT_MOTOR_2

        ldi arg1h, 3
        cp arg1h, arg1l
        breq SELECT_MOTOR_3

        SELECT_MOTOR_1:
            ldi arg2l, 0b001
            rjmp APPLY_FILTERS

        SELECT_MOTOR_2:
            ldi arg2l, 0b010
            rjmp APPLY_FILTERS

        SELECT_MOTOR_3:
            ldi arg2l, 0b100
            rjmp APPLY_FILTERS

    APPLY_FILTERS:
        and arg2l, arg1l
        out PORTB, arg2l

    ret

; checks the values in the i2c lines
.global get_i2c_status
    ldi arg1h, 0b11111000

    ldi arg4l, TWSR
    and arg4l, arg1h

    ret
