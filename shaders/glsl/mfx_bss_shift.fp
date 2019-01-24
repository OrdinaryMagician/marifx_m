/*
   BlurSharpShift shift from MariENB
   (C)2012-2019 Marisa Kirisame
*/
void main()
{
	vec2 coord = TexCoord;
	vec4 res = texture(InputTexture,coord);
	vec2 bresl = textureSize(InputTexture,0);
	vec2 bof = (1.0/bresl)*bssshiftradius;
	res.g = texture(InputTexture,coord).g;
	res.r = texture(InputTexture,coord+vec2(0,-bof.y)).r;
	res.b = texture(InputTexture,coord+vec2(0,bof.y)).b;
	FragColor = res;
}
