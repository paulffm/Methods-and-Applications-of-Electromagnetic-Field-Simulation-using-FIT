# Methods and Applications of Electromagnetic Field Simulation using Finite Integration Techniques

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/paulffm/Methods-and-Applications-of-Electromagnetic-Field-Simulation-using-FIT/blob/main/LICENSE)

This repository contains **MATLAB** implementations of Finite Integration Techniques based on the paper [A discretization model for the solution of Maxwell's equations for six-component fields](https://ui.adsabs.harvard.edu/abs/1977ArElU..31..116W/abstract) by T. Weiland, aimed at simulating electromagnetic field problems.

<p align="center">
  <img src="field_simulation.png"  alt="Field Simulation" width="518px" height="413px">
</p>

## Overview

Electromagnetic field simulation is crucial for various engineering applications, and Finite Integration Techniques (FIT) offer an effective approach to solving Maxwell's equations in complex geometries. This repository presents implementations of FIT methods and their applications to solve electromagnetic field problems and is organized into seven tasks, each addressing different aspects of electromagnetic field simulation:

### Task 1: Eigenvalue Solver and Convergence Study
- Discretization of 3D objects
- Convergence study of eigenvalue solver of the maxwell equations on the discretized objects

### Task 2: Mesh Creation and Geometric Matrices
- Creation of meshes
- Generation of geometric and topological matrices
- Imprinting field distributions

### Task 3: Material Matrices and Boundary Conditions
- Implementation of material matrices
- Application of boundary conditions
- Interpolation of fields

## Task 4:
- Implementation of a solver for the electrostatic problem
- Implementation of a solver for the magnetostatic problem
- Calculation of capacities
- Visualization and convergence study

## Task 5:
- Implementation of a solver for the magnetoquasistatic problem (vector and scalar) in frequency domain
- Implementation of a solver for the magnetoquasistatic problem (vector and scalar) in time domain
- Analysis of the differences between the time domain and frequency domain solution
- Error calculation and convergence study
  
## Task 6:
- Implementation of a solver using the [leapfrog method](https://www.sciencedirect.com/science/article/abs/pii/0375960190900923) for the high frequency problem in the time domain 
- Analysis of numerical stability properties
- Calculation of energy and power
  
## Task 7:
- Investigation of the high frequency problem in the time domain with lines and ports
- different line termination, different current excitations (reflection study)

## Task 8:
- Analysis of high-frequency phenomena in the frequency domain using transmission lines and ports. This involves examining signals through [Discrete Fourier Transformations](https://uvceee.wordpress.com/wp-content/uploads/2016/09/digital_signal_processing_principles_algorithms_and_applications_third_edition.pdf) to gain insights into their frequency characteristics. Additionally, we investigate scattering parameters as a further aspect of our analysis.
- different line termination, different current excitations (reflection study)

Detailed descriptions of each task and their outcomes can be found in the [report](https://github.com/paulffm/Methods-and-Applications-of-Electromagnetic-Field-Simulation-using-FIT/blob/main/Protokollheft.pdf).

## Visualization

Visualizations of electromagnetic fields obtained from simulations are provided in the repository to aid in understanding the results. These visualizations include...

## Conclusion

This repository provides a comprehensive resource for researchers and practitioners interested in electromagnetic field simulation using FIT. By implementing and exploring various FIT methods, it aims to advance understanding and applications in this field.


