%let pgm=utl-Lund-and-Prescott-tests-for-outliers-in-Bioequivalence;

Lund and Prescott tests for outliers in Bioequivalence

related repos on end

github
http://tinyurl.com/4dbkyprs
https://github.com/rogerjdeangelis/utl-Lund-and-Prescott-tests-for-outliers-in-Bioequivalence

# See Lund, R. E. 1975, "Tables for An Approximate Test for Outliers in Linear Models", Technometrics, vol. 17, no. 4, pp. 473-476.
# and Prescott, P. 1975, "An Approximate Test for Outliers in Linear Models", Technometrics, vol. 17, no. 1, pp. 129-132.

/**************************************************************************************************************************/
/*                                                    |                                                |                  */
/*                       INPUT                        |              PROCESS                           |                  */
/*                                                    |                                                |    OUTPUT        */
/*        Plot z*sequence table sd1,have              |                                                |                  */
/*                                                    |                                                |                  */
/*       0       27       54       81       108       |                                                |                  */
/*     --+--------+--------+--------+--------+---     |  have<-read_sas("d:/sd1/have.sas7bdat");       |  Obs    OUTLIERS */
/*     |                                        |     |  OUTLIERS <- as.data.frame(rp.outlier(have$Z));|                  */
/*     |                     Seq      Z         |     |                                                |   1        3.7   */
/*     |  Two outliers        1     0.24        |     |                                                |   2       -3.5   */
/*     |                      2    -1.52        |     |                                                |                  */
/*  4  +                      3     0.83        +  4  |                                                |                  */
/*     |     A (3,7)          ...               |     |                                                |                  */
/*     |                     100   -0.74        |     |                                                |                  */
/*     |                     101    0.71        |     |                                                |                  */
/*     |             A       102   -0.09        |     |                                                |                  */
/*  2  +                 A                      +  2  |                                                |                  */
/*     |         A A A  A      A                |     |                                                |                  */
/*     |       B    A A A  A           A  A     |     |                                                |                  */
/*     |  A     A A A    AB A ABA  A  A AA A    |     |                                                |                  */
/*     | A    A            BAA  AA  AA  A       |     |                                                |                  */
/*  0  +  AAAA A   A AA      A   A BA AAAAA     +  0  |                                                |                  */
/*     |    A     A    A AA A    AA    A A      |     |                                                |                  */
/*     |   A  B AAA A ABA     A   A   A   A     |     |                                                |                  */
/*     |   AAA                A A A             |     |                                                |                  */
/*     |  A     A  A                AB          |     |                                                |                  */
/* -2  +         A                              + -2  |                                                |                  */
/*     |                                        |     |                                                |                  */
/*     |                                        |     |                                                |                  */
/*     |                                        |     |                                                |                  */
/*     |                     A (-3,5)           |     |                                                |                  */
/* -4  +                                        + -4  |                                                |                  */
/*     |                                        |     |                                                |                  */
/*     --+--------+--------+--------+--------+---     |                                                |                  */
/*       0       27       54       81       108       |                                                |                  */
/*                                                    |                                                |                  */
/*                    SEQ                             |                                                |                  */
/*                                                    |                                                |                  */
/**************************************************************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
input z @@;
cards4;
0.24 -1.52 0.83 0 -1.23 -0.09 -0.65 -0.5 0.12 -1.13 -0.04 3.7
-1.11 -0.84 0.57 -0.74 1.37 1.08 0.01 -0.97 -1.63 0.95 -0.7
-2.06 1.55 -0.47 -0.74 0.71 -0.09 -1.45 1.43 -0.71 0.9 1.05 1.59
2.28 -0.2 -0.95 1.03 0 -0.21 -0.73 -0.92 -0.82 1.51 1.38 2.04
-0.45 0.94 0.87 0.87 -0.29 0.32 0.5 1.39 0.98 -0.4 0.21 0.26 -3.5
0.15 -1.25 -0.67 0.67 1.74 0.7 0.99 -1.16 0.38 0.63 0.57 -0.45
-0.19 -0.4 -1.27 -0.68 0.86 0.06 -0.19 -1.57 0.22 -0.03 -1.58
0.53 -1.49 0.06 0.97 -0.75 1.34 -0.48 0.01 0.73 0.21 0.04 -0.35
0.64 0.1 -0.9 0.01 1.29 0.79 2
;;;;
run;quit;

/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
*/

proc datasets lib=sd1 nolist mt=data mt=view nodetails;delete want; run;quit;
proc datasets lib=work nolist mt=data mt=view nodetails;delete want; run;quit;

%utl_rbegin;
parmcards4;
library(haven);
library(rapportools);
library(SASxport);
have<-read_sas("d:/sd1/have.sas7bdat");
want <- as.data.frame(rp.outlier(have$Z));
colnames(want)<-"outliers";
str(want);
for (i in 1:ncol(want)) {
      label(want[,i])<-colnames(want)[i];
      print(label(want[,i])); };
write.xport(want,file="d:/xpt/want.xpt");
;;;;
%utl_rend;

/*--- handles long variable names by using the label to rename the variables  ----*/

libname xpt xport "d:/xpt/want.xpt";
proc contents data=xpt._all_;
run;quit;

data want_r_long_names;
  %utl_rens(xpt.want) ;
  set want;
run;quit;
libname xpt clear;

proc print data=want_r_long_names;
run;quit;

/*           _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| `_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
*/

/**************************************************************************************************************************/
/*                                                                                                                        */
/* WANT_R_LONG_NAMES total obs=2                                                                                          */
/*                                                                                                                        */
/* Obs    OUTLIERS                                                                                                        */
/*                                                                                                                        */
/*  1        3.7                                                                                                          */
/*  2       -3.5                                                                                                          */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*        _       _           _
 _ __ ___| | __ _| |_ ___  __| |  _ __ ___ _ __   ___  ___
| `__/ _ \ |/ _` | __/ _ \/ _` | | `__/ _ \ `_ \ / _ \/ __|
| | |  __/ | (_| | ||  __/ (_| | | | |  __/ |_) | (_) \__ \
|_|  \___|_|\__,_|\__\___|\__,_| |_|  \___| .__/ \___/|___/
                                          |_|
*/

https://github.com/rogerjdeangelis/utl-grubs-test-for-outliers-using-r-package-outliers
https://github.com/rogerjdeangelis/utl-univariate-influential-outliers-using-robustreg
https://github.com/rogerjdeangelis/utl_bivariate_outliers
https://github.com/rogerjdeangelis/utl_visualizing_suspicious_bivariate_outliers_with_2_dimensional_boxplots

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
