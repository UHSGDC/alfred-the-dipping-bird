shader_type canvas_item;

uniform vec2 blur_amount;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	vec4 color_up = texture(TEXTURE, UV + vec2(0.0, blur_amount.y));
	vec4 color_down = texture(TEXTURE, UV + vec2(0.0, -blur_amount.y));
	vec4 color_right = texture(TEXTURE, UV + vec2(blur_amount.x, 0.0));
	vec4 color_left = texture(TEXTURE, UV + vec2(-blur_amount.x, 0.0));
	
	COLOR = (color_up + color_down + color_left + color_right) / 4.0;
}
