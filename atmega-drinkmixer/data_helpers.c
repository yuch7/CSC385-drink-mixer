
#define LEN_MOTORBUFFER 5

unsigned int cur_motor = 0;
typedef struct motor_action{
    char motorid;     // 1..3, 0 for NULL
    char motoraction; // 0 or 1 (OFF / ON)
    char remainingcycles; // counter of remaining cycles to do    
} motor_action;

motor_action motor_buffer[LEN_MOTORBUFFER] = {
    {1, 1, 0},
    {0, 0, 100},
    {0, 0, 0},
    {0, 0, 0},
    {0, 0, 0},
};


// declared in scheduler.m4.s
void do_motor_action(char remaining, char motoraction);

// takes whether or not to decrement the timer ct until this action
// and then executes the motor action
void interp_motor_action(char timer_cycle_passed) {
    // if the motor is NULL (0), exit
    if (timer_cycle_passed == 0) return;
    if (motor_buffer[cur_motor].motoraction == 0) return;

    // if a timer cycle passed, decrement
    if (timer_cycle_passed != 0)
        motor_buffer[cur_motor].remainingcycles--;
    
    if (motor_buffer[cur_motor].remainingcycles == 0) {
        do_motor_action(
            motor_buffer[cur_motor].remainingcycles,
            motor_buffer[cur_motor].motoraction);
        cur_motor++;
    }
}


void query_i2c() {
    // we're already in slave / recipient mode, so we just switch
    // on handling the possible states
    char status = get_i2c_status();
    switch(status) {
        default:return
    }
}
