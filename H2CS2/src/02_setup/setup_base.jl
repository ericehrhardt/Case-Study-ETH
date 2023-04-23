export setup_base
export Discount_Factor
##Notes: number of generators read from gen sheet.  Each geneartor name must be unique
##Notes: numer of regions read from consumer sheet. Each region must have consumption!
##Currently only one demand per region. I

@doc raw"""
    setup_base(model::Model, inputs::InputStruct)

Establish an economic dispatch problem with all components except the mass 
balance constraint. 

The returned model has the following formulation:

```math
\begin{aligned}
    \min  \quad  &\sum_{i \in P} \sum_{y \in Y } \delta_y C_{i,y}^I a_{i,y}+
    \sum_{i \in P}\sum_{y \in Y} \delta_y C_{i,y}^F (b_{i,y} + a_{i,y} - r_{i,y}) +\\
    &\sum_{i \in P}\sum_{y \in Y} \sum_{h \in H} \delta_y w_h C^V_{i,y,h} q_{i,y,h} 
\end{aligned}
```

```math
\text{subject to}
```

Producer availability: 
```math
    0 \leq q_{i,y,h} \leq \Gamma_{i,y,h} (b_{i,y} + a_{i,y} - r_{i,y}) \qquad\forall i, y , h
```

Added capacity restrictions:
```math
    0 \leq a_{i,y} \leq A_{i,y}^{max} \qquad\forall i, y
```

Retired capacity restrictions:
```math
  0\leq r_{i,y} \leq b_{i,y} \qquad\forall i,y
```


Flow limits:
```math
    0 \leq f_{r,j,y,h} \leq F_{r,j,y}^{max}\qquad \forall r,j,y,h
```

Annual capacity transfers:
```math
   b_{i,y} = b_{i,y-1} + a_{i,y-1} -r_{i,y-1} \qquad\forall y>0, i
```

Initial Capacity:
```math
    b_{i,0} = B_{i,0} \qquad\forall i
```


"""
function setup_base(model::Model, inputs::InputStruct)

    #get number of generators, regions, hours, and years
    inputs = add_dimensions(inputs)
    inputs = add_discount_rate(inputs)
    nprod = inputs.nprod; prod = inputs.prod
    nyear = inputs.nyear; years= inputs.years
    nhour = inputs.nhour; hours = inputs.hours

    @info "Creating Variables"

    #production quantity
    @variable(model, q[prod, years, hours],
        start = 0,
        lower_bound = 0)
    
    #added capacity
    @variable(model, a[prod, years],
        start = 0,
        lower_bound = 0)

    #existing capacity
    @variable(model, b[prod, years],
        start = 0,
        lower_bound = 0)
    
    #retired capacity
    @variable(model, r[prod, years],
        start = 0,
        lower_bound = 0)
        
    @info "Create Constraints"

    ## limit hourly generation by availability factors
    @constraint(model, availability[i in 1:nprod, y in 1:nyear, h in 1:nhour],
        q[prod[i], years[y], hours[h]] <= 
            (b[prod[i], years[y]] + a[prod[i], years[y]] - r[prod[i], years[y]])*Producer_Availability(inputs,i,y,h))

    ## set limit on buildable capacity
    @constraint(model, max_buildable_capacity[i in 1:nprod, y in 1:nyear],
        a[prod[i], years[y]] <= Max_Capacity(inputs, i, y))

    ## set limit on retired capacity
    @constraint(model, max_capacity_retirement[i in 1:nprod, y in 1:nyear],
        r[prod[i], years[y]] <= b[prod[i], years[y]])

    ## built capacity from additions/retirements of previous period
    if nyear > 1
        @constraint(model, built_capacity[i in 1:nprod, y in 2:nyear],
         b[prod[i], years[y]] == b[prod[i], years[y-1]] + a[prod[i], years[y-1]] - r[prod[i], years[y-1]])
    end

    ## pre-existing capacity before first simulation year
    @constraint(model, preexisting_capacity[i in 1:nprod],
        b[prod[i], years[1]] == Existing_Capacity(inputs, i))

    @info "Create Objective"

    #initialize objective equation to zero
    @expression(model, obj, AffExpr(0))

    #add variable cost
    for i in 1:nprod
        for y in 1:nyear
            for h in 1:nhour
                add_to_expression!(model[:obj], Discount_Factor(inputs,y)* Weight_Hour(inputs, y, h)* Cost_VOM(inputs, i,y,h) * q[prod[i], years[y], hours[h]])
            end
        end
    end

    #add fixed costs
    for i in 1:nprod
        for y in 1:nyear
            add_to_expression!(model[:obj], Discount_Factor(inputs,y) * Cost_FOM(inputs, i,y)*
            (a[prod[i], years[y]] + b[prod[i], years[y]] - r[prod[i], years[y]]))
        end
    end

    #add capital costs 
    for i in 1:nprod
        for y in 1:nyear
            add_to_expression!(model[:obj], Discount_Factor(inputs,y)*Cost_Invest(inputs, i,y)*a[prod[i], years[y]])
        end
    end
end


