#version 330 core

header_3d_frag

vec3 directional_light_calc(float _shadow) {
	vec3 _final_light = vec3(0, 0, 0);
	vec3 _light_dir = normalize(directional_light.position - fs_in.frag_pos);
	vec3 _norm = normalize(fs_in.normal);
	vec3 _diffuse = vec3(0, 0, 0);
	vec3 _specular = vec3(0, 0, 0);
	vec3 _ambient = vec3(0, 0, 0);

	if(material.Ka != vec3(0, 0, 0)) {
		vec3 _ambient = material.Ka * directional_light.ambient_color * texture(tex_kd, text_coord).rgb;
	}


	if(material.Kd != vec3(0, 0, 0)) {
		float _diff = max(dot(_light_dir, _norm), 0.0);
		_diffuse = material.Kd * directional_light.diffuse_color * _diff * texture(tex_kd, text_coord).rgb;
	}

	if(material.Ks != vec3(0, 0, 0)) {
		vec3 _view_dir = normalize(camera_pos + frag_pos);
		vec3 _reflect_dir = reflect(-_light_dir, _norm);
		float _spec = pow(max(dot(_view_dir, _reflect_dir), 0.0), material.shininess);
		_specular = material.Ks * directional_light.specular_color * _spec * texture(tex_ks, text_coord).rgb;
	}

	_final_light = _ambient + (1.0 - _shadow) * (_diffuse + _specular);

	return _final_light;
}

vec3 directional_light_calc() {
	vec3 _final_light = vec3(0, 0, 0);
	vec3 _light_dir = normalize(-directional_light.direction);
	vec3 _norm = normalize(normal);

	if(material.Ka != vec3(0, 0, 0)) {
		vec3 _ambient = material.Ka * directional_light.ambient_color * texture(tex_kd, text_coord).rgb;
		_final_light += _ambient;
	}


	if(material.Kd != vec3(0, 0, 0)) {
		float _diff = max(dot(_norm, _light_dir), 0.0);
		vec3 _diffuse = material.Kd * directional_light.diffuse_color * _diff * texture(tex_kd, text_coord).rgb;
		_final_light += _diffuse;
	}

	if(material.Ks != vec3(0, 0, 0)) {
		vec3 _view_dir = normalize(camera_pos + frag_pos);
		vec3 _reflect_dir = reflect(-_light_dir, _norm);
		float _spec = pow(max(dot(_view_dir, _reflect_dir), 0.0), material.shininess);
		vec3 _specular = material.Ks * directional_light.specular_color * _spec * texture(tex_ks, text_coord).rgb;
		_final_light += _specular;
	}

	return _final_light;
}

#if RDE_MAX_POINT_LIGHTS
vec3 point_light_calc(int _i) {
	rde_point_light _light = point_lights[_i];
	if(_light.used < 0) return vec3(0.0, 0.0, 0.0);

	float _distance = length(_light.position - frag_pos);
	float _attenuation = 1.0 / (_light.constant + _light.linear * _distance + _light.quadratic * (_distance * _distance));
	vec3 _norm = normalize(normal);
	vec3 _light_dir = normalize(_light.position - frag_pos);
	vec3 _final_light = vec3(0, 0, 0);

	if(material.Ka != vec3(0, 0, 0)) {
		vec3 _ambient = material.Ka * _light.ambient_color * texture(tex_kd, text_coord).rgb;
		_final_light += _ambient * _attenuation;
	}

	if(material.Kd != vec3(0, 0, 0)) {
		float _diff = max(dot(_norm, _light_dir), 0.0);
		vec3 _diffuse = material.Kd * _light.diffuse_color * _diff * texture(tex_kd, text_coord).rgb;
		_final_light += _diffuse * _attenuation;
	}

	if(material.Ks != vec3(0, 0, 0)) {
		vec3 _view_dir = normalize(camera_pos + frag_pos);
		vec3 _reflect_dir = reflect(-_light_dir, _norm);
		float _spec = pow(max(dot(_view_dir, _reflect_dir), 0.0), material.shininess);
		vec3 _specular = material.Ks * _light.specular_color * _spec * texture(tex_ks, text_coord).rgb;
		_final_light += _specular * _attenuation;
	}

	return _final_light;
}
#endif

