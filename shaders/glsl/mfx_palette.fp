/*
   RetroFX palette reduction from MariENB
   (C)2012-2019 Marisa Kirisame
*/
void main()
{
	#define d(x) x/64.0
	float dither8[64] =
	{
		d( 0),d(48),d(12),d(60),d( 3),d(51),d(15),d(63),
		d(32),d(16),d(44),d(28),d(35),d(19),d(47),d(31),
		d( 8),d(56),d( 4),d(52),d(11),d(59),d( 7),d(55),
		d(40),d(24),d(36),d(20),d(43),d(27),d(39),d(23),
		d( 2),d(50),d(14),d(62),d( 1),d(49),d(13),d(61),
		d(34),d(18),d(46),d(30),d(33),d(17),d(45),d(29),
		d(10),d(58),d( 6),d(54),d( 9),d(57),d( 5),d(53),
		d(42),d(26),d(38),d(22),d(41),d(25),d(37),d(21)
	};
	#undef d
	vec2 coord = TexCoord;
	vec2 sfact = textureSize(InputTexture,0);
	vec4 res = texture(InputTexture,coord);
	if ( res.r <= 0.0 ) res.r -= paldither;
	if ( res.g <= 0.0 ) res.g -= paldither;
	if ( res.b <= 0.0 ) res.b -= paldither;
	if ( res.r >= 1.0 ) res.r += paldither;
	if ( res.g >= 1.0 ) res.g += paldither;
	if ( res.b >= 1.0 ) res.b += paldither;
	res.rgb += paldither*dither8[int(coord.x*sfact.x)%8+int(coord.y*sfact.y)%8*8]-0.5*paldither;
	vec3 lc = clamp(floor(res.rgb*64),0,63);
	ivec2 lcoord = ivec2(lc.r,lc.g+lc.b*64);
	lcoord.x += 64*palnum;
	res.rgb = texelFetch(PalLUTTexture,lcoord,0).rgb;
	FragColor = res;
}
