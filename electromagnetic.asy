import graph; 
import palette;
texpreamble("\usepackage[amssymb,thinqspace,thinspace]{SIunits}"); 
 
size(500,150,keepAspect=false); 
//unitsize(200cm);

real c=3e8;
real nm=1e-9;
real freq(real lambda) {return c/(lambda*nm);} 
real lambda(real f) {return c/(f*nm);} 
 
real fmin=freq(1000);		// 1000 nm -> Hz
real fmax=freq(300);		// 300  nm -> Hz
 
scale(Log(true),Linear(true)); 
xlimits(fmin,fmax); 
ylimits(0,1); 
 
real uv=freq(400);		// 400 nm -> Hz
real uv_short=freq(100);       	// 100 nm -> Hz
uv_short = min(fmax, uv_short);	// Trim to fmax
real ir=freq(700);		// 700 nm -> Hz
real ir_long=freq(5000);	// 5  \um -> Hz
ir_long = max(fmin, ir_long);	// Trip to fmin


bounds visible=bounds(Scale(uv).x,Scale(ir).x);
palette(visible,uv,ir+(0,2),Bottom,Rainbow(),invisible);

xaxis(Label("\hertz",1),Bottom,RightTicks(n=20),above=true); 
 
real log10Left(real x) {return -log10(x);}
real pow10Left(real x) {return pow10(-x);}

scaleT LogLeft=scaleT(log10Left,pow10Left,logarithmic=true);

picture q=secondaryX(new void(picture p) { 
    scale(p,LogLeft,Linear); 
    xlimits(p,lambda(fmax),lambda(fmin));
    ylimits(p,0,1); 
    xaxis(p,Label("\nano\metre",1,0.01N),Top,LeftTicks(DefaultLogFormat,n=20)); 
  }); 
 
add(q,above=true); 

margin margin=PenMargin(0,0);
// draw("radio",Scale((10,1))--Scale((5e12,1)),S,Arrow); 
draw("infrared",Scale((ir_long,1.75))--Scale(shift(0,1.75)*ir),LeftSide,BeginArrow,margin);
draw("UV",Scale(shift(0,1.75)*uv)--Scale((uv_short,1.76)),LeftSide,EndArrow,margin);
// draw("x-rays",Scale((1e16,1))--Scale((1e21,1)),RightSide,Arrows); 
// draw("$\gamma$-rays",Scale((fmax,1.75))--Scale((2e18,1.75)),Arrow); 
