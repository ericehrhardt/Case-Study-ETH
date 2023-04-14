export Cost_VOM
export Cost_FOM
export Cost_Invest
export Producer_Availability
export Max_Capacity
export Flow_Limit
export Cost_Transport
export Weight_Hour

function Cost_VOM(inputs::InputStruct, idx_prod::Int, idx_year::Int, idx_hour::Int)
    
    #check that correct rows have been identified
    nhour = inputs.nhour
    @assert inputs.prod[idx_prod] == inputs.producer[idx_prod,:name]
    @assert inputs.hours[idx_hour] == inputs.time[(idx_year-1)*nhour + idx_hour, :hour]
    @assert inputs.years[idx_year] == inputs.time[(idx_year-1)*nhour + idx_hour, :year]

    #generator variable cost for a given producer, year, and hour
    base_vom = inputs.producer[idx_prod, :variable_cost]
    scale_column = inputs.producer[idx_prod, :vom_scale]   
    change_factor = inputs.time[(idx_year-1)*nhour + idx_hour, scale_column]

    return base_vom*change_factor
    
end

function Cost_FOM(inputs::InputStruct, idx_prod::Int, idx_year::Int)
    #check that correct rows have been identified
    @assert inputs.prod[idx_prod] == inputs.producer[idx_prod,:name]

    #generator fixed cost for a given producer and year
    fom = inputs.producer[idx_prod, :fixed_cost]
    
    return fom
end

function Cost_Invest(inputs::InputStruct, idx_prod::Int, idx_year::Int)
    #check that correct rows have been identified
    @assert inputs.prod[idx_prod] == inputs.producer[idx_prod,:name]
    
    #capital cost only applied in year that power plant is built
    build_year = inputs.producer[idx_prod, :year]
    current_year = inputs.years[idx_year]

    if build_year == current_year
        cost_invest = inputs.producer[idx_prod,:annualized_investment_cost]
    else
        cost_invest = 0;
    end

    return cost_invest
end

function Discount_Factor(inputs::InputStruct, idx_year::Int)
    # function to compute time discounting factor in the objective function

    #determine current year and base year
    current_year = inputs.years[idx_year]
    base_year = inputs.years[1]
    discount_rate = inputs.discount_rate

    #compute discount factor
    discount_factor = 1/(1+discount_rate)^(current_year - base_year)

    return discount_factor
end

function Producer_Availability(inputs::InputStruct, idx_prod::Int, idx_year::Int, idx_hour::Int)
    # function to compute time discounting factor in the objective function

    #check that correct rows have been identified
    nhour = inputs.nhour
    @assert inputs.prod[idx_prod] == inputs.producer[idx_prod,:name]
    @assert inputs.hours[idx_hour] == inputs.time[(idx_year-1)*nhour + idx_hour, :hour]
    @assert inputs.years[idx_year] == inputs.time[(idx_year-1)*nhour + idx_hour, :year]

    #generator variable cost for a given producer, year, and hour
    base_availability = inputs.producer[idx_prod, :availability_factor]
    scale_column = inputs.producer[idx_prod, :availability_scale]   
    change_factor = inputs.time[(idx_year-1)*nhour + idx_hour, scale_column]

    return base_availability*change_factor
end

function Max_Capacity(inputs::InputStruct, idx_prod::Int, idx_year::Int)
    #maximum buildable capacity of a generator for a given year

    #check that correct rows have been identified
    @assert inputs.prod[idx_prod] == inputs.producer[idx_prod,:name]
    
    #capital cost only applied in year that power plant is built
    build_year = inputs.producer[idx_prod, :year]
    current_year = inputs.years[idx_year]

    if build_year == current_year
        Amax = inputs.producer[idx_prod,:buildable_capacity]
    else
        Amax = 0;
    end

    return Amax
end

function Existing_Capacity(inputs::InputStruct, idx_prod::Int)
    #pre-existing capacity in the first simulation year for each generator

    #check that correct rows have been identified
    @assert inputs.prod[idx_prod] == inputs.producer[idx_prod,:name]
    existing = inputs.producer[idx_prod, :existing_capacity]

    return existing
end

function Flow_Limit(inputs::InputStruct, idx_edge::Int, idx_hour::Int)
    #check that correct edge is identified
    @assert inputs.transportation[idx_edge,:name] == inputs.edges[idx_edge]

    #identify flow limit
    return inputs.transportation[idx_edge, :flow_limit]
end

function Cost_Transport(inputs::InputStruct, idx_edge::Int, idx_year::Int)
    #check that correct edge is identified
    @assert inputs.transportation[idx_edge,:name] == inputs.edges[idx_edge]

    edge_year = inputs.transportation[idx_edge,:year] #year in which edge is active
    current_year = inputs.years[idx_year] #current model year
    
    #The transportation cost is set to zero when the year under consideration
    #does not match the year the transport medium is operational. This is a 
    #trick to ensure that the proper discount factor is applied to the transportation
    #cost term even though the flow variable is independent of the year.
    if (edge_year == current_year) 
        distance_km = inputs.transportation[idx_edge,:distance]
        cost_per_km = inputs.transportation[idx_edge,:cost]
        cost_transport = distance_km*cost_per_km
    else
        cost_transport = 0
    end
end

function Weight_Hour(inputs::InputStruct, idx_year::Int, idx_hour::Int)   
    #check that correct rows have been identified
    nhour = inputs.nhour
    @assert inputs.hours[idx_hour] == inputs.time[(idx_year-1)*nhour + idx_hour, :hour]
    @assert inputs.hours[idx_hour] == inputs.time[(idx_year-1)*nhour + idx_hour, :hour]

    #return weight of hour
    weight = inputs.time[(idx_year-1)*nhour + idx_hour, :weight]
    
    return weight
    
end