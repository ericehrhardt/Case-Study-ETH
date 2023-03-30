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
    include("01_input/input_struct.jl")
    include("01_input/load_inputs.jl")
    include("02_setup/create_model.jl")
    include("02_setup/setup_base.jl")


end # module H2CS2
