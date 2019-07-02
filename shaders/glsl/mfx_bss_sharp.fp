/*
   BlurSharpShift sharpen from MariENB
   (C)2012-2019 Marisa Kirisame
*/
void main()
{
	vec2 coord = TexCoord;
	vec4 res = texture(InputTexture,coord);
	vec2 ofs[8] = vec2[]
	(
		vec2(1.0,1.0), vec2(-1.0,-1.0),
		vec2(-1.0,1.0), vec2(1.0,-1.0),

		vec2(1.41,1.41), vec2(-1.41,-1.41),
		vec2(-1.41,1.41), vec2(1.41,-1.41)
	);
	vec2 bresl = textureSize(InputTexture,0);
	vec2 bof = (1.0/bresl)*bsssharpradius;
	vec4 tcol = res;
	int i;
	for ( i=0; i<8; i++ ) tcol += texture(InputTexture,coord+ofs[i]*bof);
	tcol /= 9.0;
	vec4 orig = res;
	res = orig*(1.0+dot(orig.rgb-tcol.rgb,vec3(0.333333))*bsssharpamount);
	float rg = clamp(pow(orig.b,3.0),0.0,1.0);
	res = mix(res,orig,rg);
	FragColor = res;
}
