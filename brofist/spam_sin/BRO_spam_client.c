#include <stdio.h>
#include <math.h>

#include "headers/BRO_spam_fists.h"
#include "headers/BRO_spam_client.h"


/*--------------------------------------------------------------------------*/
/* OSEK declarations                                                        */
/*--------------------------------------------------------------------------*/
DeclareCounter(SysTimer);
DeclareResource(lcd);
DeclareTask(Experiment);
DeclareTask(Display);
DeclareTask(Sample);

/*--------------------------------------------------------------------------*/
/* LEJOS OSEK hooks                                                         */
/*--------------------------------------------------------------------------*/
void ecrobot_device_initialize()
{
    ecrobot_init_bt_slave("1234");

    if (CONN_SONAR) {
        ecrobot_init_sonar_sensor(SONAR_PORT);
    };
    if (CONN_LIGHT) {
        ecrobot_set_light_sensor_active(LIGHT_PORT);
    };
}

void ecrobot_device_terminate()
{

    nxt_motor_set_speed(NXT_PORT_A, 0, 1);
    nxt_motor_set_speed(NXT_PORT_B, 0, 1);
    nxt_motor_set_speed(NXT_PORT_C, 0, 1);

    ecrobot_set_light_sensor_inactive(LIGHT_PORT);
    ecrobot_term_sonar_sensor(SONAR_PORT);

    bt_reset();

    ecrobot_term_bt_connection();
}

/*--------------------------------------------------------------------------*/
/* Function to be invoked from a category 2 interrupt                       */
/*--------------------------------------------------------------------------*/

void user_1ms_isr_type2(void)
{
    StatusType ercd;

    /*
     *  Increment OSEK Alarm System Timer Count
    */
    ercd = SignalCounter( SysTimer );
    if ( ercd != E_OK || ecrobot_is_ENTER_button_pressed() ) {
        ShutdownOS( ercd );
    }

}

#define MOTOR_PORT NXT_PORT_A

typedef enum {
    PHASE_START = 0,
    PHASE_IDLE,
    PHASE_RUNNING
} phase_t;

struct {
    phase_t phase;
    S32 speed;
    U32 period;
    U32 start_time;
    int budget;
} State = {
    .phase = PHASE_START,
    .speed = -100,
    .period = 10000     // ms
};

static
void update_motors ()
{
    float P;
    U32 now_relative;

    now_relative = systick_get_ms() - State.start_time;
    P = State.speed * sinf(now_relative * 2 * M_PI / State.period);
    nxt_motor_set_speed(MOTOR_PORT, (int)P, 1);
}

static
void update_parameters ()
{
    if (State.period == 1000) {
        State.period = 10000;
    } else {
        State.period -= 1000;
        return;
    }

    switch (State.speed) {
        case -30:
            State.speed = 30;
            break;
        case 100:
            State.speed = -100;
            break;
        default:
            State.speed += 10;
    }
}

TASK(Sample)
{
    bro_fist_t out[BUFFER_SIZE];

    out[0].data = 0.0f;
    if (State.phase == PHASE_RUNNING) {
        out[0].data = 1.0f;
        out[1].data = (float) systick_get_ms() - State.start_time;
        out[2].data = (float) State.speed;
        out[3].data = (float) State.period;     // ms
        out[4].data = (float) nxt_motor_get_count(MOTOR_PORT);
        update_motors();
    }
    bt_send((U8 *)out, sizeof(bro_fist_t) * BUFFER_SIZE);

    TerminateTask();
}

TASK(Display)
{
    char *phase_name;
    int row = 0;

    display_clear(1);
    display_goto_xy(0, row ++);
    display_string("Motor test sin");

    display_goto_xy(0, row ++);
    display_string("Phase: ");
    switch (State.phase) {
        case PHASE_IDLE:
            phase_name = "Pause";
            break;
        case PHASE_START:
            phase_name = "Start";
            break;
        case PHASE_RUNNING:
            phase_name = "Running";
            break;
        default:
            phase_name = "WTF?";
    }
    display_string(phase_name);

    display_goto_xy(0, row ++);
    display_string("Speed: ");
    display_int(State.speed, 3);

    display_goto_xy(0, row ++);
    display_string("Period: ");
    display_int(State.period / 1000, 3);

    display_update();

    TerminateTask();
}

TASK(Experiment)
{
    switch (State.phase) {
        case PHASE_IDLE:
            update_parameters();
        case PHASE_START:
            State.budget = 4;
            State.phase = PHASE_RUNNING;
            nxt_motor_set_count(MOTOR_PORT, 0);
            State.start_time = systick_get_ms();
            break;
        case PHASE_RUNNING:
            if (State.budget -- == 0) {
                State.phase = PHASE_IDLE;
                nxt_motor_set_speed(MOTOR_PORT, 0, 1);
            }
    }

    TerminateTask();
}

