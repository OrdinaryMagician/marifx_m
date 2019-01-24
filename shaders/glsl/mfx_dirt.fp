/*
   Dirty camera effect from MariENB
   (C)2012-2019 Marisa Kirisame
*/
vec3 lensdirt( in vec3 res, in vec2 coord )
{
	vec2 bresl = textureSize(InputTexture,0);
	vec2 nr = vec2(1.0,bresl.y/bresl.x);
	float ncol = texture(NoiseTexture,coord*dirtmc*nr).x;
	vec2 ds = vec2(res.r+res.g,res.g+res.b)/2.0;
	res = mix(res,(ncol+1.0)*res,dirtcfactor*clamp(1.0-(ds.x+ds.y)*0.25,0.0,1.0));
	return res;
}

void main()
{
	vec2 coord = TexCoord;
	vec4 res = texture(InputTexture,coord);
	res.rgb = lensdirt(res.rgb,coord);
	FragColor = res;
}
