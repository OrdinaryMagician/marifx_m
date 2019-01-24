/*
   Complex grain shader ported over from MariENB
   (C)2012-2019 Marisa Kirisame
*/
const float nf = 0.0005;
const vec3 nm1 = vec3(2.05,3.11,2.22);
const float nk = 0.04;
const vec3 nm2 = vec3(4.25,9.42,6.29);

#define overlay(a,b) (a<0.5)?(2.0*a*b):(1.0-(2.0*(1.0-a)*(1.0-b)))
#define darkmask(a,b) (a>0.5)?(2.0*a*(0.5+b)):(1.0-2.0*(1.0-a)*(1.0-((0.5+b))))

vec3 grain( in vec3 res, in vec2 coord )
{
	float ts = Timer*nf;
	vec2 s1 = coord+vec2(0.0,ts);
	vec2 s2 = coord+vec2(ts,0.0);
	vec2 s3 = coord+vec2(ts,ts);
	float n1, n2, n3;
	vec2 bresl = textureSize(InputTexture,0);
	vec2 nr = vec2(7.5);
	nr.y *= bresl.y/bresl.x;
	n1 = texture(NoiseTexture,s1*nm1.x*nr).r;
	n2 = texture(NoiseTexture,s2*nm1.y*nr).g;
	n3 = texture(NoiseTexture,s3*nm1.z*nr).b;
	s1 = coord+vec2(ts+n1*nk,n2*nk);
	s2 = coord+vec2(n2,ts+n3*nk);
	s3 = coord+vec2(ts+n3*nk,ts+n1*nk);
	n1 = texture(NoiseTexture,s1*nm2.x*nr).r;
	n2 = texture(NoiseTexture,s2*nm2.y*nr).g;
	n3 = texture(NoiseTexture,s3*nm2.z*nr).b;
	float n4 = (n1+n2+n3)/3.0;
	vec3 ng = vec3(n4);
	vec3 nc = vec3(n1,n2,n3);
	vec3 nt = pow(clamp(mix(ng,nc,ns),0.0,1.0),vec3(np));
	if ( nb == 0 ) res.rgb += nt*ni;
	else if ( nb == 1 )
	{
		res.r = overlay(res.r,(nt.r*ni+0.5));
		res.g = overlay(res.g,(nt.g*ni+0.5));
		res.b = overlay(res.b,(nt.b*ni+0.5));
	}
	else
	{
		float bn = 1.0-clamp((res.r+res.g+res.b)/3.0,0.0,1.0);
		bn = pow(bn,bnp);
		vec3 nn = clamp(nt*bn,vec3(0.0),vec3(1.0));
		res.r = darkmask(res.r,(nn.r*ni));
		res.g = darkmask(res.g,(nn.g*ni));
		res.b = darkmask(res.b,(nn.b*ni));
	}
	return res;
}

void main()
{
	vec2 coord = TexCoord;
	vec4 res = texture(InputTexture,coord);
	res.rgb = grain(res.rgb,coord);
	FragColor = res;
}
