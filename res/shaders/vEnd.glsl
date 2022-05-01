attribute vec3 vPosition;
attribute vec3 vNormal;
attribute vec2 vTexCoord;

uniform mat4 ModelView;
uniform mat4 Projection;

varying vec2 texCoord;
varying vec3 position;
varying vec3 normal;

void main() //Task G
{
    gl_Position = Projection * ModelView * vec4(vPosition, 1.0);
    texCoord = vTexCoord;
    position = vPosition;
    normal = vNormal;
}
