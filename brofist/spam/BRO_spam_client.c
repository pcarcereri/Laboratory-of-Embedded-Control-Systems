#include <stdio.h>
#include "headers/BRO_spam_fists.h"
#include "headers/BRO_spam_client.h"


/*--------------------------------------------------------------------------*/
/* OSEK declarations                                                        */
/*--------------------------------------------------------------------------*/
DeclareCounter(SysTimerCnt);
DeclareResource(lcd);
DeclareTask(BRO_Comm);
DeclareTask(DisplayTask);


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
    ercd = SignalCounter( SysTimerCnt );
    if ( ercd != E_OK || ecrobot_is_ENTER_button_pressed() ) {
        ShutdownOS( ercd );
    }

}

typedef union {
    float f;
    U32 u;
    S32 i;
} value_t;

typedef enum {
    PHASE_START, PHASE_PAUSE, PHASE_RUNNING
} phase_t;

#define MOTOR_PORT NXT_PORT_A
#define INCREMENT 10

struct State {
    phase_t phase;
    int speed;
} State = {
    .phase = PHASE_PAUSE,
    .speed = -100
};

int next_speed (int s)
{
    if (s < -30 || s >= 30) {
        if (s < 100) {
            s += INCREMENT;
        } else {
            s = -100;
        }
    } else if (s == -30) {
        s = 30;
    }

    return s;
}

TASK(RunExperiment)
{
    switch (State.phase) {
        case PHASE_PAUSE:
            nxt_motor_set_count(MOTOR_PORT, 0);
            State.speed = next_speed(State.speed);
            State.phase = PHASE_START;
            break;
        case PHASE_RUNNING:
            State.phase = PHASE_PAUSE;
            break;
        default:
            break;
    }

    TerminateTask();
}

static
void send_data ()
{
    bro_fist_t out[BUFFER_SIZE];

    out[0].data = 1.0f;
    out[1].data = (float) systick_get_ms();
    out[2].data = (float) State.speed;
    out[3].data = (float) nxt_motor_get_count(MOTOR_PORT);

    bt_send((U8 *)out, sizeof(bro_fist_t) * BUFFER_SIZE);
}

static
void send_dummy ()
{
    bro_fist_t out[BUFFER_SIZE];

    out[0].data = 0.0f;

    bt_send((U8 *)out, sizeof(bro_fist_t) * BUFFER_SIZE);
}

TASK(BRO_Comm)
{
    switch (State.phase) {
        case PHASE_PAUSE:
            nxt_motor_set_speed(MOTOR_PORT, 0, 1);
            send_dummy();
            break;
        case PHASE_START:
            nxt_motor_set_speed(MOTOR_PORT, State.speed, 1);
            State.phase = PHASE_RUNNING;
        default:
            send_data();
            break;
    }

    TerminateTask();
}

TASK(DisplayTask)
{
    //ecrobot_status_monitor("BROFist Client");
    char *phase_name;
    int row = 0;

    display_clear(1);
    display_goto_xy(0, row ++);
    display_string("Motor test");

    display_goto_xy(0, row ++);
    display_string("Phase: ");
    switch (State.phase) {
        case PHASE_PAUSE:
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

    display_update();

    TerminateTask();
}
