/*
   Vignette filter from MariENB
   (C)2012-2019 Marisa Kirisame
*/
void main()
{
	vec2 coord = TexCoord;
	vec4 res = texture(InputTexture,coord);
	vec2 bresl = textureSize(InputTexture,0);
	vec4 vigdata = vec4(0.0);
	if ( vigshape == 0 )
	{
		vec2 uv = ((coord-0.5)*vec2(1.0,bresl.y/bresl.x))*2.0;
		vigdata = vec4(vigcolor,clamp(pow(dot(uv,uv),vigpow)*vigmul+vigbump,0.0,1.0));
	}
	else if ( vigshape == 1 )
	{
		vec2 uv = coord.xy*(1.0-coord.yx)*4.0;
		vigdata = vec4(vigcolor,clamp(pow(max(1.0-(uv.x*uv.y),0.0),vigpow)*vigmul+vigbump,0.0,1.0));
	}
	else vigdata = texture(VignetteTexture,coord);
	vec3 outcol;
	if ( vigmode == 0 ) outcol = vigdata.rgb;
	else if ( vigmode == 1 ) outcol = res.rgb+vigdata.rgb;
	else outcol = res.rgb*vigdata.rgb;
	res.rgb = mix(res.rgb,clamp(outcol,0.0,1.0),vigdata.a);
	FragColor = res;
}
