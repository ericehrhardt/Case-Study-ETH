export get_years
export get_num_years
export get_hours
export get_num_hours
export get_nodes
export get_num_nodes
export get_prod
export get_num_prod
export get_edges
export get_num_edges
export add_discount_rate


"""
    get_years(inputs)

Return the model simulation years.

The model years are taken as unique year value from the 'time' input table. 
"""
function get_years(inputs::InputStruct)
    #number of years simulated
    return unique(inputs.time.year)
end


"""
    get_num_years(inputs)

Return the number of model simulation years.
"""
function get_num_years(inputs::InputStruct)
    #number of years simulated
    return length(get_years(inputs))
end


"""
    get_hours(inputs)

Return the representative hours (=sub-annual periods) simulated in the model.

The hours are identified from unique hour values of the 'time' input table. The
number of hours and their names must be the same accross all simulation years.
"""
function get_hours(inputs::InputStruct)
    #number of hours simulated
    return unique(inputs.time.hour)
end


"""
    get_num_hours(inputs)

Return the number representative hours (=sub-annual periods) simulated in 
each simulation year.
"""
function get_num_hours(inputs::InputStruct)
    #number of hours simulated
    return length(get_hours(inputs))
end


"""
    get_prod(inputs)

Return a list of all producers in the simulation.

The list of producers is the 'name' column of the producer input file. All names
in the producer table must therefore be unique in order for the code to properly
run.
"""
function get_prod(inputs::InputStruct)
    #number of producers
    return unique(inputs.producer.name)
end


"""
    get_num_prod(inputs)

Return the number of producers in the simulation.
"""
function get_num_prod(inputs::InputStruct)
    #number of producers
    return length(get_prod(inputs))
end


"""
    get_nodes(inputs)

Return a list of all nodes (=regions) in the simulation.

The list of nodes is taken as the unique values of the region column in the 
consumer spreadsheet. Every node must therefore be represented in the consumer
spreadsheet, even if the hydrogen demand in the region is zero. 
"""
function get_nodes(inputs::InputStruct)
    #number of model regions (=nodes)
    return unique(inputs.consumer.region)
end


"""
    get_num_nodes(inputs)

Return a the number of nodes (=regions) in the model.
"""
function get_num_nodes(inputs::InputStruct)
    #number of model regions (=nodes)
    return length(get_nodes(inputs))
end


"""
    get_edges(inputs)

Return a list of all edges (=transportation routes) in the simulation.

The transportation routes are identified as unique entires in the 'name' column
of the transportation inputs. Each transportation route must therefore have a
unique name. In general, each transportation route applies only in a single
year. If the same route is active throughout multiple simulation years, it must
be listed multiple times in the inputs.
"""
function get_edges(inputs::InputStruct)
    #number of model regions (=nodes)
    edges = unique(inputs.transportation.name)
    @assert length(edges) == nrow(inputs.transportation) "Each edge must have a unique name"
    return edges
end


"""
    get_num_edges(inputs)

Return the number of edges (=transportation routes) in the simulation.

"""
function get_num_edges(inputs::InputStruct)
    #number of model regions (=nodes)
    return length(get_edges(inputs))
end


"""
    add_dimensions(inputs)

Add the dimensions of the simulation to variables of the input structure.

The dimenstions include the simulation years, hours, producers, nodes, and edges.
Calculating these from the raw inputs is computationally expensive. It is
faster to only compute them once and save them in the input structure for 
repeaed use.
"""
function add_dimensions(inputs::InputStruct)
    #identify years
    inputs.years = get_years(inputs)
    inputs.nyear = get_num_years(inputs)

    #identify hours
    inputs.nhour = get_num_hours(inputs)
    inputs.hours = get_hours(inputs)

    #identify producers
    inputs.prod = get_prod(inputs)
    inputs.nprod = get_num_prod(inputs)

    #identify nodes
    inputs.nodes = get_nodes(inputs)
    inputs.nnode = get_num_nodes(inputs)

    #identify edges in transmission network
    inputs.edges = get_edges(inputs)
    inputs.nedge = get_num_edges(inputs)

    return inputs
end


"""
    add_discount_rate(inputs)

Add the discount rate as an direct variable in the input structure.

Computing the discount rate from the raw inputs is computationally expensive.
It is therefore faster to only calculate it once and save the value for later use.
"""
function add_discount_rate(inputs)
    #adds discount rate directly to input structure so that we do not need to 
    #search the input tables every time  the discount rate is required.
    row = filter(:name => ==("discount_rate"), inputs.universal)
    inputs.discount_rate = row[1,:value]
    return inputs
end

