/* helloworld.c for TOPPERS/ATK(OSEK) */ 
#include "kernel.h"
//#include "kernel_id.h"
#include "ecrobot_interface.h"

#define PORT NXT_PORT_S3

/* nxtOSEK hook to be invoked from an ISR in category 2 */
void user_1ms_isr_type2(void){ /* do nothing */ }

void ecrobot_device_initialize ()
{
    ecrobot_set_light_sensor_active(PORT);
}

TASK(task1)
{
    int i = 0;
	while(1) {
        if (ecrobot_is_ENTER_button_pressed()) {
            display_clear(0);
            display_goto_xy(0, i++ % 6);
            display_int(ecrobot_get_light_sensor(PORT), 0);
            display_update();
        }
	}
}
