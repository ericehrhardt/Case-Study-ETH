export setup_regions

@doc raw"""
    setup_regions(model::Model, inputs::InputStruct)
Add regional mass balance and hydrogen transportation to the model. 

The following equations are added to the model:

```math
    Objective \mathrel{+}= \sum_{e \in E} \sum_{y \in Y}\sum_{h \in H} \delta_y w_h C^{Trans}_{e,y} f_{e,y,h}
```
Mass balance:
```math
    \sum_{i\in P_r} q_{i,y,h} - \sum_{k \in K_r} D_{i,h,r} -\sum_{\substack{e \in E\\ \text{s.t}\: e = (r,j)}} (f_{e,y,h}) + \sum_{\substack{e \in E\\ \text{s.t}\: e = (j,r)} } (f_{e,y,h}) = 0 \qquad\forall r, y, h
```
"""
function setup_regions(model, inputs::InputStruct)

    nprod = inputs.nprod; prod = inputs.prod
    nyear = inputs.nyear; years= inputs.years
    nhour = inputs.nhour; hours = inputs.hours
    nnode = inputs.nnode; nodes = inputs.nodes
    nedge = inputs.nedge; edges = inputs.edges
    

    ## add transport Variables -------------------------------------------------
    @variable(model, flow[e in edges, h in hours],
        start = 0,
        lower_bound = 0)


    ## Compute Mass Balance ----------------------------------------------------

    # Mass Flow Out of Certain Node
    @expression(model, node_outflow[n in 1:nnode, y in 1:nyear, h in 1:nhour], get_node_outflow(model, inputs, n, y, h))
    
    # Demand at a Certain Node
    @expression(model, node_demand[n in 1:nnode, y in 1:nyear, h in 1:nhour], get_node_demand(model, inputs, n, y, h))
       
    # Production at a given Node
    @expression(model, node_prod[n in 1:nnode, y in 1:nyear, h in 1:nhour], get_node_production(model, inputs, n, y, h))
        
    ## add mass balance constraint!
    @constraint(model, mass_balance[n in 1:nnode, y in 1:nyear, h in 1:nhour],
        model[:node_prod][n, y, h] - model[:node_demand][n, y, h] - model[:node_outflow][n, y, h] == 0.0)


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

