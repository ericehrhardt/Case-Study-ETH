mutable struct InputStruct

    #structure to store all input data tables under one object
    universal::DataFrame #table store universal inputs
    consumer::DataFrame #table to store demand data
    producer::DataFrame #table to store producer data
    transportation::DataFrame #table of transportation data
    policy::DataFrame #table of policy data
    producer_availability::DataFrame #table of producer_availability
    producer_cost::DataFrame #table of producer_cost
    nyear::Int64 #number of simulation years
    nhour::Int64 #number of siulatio hours per year
    nprod::Int64 #number of generators
    nnode::Int64 #number of generators


    function InputStruct()
        #initialize struct to contain empty data frames
        df = DataFrame(x = [], y = [])
        new(df, df, df, df, df, df, df)
    end
end