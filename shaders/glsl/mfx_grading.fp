/*
   Math color grading from MariENB
   (C)2012-2019 Marisa Kirisame
*/
#define luminance(x) dot(x,vec3(0.2126,0.7152,0.0722))

vec3 rgb2hsv( vec3 c )
{
	vec4 K = vec4(0.0,-1.0/3.0,2.0/3.0,-1.0);
	vec4 p = (c.g<c.b)?vec4(c.bg,K.wz):vec4(c.gb,K.xy);
	vec4 q = (c.r<p.x)?vec4(p.xyw,c.r):vec4(c.r,p.yzx);
	float d = q.x-min(q.w,q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z+(q.w-q.y)/(6.0*d+e)),d/(q.x+e),q.x);
}
vec3 hsv2rgb( vec3 c )
{
	vec4 K = vec4(1.0,2.0/3.0,1.0/3.0,3.0);
	vec3 p = abs(fract(c.xxx+K.xyz)*6.0-K.www);
	return c.z*mix(K.xxx,clamp(p-K.xxx,0.0,1.0),c.y);
}

void main()
{
	vec4 res = texture(InputTexture,TexCoord);
	res.rgb = pow(max(res.rgb,0.0),gradepow)*grademul;
	float tonev = luminance(res.rgb);
	vec3 tonecolor = gradecol*tonev;
	res.rgb = res.rgb*(1.0-gradecolfact)+tonecolor*gradecolfact;
	vec3 hsv = rgb2hsv(res.rgb);
	hsv.y = clamp(pow(max(hsv.y,0.0),gradesatpow)*gradesatmul,0.0,1.0);
	hsv.z = pow(max(hsv.z,0.0),gradevalpow)*gradevalmul;
	res.rgb = hsv2rgb(hsv);
	FragColor = res;
}
