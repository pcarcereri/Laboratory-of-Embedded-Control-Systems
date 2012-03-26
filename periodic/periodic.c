#include "kernel.h"
#include "ecrobot_interface.h"

DeclareTask(task1);
DeclareCounter(SysTimerCnt);
int ctr=0;

void user_1ms_isr_type2(void)
{
    StatusType ercd;
    ercd = SignalCounter(SysTimerCnt);
    if (ercd != E_OK) {
        ShutdownOS(ercd);
    }
}

TASK(task1)
{
    display_clear(0);
    display_goto_xy(0,0);
    display_int(ctr, 3);
    ctr++;
    display_update();
    TerminateTask();
}
