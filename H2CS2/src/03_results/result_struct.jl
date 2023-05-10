export ResultStruct
mutable struct ResultStruct

    #structure to store all input data tables under one object
    objective::DataFrame	#objective value
    quantity_produced::DataFrame #quantities produced
    production_capacity::DataFrame #production capacities
    quantity_stored::DataFrame #quantities produced
    storage_level::DataFrame#how much hydrogen is stored
    storage_capacity::DataFrame #production capacities
    flow::DataFrame #transportation flows
    mass_balance::DataFrame # dual variable on the mass balance constraint
    availability::DataFrame # dual variable on the mass balance constraint


    function ResultStruct()
        #initialize struct to be empty
        #new()
        df = DataFrame(x = [], y = String[])
        new(df, df, df, df, df, df, df, df)
    end
end