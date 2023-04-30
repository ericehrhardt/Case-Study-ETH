export load_inputs
"""
    load_inputs(filename)

Load the model input from a specified Excel file.

The inputs are read into a data structure of type InputStruct. Each table (i.e.
Sheet in the excel notebook) is read in as a new attribute of the data strucutre.
This allows all data to be easily passed into functions and modified throughout
the model. The function returns a the data strucutre containting all inputs.
"""
function load_inputs(filename::String)

    #initialize new data structure for inputs
    inputs = InputStruct()

    #Add input data tables to this structure
    inputs.universal = DataFrame(XLSX.readtable(filename, "universal", first_row = 1))
    inputs.consumer = DataFrame(XLSX.readtable(filename, "consumer", first_row = 2))
    inputs.producer = DataFrame(XLSX.readtable(filename, "producer", first_row = 2))
    inputs.transportation = DataFrame(XLSX.readtable(filename, "transportation", first_row = 2))
    inputs.policy = DataFrame(XLSX.readtable(filename, "policy", first_row = 2))
    inputs.time = DataFrame(XLSX.readtable(filename, "time", first_row = 2))
    inputs.electricity_price = DataFrame(XLSX.readtable(filename, "electricity_price", first_row = 2))
    inputs.gas_price = DataFrame(XLSX.readtable(filename, "gas_price", first_row = 2))
    inputs.policy = DataFrame(XLSX.readtable(filename, "policy", first_row = 2))

    return inputs
end