
export spread_producers

@doc raw"""
    spread_producers(inputs::InputStruct)

Create cost distribution for consumers.

This function manipulates the producer input spreadsheet in order to make each
producer have a cost distribution. It does so by splitting each producer into 
n smaller producers whose costs and capacities follow a normal distribution.
"""
function spread_producers(inputs::InputStruct)

    #Duplicate producers -------------------------------------------------------
    producer = inputs.producer

    colnames = names(producer) #producer columnames
    ncol = length(colnames) #number of columns

    #get new number of producers
    producer[!, :cumulative_sum] = cumsum(producer[!, :number_producers])
    nrow_new = sum(producer.number_producers)#number of rows in new table

    #pre-allocate new table for efficiency
    producer_new  = DataFrame(repeat([Vector{Any}(undef, nrow_new)], ncol), colnames)


    for row in 1:nrow(producer)

        #get relevant parameters
        n_duplicates  = producer[row,:number_producers] #number of times to repeat producer
        standard_deviation = producer[row, :variance] #standard deviation (in percent of cost value)
        perc = [1/(2*n_duplicates):1/n_duplicates:1;] #precentiles for which to calcualte cost
        end_row = producer[row,:cumulative_sum]

        #duplicate each producer
        for d in 1:n_duplicates  
            for col in colnames
                producer_new[end_row-n_duplicates+d, col] = producer[row, col]
            end

            #adjust names
            producer_new[end_row-n_duplicates+d, :name] = producer[row, :name]*"_"*string(d)

            #adjust capacities
            producer_new[end_row-n_duplicates+d, :existing_capacity] = producer[row, :existing_capacity]/n_duplicates
            producer_new[end_row-n_duplicates+d, :buildable_capacity] = producer[row, :buildable_capacity]/n_duplicates

            #adjust costs
            z_score = norminvcdf(perc[d])
            producer_new[end_row-n_duplicates+d, :fixed_cost] = producer[row, :fixed_cost] + z_score*standard_deviation*producer[row, :fixed_cost]
            producer_new[end_row-n_duplicates+d, :annualized_investment_cost] = producer[row, :annualized_investment_cost] + z_score*standard_deviation*producer[row, :annualized_investment_cost]
            producer_new[end_row-n_duplicates+d, :nonfuel_variable_cost] = producer[row, :nonfuel_variable_cost] + z_score*standard_deviation*producer[row, :nonfuel_variable_cost]
            producer_new[end_row-n_duplicates+d, :electricity_requirement] = producer[row, :electricity_requirement] + z_score*standard_deviation*producer[row, :electricity_requirement]
            producer_new[end_row-n_duplicates+d, :gas_requirement] = producer[row, :gas_requirement] + z_score*standard_deviation*producer[row, :gas_requirement]
        end

    end

    #change inputs
    inputs.producer = producer_new

    return inputs

end


