Code and data for the paper:

*Polarization vision in terrestrial hermit crabs* (in prep 2022) Martin J. How, Alasdair Robertson, Samuel P. Smithers, David Wilby

This repository contains data and code (both R & MATLAB) for performing data analysis and plotting for the above paper.

## Repository structure

    .
    ├── data/
    │   ├── 20200212_PaleHermitCrab2
    │   ├── 20200216_PaleHermit4_i
    │   ├── 20200218_PurpleHermit_P
    │   ├── 20200221_PurpleHermit_I
    │   ├── calibrations
    │   ├── Pagurus
    |   └── csv
    ├── resources/ # MATLAB project configuration
    ├── renv/ # renv data
    ├── src # source code
    |   ├── MATLAB/
    |   |   ├── plotHermitCrabFigures.m # MATLAB function for analysis & plotting
    |   |   └── sigm_fit # MATLAB sigmoid fit function
    |   └── R/
    |       └── 01_stats.R # statistical analysis R script
    ├── LICENSE.md
    ├── HermitCrabPolVisionMATLAB.prj # MATLAB project file
    ├── HermitCrabPolarizationVision.Rproj # R project file
    └── README.md

## Experiment Analysis & Plotting (MATLAB)

### Requirements & dependencies

-   MATLAB R2016b or newer (most versions may work, but these are tested)
-   [`sigm_fit` function](https://uk.mathworks.com/matlabcentral/fileexchange/42641-sigm_fit) (provided in this repo at `src/sigm_fit`)

#### Running instructions

Instructions for plotting Figure 1: *Responses of hermit crab species to visual stimuli*

1.  Clone this repository ([instructions here for MATLAB](https://uk.mathworks.com/help/simulink/ug/clone-git-repository.html))
2.  Load the project file (`HermitCrabPolVisionMATLAB.prj`, by double-clicking in MATLAB)
3.  Run the function `plotHermitCrabFigures` to process data and plot figure 1

## Statistical Analysis (R)

### Requirements & dependencies

-   R version \>= 4
-   [`renv`](https://rstudio.github.io/renv/articles/renv.html)

### Running instructions

0.  Set up git for Rstudio if necessary: [instructions](https://jennybc.github.io/2014-05-12-ubc/ubc-r/session03_git.html)
1.  Clone this repository if you haven't already done so as above ([instructions for Rstudio here](https://datacarpentry.org/rr-version-control/03-git-in-rstudio/index.html))
2.  Install the package [`renv`](https://rstudio.github.io/renv/articles/renv.html) if not already installed.
3.  Run the command `renv::restore()` to install the required packages.
4.  Source/run the `01_stats.R` script to reproduce the analysis.
