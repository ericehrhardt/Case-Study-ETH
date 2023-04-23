export Cost_VOM
export Cost_FOM
export Cost_Invest
export Producer_Availability
export Max_Capacity
export Existing_Capacity
export Flow_Limit
export Cost_Transport
export Weight_Hour
export Discount_Factor

@doc raw"""
    Cost_VOM(inputs::InputStruct, idx_prod::Int, idx_year::Int, idx_hour::Int)

Extracts the variable cost ($C_{i,y,h}^V$) of a specified producer in a given year and hour.

For each producer, the variable cost is calculated as:

```math
\begin{aligned}
    C_{i,y,h}^V  =\:& \mathrm{nonfuel\_variable\_cost}\:+\\
    & \mathrm{electricity\_requirement}*\mathrm{electricity\_price}\:+\\
    &  \mathrm{gas\_requirement}*\mathrm{gas\_price}
\end{aligned}
```

ARGUMENTS:

inputs (InputStruct) ... data structure containing inputs

idx_producer (Int)... index of producer for which to get cost

idx_year (Int) ... index of year for which to get cost

idx_hour (Int)... index of hour for which to get cost

"""
function Cost_VOM(inputs::InputStruct, idx_prod::Int, idx_year::Int, idx_hour::Int)
    
    #check that correct rows have been identified
    nhour = inputs.nhour
    @assert inputs.prod[idx_prod] == inputs.producer[idx_prod,:name]
    @assert inputs.hours[idx_hour] == inputs.electricity_price[(idx_year-1)*nhour + idx_hour, :hour]
    @assert inputs.years[idx_year] == inputs.electricity_price[(idx_year-1)*nhour + idx_hour, :year]
    @assert inputs.hours[idx_hour] == inputs.gas_price[(idx_year-1)*nhour + idx_hour, :hour]
    @assert inputs.years[idx_year] == inputs.gas_price[(idx_year-1)*nhour + idx_hour, :year]

    #generator variable cost for a given producer, year, and hour
    nonfuel_vom = inputs.producer[idx_prod, :nonfuel_variable_cost]
    electricity_requirement = inputs.producer[idx_prod, :electricity_requirement]
    gas_requirement = inputs.producer[idx_prod, :gas_requirement]
    region = inputs.producer[idx_prod, :region]
    gas_price = inputs.gas_price[(idx_year-1)*nhour + idx_hour, region]
    electricity_price = inputs.electricity_price[(idx_year-1)*nhour + idx_hour, region]

    variable_cost = nonfuel_vom + electricity_requirement*electricity_price +
        gas_requirement*gas_price


    return variable_cost
    
end


@doc raw"""
    Cost_FOM(inputs::InputStruct, idx_prod::Int, idx_year::Int)

Extracts the annual fixed cost cost ($C_{i,y,h}^F$) of a specified producer in 
a given year. 

For each producer, the fixed cost is taken directly from the
producer inputs. We currently assume that annual fixed costs do not change over
time. 

ARGUMENTS:

inputs (InputStruct) ... data structure containing inputs

idx_producer (Int)... index of producer for which to get cost

idx_year (Int) ... index of year for which to get cost

"""
function Cost_FOM(inputs::InputStruct, idx_prod::Int, idx_year::Int)
    #check that correct rows have been identified
    @assert inputs.prod[idx_prod] == inputs.producer[idx_prod,:name]

    #generator fixed cost for a given producer and year
    fom = inputs.producer[idx_prod, :fixed_cost]
    
    return fom
end


@doc raw"""
    Cost_Invest(inputs::InputStruct, idx_prod::Int, idx_year::Int)

Extracts the investment cost ($C_{i,y,h}^I$) of a specified producer in a given year.

The investment cost is only applied during the year in which a producer adds
capacity. For all other years, the investment cost is zero. When applicable,
the investment cost is taken directly from the producer inputs.

ARGUMENTS:

inputs (InputStruct) ... data structure containing inputs

idx_producer (Int)... index of producer for which to get cost

idx_year (Int) ... index of year for which to get cost

idx_hour (Int)... index of hour for which to get cost

"""
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


@doc raw"""
    Discount_Factor(inputs::InputStruct, idx_year::Int)

Calculates the discount factor $\delta_y$ for a given year.

The discount factor is currently taken as a single-year discount factor of the 
following form:

```math
\delta_y = \frac{1}{(1 + r)^{t-t_0}}
```

where $r$ is the discount rate, $t$ is the current simulation year, and $t_0$
is the base simulation year.

ARGUMENTS:

inputs (InputStruct) ... data structure containing inputs

idx_year (Int) ... index of year for which to get cost
"""
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


