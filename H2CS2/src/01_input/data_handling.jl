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

function get_years(inputs::InputStruct)
    #number of years simulated
    return unique(inputs.time.year)
end

function get_num_years(inputs::InputStruct)
    #number of years simulated
    return length(get_years(inputs))
end

function get_hours(inputs::InputStruct)
    #number of hours simulated
    return unique(inputs.time.hour)
end

function get_num_hours(inputs::InputStruct)
    #number of hours simulated
    return length(get_hours(inputs))
end

function get_prod(inputs::InputStruct)
    #number of producers
    return unique(inputs.producer.name)
end

function get_num_prod(inputs::InputStruct)
    #number of producers
    return length(get_prod(inputs))
end

function get_nodes(inputs::InputStruct)
    #number of model regions (=nodes)
    return unique(inputs.consumer.region)
end

function get_num_nodes(inputs::InputStruct)
    #number of model regions (=nodes)
    return length(get_nodes(inputs))
end

function get_edges(inputs::InputStruct)
    #number of model regions (=nodes)
    edges = unique(inputs.transportation.name)
    @assert length(edges) == nrow(inputs.transportation) "Each edge must have a unique name"
    return edges
end

function get_num_edges(inputs::InputStruct)
    #number of model regions (=nodes)
    return length(get_edges(inputs))
end

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

function add_discount_rate(inputs)
    #adds discount rate directly to input structure so that we do not need to 
    #search the input tables every time  the discount rate is required.
    row = filter(:name => ==("discount_rate"), inputs.universal)
    inputs.discount_rate = row[1,:value]
    return inputs
end
