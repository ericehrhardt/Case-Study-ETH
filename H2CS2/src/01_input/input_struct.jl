mutable struct InputStruct

    #structure to store all input data tables under one object
    universal::DataFrame #table store universal inputs
    consumer::DataFrame #table to store demand data
    producer::DataFrame #table to store producer data
    transportation::DataFrame #table of transportation data
    policy::DataFrame #table of policy data
    time::DataFrame #table of producer_availability
    years   #list of simulation years
    hours   #list of hours
    prod    #list of producers
    nodes   #list of nodes
    nyear::Int64 #number of simulation years
    nhour::Int64 #number of siulatio hours per year
    nprod::Int64 #number of generators
    nnode::Int64 #number of generators
    discount_rate #discount rate


    function InputStruct()
        #initialize struct to contain empty data frames
        df = DataFrame(x = [], y = [])
        new(df, df, df, df, df, df)
    end
end