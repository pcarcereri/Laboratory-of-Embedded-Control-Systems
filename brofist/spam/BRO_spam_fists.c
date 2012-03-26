#include "headers/BRO_spam_fists.h"


static void
decode_bro_port (U8 in_port, U8 * out_port)
{
    switch (in_port) {
        case MOTOR_A:
            *out_port = NXT_PORT_A;
            break;
        case MOTOR_B:
            *out_port = NXT_PORT_B;
            break;
        case MOTOR_C:
            *out_port = NXT_PORT_C;
            break;
        
        case PORT_1:
            *out_port = NXT_PORT_S1;
            break;
        case PORT_2:
            *out_port = NXT_PORT_S2;
            break;
        case PORT_3:
            *out_port = NXT_PORT_S3;
            break;
        case PORT_4:
            *out_port = NXT_PORT_S4;
            break;
        default:    //  Only for future upgrades
            break;
    };
}

//  :3 Listen, here we will write the function that will decode only ONE order and will return some data, IF it's a sensors packet...
static void
decode_bro_input (const bro_fist_t * input_packet, bro_fist_t * output_packet)
{
    U8 temp_port;
    
    output_packet->port = input_packet->port;
    output_packet->operation = input_packet->operation;
    
    switch (input_packet->operation) {
        case LIGHT_SENSOR:
            decode_bro_port (input_packet->port, &temp_port);
            output_packet->data = (float) ecrobot_get_light_sensor(temp_port);
            break;
            
        case TOUCH_SENSOR:
            decode_bro_port (input_packet->port, &temp_port);
            output_packet->data = (float) ecrobot_get_touch_sensor(temp_port);
            break;
            
        case SOUND_SENSOR:
            decode_bro_port (input_packet->port, &temp_port);
            output_packet->data = (float) ecrobot_get_sound_sensor(temp_port);
            break;
            
        case RADAR_SENSOR:
            decode_bro_port (input_packet->port, &temp_port);
            output_packet->data = (float) ecrobot_get_sonar_sensor(temp_port);
            break;
            
        case TACHO_COUNT:
            decode_bro_port (input_packet->port, &temp_port);
            output_packet->data = (float) nxt_motor_get_count(temp_port);
            break;
            
        default:
            //Nothing HERE
            break;
    };
}


//  Function to decode a LIST of FISTS and do things accordingly... :3 
void decode_bro_fists (const bro_fist_t * orders, bro_fist_t * response)
{
    int i;
    
    for (i = 0; i < BUFFER_SIZE; i ++) {
        decode_bro_input (&orders[i], &response[i]);    
    };
};
