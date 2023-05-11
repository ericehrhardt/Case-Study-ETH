## Introduction

Welcome to the Hydrogen Case Study 2 (H2CS2) model!

This model is a complete optimization model for the European Hydrogen system.
It was developed by Davide Berti, Eric Ehrhardt, Christoph Funke, and Federico
Sartore for the Case Study course of ETH's Masters in Energy Science and Technology.
We hope that you enjoy our model.

## Installation Instructions

This model was developed using VS Code on Windows using Julia Version 1.8. 
The model is programed as a package containing a series of functions and data
structures which can be loaded and utilized in standard Julia code. The 
following steps will install and activate the model under this setup.

1\. Clone the git repository 

```julia
git clone https://github.com/ericehrhardt/Case-Study-ETH.git
```
2\. From inside the project directory, navigate into the folder H2CS2

```julia
cd H2CS2
```

3\. Enter into to package environment. If done correctly, the termial should now turn into a julia promt.

```julia
julia --project=.
``` 
4\. Type ']' to enter Julia's package manager. If steps 1-3 are properly executed, the prompt should display: (H2CS2) pkg>. From the package manager, type 'instantiate' to install all required packages and dependencies for the model.

```julia
instantiate
```
Exit the package manager by pressing backspace until the "julia>" prompt returns.

5\. Run the model by executing:
```julia
include("main.jl")
```
The function "include" is Julia's command for running a file. The standard "run" 
button in VS Code does not work.

## Gurobi

The model currently uses Gurobi optimizer, although it can easily be adapted
to use other solvers. To use Gurobi, first install Gurobi on your computer. Then
add the path to Gurobi executing the following command in a Julia terminal:

```julia
ENV["GUROBI_HOME"] = <path_to_gurobi>
```


The path_to_gurobi may for instance be: "C:\\gurobi1000\\win64".

After adding path, install the Julia Gurobi interface by running:

```julia
Pkg.add("Gurobi")
Pkg.build("Gurobi")
```