export setup_mass_balance

@doc raw"""
    setup_mass_balance(model::Model, inputs::InputStruct)

This function modifies the model by adding regional mass balance constraints 

The added constraint is shown below. In the constraint formulation, $P_r$, $S_r$,
and $K_r$ represent the producers, storage units, and consumers that are located 
in region $r$.

Mass balance:
```math
\begin{aligned}
    0 =&\sum_{i\in P_r} q_{i,y,h} + \sum_{j\in S_r} (q_{j,y,h}^d-q_{j,y,h}^c)\\
    & - \sum_{k \in K_r} D_{i,h,r} -\sum_{\substack{e \in E\\ \text{s.t}\: e = (r,j)}} (f_{e,y,h}) + \sum_{\substack{e \in E\\ \text{s.t}\: e = (j,r)} } (f_{e,y,h}) \qquad\forall r, y, h
\end{aligned}
```
"""
function setup_mass_balance(model::Model, inputs::InputStruct)

    nprod = inputs.nprod; prod = inputs.prod
    nyear = inputs.nyear; years= inputs.years
    nhour = inputs.nhour; hours = inputs.hours
    nnode = inputs.nnode; nodes = inputs.nodes
    nedge = inputs.nedge; edges = inputs.edges
    
    ## Compute Mass Balance ----------------------------------------------------

    # Mass Flow Out of Certain Node
    @expression(model, node_outflow[n in 1:nnode, y in 1:nyear, h in 1:nhour], get_node_outflow(model, inputs, n, y, h))
    
    # Demand at a Certain Node
    @expression(model, node_demand[n in 1:nnode, y in 1:nyear, h in 1:nhour], get_node_demand(model, inputs, n, y, h))
       
    # Production at a given Node
    @expression(model, node_prod[n in 1:nnode, y in 1:nyear, h in 1:nhour], get_node_production(model, inputs, n, y, h))
        
    # Hydrogen stored at given node
    @expression(model, node_stor[n in 1:nnode, y in 1:nyear, h in 1:nhour], get_node_storage(model, inputs, n, y, h))

    ## add mass balance constraint!
    @constraint(model, mass_balance[n in 1:nnode, y in 1:nyear, h in 1:nhour],
        model[:node_prod][n, y, h] - model[:node_demand][n, y, h] - model[:node_outflow][n, y, h] - model[:node_stor][n, y, h]  == 0.0)

end

