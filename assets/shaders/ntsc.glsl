// Sourced from https://www.shadertoy.com/view/XlsczN, with heavy modifications.
uniform float time;
uniform float degradation;
uniform float random;
uniform Image grain_tex;
uniform Image lines_tex;

vec3 rgb2yiq(vec3 c){   
	return vec3(
		(0.2989*c.x + 0.5959*c.y + 0.2115*c.z),
		(0.5870*c.x - 0.2744*c.y - 0.5229*c.z),
		(0.1140*c.x - 0.3216*c.y + 0.3114*c.z)
	);
}

vec3 yiq2rgb(vec3 c){				
	return vec3(
		(1.0*c.x + 1.0*c.y + 1.0*c.z),
		(0.956*c.x - 0.2720*c.y - 1.1060*c.z),
		(0.6210*c.x - 0.6474*c.y + 1.7046*c.z)
	);
}

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

vec2 Circle(float Start, float Points, float Point){
	float Rad = (3.141592 * 2.0 * (1.0 / Points)) * (Point + Start);
	return vec2(-(.3+Rad), cos(Rad));
}

vec3 Blur(vec2 uv, float f, float d, Image texture){
	float t = (sin(time*5.0+uv.y*5.0))/10.0;
    float b = 1.0;
    t=0.0;
    vec2 PixelOffset=vec2(d+.0005*t,0);
    
    float Start = 2.0 / 14.0;
    vec2 Scale = 0.66 * 4.0 * 2.0 * PixelOffset.xy;
    
    vec3 N0 = Texel(texture, uv + Circle(Start, 14.0, 0.0) * Scale).rgb;
    vec3 N1 = Texel(texture, uv + Circle(Start, 14.0, 1.0) * Scale).rgb;
    vec3 N2 = Texel(texture, uv + Circle(Start, 14.0, 2.0) * Scale).rgb;
    vec3 N3 = Texel(texture, uv + Circle(Start, 14.0, 3.0) * Scale).rgb;
    vec3 N4 = Texel(texture, uv + Circle(Start, 14.0, 4.0) * Scale).rgb;
    vec3 N5 = Texel(texture, uv + Circle(Start, 14.0, 5.0) * Scale).rgb;
    vec3 N6 = Texel(texture, uv + Circle(Start, 14.0, 6.0) * Scale).rgb;
    vec3 N7 = Texel(texture, uv + Circle(Start, 14.0, 7.0) * Scale).rgb;
    vec3 N8 = Texel(texture, uv + Circle(Start, 14.0, 8.0) * Scale).rgb;
    vec3 N9 = Texel(texture, uv + Circle(Start, 14.0, 9.0) * Scale).rgb;
    vec3 N10 = Texel(texture, uv + Circle(Start, 14.0, 10.0) * Scale).rgb;
    vec3 N11 = Texel(texture, uv + Circle(Start, 14.0, 11.0) * Scale).rgb;
    vec3 N12 = Texel(texture, uv + Circle(Start, 14.0, 12.0) * Scale).rgb;
    vec3 N13 = Texel(texture, uv + Circle(Start, 14.0, 13.0) * Scale).rgb;
    vec3 N14 = Texel(texture, uv).rgb;
    
    vec4 clr = Texel(texture, uv);
    float W = 1.0 / 15.0;
    
    clr.rgb= 
		(N0 * W) +
		(N1 * W) +
		(N2 * W) +
		(N3 * W) +
		(N4 * W) +
		(N5 * W) +
		(N6 * W) +
		(N7 * W) +
		(N8 * W) +
		(N9 * W) +
		(N10 * W) +
		(N11 * W) +
		(N12 * W) +
		(N13 * W) +
    (N14 * W);
    
   
    return vec3(clr.xyz)*b;
}
        
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords){
    float d = 0.1 * 1.0 / 50.0;
	vec2 uv = texture_coords;

    float s = 0.5+(random/16)+((degradation/3)*random)/4;
    float t = (Texel(lines_tex, vec2(uv.x, (uv.y/2)+(random/2))).r * (degradation/4));
    float u = Texel(grain_tex,vec2(0.01+(uv.y*32.0)/32.0,mod(time * 10.0, mod(time * 10.0, 256.0) * (1.0 / 256.0)))).r;
   
    float e = min(0.30, pow(max(0.0, cos((1.0 - uv.y) * 4.0 + 0.3) - 0.75) * (s + 0.5) * 1.0, 3.0)) * 25.0;
	s-=pow(0.5+(random/16)+((degradation/3)*random)/4,1.0);
	uv.x += (0.015*degradation/3)-abs(u * 0.03*(degradation/3));
    float r = Texel(grain_tex, vec2(mod(time * 10.0, mod(time * 10.0, 256.0) * (1.0 / 256.0)), 0.0)).r * (2.0 * ((degradation/3)*random));
    uv.x += abs(r * pow(max(0.003, (uv.y - 0.95) + (u*0.5*degradation/3)) * 2.0, 2.0));
    
    d = 0.051 + abs(sin(s / 4.0));
    float c = max(0.0001, 0.002 * d);
    color.xyz = Blur(uv, 0.0, c + c * (uv.x), texture);
    float y = rgb2yiq(color.xyz).r;
    
	uv.x += .01 * d;
    c *= 6.0;
    color.xyz = Blur(uv, 0.333, c, texture);
    float i = rgb2yiq(color.xyz).g;
	
    uv.x += 0.005 * d;
	
    c *= 2.50;
    color.xyz = Blur(uv, 0.666, c, texture);
    float q = rgb2yiq(color.xyz).b;
    
    color.xyz = yiq2rgb(vec3(y, i, q)) - pow(s + e * 2.0, 3.0);
	color.xyz = rgb2hsv(color.xyz);
	color.y += degradation/4;
	color.xyz = hsv2rgb(color.xyz);
    color.xyz = mix(color.xyz, vec3(dot(color.xyz, vec3(.5, .5, .5))), t);
    color.xyz *= smoothstep(1.0, 0.999, uv.x - 0.1);
    
    return color;
}