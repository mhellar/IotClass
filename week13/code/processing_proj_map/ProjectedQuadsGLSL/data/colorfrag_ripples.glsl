// Slightly modified to better test FP precision.

// Results:
// * Windows / nVidia gfx cards: rules
// * Windows / AMD gfx cards: sucks (tested: 7770)
// * Ubuntu / Core i3 onboard graphics: rules
// * Nexus 4 (Adreno graphics): censored and distorted due to using 16 bit float (11 bits mantissa (-> distorts) and 5 bits exponent (long words don't display any more due to FP overflow))

// If you experience odd behaviour please specify what device you are using

//
//Using a GTX 650, it shows 'rules', but some of the letters are distorted anyway...
// Radeon HD 5400: The thumbnail is distorted


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float showText(vec2 p, float r0, float r1, float r2, float r3, float r4, float r5, float r6, float ofs) {
  if(p.y < 0. || p.y > 7.) return 0.; // Bit count Y
  if(p.x < 0. || p.x > 24.) return 0.; // Bit count X
    
  float v = r0;
  v = mix(v, r1, step(p.y, 6.));
  v = mix(v, r2, step(p.y, 5.));
  v = mix(v, r3, step(p.y, 4.));
  v = mix(v, r4, step(p.y, 3.));
  v = mix(v, r5, step(p.y, 2.));
  v = mix(v, r6, step(p.y, 1.));
  
  
  return floor(mod((v+ofs)/pow(2.,floor(p.x)), 2.0));
}


void main( void ) {

  vec2 position = gl_FragCoord.xy / resolution.xy;

  float color = 0.0;
  color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
  color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
  color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
  color *= sin( time / 10.0 ) * 0.5;

  gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );
  if (mod(time*1., 1.) < 0.5) {
  if (showText(vec2(16.-position.x*35.,position.y*25.-17.),22359., 21845., 21845., 30039., 9558., 9557., 10101., 0.)>.5) gl_FragColor = vec4(1.);
  
  if (showText(vec2(34.-position.x*35.,position.y*25.-17.),29812., 17476., 17476., 21620., 21524., 21524., 30583., 0.)>.5) gl_FragColor = vec4(1.);
  
  if (showText(vec2(14.-position.x*33.,position.y*25.-9.),7616., 4416., 4416., 4416., 4416., 4416., 7616., .2)>.5) gl_FragColor = vec4(1.);

  if (showText(vec2(32.-position.x*33.,position.y*25.-9.),8246391., 5592133., 5592133., 5624951., 5575750., 5575749., 5576565., .4)>.5) gl_FragColor = vec4(1.);
  
  float show = 0.;
  for (int i = 0; i < 2; i++) {
    show = showText(vec2(22.-position.x*25.,position.y*25.-1.),480375., 349252., 349252., 480375., 414785., 349249., 358263., .8)-.5;
  }
  if (abs(show)<.1) {
    show += showText(vec2(22.-position.x*25.,position.y*25.-1.),481111., 283732., 283732., 480359., 87121., 87121., 489303., .8)-.5;
  }
  
  if (show> .2) gl_FragColor = vec4(1);
  
  
  }

}