/*
   Border blur from MariENB
   (C)2012-2019 Marisa Kirisame
*/
void main()
{
	float gauss4[4] = float4[]( 0.270682, 0.216745, 0.111281, 0.036633 );
	vec2 coord = TexCoord;
	vec4 res = texture(InputTexture,coord);
	vec2 bresl = textureSize(InputTexture,0);
	float vigdata = 0.0;
	if ( vigshape == 0 )
	{
		vec2 uv = ((coord-0.5)*vec2(1.0,bresl.y/bresl.x))*2.0;
		vigdata = clamp(pow(dot(uv,uv),vigpow)*vigmul+vigbump,0.0,1.0);
	}
	else if ( vigshape == 1 )
	{
		vec2 uv = coord.xy*(1.0-coord.yx)*4.0;
		vigdata = clamp(pow(max(1.0-(uv.x*uv.y),0.0),vigpow)*vigmul+vigbump,0.0,1.0);
	}
	else vigdata = texture(VignetteTexture,coord).a;
	float bfact = clamp(pow(max(vigdata,0.0),bblurpow)*bblurmul+bblurbump,0.0,1.0);
	vec2 bof = (1.0/bresl)*bblurradius*bfact;
	res.rgb *= 0;
	int i,j;
	for ( i=-3; i<4; i++ ) for ( j=-3; j<4; j++ )
		res.rgb += gauss4[abs(i)]*gauss4[abs(j)]*texture(InputTexture,coord+vec2(i,j)*bof).rgb;
	FragColor = res;
}
