/**********************************************************************
 Population Growth, Technological Change, and Unemployment
  Fixed-Effects Panel Regression (PROC PANEL)
   MECO 6312.501 - Applied Econometrics and Time Series Analysis, UTD

    NOTE: This script was reconstructed from the project's documented
     methodology (Final_Paper_Complete.docx, Section 4; Econ_Complete_Final.pptx,
      slides 12-14) because the original .sas file was not available. The actual
       SAS session for this project was run by a teammate (SAS user "dal091813",
        per the file path recorded in Results.pdf). This script reproduces the same
         three model specifications and variable set documented in the paper and
          verified against the coefficients in Results.pdf; it is not the original
           code file.
           **********************************************************************/

           /* 1. Import the long-format World Bank / OWID extracts */
           proc import datafile="Population_filtered.xlsx" out=population dbms=xlsx replace; getnames=yes; run;
           proc import datafile="GDP_filtered.xlsx"        out=gdp        dbms=xlsx replace; getnames=yes; run;
           proc import datafile="Urban_filtered.xlsx"       out=urban      dbms=xlsx replace; getnames=yes; run;
           proc import datafile="Education_filtered.xlsx"  out=education  dbms=xlsx replace; getnames=yes; run;
           proc import datafile="RD_filtered.xlsx"         out=rd         dbms=xlsx replace; getnames=yes; run;
           proc import datafile="Unemployment_filtered.xlsx" out=unemployment dbms=xlsx replace; getnames=yes; run;

           /* 2. Compute population growth as year-over-year % change in Population,
                 within each country */
                 proc sort data=population; by Country_Code Year; run;

                 data population_growth;
                   set population;
                     by Country_Code;
                       lag_pop = lag(Population);
                         if first.Country_Code then Pop_Growth = .;
                           else Pop_Growth = 100 * (Population - lag_pop) / lag_pop;
                           run;

                           /* 3. Merge all series into one panel, keyed on Country_Code + Year */
                           proc sort data=population_growth; by Country_Code Year; run;
                           proc sort data=gdp;               by Country_Code Year; run;
                           proc sort data=urban;             by Country_Code Year; run;
                           proc sort data=education;         by Country_Code Year; run;
                           proc sort data=rd;                by Country_Code Year; run;
                           proc sort data=unemployment;      by Country_Code Year; run;

                           data panel_full;
                             merge population_growth(keep=Country_Name Country_Code Year Pop_Growth)
                                     gdp(keep=Country_Code Year GDP_Growth)
                                             urban(keep=Country_Code Year Urban)
                                                     education(keep=Country_Code Year Education)
                                                             rd(keep=Country_Code Year RD)
                                                                     unemployment(keep=Country_Code Year Unemployment);
                                                                       by Country_Code Year;
                                                                       run;

                                                                       /* 4. Interaction term for Model 3 */
                                                                       data panel_full;
                                                                         set panel_full;
                                                                           interaction = GDP_Growth * RD;
                                                                           run;

                                                                           /* 5. Model 1 - Base model, 1990-2022 (N = 384) */
                                                                           data model1_sample;
                                                                             set panel_full;
                                                                               where Year >= 1990 and Year <= 2022
                                                                                   and Pop_Growth ne . and GDP_Growth ne . and Urban ne .
                                                                                       and Education ne . and Unemployment ne .;
                                                                                       run;

                                                                                       proc panel data=model1_sample;
                                                                                         id Country_Code Year;
                                                                                           model Unemployment = Pop_Growth GDP_Growth Urban Education / fixone;
                                                                                           run;

                                                                                           /* 6. Model 2 - Extended model with R&D, 2005-2022 (N = 211) */
                                                                                           data model2_sample;
                                                                                             set panel_full;
                                                                                               where Year >= 2005 and Year <= 2022
                                                                                                   and Pop_Growth ne . and GDP_Growth ne . and Urban ne .
                                                                                                       and Education ne . and RD ne . and Unemployment ne .;
                                                                                                       run;
                                                                                                       
                                                                                                       proc panel data=model2_sample;
                                                                                                         id Country_Code Year;
                                                                                                           model Unemployment = Pop_Growth GDP_Growth Urban Education RD / fixone;
                                                                                                           run;
                                                                                                           
                                                                                                           /* 7. Model 3 - Interaction model, 2005-2022 (N = 211) */
                                                                                                           proc panel data=model2_sample;
                                                                                                             id Country_Code Year;
                                                                                                               model Unemployment = Pop_Growth GDP_Growth Urban Education RD interaction / fixone;
                                                                                                               run;
                                                                                                               
