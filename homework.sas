LIBNAME assn1 'H:\PHS 552';
* 1.a. Summary table of descriptive statistic;
proc means data=assn1.wisc_3rd n mean var std stderr; run;

* 1.b. Below is data for first 5 observations;
proc print data=assn1.wisc_3rd (obs=5); run;

data assn1.wisc_3rd;
     set assn1.wisc_3rd;
     if sex="M" then gender=0;
     if sex="F" then gender=1;
run;

proc reg data = assn1.wisc_3rd;
     model wt = gender / clb;
     output out=rr r=resid p=pred;
run;

* 1.c. For the change in gender (due to dichotomous 1/0 gender variable) from male to female, there is a decrease in weight by 1.14153 kg;

     proc means data = assn1.wisc_3rd; var ht; run;
     data assn1.wisc_3rd;
          set assn1.wisc_3rd;
          scaled_ht = (ht-138.4305618)/7.3324678;
     run;
     proc reg data = assn1.wisc_3rd;
          model wt = scaled_ht / clb;
          output out=rr r=resid p=pred;
     run;
     proc univariate data=rr normal plot;
      var resid;
      run;

* 1.d.i: For the regression model of weight on height the intercept is -80.38 (-92.72, -68.03) and the slope is 0.83 (0.75, 0.93);
* 1.d.ii: For every 1 SD increase in height, there is a 6.15551 kg increase in weight;
* 1.d.iii: See attached. Z scores were calculated at p=0.05. (notes: SD of wt (8.7689553), unscaled intercept (-80.37675), unscaled slope (0.83949));

     proc means data = assn1.wisc_3rd; var ht; run;
          proc reg data = assn1.wisc_3rd;
          model wt = ht / clb;
          output out=rr r=resid p=pred;
     run;

* 1.d.iv. The assumption of normality is supported by the positive relationship between the two variables. The assumption of independence is difficult to discern given the lack of knowledge about the data sources. Variance of the residuals appears to be slightly positive but looks almost normal. The residual line seems to demonstrate some linearity.


* 1.e.i.: Regression analysis to determine the effect of weight on height using log transform. The intercept's CI is 0.44 (0.12, 0.75) and the height's CI is 0.02 (0.02, 0.02).;

data assn1.wisc_3rd;
set assn1.wisc_3rd;
log_wt=log(wt);
run;

proc reg data = assn1.wisc_3rd;
     model log_wt = ht / clb;
     output out=rr r=resid p=pred;
run;

*1.e.ii: Given log(y), for every 1 cm increase, 0.02251 kg is gained. Once transformed, e^0.2251 is 1.02, therefore, for every 1 cm increase, 1.02 kg is gained.;

*1.e.iii: SD, unscaled intercept, unscaled slope
 
* 1.e.iv. No assumptions seemm to be violated but independence cannot truly be assessed. Linearity seems good given residuals, constant variance seems OK since residuals symmetric and spread around 0, Normality seems good given the histogram.

* 1.e.v. The log model appears to fit better as it is more normal in the histogram and it is supported by the improvement in adjusted r^2. The adjusted r^2 for the log model was 0.5198 whereas it was previously 0.4913. However, these both remain between r=0.03-0.05 which

*2.a.i. Regression line appears to give a good fit to the data, the data seems clearly negatively correlated.;

proc gplot data = assn1.muscle;
plot muscle_mass*age;
run;

proc reg data = assn1.muscle;
     model muscle_mass = age / clb;
     output out=rr r=resid p=pred;
run;

*2.a.ii. The intercept is 156.34 (145.31, 167.38) and the slope is -1.19 (-1.37, -1.01).;
*2.a.iii. For every 1 year increase in age, muscle mass decreases by 1.19 pounds.;
*2.a.iv. Yes.
*2.a.v. The regression model assumes normality, linearity, constant variance, and independence. The residuals s


*2.b.i. There is a very large negative correlation between age and muscle mass (r=-0.86606);
proc corr data = assn1.muscle fisher;
     var muscle_mass age;
