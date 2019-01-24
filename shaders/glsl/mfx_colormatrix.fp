/*
   Simple color matrix from MariENB
   (C)2012-2019 Marisa Kirisame
*/
void main()
{
	vec2 coord = TexCoord;
	vec4 res = texture(InputTexture,coord);
	mat3 cmat = mat3(redrow,greenrow,bluerow);
	float cmatscale = (redrow.r+redrow.g+redrow.b+greenrow.r+greenrow.g+greenrow.b+bluerow.r+bluerow.g+bluerow.b)/3.0;
	res.rgb *= cmat;
	res.rgb /= cmatscale;
	FragColor = res;
}
