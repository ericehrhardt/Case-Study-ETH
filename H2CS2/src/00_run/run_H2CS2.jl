export run_H2CS2
function run_H2CS2(input_filepath::String, output_filepath::String)
    #Load Inputs ---------------------------------------------------------------
    inputs = load_inputs(input_filepath)

    #Create Model --------------------------------------------------------------
    model = create_model(inputs)
    print(model)

    #Solve Model ---------------------------------------------------------------
    optimize!(model)
    solution_summary(model)

    #Process Solutions ---------------------------------------------------------
    result = get_results(model)

    #Save Solution -------------------------------------------------------------
    if isfile(output_filepath)
        rm(output_filepath)
    end
    XLSX.writetable(output_filepath, 
        "objective" => result.objective, 
        "quantity" => result.quantity,
        "capacity" => result.capacity,
        "flow" => result.flow,
        "mass_balance" => result.mass_balance)

    
    @info "Model complete :)"

end
