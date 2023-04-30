export setup_policy

# add emission variable costs
function setup_policy(model::Model, inputs::InputStruct)
    
    inputs = add_dimensions(inputs)
    inputs = add_discount_rate(inputs)
    nprod = inputs.nprod; prod = inputs.prod
    nyear = inputs.nyear; years= inputs.years
    nhour = inputs.nhour; hours = inputs.hours
    
    @info "Create Objective"
    for i in 1:nprod
        for y in 1:nyear
            for h in 1:nhour
                add_to_expression!(model[:obj], Emission_Factor(inputs, i,y) * Discount_Factor(inputs,y) * Weight_Hour(inputs, y,h) * q[prod[i], years[y], hours[h]])
            end
        end
    end
end