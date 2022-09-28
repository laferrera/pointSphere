#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec2 surfacePosition;

void main() {  
    float intensity = 0.1; // Lower number = more 'glow'
    vec3 light_color = vec3(0.674, 0.36778, 0.78761); // RGB, proportional values, higher increases intensity
    float master_scale = 5.91; // Change the size of the effect

    // float c = master_scale/(length(surfacePosition) * length(surfacePosition));
    float c = master_scale;
    gl_FragColor = vec4(vec3(pow(c, intensity))*light_color, 0.9);
    
}