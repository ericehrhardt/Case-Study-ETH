export get_node_outflow
export get_node_production
export get_node_demand

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

    #compute net outflow from node
    net_outflow = sum(model[:flow][e, hour] for e in outflow.name) - 
        sum(model[:flow][e, hour] for e in inflow.name)

    return net_outflow
end

function get_node_production(model, inputs, n, y, h)
    #Expression for hydrogen produced at node n in year y and hour h
    #Note that n, y, and h are all indices, not names
    node = inputs.nodes[n]
    year = inputs.years[y]
    hour = inputs.hours[h]
    
    #identify all producers at node
    producers = filter(row -> row.region == node, inputs.producer)

    #compute net outflow from node
    node_production = sum(model[:q][i, year, hour] for i in producers.name)

    return node_production
end


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