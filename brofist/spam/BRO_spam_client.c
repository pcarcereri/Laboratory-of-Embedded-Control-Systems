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
    if ( ercd != E_OK ) {
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

struct State {
    phase_t phase;
    int speed;
} State = {
    .phase = PHASE_PAUSE,
    .speed = 0
};

#define MOTOR_PORT NXT_PORT_A
#define INCREMENT 10

TASK(RunExperiment)
{
    phase_t p = State.phase;
    int s = State.speed;

    switch (p) {
        case PHASE_PAUSE:
            if (s < 100) {
                nxt_motor_set_count(MOTOR_PORT, 0);
                s += INCREMENT;
                p = PHASE_START;
            } else {
                ShutdownOS(E_OK);
            }
            break;
        case PHASE_RUNNING:
            p = PHASE_PAUSE;
            break;
        default:
            break;
    }

    State.phase = p;
    State.speed = s;

    TerminateTask();
}

TASK(BRO_Comm)
{
    bro_fist_t out[BUFFER_SIZE];
    value_t tstamp;
    value_t power;
    value_t tacho;

    switch (State.phase) {
        case PHASE_PAUSE:
            nxt_motor_set_speed(MOTOR_PORT, 0, 1);
            TerminateTask();
        case PHASE_START:
            State.phase = PHASE_RUNNING;
        default:
            break;
    }

    tstamp.u = systick_get_ms();
    power.i = State.speed;
    tacho.i = nxt_motor_get_count(MOTOR_PORT);

    memset(out, 0, sizeof(out));

    out[0].data = tstamp.f;
    out[1].data = power.f;
    out[2].data = tacho.f;

    bt_send((U8 *)out, sizeof(out));

    TerminateTask();
}

TASK(DisplayTask)
{
    ecrobot_status_monitor("BROFist Client");
    TerminateTask();
}
