export create_model
function create_model(inputs::InputStruct)

    # Create base model and set solver attributes
    # Using Gurobi
    model = Model(Gurobi.Optimizer)
    set_optimizer_attribute(model, "TimeLimit", 100)
    set_optimizer_attribute(model, "Presolve", 0)

    #Define model variables
    setup_base(model, inputs)
    

    return model
end

