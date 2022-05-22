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
uniform vec4 SpotLightPosition;
uniform vec3 SpotLightDirection;
uniform int selectedObject; 

uniform float Shininess;

uniform sampler2D texture;
uniform float texScale; // TASK B

void main() //Task G
{
    // vec4 vpos = vec4(position, 1.0);

    // vec3 pos = (ModelView * vpos).xyz;


    // // The vector to the light from the vertex    
    // vec3 Lvec = LightPosition.xyz - pos;
    // vec3 sLvec = vec3(SunLightPosition.xy - vec2(0.0,0.0), 2.0);
    // float sunStrength = SunLightPosition.z;

    // // Unit direction vectors for Blinn-Phong shading calculation
    // vec3 L = normalize( Lvec );   // Direction to the light source
    // vec3 E = normalize( -pos );   // Direction to the eye/camera
    // vec3 H = normalize( L + E );  // Halfway vector

    // vec3 sL = normalize( sLvec );   // Direction to the light source
    // vec3 sE = normalize( -pos );   // Direction to the eye/camera
    // vec3 sH = normalize( L + E );  // Halfway vector

    // // Transform vertex normal into eye coordinates (assumes scaling
    // // is uniform across dimensions)
    // vec3 N = normalize( (ModelView*vec4(normal, 0.0)).xyz );

    // // Compute terms in the illumination equation
    // vec3 ambient = AmbientProduct;

    // float Kd = max( dot(L, N), 0.0 );
    // vec3  diffuse = Kd*DiffuseProduct;

    // float Ks = pow( max(dot(N, H), 0.0), Shininess );
    // vec3  specular = Ks * SpecularProduct;
    
    // if (dot(L, N) < 0.0 ) {
	// specular = vec3(0.0, 0.0, 0.0);
    // } 

    // // SUNLIGHT
    // // Compute terms in the illumination equation
    // vec3  sunAmbient = AmbientProduct;

    // float sKd = max( dot(sL, N), 0.0 );
    // vec3  sunDiffuse = sKd*DiffuseProduct;

    // float sKs = pow( max(dot(N, sH), 0.0), Shininess );
    // vec3 sunSpecular = sKs * SpecularProduct;
    
    // if (dot(sL, N) < 0.0 ) {
	// specular = vec3(0.0, 0.0, 0.0);
    // } 

    // // globalAmbient is independent of distance from the light source
    // vec3 globalAmbient = vec3(0.1, 0.1, 0.1);
    // float falloff = max(pow(pow(length(Lvec), 2.0), -1.0), 0.0); //Task F
    // vec3 lightingColor = globalAmbient + ((ambient + diffuse) * falloff) + ((sunAmbient + sunDiffuse)*sunStrength);

    // vec4 mixColor = vec4(lightingColor, 1.0) * texture2D(texture, texCoord * texScale);

    // gl_FragColor = mix(mix(mixColor, vec4(0.0, 0.0, 0.0, 1.0), length(specular*falloff) + length(sunSpecular*sunStrength)) + (vec4(specular, 0.0)*falloff) + (vec4(sunSpecular, 0.0)*sunStrength), vec4(0.0, 0.5, 1.0, 1.0), float(selectedObject)/0.5);






    // vec4 mixColor = vec4(0.0, 0.0, 0.0, 0.0);

    // for (int l = 0; l < lightCount; l++) { // Here lied kug, a friend to all, hero to many
    //     // The vector to the light from the vertex    
    //     vec3 Lvec = LightPosition.xyz - pos;

    //     // Unit direction vectors for Blinn-Phong shading calculation
    //     vec3 L = normalize( Lvec );   // Direction to the light source
    //     vec3 E = normalize( -pos );   // Direction to the eye/camera
    //     vec3 H = normalize( L + E );  // Halfway vector

    //     // Transform vertex normal into eye coordinates (assumes scaling
    //     // is uniform across dimensions)
    //     vec3 N = normalize( (ModelView*vec4(normal, 0.0)).xyz );

    //     // Compute terms in the illumination equation
    //     vec3 ambient = AmbientProduct;

    //     float Kd = max( dot(L, N), 0.0 );
    //     vec3  diffuse = Kd*DiffuseProduct;

    //     float Ks = pow( max(dot(N, H), 0.0), Shininess );
    //     vec3  specular = Ks * SpecularProduct;
        
    //     if (dot(L, N) < 0.0 ) {
    //     specular = vec3(0.0, 0.0, 0.0);
    //     }

    //     mixColor += ambient + ;
    // }

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
    Lvec = SpotLightPosition.xyz - pos;
    float theta = dot(Lvec, normalize(-SpotLightDirection));

    if (theta > 0.78) {

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

        // falloff = min(pow(pow(length(Lvec), 2.0), -1.0), 1.0);

        // mixAmbient  += ambient;
        // mixDiffuse  += diffuse;
        // mixSpecular += specular;

        mixDiffuse += vec3(0.0,1.0,0.0);

    } else {
        mixDiffuse += vec3(1.0,0.0,0.0);
    }



    gl_FragColor = vec4(mixAmbient, 1.0) + vec4(mixDiffuse, 1.0) + vec4(mixSpecular, 1.0);
}
