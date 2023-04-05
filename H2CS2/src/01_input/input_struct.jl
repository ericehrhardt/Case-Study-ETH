mutable struct InputStruct

    #structure to store all input data tables under one object
    universal::DataFrame #table store universal inputs
    consumer::DataFrame #table to store demand data
    producer::DataFrame #table to store producer data
    transportation::DataFrame #table of transportation data
    policy::DataFrame #table of policy data
    time::DataFrame #table of producer_availability
    years::Vector   #list of simulation years
    hours::Vector   #list of hours
    prod::Vector    #list of producers
    nodes::Vector   #list of nodes
    edges::Vector  #list of transportation routes (i.e. edges on transportation graph)
    nyear::Int64 #number of simulation years
    nhour::Int64 #number of siulatio hours per year
    nprod::Int64 #number of generators
    nnode::Int64 #number of generators
    nedge::Int64 #number of transportation routes
    discount_rate #discount rate


    function InputStruct()
        #initialize struct to be empty
        new()
    end
end