export setup_transport

@doc raw"""
    setup_transport(model::Model, inputs::InputStruct)
Add regional transportation to the model. 

The following equations are added to the model:

```math
    Objective \mathrel{+}= \sum_{e \in E} \sum_{y \in Y}\sum_{h \in H} \delta_y w_h C^{Trans}_{e,y} f_{e,y,h}
```
"""
function setup_transport(model::Model, inputs::InputStruct)

    nprod = inputs.nprod; prod = inputs.prod
    nyear = inputs.nyear; years= inputs.years
    nhour = inputs.nhour; hours = inputs.hours
    nnode = inputs.nnode; nodes = inputs.nodes
    nedge = inputs.nedge; edges = inputs.edges
    
    
    ## add transport Variables -------------------------------------------------
    @variable(model, flow[e in edges, h in hours],
        start = 0,
        lower_bound = 0)

    ## Add Transportation Limits -----------------------------------------------
    @constraint(model, flow_limit[e in 1:nedge, h in 1:nhour], 
        flow[edges[e], hours[h]] <= Flow_Limit(inputs, e, h))


    # Modify Objective ---------------------------------------------------------
    ##add transportation cost to the objective function
    #add variable cost
    for e in 1:nedge
        for y in 1:nyear
            for h in 1:nhour
                add_to_expression!(model[:obj], Discount_Factor(inputs,y)* Weight_Hour(inputs, y, h) * Cost_Transport(inputs, e, y) * flow[edges[e], hours[h]])
            end
        end
    end

end

