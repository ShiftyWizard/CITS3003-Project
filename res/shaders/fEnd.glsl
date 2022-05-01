varying vec4 color;
varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded

uniform sampler2D texture;

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec4 LightPosition;
uniform float Shininess;

uniform vec3 pos;
varying vec3 Normal;

void main() //Task G
{
    // The vector to the light from the vertex    
    vec3 Lvec = LightPosition.xyz - pos;

    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L = normalize( Lvec );   // Direction to the light source
    vec3 E = normalize( -pos );   // Direction to the eye/camera
    vec3 H = normalize( L + E );  // Halfway vector

    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    vec3 N = normalize( (ModelView*vec4(Normal, 0.0)).xyz );

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
    // float falloff = max(pow(pow(length(Lvec), 2.0), -1.0), 0.0); //Task F
    float falloff = 1.0;
    vec4 lightColor;
    lightColor.rgb = (globalAmbient + ambient + diffuse + specular) * falloff; //Task F
    lightColor.a = 1.0;

    gl_FragColor = lightColor * texture2D( texture, texCoord * 2.0 );
}
