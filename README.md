# SCSO
Algorithm
# Overview
SCSO (Sand Cat Swarm Optimization) is a population-based metaheuristic optimization algorithm that simulates the hunting behavior of sand cats in nature. The code provided in this repository is mainly applied to dispersion curve inversion for retrieving subsurface layer parameters such as shear wave velocity and layer thickness from geophysical exploration data.
By simulating the search, attack, and prey-catching strategies of sand cats, this algorithm can effectively solve nonlinear, multi-parameter geophysical inverse problems. This code supports Rayleigh wave dispersion curve inversion and is applicable to fields such as engineering geophysics and seismic exploration.

# System Requirements
Hardware Requirements
RAM: Minimum 12 GB (16 GB or more recommended for complex models)

Processor: Any mainstream CPU (Intel Core i5/i7 or equivalent)

Storage: Approximately 10 MB (for storing code and inversion results)

# Software Requirements
Operating System: Windows 10/11, Linux, or macOS (MATLAB-supported versions)

MATLAB Version: R2017a or later

Required Toolboxes:

Statistics and Machine Learning Toolbox (essential)

Optimization Toolbox (recommended, but not required)

# Installation and Setup
1. Download the Code
 `git clone (https://github.com/lan1041/SCSO2)
cd SCSO`
2. Add to MATLAB Path
Open matlab and run the algorithm

# Test with Synthetic Data
Run the following command to test the code with the provided synthetic data

This test script will:

- Load the synthetic  data:`test_synthetic`

- Perform inversion using default parameters

- Output the inverted layer thicknesses 、shear wave velocities and so on

Expected output: The script should execute without errors,and store in table form in a folder.

# Inversion Workflow

1. Parameter Configuration

Before running the inversion, you need to set the following parameters according to your specific requirements:
`vp;thk;density;vs;` 
You can modify those parameters on demand.
  
 2. Running the algorithm
  
 3. Obtaining inversion results
After inversion, you can extract the following results:`    xlswrite('fitbest.xlsx', fit_best,'sheet1',str);
    xlswrite('vs.xlsx', vs_best,'sheet1',str);
    xlswrite('thk.xlsx', depth_best,'sheet1',str);
    xlswrite('fr_best.xlsx', fr_best,'sheet1',str);`

4. Plotting in Origin
You can import the exported text files into Origin for professional publication-quality figures to evaluate the feasibility of the algorithm.
