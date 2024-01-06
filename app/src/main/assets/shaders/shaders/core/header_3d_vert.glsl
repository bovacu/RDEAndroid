layout(location = 0) in vec3 in_pos;
layout(location = 1) in vec3 in_normal;
layout(location = 2) in vec2 in_text_coord;
layout(location = 3) in mat4 in_model;

out vec3 normal;
out vec2 text_coord;
out vec3 frag_pos;
out mat4 model_matrix;
uniform int use_shadows;
uniform mat4 view_projection_matrix;
uniform float dt;
uniform vec2 mouse_position;
uniform mat4 light_space_matrix;

out VS_OUT {
    vec3 frag_pos;
    vec3 normal;
    vec4 frag_pos_light_space;
} vs_out;
