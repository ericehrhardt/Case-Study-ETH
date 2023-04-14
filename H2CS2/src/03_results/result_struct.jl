export ResultStruct
mutable struct ResultStruct

    #structure to store all input data tables under one object
    objective::DataFrame	#objective value
    quantity::DataFrame #quantities produced
    capacity::DataFrame #existing capacities
    flow::DataFrame #transportation flows
    mass_balance::DataFrame # dual variable on the mass balance constraint

    function ResultStruct()
        #initialize struct to be empty
        new()
    end
end