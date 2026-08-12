uniform vec2 texel;
uniform vec3 watercol;
uniform float timer;
uniform float frequency;
uniform float amp;

vec4 effect(vec4 drawcolor, Image texture, vec2 texture_coords, vec2 screen_coords)
{
	vec2 coord = texture_coords;
	coord.x = coord.x + (sin(timer/30.0 + coord.y/(texel.y*frequency)) * texel.x * 1.0) * amp ;
    vec4 outcolor = drawcolor * Texel( texture, coord );
	vec3 mixcol = vec3(0.0);
	mixcol = mix(outcolor.rgb, watercol,0.7);
    return vec4(mixcol.r,mixcol.g,mixcol.b,outcolor.a);
}