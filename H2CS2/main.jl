using Revise
using H2CS2
using JuMP

#Case Parameters ---------------------------------------------------------------
input_filepath = "./inputs/"
input_filename = "input.xlsx"

output_filepath = "./outputs/"
output_filename = "output.xlsx"

#Run H2CS2
run_H2CS2(input_filepath*input_filename, output_filepath*output_filename)

