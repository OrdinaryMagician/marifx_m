/*
   Hue-Saturation filter from MariENB, ported over from GIMP
   (C)2007 Michael Natterer
   (C)2012-2019 Marisa Kirisame
*/
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

float hs_hue_overlap( float hue_p, float hue_s, float res )
{
	float v = hue_p+hue_s;
	res += (hshue_a+v)/2.0;
	return mod(res,1.0);
}
float hs_hue( float hue, float res )
{
	res += (hshue_a+hue)/2.0;
	return mod(res,1.0);
}
float hs_sat( float sat, float res )
{
	float v = hssat_a+sat;
	res *= v+1.0;
	return clamp(res,0.0,1.0);
}
float hs_val( float val, float res )
{
	float v = (hsval_a+val)/2.0;
	if ( v < 0.0 ) return res*(v+1.0);
	return res+(v*(1.0-res));
}
void main()
{
	vec2 coord = TexCoord;
	vec4 res = texture(InputTexture,coord);
	vec3 hsv = rgb2hsv(res.rgb);
	float ch = hsv.x*6.0;
	int ph = 0, sh = 0;
	float pv = 0.0, sv = 0.0;
	bool usesh = false;
	float hues[6] = float[](hshue_r,hshue_y,hshue_g,hshue_c,hshue_b,hshue_m);
	float sats[6] = float[](hssat_r,hssat_y,hssat_g,hssat_c,hssat_b,hssat_m);
	float vals[6] = float[](hsval_r,hsval_y,hsval_g,hsval_c,hsval_b,hsval_m);
	float v;
	for ( float h=0.0; h<7.0; h+=1.0 )
	{
		float ht = h+0.5;
		if ( ch < ht+hsover )
		{
			ph = int(floor(h));
			if ( (hsover > 0.0) && (ch > ht-hsover) )
			{
				usesh = true;
				sh = ph+1;
				sv = (ch-ht+hsover)/(2.0*hsover);
				pv = 1.0-sv;
			}
			else usesh = false;
			break;
		}
	}
	if ( ph >= 6 )
	{
		ph = 0;
		usesh = false;
	}
	if ( sh >= 6 ) sh = 0;
	if ( usesh )
	{
		hsv.x = hs_hue_overlap(hues[ph]*pv,hues[sh]*sv,hsv.x);
		hsv.y = hs_sat(sats[ph],hsv.y)*pv+hs_sat(sats[sh],hsv.y)*sv;
		hsv.z = hs_val(vals[ph],hsv.z)*pv+hs_val(vals[sh],hsv.z)*sv;
	}
	else
	{
		hsv.x = hs_hue(hues[ph],hsv.x);
		hsv.y = hs_sat(sats[ph],hsv.y);
		hsv.z = hs_val(vals[ph],hsv.z);
	}
	res.rgb = hsv2rgb(hsv);
	FragColor = res;
}
