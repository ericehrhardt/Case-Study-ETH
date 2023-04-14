using Revise
using H2CS2
using JuMP

#Case Parameters ---------------------------------------------------------------
input_filepath = "./inputs/"
input_filename = "input_2region_short.xlsx"

output_filepath = "./outputs/"
output_filename = "output_2region_short.xlsx"

#Run H2CS2
run_H2CS2(input_filepath*input_filename, output_filepath*output_filename)

