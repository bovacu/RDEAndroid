#version 300 es
precision mediump float;

in vec2 uv;
in vec4 color;

uniform sampler2D tex;
layout(location = 0) out vec4 out_color;

void main(void) {
	out_color = texture(tex, uv) * vec4(color.x / 255.f, color.y / 255.f, color.z / 255.f, color.w / 255.f);
}