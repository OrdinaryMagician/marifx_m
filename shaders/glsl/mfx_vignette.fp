void main()
{
	vec2 coord = TexCoord;
	vec4 res = texture(InputTexture,coord);
	vec2 bresl = textureSize(InputTexture,0);
	vec2 uv = ((coord-0.5)*vec2(1.0,bresl.y/bresl.x))*2.0;
	vec4 vigdata = vec4(vigcolor,clamp(pow(dot(uv,uv),vigpow)*vigmul+vigbump,0.0,1.0));
	vec3 outcol = clamp(res.rgb+vigdata.rgb,0.0,1.0);
	res.rgb = mix(res.rgb,outcol,vigdata.a);
	FragColor = res;
}
