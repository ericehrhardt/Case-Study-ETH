export setup_storage

function setup_storage(model::Model, inputs::InputStruct)

    @info "Implementing Storage"
    #get number of storage units, hours, and years
    nstor = inputs.nstor; stor = inputs.stor
    nyear = inputs.nyear; years= inputs.years
    nhour = inputs.nhour; hours = inputs.hours

    # Define Variables ---------------------------------------------------------

    #quantity added to storage
    @variable(model, q_charge[stor, years, hours],
       start = 0,
       lower_bound = 0)

    #quantity discharged from storage to storage
    @variable(model, q_discharge[stor, years, hours],
       start = 0,
       lower_bound = 0)

    #quantity discharged from storage to storage
    @variable(model, s[stor, years, hours],
       start = 0,
       lower_bound = 0)       
   
    #added capacity
    @variable(model, a_stor[stor, years],
       start = 0,
       lower_bound = 0)

    #existing capacity
    @variable(model, b_stor[stor, years],
       start = 0,
       lower_bound = 0)
   
    #retired capacity
    @variable(model, r_stor[stor, years],
       start = 0,
       lower_bound = 0)

    # Add Constraints  ---------------------------------------------------------
    @infiltrate
    ## limit hourly charging quanitity
    @constraint(model, charge_availability[j in 1:nstor, y in 1:nyear, h in 1:nhour], 
        q_charge[stor[j], years[y], hours[h]] <= 
        (b_stor[stor[j], years[y]] + a_stor[stor[j], years[y]] - r_stor[stor[j], years[y]])*Storage_Availability(inputs,j,y,h))
    
    ## limit hourly discharge quanitity
    @constraint(model, discharge_availability[j in 1:nstor, y in 1:nyear, h in 1:nhour], 
        q_discharge[stor[j], years[y], hours[h]] <= 
        (b_stor[stor[j], years[y]] + a_stor[stor[j], years[y]] - r_stor[stor[j], years[y]])*Storage_Availability(inputs,j,y,h))

    ## set limit on buildable storage capacity
    @constraint(model, max_buildable_storage_capacity[j in 1:nstor, y in 1:nyear],
        a_stor[stor[j], years[y]] <= Max_Storage_Capacity(inputs, j, y))

    ## set limit on retired capacity
    @constraint(model, max_storage_capacity_retirement[j in 1:nstor, y in 1:nyear],
        r_stor[stor[j], years[y]] <= b_stor[stor[j], years[y]])


    ## built capacity from additions/retirements of previous period
    if nyear > 1
        @constraint(model, built_storage_capacity[j in 1:nstor, y in 2:nyear],
            b_stor[stor[j], years[y]] == 
            b_stor[stor[j], years[y-1]] + a_stor[stor[j], years[y-1]] - r_stor[stor[j], years[y-1]])
    end

    ## pre-existing capacity before first simulation year
    @constraint(model, preexisting_storage_capacity[j in 1:nstor],
        b_stor[stor[j], years[1]] == Existing_Storage_Capacity(inputs, j))


    ## stored energy
    @constraint(model, stored_energy[j in 1:nstor, y in 1:nyear, h in 2:nhour],
        s[stor[j], years[y], hours[h]] == 
        ((1 - Self_Discharge_Rate(inputs,j))^Weight_Hour(inputs,y,h))*s[stor[j], years[y], hours[h-1]] +
        Charge_Efficiency(inputs, j)* Weight_Hour(inputs,y,h)*q_charge[stor[j], years[y], hours[h]] -
        Weight_Hour(inputs,y,h)/Discharge_Efficiency(inputs,j)*q_discharge[stor[j], years[y], hours[h]])

    ## storage periodicity
    @constraint(model, storage_periodicity[j in 1:nstor, y in 1:nyear],
        s[stor[j], years[y], hours[1]] == 
        ((1 - Self_Discharge_Rate(inputs,j))^Weight_Hour(inputs,y,1))*s[stor[j], years[y], hours[nhour]] +
        Charge_Efficiency(inputs, j)* Weight_Hour(inputs,y,1)*q_charge[stor[j], years[y], hours[1]] -
        Weight_Hour(inputs,y,1)/Discharge_Efficiency(inputs,j)*q_discharge[stor[j], years[y], hours[1]])

    ## Storage Limit
    @constraint(model, storage_limit[j in 1:nstor, y in 1:nyear, h in 1:nhour],
        s[stor[j], years[y], hours[h]] <=  Max_Storage_Quantity(inputs, j))

    # Add to Objective ---------------------------------------------------------

end