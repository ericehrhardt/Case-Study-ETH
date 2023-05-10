module H2CS2
#This module loads all the necessary packages and defines all the necessary
#functions for running the H2CS2 model. 
    #load necessary packages---------------------------------------------------
    using XLSX
    using JuMP 
    using DataFrames
    using Infiltrator
    using Gurobi
    using Documenter
    import StatsFuns: norminvcdf
    import Base: repeat, cumsum


    ##run necessary code and functions -----------------------------------------
    #run model
    include("00_run/run_H2CS2.jl")

    #load inputs
    include("01_input/input_struct.jl")
    include("01_input/load_inputs.jl")
    include("01_input/data_handling.jl")

    #setup model
    include("02_setup/create_model.jl")
    include("02_setup/setup_base.jl")
    include("02_setup/coefficients.jl")
    include("02_setup/setup_transport.jl")
    include("02_setup/mass_balance_helper.jl")
    include("02_setup/setup_policy.jl")
    include("02_setup/setup_storage.jl")
    include("02_setup/setup_mass_balance.jl")
    include("02_setup/spread_producers.jl")
  
    #extract solution
    include("03_results/get_results.jl")
    include("03_results/result_struct.jl")
    include("03_results/save_results.jl")

end # module H2CS2
