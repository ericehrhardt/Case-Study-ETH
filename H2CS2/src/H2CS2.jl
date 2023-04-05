module H2CS2
#This module loads all the necessary packages and defines all the necessary
#functions for running the H2CS2 model. 
    #load necessary packages
    using XLSX
    using JuMP 
    using DataFrames
    using Infiltrator
    using Gurobi

    export InputStruct
    export load_inputs

    ##run necessary code and functions
    include("00_run/run_H2CS2.jl")
    include("01_input/input_struct.jl")
    include("01_input/load_inputs.jl")
    include("01_input/data_handling.jl")
    include("02_setup/create_model.jl")
    include("02_setup/setup_base.jl")
    include("02_setup/coefficients.jl")
    include("02_setup/setup_regions.jl")
    include("02_setup/power_balance_functions.jl")





end # module H2CS2
