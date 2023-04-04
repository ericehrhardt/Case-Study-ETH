using Revise
using H2CS2
using JuMP

#Case Parameters ---------------------------------------------------------------
input_filepath = "./inputs/"
input_filename = "input_2region_short.xlsx"


#Load Inputs -------------------------------------------------------------------
inputs = load_inputs(input_filepath*input_filename)

#Create Model ------------------------------------------------------------------
model = create_model(inputs)

#Solve Model -------------------------------------------------------------------
optimize!(model)
solution_summary(model)