#if RDE_MAX_SPOT_LIGHTS
vec3 spot_light_calc(int _i) {
	rde_spot_light _light = spot_lights[_i];
	if(_light.used < 0) return vec3(0.0, 0.0, 0.0);

	vec3 _light_dir = normalize(_light.position - frag_pos);
	float _theta = dot(_light_dir, normalize(-_light.direction));
	float _epsilon = (_light.cut_off - _light.outer_cut_off);
	float _intensity = clamp((_theta - _light.outer_cut_off) / _epsilon, 0.0, 1.0);
	float _distance = length(_light.position - frag_pos);
	float _attenuation = 1.0 / (_light.constant + _light.linear * _distance + _light.quadratic * (_distance * _distance));
	vec3 _final_light = vec3(0, 0, 0);

	if(material.Ka != vec3(0, 0, 0)) {
		vec3 _ambient = material.Ka * _light.ambient_color * texture(tex_kd, text_coord).rgb;
		_final_light += _ambient * _attenuation;
	}

	if(material.Kd != vec3(0, 0, 0)) {
		vec3 _norm = normalize(normal);
		float _diff = max(dot(_norm, _light_dir), 0.0);
		vec3 _diffuse = material.Kd * _light.diffuse_color * _diff * texture(tex_kd, text_coord).rgb;
		_final_light += _diffuse * _attenuation * _intensity;
	}

	return _final_light;
}
#endif

float ShadowCalculation(vec4 frag_pos_light_space) {
    // perform perspective divide
    vec3 _proj_coords = frag_pos_light_space.xyz / frag_pos_light_space.w;
    // transform to [0,1] range
    _proj_coords = _proj_coords * 0.5 + 0.5;
    // get closest depth value from light's perspective (using [0,1] range fragPosLight as coords)
    float _closest_depth = texture(shadow_map, _proj_coords.xy).r;
    // get depth of current fragment from light's perspective
    float _current_depth = _proj_coords.z;
    // check whether current frag pos is in shadow

	vec3 _light_dir = normalize(directional_light.position - fs_in.frag_pos);
	vec3 _norm = normalize(fs_in.normal);
	float _bias = mix(0.005, 0.0, dot(_norm, -_light_dir));

    float _shadow = 0.0;
    vec2 _texel_size = 1.0 / textureSize(shadow_map, 0);
	
    for(int _x = -1; _x <= 1; ++_x) {
        for(int _y = -1; _y <= 1; ++_y) {
            float _pcf_depth = texture(shadow_map, _proj_coords.xy + vec2(_x, _y) * _texel_size).r;
            _shadow += _current_depth - _bias > _pcf_depth  ? 1.0 : 0.0;
        }
    }
    
    _shadow /= 20.0;

	if(_proj_coords.z > 1.0)
        _shadow = 0.0;

    return _shadow;
}

void normal_rendering() {
	if(texture(tex_kd, text_coord).a < 0.05) discard;
	vec3 _final_light = vec3(0.0);

	_final_light += directional_light_calc();

#if RDE_MAX_POINT_LIGHTS
	for (int _i = 0; _i < RDE_MAX_POINT_LIGHTS; _i++) {
		_final_light += point_light_calc(_i);
	}
#endif

#if RDE_MAX_SPOT_LIGHTS
	for (int _i = 0; _i < RDE_MAX_SPOT_LIGHTS; _i++) {
		_final_light += spot_light_calc(_i);
	}
#endif

	color_out = vec4(_final_light, 1.0);
}

void shadow_rendering() {
	if(texture(tex_kd, text_coord).a < 0.05) discard;

	float _shadow = ShadowCalculation(fs_in.frag_pos_light_space);
	vec3 _final_light = vec3(0.0);

	_final_light += directional_light_calc(_shadow);

// #if RDE_MAX_POINT_LIGHTS
// 	for (int _i = 0; _i < RDE_MAX_POINT_LIGHTS; _i++) {
// 		_final_light += point_light_calc(_i);
// 	}
// #endif
// 
// #if RDE_MAX_SPOT_LIGHTS
// 	for (int _i = 0; _i < RDE_MAX_SPOT_LIGHTS; _i++) {
// 		_final_light += spot_light_calc(_i);
// 	}
// #endif

	color_out = vec4(_final_light, 1.0);
}

void render_texture_rendering() {
	color_out = texture(render_texture, text_coord);
}

void main(){
	if(material.using_render_texture == 0) {
		if(use_shadows == 0) {
			normal_rendering();
		} else {
			shadow_rendering();
		}
	} else {
		render_texture_rendering();
	}
}
