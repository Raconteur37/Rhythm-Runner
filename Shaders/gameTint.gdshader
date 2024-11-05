shader_type canvas_item;

uniform vec4 tint_color = vec4(0, 0, 0, .5);

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    COLOR = mix(tex_color, tint_color, tint_color.a);
}
