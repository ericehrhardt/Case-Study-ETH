export setup_policy

# add emission variable costs
function setup_policy(model::Model, inputs::InputStruct)
    
    for i in 1:nprod
        for y in 1:nyear
            for h in 1:nhour
                add_to_expression!(model[:obj], Emission_Factor(inputs, i,y)* Discount_Factor(inputs,y) * Weight_Hour(inputs, y,h) * q[prod[i], years[y], hours[h]])
            end
        end
    end
end