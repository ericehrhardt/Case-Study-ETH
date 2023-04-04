export Cost_VOM
export Cost_FOM
export Cost_Invest
export Producer_Availability

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