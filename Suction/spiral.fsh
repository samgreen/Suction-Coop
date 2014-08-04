//
//  spiral.fsh
//  Suction
//
//  Created by Sam Green on 8/4/14.
//  Copyright (c) 2014 Sam Green. All rights reserved.
//

void main( void ) {
    vec2 u_aspect = vec2(1.5, 1.5);
    vec2 position = -u_aspect.xy + 2.0 * gl_FragCoord.xy / u_resolution.xy * u_aspect.xy;
    float angle = 0.0 ;
    float radius = length(position);
    if (position.x != 0.0 && position.y != 0.0){
        angle = degrees(atan(position.y, position.x)) ;
    }
    float amod = mod(angle+30.0*u_time-120.0*log(radius), 30.0) ;
    if (amod < 15.0){
        gl_FragColor = vec4( 0.0, 0.0, 0.0, 1.0 );
    } else{
        gl_FragColor = vec4( 1.0, 1.0, 1.0, 1.0 );
    }
}