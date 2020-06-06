// generate eps with asy -f eps electromagnetic.asy
// Make decent png with convert -density 600 electromagnetic.eps electromagnetic.png

import graph; 			
import palette;
import markers;

texpreamble("\usepackage[amssymb,thinqspace,thinspace]{SIunits}"); 
 
size(500,150,keepAspect=false); 
//unitsize(200cm);

real c=3e8;
real nm=1e-9;
real freq(real lambda) {return c/(lambda*nm);}
real freq_t(real lambda) {return freq(lambda)*1e-12;}
real lambda(real f) {return c/(f*nm);}
real lambda_t(real f_thz){return lambda(f_thz*1e12);}
 
real fmin_t=freq_t(1000);		// 1000 nm -> THz
real fmax_t=freq_t(300);		// 300  nm -> THz
real uv=freq_t(400);		// 400 nm -> THz
real uv_short=freq_t(100);      // 100 nm -> THz
uv_short = min(fmax_t, uv_short); // Trim to fmax_t
real ir=freq_t(700);		// 700 nm -> THz
real ir_long=freq_t(5000);	// 5  \um -> THz
ir_long = max(fmin_t, ir_long);	// Trim to fmin_t

// write("UV: 400 nm = ", uv), " THz");
write("IR: 700 nm = ");
write(ir);
write(" THz");

bounds visible=bounds(Scale(uv).x,Scale(ir).x);

void do_draw(bool draw_colors=false)
{
  scale(Log(true),Linear(true));
  xlimits(fmin_t,fmax_t);
  ylimits(0,1); 
 
  if (draw_colors){
    palette(visible,uv,ir+(0,2),Bottom,Rainbow(),invisible);
  }
  
  xaxis(Label("\tera\hertz",1),Bottom,xmin=fmin_t, xmax=fmax_t, RightTicks(Step=1), above=true); 
 
  real log10Left(real x) {return -log10(x);}
  real pow10Left(real x) {return pow10(-x);}

  scaleT LogLeft=scaleT(log10Left,pow10Left,logarithmic=true);

  picture q=secondaryX(new void(picture p) { 
      scale(p,LogLeft,Linear); 
      xlimits(p,lambda_t(fmax_t),lambda_t(fmin_t));
      ylimits(p,0,0.5); 
      xaxis(p,Label("\nano\metre",1,0.01N),Top,LeftTicks(DefaultLogFormat,Step=1)); 
    }); 
 
  add(q,above=true); 

  margin margin=PenMargin(0,0);
  // draw("radio",Scale((10,1))--Scale((5e12,1)),S,Arrow); 
  draw("infrared",Scale((ir_long,1.75))--Scale(shift(0,1.75)*ir),LeftSide,BeginArrow,margin);
  draw("UV",Scale(shift(0,1.75)*uv)--Scale((uv_short,1.75)),LeftSide,EndArrow,margin);
  draw("Visible",
       Scale((ir,1.75)) -- Scale((uv,1.75)),
       LeftSide,
       p=currentpen+linewidth(1.5bp),
       arrow=None,
       margin=margin,
       marker=marker(stickframe(currentpen+linewidth(1.5bp)), markuniform(2)));
  // draw("x-rays",Scale((1e16,1))--Scale((1e21,1)),RightSide,Arrows); 
  // draw("$\gamma$-rays",Scale((fmax,1.75))--Scale((2e18,1.75)),Arrow); 
}

do_draw(true);
shipout("visible_spectrum");

erase();
do_draw(false);
real ruby_l = 694.3;
real ruby_f = freq_t(ruby_l);

real f(real x, real y){
  return(-x);
}
bounds range = image(f, range=Full, initial=ir,final=uv+(0,0.25),palette=Rainbow(),antialias=true);

pen getcolor(real z, bounds range, pen[] palette)
{
  assert(-z >= range.min, "z is below specified range");
  assert(-z <= range.max, "z is above the specified range");
  real r_span = range.max - range.min; // the bigness of the range
  real span_frac = (-z - range.min) / r_span; // How "far into" the range is value z
  real float_idx = palette.length * span_frac;
  int idx = floor(float_idx);
  return(palette[idx]);
}

pen laser_color=getcolor(ruby_f, range, Rainbow());

draw(minipage("Ruby Laser \\ \smallskip 694.3 nm"),
     Scale((ruby_f, 0)) -- Scale(shift(0,1.75)*ruby_f),
     p=currentpen+linewidth(2bp)+laser_color,
     arrow=Arrow(size=10)
     );




shipout("ruby_laser");
