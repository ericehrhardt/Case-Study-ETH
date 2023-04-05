export run_H2CS2
function run_H2CS2(input_filepath::String)
    #Load Inputs -------------------------------------------------------------------
    inputs = load_inputs(input_filepath)

    #Create Model ------------------------------------------------------------------
    model = create_model(inputs)

    #Solve Model -------------------------------------------------------------------
    optimize!(model)
    solution_summary(model)
end