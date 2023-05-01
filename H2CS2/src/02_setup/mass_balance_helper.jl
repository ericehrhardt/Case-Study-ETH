export get_node_outflow
export get_node_production
export get_node_demand
export get_node_storage


"""
    get_node_outflow(model, inputs, n, y, h)

Returns an expression for the net outflow (= transportation of hydrogen away) for
a given node in a given year and hour.

The expression is in terms of the decision variables and can be used  to set up 
the mass balance constraints.
"""
function get_node_outflow(model, inputs, n, y, h)
    # Returns an expression for hydrogen transported out of node n in year year
    # and hour h.

    node = inputs.nodes[n]
    year = inputs.years[y]
    hour = inputs.hours[h]

    #identify all branches flowing out of the node
    outflow = filter(row -> row.from == node && row.year == year, inputs.transportation)

    #identify all branches flowing into the node
    inflow = filter(row -> row.to == node && row.year == year, inputs.transportation)

    #get total inflows and total outflow
    if nrow(outflow) >0
        total_outflow = sum(model[:flow][e, hour] for e in outflow.name)
    else
        total_outflow = AffExpr(0)
    end

    if nrow(inflow) >0
        total_inflow = sum(model[:flow][e, hour] for e in inflow.name)
    else
        total_inflow = AffExpr(0)
    end

    #compute net outflow from node
    net_outflow = total_outflow - total_inflow

    return net_outflow
end


"""
    get_node_production(model, inputs, n, y, h)

Returns an expression for the total hydrogen production at a given node in a 
given year and hour.

The expression is in terms of the decision variables and can be used to set up 
the mass balance constraints.
"""
function get_node_production(model, inputs, n, y, h)
    #Expression for hydrogen produced at node n in year y and hour h
    #Note that n, y, and h are all indices, not names
    node = inputs.nodes[n]
    year = inputs.years[y]
    hour = inputs.hours[h]
    
    #identify all producers at node
    producers = filter(row -> row.region == node && row.year <= year, inputs.producer)

    #compute net outflow from node
    node_production = sum(model[:q][prod, year, hour] for prod in producers.name)

    return node_production
end



"""
    get_node_storage(model, inputs, n, y, h)

Returns an expression for the net hydrogen stored at a given node in a 
given year and hour.

Net hydrogen stored is the amount of hydrogen put into storage (i.e. charged)
minus the amount hydrogen removed from storage (i.e. discharged). The expression 
is in terms of the decision variables and can be used to set up the mass balance 
constraints.
"""
function get_node_storage(model, inputs, n, y, h)
    #Expression for hydrogen produced at node n in year y and hour h
    #Note that n, y, and h are all indices, not names
    node = inputs.nodes[n]
    year = inputs.years[y]
    hour = inputs.hours[h]
    
    #identify all producers at node
    storage = filter(row -> row.region == node && row.year <= year, inputs.storage)

    if nrow(storage) > 0 
        #compute net outflow from node
        node_storage = sum(model[:q_charge][stor, year, hour] for stor in storage.name) -
            sum(model[:q_discharge][stor, year, hour] for stor in storage.name)
    else
        node_storage = AffExpr(0)
    end 
        
    return node_storage
end


"""
    get_node_demand(model, inputs, n, y, h)

Returns an expression for the total hydrogen demand at a given node in a 
given year and hour.

If there are multiple consumers at a node, the expression will contain the sum
of consumption over all consumers.
"""
function get_node_demand(model, inputs, n, y, h)
    #returns total demand at node n in year y and hour y
    node = inputs.nodes[n]
    nhour = inputs.nhour
    
    #find consumers at the given node
    consumers = filter(row -> row.region == node, inputs.consumer)

    # Add hourly demand from each consumer
    total_demand = 0;
    for row in 1:nrow(consumers) #iterate over each consumer
        base_demand = consumers[row, :hourly_demand]
        scale_column = consumers[row, :scale]   
        change_factor = inputs.time[(y-1)*nhour + h, scale_column]

        total_demand += base_demand*change_factor #add consumer demand
    end 

    return AffExpr(total_demand)
end