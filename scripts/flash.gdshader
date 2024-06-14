shader_type canvas_item;

uniform vec4 color : source_color;
uniform float flashState : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    vec4 pixelColor = texture(TEXTURE, UV);


    COLOR = mix(pixelColor, color, flashState);
	COLOR.a *= pixelColor.a;
}