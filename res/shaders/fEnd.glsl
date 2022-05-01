varying vec2 texCoord;
varying vec3 position;
varying vec3 normal;

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec4 LightPosition;
uniform float Shininess;

uniform sampler2D texture;
uniform float texScale; // TASK B

void main() //Task G
{
    vec4 vpos = vec4(position, 1.0);

    vec3 pos = (ModelView * vpos).xyz;


    // The vector to the light from the vertex    
    vec3 Lvec = LightPosition.xyz - pos;

    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L = normalize( Lvec );   // Direction to the light source
    vec3 E = normalize( -pos );   // Direction to the eye/camera
    vec3 H = normalize( L + E );  // Halfway vector

    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    vec3 N = normalize( (ModelView*vec4(normal, 0.0)).xyz );

    // Compute terms in the illumination equation
    vec3 ambient = AmbientProduct;

    float Kd = max( dot(L, N), 0.0 );
    vec3  diffuse = Kd*DiffuseProduct;

    float Ks = pow( max(dot(N, H), 0.0), Shininess );
    vec3  specular = Ks * SpecularProduct;
    
    if (dot(L, N) < 0.0 ) {
	specular = vec3(0.0, 0.0, 0.0);
    } 

    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);
    float falloff = max(pow(pow(length(Lvec), 2.0), -1.0), 0.0); //Task F
    vec3 lightingColor = (globalAmbient + ambient + diffuse) * falloff;

    vec4 mixColor = vec4(lightingColor, 1.0) * texture2D(texture, texCoord * texScale);

    gl_FragColor = mix(mixColor, vec4(0.0, 0.0, 0.0, 1.0), length(specular)) + (vec4(specular, 0.0)*falloff);
}
