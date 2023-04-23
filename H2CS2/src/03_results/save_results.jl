export save_results


function save_results(result::ResultStruct, output_filepath::String)

    @info "Saving Results"

    #remove existing file
    if isfile(output_filepath)
        rm(output_filepath)
    end

    #save each field in the results structure to a separate excel sheet
    XLSX.openxlsx(output_filepath, mode="w") do xf
        for field in fieldnames(ResultStruct)
            df = getfield(result, field)
            sheet_name = string(field)
            
            if isempty(df)
                continue
            elseif field == fieldnames(ResultStruct)[1]
                sheet = xf[1]
                XLSX.rename!(sheet, sheet_name)
                XLSX.writetable!(sheet, df)
            else
                sheet = XLSX.addsheet!(xf, sheet_name)
                XLSX.writetable!(sheet, df)        
            end
        end
    end

end