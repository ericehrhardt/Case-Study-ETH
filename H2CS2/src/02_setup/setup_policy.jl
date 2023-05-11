export setup_policy

@doc raw"""
    setup_policy(model::Model, inputs::InputStruct) 
    
This function modifies the base model by adding a carbon tax.

The carbon tax is implemented as a variable production cost in the objective function. In 
the future, this function could be expanded to allow for more complex policies.


```math
    Objective \mathrel{+}= \sum_{i \in P}\sum_{y \in Y} \sum_{h \in H} \delta_y w_h \tau_{CO_2} q_{i,y,h} \epsilon_{i}
```
"""
function setup_policy(model::Model, inputs::InputStruct)
    
    inputs = add_dimensions(inputs)
    inputs = add_discount_rate(inputs)
    nprod = inputs.nprod; prod = inputs.prod
    nyear = inputs.nyear; years= inputs.years
    nhour = inputs.nhour; hours = inputs.hours
    
    for i in 1:nprod
        for y in 1:nyear
            for h in 1:nhour
                add_to_expression!(model[:obj], Emission_Factor(inputs, i,y) * Discount_Factor(inputs,y) * Weight_Hour(inputs, y,h) * model[:q][prod[i], years[y], hours[h]])
            end
        end
    end
end