run;

*2.b.ii. -0.86606*sqrt(58/0.2499400764) = t = -13.193. T-score for 58 DF was 2.663, therefore since t-distribution is symmetrical t = 13.193 and therefore the two variables are stattistically independent.;

*2.b.iii.;
proc corr data = assn1.muscle spearman;
     var muscle_mass age;
run;

*2.b.iv. -0.86572*sqrt(58/(1--0.86572^2)) = t = -4.985.

*2.b.v. Spearman had  lower R value and had a lower t-score. Given this, the monotonic relationship measured in the Spearman analysis may not be as powerful as the linear relationship measured by Pearson. Additionally, it may be that the flexibility of Spearman as it uses ranks may be less suited to this comparison as the variables are continuous.

*2.b.vi. The correlation coefficient is rarely comparable, however given that the groups are identical, this one able to compare R values.

libname session10 'F:\SAS\SESSION10';
*review;
%macro rename (DSN = , name = , newname = );
data new (rename = (&name = &newname));
set &DSN;
run;
proc print data = new;
title in datatbase &DSN, the macro renamed &name to &newname;
run;
title;
%mend rename;
*double checking
%rename (DSN = session10.intake_as5, name = SEX, newname = GENDER);
%rename (DSN = session10.intake_as5, name = BD, newname = BIRTHDATE);

data intake; set session10.intake_as5; run;
proc contents data = sashelp.cars; run;
proc print data = sashelp.cars; run;
data work.cars; set sashelp.cars; run;
proc sort data = work.cars; by TYPE MSRP; run;
proc print data = work.cars; run;
 *this next step only works because we already sorted it;
data cheapest_cars; set cars;
by TYPE MSRP;
*needs to be in the SAME ORDER that we sorted by;
if first.type;
proc print; run;
*there were only 6 types of cars, and it lists the cheapest one in each category;
data cars_2; set cars;
by type msrp;
*put will put everything into the log screen, which is helpful for debugging;
put type = model = msrp = last.type= first.type=;
firsttype = first.type;
lasttype = last.type;
title 'specifying first.type and last.type of each car';
run;
proc print; run;
data mostexp_cars; set cars;
put make = model = msrp= last.type = first.type=;
by type msrp;
if last.type;
run;
proc print; run;
proc sort data = cars;
by type cylinders;
run;
title;
data cars_2; set cars;
by type cylinders;
if first.cylinders;
if last.cylinders;
*this would be unique amount of cylinders. should only get cars of that type with that number of cylinders;
run;
proc print;
run;
proc sql;
select advisor, study_age
from session10.intake_as5;
quit;
proc sql;
select studyid, advisor, study_age
from session10.intake_as5
where LOWCASE (advisor) LIKE "%martinez%" AND study_age IS NOT NULL;
QUIT;
proc print data = session10.intake_as5;
var studyid advisor study_age;
where lowcase(advisor) LIKE "%martinez%" and Not Missing(Study_age);
run;
PROC SQL;
select sex,
   COUNT(*) Label = "Observations",
   AVG(Study_age) Label = "Average age" Format =5.2
   FROM session10.intake_as5
   GROUP BY Sex;
QUIT;

*this was much faster than the corresponding Proc statements would have been, see below;


PROC SORT DATA=session10.intake_as5; BY sex; RUN;

PROC MEANS DATA=session10.intake_as5 NOPRINT;
VAR study_age;
BY sex;
OUTPUT OUT=counts MEAN=avg_age;
RUN;

PROC PRINT DATA=counts LABEL;
VAR sex _freq_ avg_age;
LABEL
_freq_ = "Observations"
avg_age = "Average age";
FORMAT avg_age 5.2;
RUN;

proc sql;
select
   upcase(pie) as up_pie label = "Type of pie",
   count(*) as pie_count label  = "count"
from intake
where pie is NOT null
group by up_pie
having pie_count>1
order by pie_count desc, up_pie;
quit;

