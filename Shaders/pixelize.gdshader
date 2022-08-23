shader_type canvas_item;
uniform float pixel_factor : hint_range(0, 1) = 0.5;

void fragment(){
	vec2 pixelNumber = vec2(textureSize(TEXTURE, 0)) * pixel_factor;
	vec2 pixelatedUV = round(UV * pixelNumber) / pixelNumber;
	COLOR = texture(TEXTURE, pixelatedUV);
}