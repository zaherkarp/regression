data grads; set grads;
if gradyr = 2007 then recession=0;
if gradyr = 2008 then recession=0;
if gradyr = 2009 then recession=0;
if gradyr = 2010 then recession=1;
if gradyr = 2011 then recession=1;
if gradyr = 2012 then recession=1;
if gradyr = 2013 then recession=1;
if gradyr = 2014 then recession=1;
if gradyr > 2010 then afterY10=1;
if gradyr <= 2010 then afterY10=0;
earlygrads = y2+y25;
normallategrads = y3+y35+y4+y45;
earlypct=earlygrads/(normallategrads+earlygrads);
run;

proc genmod data=lawgrads ;
model   earlypct= afterY10 ;  
quit;

proc npar1way wilcoxon correct=no data=lawgrads;
      class afterY10;
      var earlypct;
      exact wilcoxon;
run; 
