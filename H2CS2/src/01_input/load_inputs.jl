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

    return inputs
end