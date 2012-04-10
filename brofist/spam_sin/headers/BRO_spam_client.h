/** @file BRO_spam_client.h */
#ifndef __bro_headers_spam_client_h
#define __bro_headers_spam_client_h

#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "kernel.h"
#include "kernel_id.h"
#include "ecrobot_interface.h"

#include "../../src/headers/bro_fist.h"

/** @addtogroup BROSClient */
/* @{ */
/*--------------------------------------------------------------------------*/
/* Definitions                                                              */
/*--------------------------------------------------------------------------*/

/*  It's a shame, but it's required to declare on which port are connected the
 *  sonar or the light sensor. It's messy but there are some initialisation that
 *  have to be performed even BEFORE the first packet. XD
 */

/** Ultrasonic Distance Sensor Flag.
 *  Set to @c 1 if connected, @c 0 if not present.
 */
#define CONN_SONAR      1           
/** Ultrasonic Distance Sensor PORT.
 *  Use the standard nxtOSEK port descriptors to tell the system which port
 *  the Sonar is connected to.
 */
#define SONAR_PORT      NXT_PORT_S1

/** Light Sensor Flag.
 *  Set to @c 1 if connected, @c 0 if not present.
 */
#define CONN_LIGHT      1            
/** Ultrasonic Distance Sensor PORT.
 *  Use the standard nxtOSEK port descriptors to tell the system which port
 *  the Sonar is connected to.
 */
#define LIGHT_PORT      NXT_PORT_S2 

/* @} */

#endif
