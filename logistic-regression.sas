-- Hypertension model
proc genmod data=tmp descending;
model htn = male age age2 wt age*wt male*age/ dist=binomial;
  estimate 'prevalence of htn in male age 55 wt 83.928' intercept 1 male 1 age 55 age2 3025 wt 83.9228 age*wt 4615 male*age 55;
run;

-- Income model
proc genmod data=hrs_cen descending;
model fairpoor = incomec / dist=binomial;
estimate 'log OR for 40th percentile vs 20th percentile' incomec -3.42 / exp;
estimate 'log OR for 60th percentile vs 20th percentile' incomec -1.88 / exp;
estimate 'log OR for 80th percentile vs 20th percentile' incomec 0.58 / exp;
estimate 'log OR for 100th percentile vs 20th percentile' incomec 133 / exp;
run;
 
data hrs_cen;
set here.hrs;
incomec = (income-20000)/5000;
agec = (age-75)/5;
educc = (educ-10);
run;
 
