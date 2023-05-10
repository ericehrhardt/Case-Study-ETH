export get_results
export value_or_shadow_price

function get_results(model::Model, inputs::InputStruct)
    @info "Compiling Results"
    #initialize a new results structure
    result = ResultStruct()

    result.objective = DataFrame(Objective=objective_value(model))

    #extract primal variable solutions
    if has_values(model)
        @info "Extracting Primal Variables"
        #quanity produced
        result.quantity_produced = extract_primal_as_table(model, :q, [:producer, :year, :hour, :quantity])

        #quanity stired
        quantity_charged = extract_primal_as_table(model, :q_charge, [:storage_unit, :year, :hour, :quantity_charged])
        quantity_discharged = extract_primal_as_table(model, :q_discharge, [:storage_unit, :year, :hour, :quantity_discharged])
        if nrow(quantity_charged)>0
            result.quantity_stored = outerjoin(quantity_charged, quantity_discharged, on = [:storage_unit, :year, :hour], validate=(true, true))
        end
        
        #flow
        result.flow = extract_primal_as_table(model, :flow, [:line, :hour, :quantity])

        #built, added, retired capacity of producers
        built_capacity = extract_primal_as_table(model, :b, [:producer, :year, :built_capacity])
        retired_capacity = extract_primal_as_table(model, :r, [:producer, :year, :retired_capacity])
        added_capacity = extract_primal_as_table(model, :a, [:producer, :year, :added_capacity])
        
        #join producer capacities into single table
        production_capacity = outerjoin(built_capacity, added_capacity, on = [:producer, :year], validate=(true, true))
        production_capacity = outerjoin(production_capacity, retired_capacity, on = [:producer, :year], validate=(true, true))
        result.production_capacity = production_capacity

        #storage level
        result.storage_level = extract_primal_as_table(model, :s, [:storage_unit, :year, :hour, :kg_stored])

        #built, added, retired capacity of storage units
        built_capacity_storage = extract_primal_as_table(model, :b_stor, [:storage_unit, :year, :built_capacity])
        retired_capacity_storage = extract_primal_as_table(model, :r_stor, [:storage_unit, :year, :retired_capacity])
        added_capacity_storage = extract_primal_as_table(model, :a_stor, [:storage_unit, :year, :added_capacity])
        
        #join storage capacities into single table
        if nrow(built_capacity_storage) >0
            storage_capacity = outerjoin(built_capacity_storage, added_capacity_storage, on = [:storage_unit, :year], validate=(true, true))
            storage_capacity = outerjoin(storage_capacity, retired_capacity_storage, on = [:storage_unit, :year], validate=(true, true))
            result.storage_capacity = storage_capacity
        end
        

    end

    #extract dual variable solutions
    if has_duals(model)
        @info "Extracting Dual Variables"

        #get hydrogen prices
        result.mass_balance = extract_dual_as_table(model, :mass_balance, [:region, :year, :hour, :dual])
        result.mass_balance = unweight_dual(inputs, result.mass_balance)
        result.mass_balance = label_indices(inputs, result.mass_balance)
        result.mass_balance = unstack(result.mass_balance, [:region, :year], :hour, :dual)

        #get cost of availability constraints
        result.availability = extract_dual_as_table(model, :availability, [:producer, :year, :hour, :dual])
        result.availability = unweight_dual(inputs, result.availability)
        result.availability = label_indices(inputs, result.availability)
        result.availability = unstack(result.availability, [:producer, :year], :hour, :dual)

    end

    return result
end


function extract_primal_as_table(model::Model, s::Symbol, header::Vector)
    #extract primal solution from model into a dataframe
    result = Containers.rowtable(value, model[s]; header = header)
    result = DataFrames.DataFrame(result) 
end

function extract_dual_as_table(model::Model, s::Symbol, header::Vector)
    #extract shadow prices of a constraint into a dataframe
    result = Containers.rowtable(shadow_price, model[s]; header = header)
    result = DataFrames.DataFrame(result) 
end

function unweight_dual(inputs::InputStruct, data::DataFrame)
    #take discount factor and hour weights out of the dual variable to get prices
    #vectorize to make faster
    discount_factors = map(y->Discount_Factor(inputs, y), data[!,:year])
    hour_weights = map(i->Weight_Hour(inputs, data[i,:year], data[i,:hour]), 1:nrow(data))

    data[!, :dual] = -1*data[!,:dual]./(discount_factors.*hour_weights)
    return data
end

function label_indices(inputs::InputStruct, data::DataFrame)
    #relabel each column of indices to their appropriate labels 
    columns = names(data)

    #change year index to year
    if "year" in columns
        data[!, :year] = map(i->inputs.years[i], data[!, :year])
    end

    #change hour index to hour
    if "hour" in columns
        data[!, :hour] = map(i->inputs.hours[i], data[!, :hour])
    end

    #change region index to region
    if "region" in columns
        data[!,:region] = map(i->inputs.nodes[i], data[!, :region])
    end

    if "producer" in columns
        data[!,:producer] = map(i->inputs.prod[i], data[!, :producer])
    end
    return data
end

