shader_type spatial;

render_mode cull_disabled;

uniform sampler2D noise;
uniform sampler2D gradient;

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow(
		(clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0)),
		amount
	);
}

void fragment() {
	float basic_fresnel = fresnel(0.10, NORMAL, VIEW);
	vec4 pixel = round(texture(noise, UV * vec2(1, 0.25) + vec2(0, 2.0 * TIME)));
	vec4 color = texture(gradient, vec2(UV.y, 0));
	ALBEDO = pixel.rgb * color.rgb;
	EMISSION = ALBEDO * 5.0;
	ALPHA = (pixel.r * pow(UV.y, 1) * pow(basic_fresnel, 5.0)) * 3.0;
}
