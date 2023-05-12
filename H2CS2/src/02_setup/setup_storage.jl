export setup_storage
@doc raw"""
    setup_storage(model::Model, inputs::InputStruct)

This function modifies the model created by "setup_base" in order to add storage units to the model.

These units store energy within a given simulation year. The storage levels
at the beginning of the year are optimized by the model. Each storage resevoir may
thus begin the year either full, empty, or anywhere in between. At the end of each 
year, the storge unit must return to the same level as at the beginning.

Storage units have two different types of capacity. The first, henceforth refered to as
charge/discharge capacity, indicates the rate at which hydrogen can be added or removed 
from the resevoir. This capacity is analagous to the "power capacity" of battery storage
systems. In our model, we determine this capacity endogenously, meaning that the model can
choose how much to build or retire. The second capacity, henceforth called the storage 
capacity, indicates the total quantity of hydrogen that can be held in a given storage unit.
This is analagous to the "energy capacity" of battery storage systems. In our model, the 
storage capacity is an exogenous input parameter.

To implement storage, we make the following modifications to the model:

```math
\begin{aligned}
    Objective \mathrel{+}=&\sum_{j \in S} \sum_{y \in Y } \delta_y C_{j,y}^I a_{j,y}+
    \sum_{j \in S}\sum_{y \in Y} \delta_y C_{j,y}^F (b_{j,y} + a_{j,y} - r_{j,y}) +\\
    &\sum_{j \in S}\sum_{y \in Y} \sum_{h \in H} \delta_y w_h C^V_{j,y,h} q_{i,y,h}^c 
\end{aligned}
```

Storage charge availability
```math
0 \leq q_{j,y,h}^c \leq \Gamma_{j,y,h} (b_{j,y} + a_{j,y} - r_{j,y}) \qquad\forall j, y , h
```

Storage discharge availability
```math
0 \leq q_{j,y,h}^d \leq \Gamma_{j,y,h} (b_{j,y} + a_{j,y} - r_{j,y}) \qquad\forall j, y , h
```

Added charge/discharge capacity restrictions
```math
0 \leq a_{j,y} \leq A_{j,y}^{max} \qquad\forall j, y
```

Retired capacity restrictions
```math
0\leq r_{j,y} \leq b_{j,y} \qquad\forall j,y
```

Annual capacity transfers
```math
b_{j,y} = b_{j,y-1} + a_{j,y-1} -r_{j,y-1} \qquad\forall y>0, j
```

Initial charge/discharge capacity
```math
b_{j,0} = B_{j,0} \qquad\forall i
```

Maximum storage capacity
```math
0\leq s_{j,y,h} \leq S_{j}^{max} \qquad \forall j
```

Storage levels after charging and discharging
```math
s_{j,y,h} = (1- \lambda_{j})^{w_{h}}s_{j,y-1,h} + \eta_j^c  w_h q^{c}_{j,y,h}  - \frac{q_{j,y,h}^d w_h}{\eta_j^{d}} \qquad \forall j,y,h
```

The last constraint is set to be periodic, so that the state of charge at 
the end of each year is the same as at the beginning of the year.



"""
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
    
    #add variable cost
    for j in 1:nstor
        for y in 1:nyear
            for h in 1:nhour
                add_to_expression!(model[:obj], Discount_Factor(inputs,y)* Weight_Hour(inputs, y, h)*Cost_VOM_Storage(inputs, j,y,h) * q_charge[stor[j], years[y], hours[h]])
            end
        end
    end

    #add fixed costs
    for j in 1:nstor
        for y in 1:nyear
            add_to_expression!(model[:obj], Discount_Factor(inputs,y) * Cost_FOM_Storage(inputs, j,y)*
            (a_stor[stor[j], years[y]] + b_stor[stor[j], years[y]] - r_stor[stor[j], years[y]]))
        end
    end

    #add capital costs 
    for j in 1:nstor
        for y in 1:nyear
            add_to_expression!(model[:obj], Discount_Factor(inputs,y)*Cost_Invest_Storage(inputs, j,y)*a_stor[stor[j], years[y]])
        end
    end
end