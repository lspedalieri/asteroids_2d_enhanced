shader_type canvas_item;

uniform float grid_speed = 1.0;
uniform float quota = 4.0;
//uniform vec4 MOUSE = vec4(0,0,0,0);

float sun(vec2 uv, float battery)
{
 	float val = smoothstep(0.5, 0.49, length(uv));
 	float bloom = smoothstep(0.7, 0.0, length(uv));
    float cut = 3.0 * sin((uv.y - TIME * 0.02 * (battery + 0.02)) * 100.0) 
				+ clamp(uv.y * 14.0 + 2.0, -6.0, 6.0);
    cut = clamp(cut, 0.0, 1.0);
    return clamp(val * cut, 0.0, 1.0) + bloom * 0.6;
}

float grid(vec2 uv, float battery, float speed)
{
    vec2 size = vec2(uv.y, uv.y * uv.y * 0.2) * 0.01;
    uv += vec2(0.0, TIME * speed * (battery + 0.05));
    uv = abs(fract(uv) - 0.5);
 	vec2 lines = smoothstep(size, vec2(0.0), uv);
 	lines += smoothstep(size * 15.0, vec2(0.0), uv) * 0.2 * battery;
    return clamp(lines.x + lines.y, 0.0, 3.0);
}

float dot2(in vec2 v ) { return dot(v,v); }

float sdLine( in vec2 p, in vec2 a, in vec2 b )
{
    vec2 pa = p-a, ba = b-a;
    float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
    return length( pa - ba*h );
}

float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,vec2(0))) + min(max(d.x,d.y),0.0);
}

float opSmoothUnion(float d1, float d2, float k){
	float h = clamp(0.5 + 0.5 * (d2 - d1) /k,0.0,1.0);
    return mix(d2, d1 , h) - k * h * ( 1.0 - h);
}


void fragment()
{
    vec2 uv = (2.0 * FRAGCOORD.xy - (1.0/SCREEN_PIXEL_SIZE).xy)/(1.0/SCREEN_PIXEL_SIZE).y;
    float battery = 1.0;

	//Proporzioni schermo    
    //if (abs(uv.x) < (9.0 / 16.0))
    {
        // Grid
        float fog = smoothstep(0.1, -0.02, abs(uv.y + 0.2));
        vec3 col = vec3(0.0, 0.1, 0.2);
        if (uv.y < -0.2)
        {
            uv.y = quota / (abs(uv.y + 0.2) + 0.05);
            uv.x *= uv.y * 1.0;
            float gridVal = grid(uv, battery, grid_speed);
            col = mix(col, vec3(1.0, 0.5, 1.0), gridVal);
        }else{
            float fujiD = min(uv.y * 4.5 - 0.5, 1.0);
            uv.y -= battery * 1.1 - 0.51;
            
            vec2 sunUV = uv;
            vec2 fujiUV = uv;
            
            // Sun
            sunUV += vec2(0., 0.7);
            //uv.y -= 1.1 - 0.51;
            col = vec3(1.0, 0.3, 0.0);
            float sunVal = sun(sunUV, battery);
            
            col = mix(col, vec3(1.0, 0.4, 0.1), sunUV.y * 2.0 + 0.2);
            col = mix(vec3(0.0, 0.0, 0.0), col, sunVal);
            
        }

        col += fog * fog * fog;
        col = mix(vec3(col.r, col.r, col.r) * 0.5, col, battery * 0.7);

        COLOR = vec4(col, 1.0);
    }

}