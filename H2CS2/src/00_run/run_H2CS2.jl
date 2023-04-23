export run_H2CS2

"""
    run_H2CS2(input_filepath::String, output_filepath::String)

Run the H2CS2 Model using inputs from a specified file.

The input_filepath must point toward a Excel Workbook with all required input 
tables in separate worksheets.

The output_filepath specifies where the model outputs should be saved. 

WARNING: The model will delete and overwrite any existing file in the output_filepath
"""
function run_H2CS2(input_filepath::String, output_filepath::String)
    #Load Inputs ---------------------------------------------------------------
    inputs = load_inputs(input_filepath)

    #Create Model --------------------------------------------------------------
    model = create_model(inputs)
    # print(model)

    #Solve Model ---------------------------------------------------------------
    optimize!(model)
    solution_summary(model)

    #Process Solutions ---------------------------------------------------------
    result = get_results(model, inputs)

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
