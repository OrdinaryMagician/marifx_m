/*
   BlurSharpShift blur from MariENB
   (C)2012-2019 Marisa Kirisame
*/
void main()
{
	vec2 coord = TexCoord;
	vec4 res = texture(InputTexture,coord);
	vec2 ofs[16] =
	{
		vec2(1.0,1.0), vec2(-1.0,-1.0),
		vec2(-1.0,1.0), vec2(1.0,-1.0),

		vec2(1.0,0.0), vec2(-1.0,0.0),
		vec2(0.0,1.0), vec2(0.0,-1.0),

		vec2(1.41,0.0), vec2(-1.41,0.0),
		vec2(0.0,1.41), vec2(0.0,-1.41),

		vec2(1.41,1.41), vec2(-1.41,-1.41),
		vec2(-1.41,1.41), vec2(1.41,-1.41)
	};
	vec2 bresl = textureSize(InputTexture,0);
	vec2 bof = (1.0/bresl)*bssblurradius;
	for ( int i=0; i<16; i++ ) res.rgb += texture(InputTexture,coord+ofs[i]*bof).rgb;
	res.rgb /= 17.0;
	FragColor = res;
}
