vec3 lensdirt( in vec3 res, in vec2 coord )
{
	vec2 nr = textureSize(InputTexture,0)/textureSize(NoiseTexture,0);
	vec3 ncolc = texture(NoiseTexture,coord*dirtmc*nr).rgb;
	vec2 ds = vec2(res.r+res.g,res.g+res.b)/2.0;
	res = mix(res,(ncolc.r+1.0)*res,dirtcfactor*clamp(1.0-(ds.x+ds.y)*0.25,0.0,1.0));
	return res;
}

void main()
{
	vec2 coord = TexCoord;
	vec4 res = texture(InputTexture,coord);
	res.rgb = lensdirt(res.rgb,coord);
	FragColor = res;
}
