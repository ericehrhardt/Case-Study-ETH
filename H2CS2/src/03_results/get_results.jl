export get_results
export value_or_shadow_price

function get_results(model)
    @info "Compiling Results"
    
    #initialize a new results structure
    result = ResultStruct()

    result.objective = DataFrame(Objective=objective_value(model))

    #extract primal variable solutions
    if has_values(model)
        @info "Extracting Primal Variables"
        #quanity produced
        result.quantity = extract_primal_as_table(model, :q, [:producer, :year, :hour, :quantity])
        
        #flow
        result.flow = extract_primal_as_table(model, :flow, [:line, :hour, :quantity])

        #built, added, retired capacity
        built_capacity = extract_primal_as_table(model, :b, [:producer, :year, :built_capacity])
        retired_capacity = extract_primal_as_table(model, :r, [:producer, :year, :retired_capacity])
        added_capacity = extract_primal_as_table(model, :a, [:producer, :year, :added_capacity])
        capacity = outerjoin(built_capacity, added_capacity, on = [:producer, :year], validate=(true, true))
        capacity = outerjoin(capacity, retired_capacity, on = [:producer, :year], validate=(true, true))
        result.capacity = capacity

    end

    #extract dual variable solutions
    if has_duals(model)
        @info "Extracting Dual Variables"
        result.mass_balance = extract_dual_as_table(model, :mass_balance, [:region, :year, :hour, :dual])
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

