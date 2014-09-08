const int numlights = 3;

const vec3 gamma = vec3(2.2);
const vec3 invgamma = 1.0/gamma;

const vec3 viewdir = vec3(0.0, 0.0, 1.0);


extern vec4 Lights[6]; // max n / 2 lights

extern Image normaltexture;

extern number specpower = 25.0;
      
extern number yres;
extern number z = 0.0;
      
vec4 pow(vec4 color, vec3 exp)
{
   color.rgb = pow(color.rgb, exp);
   return color;
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
{
   vec3 coords = vec3(pixel_coords.x, yres - pixel_coords.y, z);
            
   vec4 texcolor = pow(Texel(texture, texture_coords), gamma);

   vec4 finalcolor = pow(vec4(0.0), gamma) * texcolor;
   
   vec4 normal = Texel(normaltexture, texture_coords);
   vec3 N = normalize(normal.xyz * 2.0 - 1.0);
   
   float specvalue = normal.a; // the normal texture has the specular texture inside its alpha component
   
   for (int i = 0; i < numlights * 2; i += 2)
   {
      vec3 L = normalize(Lights[i].xyz - coords);
      number NdotL = max(dot(N, L), 0.0);
   
      vec3 R = normalize(reflect(-L, N));
      number specular = pow(max(dot(viewdir, R), 0.0), specpower);
   
      finalcolor += (texcolor * Lights[i+1] * NdotL) + (Lights[i+1] * specvalue * specular);
   }

   finalcolor.a = texcolor.a;
   
   return pow(finalcolor, invgamma);
}
