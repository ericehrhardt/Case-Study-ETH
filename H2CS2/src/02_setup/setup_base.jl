export setup_base
##Notes: number of generators read from gen sheet.  Each geneartor name must be unique
##Notes: numer of regions read from consumer sheet. Each region must have consumption!
##Currently only one demand per
function setup_base(model, inputs::InputStruct)

    #extract input data 
    universal = inputs.universal 
    consumer = inputs.consumer
    producer = inputs.producer
    transportation = inputs.transportation
    producer_availability = inputs.producer_availability
    producer_cost = inputs.producer_cost

    #get number of generators, regions, hours, and years
    nyear = get_num_years(inputs); inputs.nyear = nyear
    nhour = get_num_hours(inputs); inputs.nhour = nhour
    nprod = get_num_prod(inputs); inputs.nprod = nprod
    nnode = get_num_nodes(inputs); inputs.nnode = nnode


    @info "Creating Variables"
    #quantities produced
    @variable(model, q[prod_idx in 1:nprod, year_idx in 1:nyear, hour_idx in 1:nhour],
        start = 0,
        lower_bound = 0)

   #quantities demanded
    @variable(model, d[node_idx in 1:nnode, year_idx in 1:nyear, hour_idx in 1:nhour],
        start = 0,
        lower_bound = 0) # Lower value from MATLAB E4ST minimum(res.base.bus(:, VA)) was ~-2.5e5

    # #production capacities
    # @variable(model, A0[prod_idx in 1:nprod],
    #     lower_bound = min_cap(producer, prod_idx),
    #     upper_bound = max_cap(producer, prod_idx))
    

    @info "Create Objective"

    #initialize objective equation
    #needed to be defined as an GenericAffExp instead of an Int64 so multiplied by an arbitrary var
    @expression(model, obj, 1*model[:d][1,1,1])

    ##get variable costs
    # @expression(model, "vom",
    #     sum(variable_cost(inputs, prod_idx, year_idx, hour_idx)*
    #         q[prod_idx, year_idx, hour_idx] for prod_idx=1:nprod for
    #         year_idx = 1:nyear for hour_idx = 1:nhour))

    @objective(model, Min, model[:obj])

    #add_to_expression!(model[:obj], new_term)


    variable_cost(inputs, 1,2,3)


end

function get_num_years(inputs::InputStruct)
    #number of years simulated
    return length(unique(inputs.producer_cost.year))
end

function get_num_hours(inputs::InputStruct)
    #number of hours simulated
    return length(unique(inputs.producer_cost.hour))
end

function get_num_prod(inputs::InputStruct)
    #number of producers
    return length(unique(inputs.producer.name))
end

function get_num_nodes(inputs::InputStruct)
    #number of model regions (=nodes)
    return length(unique(inputs.consumer.region))
end

function max_cap(producer::DataFrame, idx_gen)
    #maximum installed capacity
    val = producer[idx_gen, :existing_capacity] + producer[idx_gen, :buildable_capacity]
    return val

end

function min_cap(producer::DataFrame, idx_gen)
    #minimum installed capacity
    return producer[idx_gen, :existing_capacity]
end

function variable_cost(inputs, idx_prod, idx_year, idx_hour)
    nhour = inputs.nhour
    base_vom = inputs.producer[idx_prod, :fuel_cost]
    producer_region = inputs.producer[idx_prod, :region]
    producer_type = inputs.producer[idx_prod, :type]
    label = producer_region*"_"*producer_type*":variable_cost"
    change_factor = inputs.producer_cost[(idx_year-1)*nhour + idx_hour, label]
    
    return base_vom*change_factor
    
end
