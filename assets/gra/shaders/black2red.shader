shader_type canvas_item;

void fragment() {
	vec4 curr_color = texture(TEXTURE,UV); //Get current color of pixel
	
	if (curr_color == vec4(0,0,0,1)){
		COLOR = vec4(1,0,0,1);
	}else{
		COLOR = curr_color;
	}
}