*this did a lot of things in one step;

DATA L13_1;
LENGTH NAME $ 60.;
INPUT GROUP $ GENDER $ NAME $;
DATALINES;
*insert names
;
RUN;
PROC PRINT; RUN;

title1 'surveyselecte example - does not run';
proc surveyselect data = l13_1; run;
*samplesize?;

title1 'surveyselect example - srs random sampling';
title2 'winner#1';
proc surveyselect data = l13_1 out =l13_sample_1 sampsize =1; run;
proc print; run;
*a new winner is chosen each time;

title1 'third run - self-selection';
title2 'winner #2';
proc surveyselect data = l13_1 out = l_13_sample_1 sampsize =1 seed =530; run;
proc print; run;
*now if you run it you get the same winner;


*what if we wanted to have one female winner and one male winnter?;
PROC SORT DATA = L13_1; BY GENDER; RUN;
TITLE1 "ONE WINNER PER GENDER";
PROC SURVEYSELECT DATA = L13_1 OUT = L13_SAMPLE_1 SAMPSIZE = 1 METHOD=SRS;
STRATA GENDER; RUN;     
PROC PRINT; RUN;


*or if we wanted one winner per graduate program;
PROC SORT DATA = L13_1; BY GROUP; RUN;
TITLE1 "ONE WINNER PER GROUP";
PROC SURVEYSELECT DATA = L13_1 OUT = L13_SAMPLE_1 SAMPSIZE = 1 METHOD=SRS;
STRATA GROUP; RUN;     
PROC PRINT; RUN;


*macros revisited;
data l12_1; set l13_1; run;
PROC SORT DATA = L12_1; BY GROUP; RUN;
PROC SURVEYSELECT DATA = L12_1 OUT = L12_SAMPLE_1 SAMPSIZE = 1 METHOD=SRS;
STRATA GROUP; RUN;     
PROC PRINT; RUN;


%macro selection (method, strat);
proc sort data = l12_1;  by &strat; run;
title1 ONE WINNER (&strat by method &method);
proc surveyselect data = l12_1 out = l12_sample_1 sampsize =1 method = &method;
strata &strat; run; proc print; run;
%mend selection;

%selection (srs, gender);
%selection (urs, group);

*now let's say we wanted to be able to change the sample size;
%macro selection (method, strat, samp);
proc sort data = l12_1;  by &strat; run;
title1 ONE WINNER (&strat by method &method);
proc surveyselect data = l12_1 out = l12_sample_1 sampsize =&samp method = &method;
strata &strat; run; proc print; run;
%mend selection;

%selection (urs, gender, 5);
*this gives out 5 female and 5 male winners;


data question1; set sashelp.zipcode; run;
proc sort data = question1; by county zip; run;
proc contents data = question1; run;

data wisconsin; set question1;
if STATECODE NE "WI" then delete;
run;
proc contents data = wisconsin; run;
proc sort data = wisconsin; by county; run;
proc print data = wisconsin; run;
*all counties have at least one zipcode therefore there are 72  counties taht have at least one zipcode in WI;

data america; set question1;
run;
proc sort data = america; by COUNTY ZIP ; run;
data new; set america;
by county zip;
if first.county;
if last.county;
run;
proc print; run;
*answer to 2a: 21.
answer to 2b: Virginia has 11, Texas has 5, Alaska has 4, and Puerto Rico has 1;

data wi_zip; set sashelp.zipcode;
if STATECODE NE "WI" then delete;
run;
proc sort data = wi_zip; by county zip; run;
proc surveyselect data = wi_zip out = wis sampsize = 1 seed = 12132013 method = srs;
strata county;
run;
proc print; run;
*53718 was chosen for Dane county;

*question 4;
proc print data = intake_as9 NOOBS; run;

*question 5;
proc sql;
select
   BMI,
   SEX_NUM,
   AGE AS age label = "AGE AT START of PHS451"
from intake_as9
WHERE BMI >30
;
QUIT;
