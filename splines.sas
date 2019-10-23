proc contents data=here.ghb;
run;

proc print data=here.ghb (obs=15);
run;

proc univariate data=here.ghb noprint;
    var age_ghgb;
    output out=knots pctlpts=0 20 25 40 50 60 75 80 100 pctlpre=pct;
run;

proc print data=knots;
run;


*LINEAR SPLINES

    *linear spline basis;
    age  = age_ghgb;
    age2 = max(0,age-8.74743);
*age-cutpoint
    age3 = max(0,age-12.2437);
    age4 = max(0,age-15.2005);
run;


proc reg data=ghb_linear plots=predictions(X=age);
    model hba1c = age age2 age3 age4;
run;

proc glm data=ghb_linear;
    model hba1c = age age2 age3 age4 / clparm;
    contrast 'age, overall' age 1, age2 1, age3 1, age4 1;
*does age matter? do we need age?
    contrast 'age, nonlinear' age2 1, age3 1, age4 1;
*is this a linear relationship?
    estimate 'age 5' intercept 1 age 5;

    estimate 'age 10' intercept 1 age 10 age2 1.25257;
*10-age2=10-8.74743;
    estimate 'age 15' intercept 1 age 15 age2 6.25257 age3 2.7563;
*15-age2, 15-age3
    estimate 'age 20' intercept 1 age 20 age2 11.25257 age3 7.7563 age4 4.7995;
    estimate 'age 10 vs age 5' age 5 age2 1.25257;
    estimate 'age 15 vs age 10' age 5 age2 5 age3 2.7563;
    estimate 'age 15 vs age 5' age 10 age2 6.25257 age3 2.7563;
    estimate 'age 20 vs age 15' age 5 age2 5 age3 5 age4 4.7995;
    estimate 'age 20 vs age 10' age 10 age2 10 age3 7.7563 age4 4.7995;
    estimate 'age 20 vs age 5' age 15 age2 11.25257 age3 7.7563 age4 4.7995;
run;




*CUBIC SPLINES

data ghb_cubic;
    set here.ghb;

    *natural cubic spline basis;
    age  = age_ghgb;
    cub1 = max(0,(age-3.69336)**3);
    cub2 = max(0,(age-8.74743)**3);
    cub3 = max(0,(age-12.2437)**3);
    cub4 = max(0,(age-15.2005)**3);
    cub5 = max(0,(age-19.9671)**3);

    d1 = (cub1-cub5)/(19.9671-3.69336);
    d2 = (cub2-cub5)/(19.9671-8.84743);
    d3 = (cub3-cub5)/(19.9671-12.2437);
    d4 = (cub4-cub5)/(19.9671-15.2005);

    N1 = d1-d4;
    N2 = d2-d4;
    N3 = d3-d4;
run;

proc reg data=ghb_cubic plots=predictions(X=age);
    model hba1c = age N1 N2 N3;
run;

proc glm data=ghb_cubic;
    model hba1c = age N1 N2 N3 / clparm;
    contrast 'age, overall' age 1, N1 1, N2 1, N3 1;
    contrast 'age, nonlinear' N1 1, N2 1, N3 1;
    estimate 'age 5' intercept 1 age 5 N1 .137082 N2 0 N3 0;
    estimate 'age 10' intercept 1 age 10 N1 15.413695 N2 0.1751564 N3 0;
    estimate 'age 15' intercept 1 age 15 N1 88.820522 N2 21.7869082 N3 2.711259;
    estimate 'age 20' intercept 1 age 20 N1 243.249893 N2 103.7974372 N3 37.22278;
    estimate 'age 10 vs age 5' age 5 N1 15.27661 N2 0.1751564 N3 0;
    estimate 'age 15 vs age 10' age 5 N1 73.40683 N2 21.6117519 N3 2.711259;
    estimate 'age 15 vs age 5' age 10 N1 88.68344 N2 21.78691 N3 2.711259;
    estimate 'age 20 vs age 15' age 5 N1 154.42937 N2 82.0105291 N3 34.511010;
    estimate 'age 20 vs age 10' age 10 N1 227.8362 N2 103.6223 N3 37.22227;
    estimate 'age 20 vs age 5' age 15 N1 243.1128 N2 103.7974 N3 37.22227;
run;
