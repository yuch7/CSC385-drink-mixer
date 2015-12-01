#include "attiny45.h"

int main (int argc, char ** argv) {
    // set pins 0, 1, 2 as output and 3,4 as input
    // 0: motor 0
    // 1: motor 1
    // 2: motor 2
    // 3: input data
    // 4: input clock
    
    ldi tmp, 0b00111
    out DDRB, tmp

    ; set shouldread high
    ldi shouldread, 1
    ldi command_ct, 0

    ldi command, 0b0000
    ldi command_ct, 0
    ldi shouldread, 1

    ldi loop_ct, 0
    ldi last_data, 0

    out PORTB, command
}
