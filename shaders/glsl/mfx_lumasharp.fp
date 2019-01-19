#define luminance(x) dot(x,vec3(0.2126,0.7152,0.0722))

void main()
{
	vec2 coord = TexCoord;
	vec4 res = texture(InputTexture,coord);
	vec2 bof = (1.0/textureSize(InputTexture,0))*sharpradius;
	vec4 crawling = texture(InputTexture,coord+vec2(0,-1)*bof);
	crawling += texture(InputTexture,coord+vec2(-1,0)*bof);
	crawling += texture(InputTexture,coord+vec2(1,0)*bof);
	crawling += texture(InputTexture,coord+vec2(0,1)*bof);
	crawling *= 0.25;
	vec4 inmyskin = res-crawling;
	float thesewounds = luminance(inmyskin.rgb);
	thesewounds = clamp(thesewounds,-sharpclamp*0.01,sharpclamp*0.01);
	vec4 theywillnotheal = res+thesewounds*sharpblend;
	FragColor = theywillnotheal;
}