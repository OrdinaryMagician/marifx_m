void main()
{
	float gauss4[4] = { 0.270682, 0.216745, 0.111281, 0.036633 };
	vec2 coord = TexCoord;
	vec4 res = texture(InputTexture,coord);
	vec2 bresl = textureSize(InputTexture,0);
	vec2 uv = ((coord-0.5)*vec2(1.0,bresl.y/bresl.x))*2.0;
	float bfact = clamp(pow(dot(uv,uv),bblurpow)*bblurmul+bblurbump,0.0,1.0);
	vec2 bof = (1.0/bresl)*bblurradius*bfact;
	res.rgb *= 0;
	int i,j;
	for ( i=-3; i<4; i++ ) for ( j=-3; j<4; j++ )
		res.rgb += gauss4[abs(i)]*gauss4[abs(j)]*texture(InputTexture,coord+vec2(i,j)*bof).rgb;
	FragColor = res;
}
