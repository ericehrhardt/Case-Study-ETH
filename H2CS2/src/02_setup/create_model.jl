export create_model

"""
    create_model(inputs::InputStruct)

Set up the H2CS2 model formulation from given inputs using the JuMP package.
"""
function create_model(inputs::InputStruct)

    # Create base model and set solver attributes
    # Using Gurobi
    model = Model(Gurobi.Optimizer)
    set_optimizer_attribute(model, "TimeLimit", 100)
    set_optimizer_attribute(model, "Presolve", 0)

    #Define base model
    setup_base(model, inputs)

    #Add regions
    setup_transport(model, inputs)
    #setup_regions(model, inputs)

    #Add storage
    setup_storage(model,inputs)

    #Add policies
    setup_policy(model,inputs)

    # Add mass balance constraint
    setup_mass_balance(model, inputs)
    
    #create model objective function
    @objective(model, Min, model[:obj])

    return model
end

