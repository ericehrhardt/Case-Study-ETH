export InputStruct

"""
    InputStruct

Container for storing input and important parameters throughout the model. 

Each input table is stored as a separate attribute of the data structure. 
Throughout the code, factors that get repeatedly called (such as indices for
producers, consumers, nodes, etc.) are added to the data structure for
convenience and computational efficiency. In order to add a new variable to 
the data structure, it must be added to the sturcture definition. The H2CS2
package needs to be fully reloaded before that variable can be used and
accesed.

"""
mutable struct InputStruct

    #structure to store all input data tables under one object
    universal::DataFrame #table store universal inputs
    consumer::DataFrame #table to store demand data
    producer::DataFrame #table to store producer data
    transportation::DataFrame #table of transportation data
    policy::DataFrame #table of policy data
    time::DataFrame #table of producer_availability
    electricity_price::DataFrame#table of electricity prices
    gas_price::DataFrame#table of natural gas prices
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
    discount_rate::Float64


    function InputStruct()
        #initialize struct to be empty
        new()
    end
end