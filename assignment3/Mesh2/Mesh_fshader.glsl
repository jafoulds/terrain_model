#version 330 core
out vec3 color;

in vec2 uv;

uniform sampler2D height_map;
uniform sampler2D diffuse_map;//add more lines for each texture
uniform sampler2D snow_map;
uniform sampler2D water_map;

uniform float time;

void main() {

    float tiling_amount = 5;

    float height_center = texture(height_map, uv).r;

    float height_plus_u = textureOffset(height_map, uv, ivec2(1,0)).r; // TODO: get offset height values
    float height_plus_v = textureOffset(height_map, uv, ivec2(0,1)).r;
    float u_diff =  height_plus_u - height_center;
    float v_diff = height_plus_v - height_center;
    //vec3 u =vec3(u_diff,0,0);
    //vec3 v =vec3(0,v_diff,0);
    //vec3 cool = vec3(u_diff, v_diff, 0);


    vec3 z_random =vec3(0,v_diff, 1);
    vec3 x_random =vec3(1, u_diff, 0);

    //float new_u_diff = u_diff *-1.0;
    //float new_v_diff = v_diff *-1.0;

    //vec3 N = normalize(cross(z_random, x_random));
    //vec3 N = normalize(vec3(new_v_diff, u_diff ,0));

    vec3 N = vec3(0, 1, 0); // Calculate normal from height differences
    vec3 light = normalize(vec3(1,3,0));
    vec3 ambient = vec3(0.1, 0.1, 0.2);

    vec3 diffuse = texture(diffuse_map, uv * tiling_amount).rgb * clamp(dot(N, light), 0, 1);
    if(height_center >0.3){
        diffuse = texture(snow_map, uv * tiling_amount).rgb * clamp(dot(N, light), 0, 1);
    }
    else if(height_center < -0.1){
        diffuse = texture(water_map, uv * tiling_amount).rgb * clamp(dot(N, light), 0, 1);
    }


    // Optional TODO: add specular term
    // Hint: you will need the world space position of each pixel.
    // You can easily get this from the vertex shader where it is
    // already calculated

    color = ambient + diffuse;

}