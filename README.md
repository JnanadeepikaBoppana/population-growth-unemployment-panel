# Population Growth, Technological Change, and Unemployment

Can economic growth offset the labor-market effects of population growth and technological change? A fixed-effects panel analysis across 12 countries, 1990-2022.

**Course project - MECO 6312.501, Applied Econometrics and Time Series Analysis, The University of Texas at Dallas (Instructor: Quanquan Liu).** Authors: Hamza Karayaka, Jnana Deepika Boppana, Chaitanya Nimmagadda, Jhanvi Rohit Patel, Bharat Sai Ganta, Michael Ugochukwu Uwazie. My contribution was the results interpretation and write-up (Section 5 of the paper / Section 4 of the deck); the SAS models were run by a teammate.

## Research Question

How do population growth and technological change affect unemployment, and to what extent can economic growth offset these effects?

## Data

- Annual panel dataset, 12 countries: United States, Germany, United Kingdom, Japan, Canada, France, South Korea, China, India, Brazil, Turkiye, Mexico.
- - Base model (Model 1): 1990-2022, 384 country-year observations.
  - - Extended models (Models 2-3): 2005-2022, 211 observations, restricted by R&D data availability.
    - - Variables: unemployment rate (World Bank WDI, ILO-modeled), population growth (computed from World Bank population totals), GDP growth (World Bank WDI), urbanization rate (World Bank WDI), mean years of schooling (Our World in Data, Barro-Lee/UNDP), R&D expenditure as % of GDP (World Bank WDI, technology proxy).
     
      - ## Method
     
      - Fixed-effects panel regression (country fixed effects, PROC PANEL / FixOne estimator in SAS) across three specifications:
     
      - - Model 1 (Base): Unemployment ~ Population Growth + GDP Growth + Urbanization + Education
        - - Model 2 (Extended): adds R&D Expenditure (% of GDP) as the technology proxy
          - - Model 3 (Interaction): adds a GDP Growth x R&D interaction term, to test whether growth moderates technology's effect on unemployment
           
            - ## Results
           
            - | Variable | Model 1 (1990-2022) | Model 2 (2005-2022) | Model 3 (2005-2022) |
            - |---|---|---|---|
            - | Population Growth | -1.401*** | -0.888** | -0.884** |
            - | GDP Growth | -0.081*** | -0.108*** | -0.134** |
            - | Urbanization | +0.101*** | +0.017 (n.s.) | +0.015 (n.s.) |
            - | Education | -0.611*** | +0.119 (n.s.) | +0.107 (n.s.) |
            - | R&D (% GDP) | - | -1.163*** | -1.178*** |
            - | GDP Growth x R&D | - | - | +0.016 (n.s.) |
            - | R-squared (within) | 0.7423 | 0.7881 | 0.7884 |
            - | N | 384 | 211 | 211 |
           
            - *** p<0.01, ** p<0.05. Coefficients verified against the original SAS PROC PANEL output (Results.pdf).
           
            - ## Key Findings
           
            - - Okun's Law holds robustly: GDP growth significantly reduces unemployment in all three models.
              - - R&D reduces unemployment: a 1-percentage-point increase in R&D spending (% of GDP) is associated with a 1.16-1.18 percentage point reduction in unemployment - over this horizon, innovation appears to create more jobs than it displaces.
                - - Growth does not moderate technology's effect: the GDP Growth x R&D interaction in Model 3 is small and statistically insignificant (beta = +0.016, p = 0.605). Economic growth and technological change act as independent forces on unemployment rather than substitutes or complements.
                  - - Population growth is negatively associated with unemployment within countries - counterintuitive at first glance, but it reflects the sample composition: high-population-growth countries in this panel (China, India) also had strong GDP expansion that absorbed the added labor supply.
                    - - Urbanization and education lose significance once the sample is restricted to 2005-2022 (Models 2-3), while education is the strongest predictor in the full 1990-2022 sample (Model 1).
                     
                      - ## Policy Implications
                     
                      - Maintaining output growth remains a primary lever for reducing unemployment. Concerns about broad automation-driven job loss may be overstated over multi-year horizons in economies with active R&D investment - but since growth and technology act independently rather than reinforcing each other, both need direct policy support rather than assuming growth alone will absorb technological disruption.
                     
                      - ## Repo Contents
                     
                      - - `population_unemployment_panel_models.sas` - reconstructed PROC PANEL script for all three models. The original .sas file wasn't available (see note in the script header); this version reproduces the documented specification and its coefficients match Results.pdf.
                        - - `Results.pdf` - original SAS output for all three models (9 pages), the source used to verify every coefficient in this README.
                          - - `Final_Paper_Complete.docx` - the full research paper (introduction, literature review, data, methods, results, conclusion, policy implications, references).
                            - - `Econ_Complete_Final.pptx` - the 20-slide project presentation.
                              - - `data/` - the six filtered World Bank / Our World in Data extracts used to build the panel (population, GDP growth, urbanization, education, R&D, unemployment), each keyed by country and year.
                               
                                - ## Note on Reconstructed Code
                               
                                - `population_unemployment_panel_models.sas` was rebuilt from the paper's documented model specifications and variable definitions, not recovered from an original file - the actual analysis was run by a teammate. Every coefficient it's meant to reproduce is independently verified against the real SAS output in Results.pdf, so the numbers in this README are the actual project results, not estimates.
                               
                                - ## Tools
                               
                                - SAS (PROC PANEL, PROC IMPORT), Microsoft Excel (data preparation)
                                - 
