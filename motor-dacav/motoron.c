#include "kernel.h"
#include "ecrobot_interface.h"

DeclareTask(task1);
DeclareCounter(SysTimerCnt);

int phase = 0;

void user_1ms_isr_type2(void)
{
    StatusType ercd;
    ercd = SignalCounter(SysTimerCnt);
    if (ercd != E_OK) {
        ShutdownOS(ercd);
    }
}

void init ()
{
    nxt_motor_set_count(NXT_PORT_A, 0);
    nxt_motor_set_speed(NXT_PORT_A, 80, 1);
    phase ++;
}

TASK(task1)
{
    if (phase == 0) {
        init();
    }

    display_goto_xy(0, phase);
    display_int(nxt_motor_get_count(NXT_PORT_A), 3);

    if (phase >= 10) {
        TerminateTask();
    }
}