@doc raw"""
    Producer_Availability(inputs::InputStruct, idx_prod::Int, idx_year::Int, idx_hour::Int)

Extracts the producer availability factor ($\Gamma_{i,y,h}$) of a specified producer 
in a given year and hour.

For each producer, the availability factor is calculated as:

```math
    \Gamma_{i,y,h}  =\: \mathrm{base\_availability}*\mathrm{scale\_factor}
```

where the base availability is taken directly from the "producer" inputs and the 
scale factor is taken for the corresponding column in the "time" inputs. The 
scale factor varies by year and hour.


ARGUMENTS:

inputs (InputStruct) ... data structure containing inputs

idx_producer (Int)... index of producer for which to get cost

idx_year (Int) ... index of year for which to get cost

idx_hour (Int)... index of hour for which to get cost

"""
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


@doc raw"""
    Max_Capacity(inputs::InputStruct, idx_prod::Int, idx_year::Int)

Extracts the maximum capacity ($A_{i,y}^{max}$) that can be added by a producer in a given year. 
 
By design, each producer can only build capacity in a single year. During that year,
the max buildable capacity is taken directly from the producer inputs. During 
every other year, the maximum capacity is set to zero. 

ARGUMENTS:

inputs (InputStruct) ... data structure containing inputs

idx_producer (Int)... index of producer for which to get cost

idx_year (Int) ... index of year for which to get cost

"""
function Max_Capacity(inputs::InputStruct, idx_prod::Int, idx_year::Int)

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

@doc raw"""
    Existing_Capacity(inputs::InputStruct, idx_prod::Int)

Extracts the pre-existing capacity ($B_{i,0}$) for each producer at the beginning
of the first simulation year. 
 
The pre-existing capacity is taken direclty from the "producer" input table.

ARGUMENTS:

inputs (InputStruct) ... data structure containing inputs

idx_producer (Int)... index of producer for which to get cost

idx_year (Int) ... index of year for which to get cost

"""
function Existing_Capacity(inputs::InputStruct, idx_prod::Int)
    #pre-existing capacity in the first simulation year for each generator

    #check that correct rows have been identified
    @assert inputs.prod[idx_prod] == inputs.producer[idx_prod,:name]
    existing = inputs.producer[idx_prod, :existing_capacity]

    return existing
end


@doc raw"""
    Flow_Limit(inputs::InputStruct, idx_edge::Int, idx_hour::Int)

Extracts the pre-existing capacity ($F_{e,y}^{max}$) for a given transportation route
and in a given year.

The flow limit is taken directly from the "transportation" input table.

ARGUMENTS:

inputs (InputStruct) ... data structure containing inputs

idx_producer (Int)... index of producer for which to get cost

idx_year (Int) ... index of year for which to get cost

"""
function Flow_Limit(inputs::InputStruct, idx_edge::Int, idx_hour::Int)
    #check that correct edge is identified
    @assert inputs.transportation[idx_edge,:name] == inputs.edges[idx_edge]

    #identify flow limit
    return inputs.transportation[idx_edge, :flow_limit]
end


@doc raw"""
    Cost_Transport(inputs::InputStruct, idx_edge::Int, idx_year::Int)

Extracts the transportation cost factor ($C_{e,y}^{Trans}$) of along a specified
transportation route (edge) for a given year.

For each edge, the cost is calculated as:

```math
    C_{e,y}^{Trans}  =\: \mathrm{distance}*\mathrm{cost\_per\_unit\_distance}
```

ARGUMENTS:

inputs (InputStruct) ... data structure containing inputs

idx_edge (Int)... index of transportation route for which to get cost.

idx_year (Int) ... index of year for which to get cost.

"""
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


@doc raw"""
    Weight_Hour(inputs::InputStruct, idx_year::Int, idx_hour::Int)

Extracts the hour weight ($w_h$) of a given hour in a given year.

Each hour in the model is a "representative" for a collection of hours 
throughout the year. For instance, we may simulate only one hour to represent
all hours wihtin the month of January. The hour weight gives the number of
real-life hours represented by a the given simuation hour. It is used to weight 
the objective function. The hour weights are taken directly from the "time" input
table.

ARGUMENTS:

inputs (InputStruct) ... data structure containing inputs

idx_year (Int) ... index of year for which to get cost

idx_hour (Int)... index of hour for which to get cost

"""
function Weight_Hour(inputs::InputStruct, idx_year::Int, idx_hour::Int)   
    #check that correct rows have been identified
    nhour = inputs.nhour
    @assert inputs.hours[idx_hour] == inputs.time[(idx_year-1)*nhour + idx_hour, :hour]
    @assert inputs.hours[idx_hour] == inputs.time[(idx_year-1)*nhour + idx_hour, :hour]

    #return weight of hour
    weight = inputs.time[(idx_year-1)*nhour + idx_hour, :weight]
    
    return weight
    
end