// Adrian Bedford 229373676
// Oliver Lynch 22989775

varying vec2 texCoord;
varying vec3 position;
varying vec3 normal;

uniform vec3     AmbientProduct,     DiffuseProduct,     SpecularProduct;
uniform vec3  sunAmbientProduct,  sunDiffuseProduct,  sunSpecularProduct;
uniform vec3 spotAmbientProduct, spotDiffuseProduct, spotSpecularProduct;
uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec4 LightPosition;
uniform vec4 SunLightPosition;
uniform vec4 SpotlightPosition;
uniform vec3 SpotlightDirection;
uniform int  selectedObject; 
varying vec3 fragPos;


uniform float Shininess;

uniform sampler2D texture;
uniform float texScale; // TASK B

void main() //Task G
{
    vec3 mixAmbient  = vec3(0.0,0.0,0.0);
    vec3 mixDiffuse  = vec3(0.0,0.0,0.0);
    vec3 mixSpecular = vec3(0.0,0.0,0.0);

    vec3 N, Lvec, L, E, H, ambient, diffuse, specular;
    float Kd, Ks, falloff;

    vec4 vpos = vec4(position, 1.0);
    vec3 pos = (ModelView * vpos).xyz;

    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    N = normalize( (ModelView*vec4(normal, 0.0)).xyz );

    // *************************************
    // Calculate Directional (Sun) Lighting
    // *************************************
    Lvec = vec3(SunLightPosition.xy, 2.0) - pos;

    L = normalize( Lvec );   // Direction to the light source
    E = normalize( -pos );   // Direction to the eye/camera
    H = normalize( L + E );  // Halfway vector

    ambient = sunAmbientProduct; // Compute terms in the illumination equation

    Kd = max( dot(L, N), 0.0 );
    diffuse = Kd*sunDiffuseProduct;

    Ks = pow( max(dot(N, H), 0.0), Shininess );
    specular = Ks * sunSpecularProduct;
    
    if (dot(L, N) < 0.0 ) {
	specular = vec3(0.0, 0.0, 0.0);
    } 

    mixAmbient  += ambient;
    mixDiffuse  += diffuse;
    mixSpecular += specular;

    // *************************************
    // Calculate point lighting
    // *************************************
    Lvec = LightPosition.xyz - pos;

    L = normalize( Lvec );   // Direction to the light source
    E = normalize( -pos );   // Direction to the eye/camera
    H = normalize( L + E );  // Halfway vector

    ambient = AmbientProduct; // Compute terms in the illumination equation

    Kd = max( dot(L, N), 0.0 );
    diffuse = Kd*DiffuseProduct;

    Ks = pow( max(dot(N, H), 0.0), Shininess );
    specular = Ks * SpecularProduct;
    
    if (dot(L, N) < 0.0 ) {
	specular = vec3(0.0, 0.0, 0.0);
    } 

    falloff = min(pow(pow(length(Lvec), 2.0), -1.0), 1.0);

    mixAmbient  += ambient  * falloff;
    mixDiffuse  += diffuse  * falloff;
    mixSpecular += specular * falloff;

    // *************************************
    // Calculate spotlight lighting
    // *************************************
    Lvec = SpotlightPosition.xyz - pos.xyz;// - vpos.xyz;
    float theta = dot(normalize(Lvec), normalize(-SpotlightDirection));

    if (theta > 0.3) {

        // L = normalize( Lvec );   // Direction to the light source
        // E = normalize( -pos );   // Direction to the eye/camera
        // H = normalize( L + E );  // Halfway vector

        // ambient = AmbientProduct; // Compute terms in the illumination equation

        // Kd = max( dot(L, N), 0.0 );
        // diffuse = Kd*DiffuseProduct;

        // Ks = pow( max(dot(N, H), 0.0), Shininess );
        // specular = Ks * SpecularProduct;
        
        // if (dot(L, N) < 0.0 ) {
        // specular = vec3(0.0, 0.0, 0.0);
        // } 

        // mixAmbient  += ambient;
        // mixDiffuse  += diffuse;
        // mixSpecular += specular;

        // gl_FragColor = vec4(0.0,1.0,0.0,1.0);

    }

    mixAmbient += vec3(0.0,0.0,1.0) * float(selectedObject); // Selected object glow

    float sL = (mixSpecular.x + mixSpecular.y + mixSpecular.z)/3.0;

    gl_FragColor = vec4(mixAmbient, 1.0) + vec4(mixDiffuse, 1.0) + vec4(sL,sL,sL,1.0);

    gl_FragColor = vec4(theta, theta, theta, 1.0);
}
