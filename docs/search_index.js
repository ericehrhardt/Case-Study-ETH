var documenterSearchIndex = {"docs":
[{"location":"model_coefficients/#Model-Coefficients","page":"Coefficients","title":"Model Coefficients","text":"","category":"section"},{"location":"model_coefficients/","page":"Coefficients","title":"Coefficients","text":"Each model coefficient is defined through a function that reads the coefficient value from the input data. All coefficient functions have names beginning with capital letters. The code for all of the coefficients is contained in the coefficients.jl file.","category":"page"},{"location":"model_coefficients/","page":"Coefficients","title":"Coefficients","text":"In this page, we proviide documentation for each of the coefficient functions. The documentation for each coefficient specifies exactly how the coefficient values are calculated from the input data. ","category":"page"},{"location":"model_coefficients/","page":"Coefficients","title":"Coefficients","text":"    Cost_VOM","category":"page"},{"location":"model_coefficients/#H2CS2.Cost_VOM","page":"Coefficients","title":"H2CS2.Cost_VOM","text":"Cost_VOM(inputs::InputStruct, idx_prod::Int, idx_year::Int, idx_hour::Int)\n\nExtracts the variable cost (C_iyh^V) of a specified producer in a given year and hour.\n\nFor each producer, the variable cost is calculated as:\n\nbeginaligned\n    C_iyh^V  = mathrmnonfuel_variable_cost+\r\n     mathrmelectricity_requirement*mathrmelectricity_price+\r\n      mathrmgas_requirement*mathrmgas_price\nendaligned\n\nARGUMENTS:\n\ninputs (InputStruct) ... data structure containing inputs\n\nidx_producer (Int)... index of producer for which to get cost\n\nidx_year (Int) ... index of year for which to get cost\n\nidx_hour (Int)... index of hour for which to get cost\n\n\n\n\n\n","category":"function"},{"location":"model_coefficients/","page":"Coefficients","title":"Coefficients","text":"    Cost_VOM_Storage","category":"page"},{"location":"model_coefficients/#H2CS2.Cost_VOM_Storage","page":"Coefficients","title":"H2CS2.Cost_VOM_Storage","text":"Cost_VOM_Storage(inputs::InputStruct, idx_stor::Int, idx_year::Int, idx_hour::Int)\n\nExtracts the variable cost (C_jyh^V) of a specified storage unit in a given year and hour.\n\nFor each storage unit, the variable cost is calculated as:\n\nbeginaligned\n    C_jyh^V  = mathrmnonfuel_variable_cost+\r\n     mathrmelectricity_requirement*mathrmelectricity_price+\r\n      mathrmgas_requirement*mathrmgas_price\nendaligned\n\nARGUMENTS:\n\ninputs (InputStruct) ... data structure containing inputs\n\nidx_stor (Int)... index of storage unit for which to get cost\n\nidx_year (Int) ... index of year for which to get cost\n\nidx_hour (Int)... index of hour for which to get cost\n\n\n\n\n\n","category":"function"},{"location":"model_coefficients/","page":"Coefficients","title":"Coefficients","text":"    Cost_FOM","category":"page"},{"location":"model_coefficients/#H2CS2.Cost_FOM","page":"Coefficients","title":"H2CS2.Cost_FOM","text":"Cost_FOM(inputs::InputStruct, idx_prod::Int, idx_year::Int)\n\nExtracts the annual fixed cost cost (C_iyh^F) of a specified producer in  a given year. \n\nFor each producer, the fixed cost is taken directly from the producer inputs. We currently assume that annual fixed costs do not change over time. \n\nARGUMENTS:\n\ninputs (InputStruct) ... data structure containing inputs\n\nidx_producer (Int)... index of producer for which to get cost\n\nidx_year (Int) ... index of year for which to get cost\n\n\n\n\n\n","category":"function"},{"location":"model_coefficients/","page":"Coefficients","title":"Coefficients","text":"Cost_FOM_Storage","category":"page"},{"location":"model_coefficients/#H2CS2.Cost_FOM_Storage","page":"Coefficients","title":"H2CS2.Cost_FOM_Storage","text":"Cost_FOM_Storage(inputs::InputStruct, idx_stor::Int, idx_year::Int)\n\nExtracts the annual fixed cost cost (C_jyh^F) of a specified storage unit in  a given year. \n\nFor each storage unit, the fixed cost is taken directly from the storage inputs. We currently assume that annual fixed costs do not change over time. \n\nARGUMENTS:\n\ninputs (InputStruct) ... data structure containing inputs\n\nidx_stor (Int)... index of storage unit for which to get cost\n\nidx_year (Int) ... index of year for which to get cost\n\n\n\n\n\n","category":"function"},{"location":"model_coefficients/","page":"Coefficients","title":"Coefficients","text":"    Cost_Invest","category":"page"},{"location":"model_coefficients/#H2CS2.Cost_Invest","page":"Coefficients","title":"H2CS2.Cost_Invest","text":"Cost_Invest(inputs::InputStruct, idx_prod::Int, idx_year::Int)\n\nExtracts the investment cost (C_iyh^I) of a specified producer in a given year.\n\nThe investment cost is only applied during the year in which a producer adds capacity. For all other years, the investment cost is zero. When applicable, the investment cost is taken directly from the producer inputs.\n\nARGUMENTS:\n\ninputs (InputStruct) ... data structure containing inputs\n\nidx_producer (Int)... index of producer for which to get cost\n\nidx_year (Int) ... index of year for which to get cost\n\n\n\n\n\n","category":"function"},{"location":"model_coefficients/","page":"Coefficients","title":"Coefficients","text":"    Cost_Invest_Storage","category":"page"},{"location":"model_coefficients/#H2CS2.Cost_Invest_Storage","page":"Coefficients","title":"H2CS2.Cost_Invest_Storage","text":"Cost_Invest_Storage(inputs::InputStruct, idx_prod::Int, idx_year::Int)\n\nExtracts the investment cost (C_jyh^I) of a specified storage unit in a given year.\n\nThe investment cost is only applied during the year in which a storage unit adds capacity. For all other years, the investment cost is zero. When applicable, the investment cost is taken directly from the storage inputs.\n\nARGUMENTS:\n\ninputs (InputStruct) ... data structure containing inputs\n\nidx_stor (Int)... index of storage unit for which to get cost\n\nidx_year (Int) ... index of year for which to get cost\n\n\n\n\n\n","category":"function"},{"location":"model_coefficients/","page":"Coefficients","title":"Coefficients","text":"    Producer_Availability","category":"page"},{"location":"model_coefficients/#H2CS2.Producer_Availability","page":"Coefficients","title":"H2CS2.Producer_Availability","text":"Producer_Availability(inputs::InputStruct, idx_prod::Int, idx_year::Int, idx_hour::Int)\n\nExtracts the producer availability factor (Gamma_iyh) of a specified producer  in a given year and hour.\n\nFor each producer, the availability factor is calculated as:\n\n    Gamma_iyh  = mathrmbase_availability*mathrmscale_factor\n\nwhere the base availability is taken directly from the \"producer\" inputs and the  scale factor is taken for the corresponding column in the \"time\" inputs. The  scale factor varies by year and hour.\n\nARGUMENTS:\n\ninputs (InputStruct) ... data structure containing inputs\n\nidx_producer (Int)... index of producer for which to get cost\n\nidx_year (Int) ... index of year for which to get cost\n\nidx_hour (Int)... index of hour for which to get cost\n\n\n\n\n\n","category":"function"},{"location":"model_coefficients/","page":"Coefficients","title":"Coefficients","text":"    Max_Producer_Capacity","category":"page"},{"location":"model_coefficients/#H2CS2.Max_Producer_Capacity","page":"Coefficients","title":"H2CS2.Max_Producer_Capacity","text":"Max_Producer_Capacity(inputs::InputStruct, idx_prod::Int, idx_year::Int)\n\nExtracts the maximum capacity (A_iy^max) that can be added by a producer in a given year. \n\nBy design, each producer can only build capacity in a single year. This \"build year\" is specified by the \"year\" column of the producer inputs.  During that year, the max buildable capacity is taken directly from the producer inputs. During  every other year, the maximum buildable capacity is set to zero. \n\nCapacity expansion in mulitple years can be incorporated by creating a new producer for each simulation year. For instance, once could create a \"electrolyzer2030\", which can be built in 2030 and an \"electrolyzer2040\", which can be built in 2040. This would allow the model to build capacity in both years. \n\nARGUMENTS:\n\ninputs (InputStruct) ... data structure containing inputs\n\nidx_producer (Int)... index of producer for which to get cost\n\nidx_year (Int) ... index of year for which to get cost\n\n\n\n\n\n","category":"function"},{"location":"model_coefficients/","page":"Coefficients","title":"Coefficients","text":"    Max_Storage_Capacity","category":"page"},{"location":"model_coefficients/#H2CS2.Max_Storage_Capacity","page":"Coefficients","title":"H2CS2.Max_Storage_Capacity","text":"Max_Storage_Capacity(inputs::InputStruct, idx_prod::Int, idx_year::Int)\n\nExtracts the maximum capacity (A_jy^max) that can be added by a storage unit in a given year. \n\nBy design, each storage unit can only build capacity in a single year. This \"build year\" is specified by the \"year\" column of the storage inputs.  During that year, the max buildable capacity is taken directly from the storage inputs. During  every other year, the maximum buildable capacity is set to zero. \n\nCapacity expansion in mulitple years can be incorporated by creating a new storage unit for each simulation year. For instance, once could create a \"saltcaverns2030\", which can be built in 2030 and an \"saltcaverns2040\", which can be built in 2040. This would allow the model to build capacity in both years. \n\nARGUMENTS:\n\ninputs (InputStruct) ... data structure containing inputs\n\nidx_stor (Int)... index of storage unit for which to get cost\n\nidx_year (Int) ... index of year for which to get cost\n\n\n\n\n\n","category":"function"},{"location":"model_coefficients/","page":"Coefficients","title":"Coefficients","text":"    Max_Storage_Quantity","category":"page"},{"location":"model_coefficients/#H2CS2.Max_Storage_Quantity","page":"Coefficients","title":"H2CS2.Max_Storage_Quantity","text":"Max_Storage_Quantitity(inputs::InputStruct, idx_stor::Int)\n\nExtracts the maximum storage quantity (S_j^max) for each storage unit.\n\nThe storage limit is taken direclty from the \"storage\" input table.\n\nARGUMENTS:\n\ninputs (InputStruct) ... data structure containing inputs\n\nidx_stor (Int)... index of storage unit for which to get cost\n\n\n\n\n\n","category":"function"},{"location":"model_coefficients/","page":"Coefficients","title":"Coefficients","text":"    Existing_Capacity","category":"page"},{"location":"model_coefficients/#H2CS2.Existing_Capacity","page":"Coefficients","title":"H2CS2.Existing_Capacity","text":"Existing_Capacity(inputs::InputStruct, idx_prod::Int)\n\nExtracts the pre-existing capacity (B_i0) for each producer at the beginning of the first simulation year. \n\nThe pre-existing capacity is taken direclty from the \"producer\" input table.\n\nARGUMENTS:\n\ninputs (InputStruct) ... data structure containing inputs\n\nidx_prod (Int)... index of producer for which to get cost\n\n\n\n\n\n","category":"function"},{"location":"model_coefficients/","page":"Coefficients","title":"Coefficients","text":"    Existing_Storage_Capacity","category":"page"},{"location":"model_coefficients/#H2CS2.Existing_Storage_Capacity","page":"Coefficients","title":"H2CS2.Existing_Storage_Capacity","text":"Existing_Storage_Capacity(inputs::InputStruct, idx_stor::Int)\n\nExtracts the pre-existing capacity (B_j0) for each storage unit at the beginning of the first simulation year. \n\nThe pre-existing capacity is taken direclty from the \"storage\" input table.\n\nARGUMENTS:\n\ninputs (InputStruct) ... data structure containing inputs\n\nidx_stor (Int)... index of storage unit for which to get cost\n\n\n\n\n\n","category":"function"},{"location":"model_coefficients/","page":"Coefficients","title":"Coefficients","text":"    Flow_Limit","category":"page"},{"location":"model_coefficients/#H2CS2.Flow_Limit","page":"Coefficients","title":"H2CS2.Flow_Limit","text":"Flow_Limit(inputs::InputStruct, idx_edge::Int, idx_hour::Int)\n\nExtracts the pre-existing capacity (F_ey^max) for a given transportation route and in a given year.\n\nThe flow limit is taken directly from the \"transportation\" input table. Note that each edge on the graph is active for only a single year. Hence, the flow limit function does not depend on the year.\n\nARGUMENTS:\n\ninputs (InputStruct) ... data structure containing inputs\n\nidx_edge (Int)... index of edge for which to get the flow limit\n\nidx_hour (Int) ... index of hour for which to get the flow limit\n\n\n\n\n\n","category":"function"},{"location":"model_coefficients/","page":"Coefficients","title":"Coefficients","text":"    Cost_Transport","category":"page"},{"location":"model_coefficients/#H2CS2.Cost_Transport","page":"Coefficients","title":"H2CS2.Cost_Transport","text":"Cost_Transport(inputs::InputStruct, idx_edge::Int, idx_year::Int)\n\nExtracts the transportation cost factor (C_ey^Trans) of along a specified transportation route (edge) for a given year.\n\nFor each edge, the cost is calculated as:\n\n    C_ey^Trans  = mathrmdistance*mathrmcost_per_unit_distance\n\nARGUMENTS:\n\ninputs (InputStruct) ... data structure containing inputs\n\nidx_edge (Int)... index of transportation route for which to get cost.\n\nidx_year (Int) ... index of year for which to get cost.\n\n\n\n\n\n","category":"function"},{"location":"model_coefficients/","page":"Coefficients","title":"Coefficients","text":"    Discharge_Efficiency","category":"page"},{"location":"model_coefficients/#H2CS2.Discharge_Efficiency","page":"Coefficients","title":"H2CS2.Discharge_Efficiency","text":"Discharge_Efficiency(inputs::InputStruct, idx_stor::Int)\n\nExtracts the discharge efficiency (eta^d_j) for each storage unit.\n\nThe discharge efficiency is taken directly from the \"storage\" input table.\n\nARGUMENTS:\n\ninputs (InputStruct) ... data structure containing inputs\n\nidx_stor (Int)... index of storage unit for which to get cost\n\n\n\n\n\n","category":"function"},{"location":"model_coefficients/","page":"Coefficients","title":"Coefficients","text":"    Charge_Efficiency","category":"page"},{"location":"model_coefficients/#H2CS2.Charge_Efficiency","page":"Coefficients","title":"H2CS2.Charge_Efficiency","text":"Charge_Efficiency(inputs::InputStruct, idx_stor::Int)\n\nExtracts the charge efficiency (eta^c_j) for each storage unit.\n\nThe charge efficiency is taken directly from the \"storage\" input table.\n\nARGUMENTS:\n\ninputs (InputStruct) ... data structure containing inputs\n\nidx_stor (Int)... index of storage unit for which to get cost\n\n\n\n\n\n","category":"function"},{"location":"model_coefficients/","page":"Coefficients","title":"Coefficients","text":"    Self_Discharge_Rate","category":"page"},{"location":"model_coefficients/#H2CS2.Self_Discharge_Rate","page":"Coefficients","title":"H2CS2.Self_Discharge_Rate","text":"Self_Discharge_Rate(inputs::InputStruct, idx_stor::Int)\n\nExtracts the self-discharge rate (lambda_j) for each storage unit.\n\nThe self-discharge rate is taken direclty from the \"storage\" input table.\n\nARGUMENTS:\n\ninputs (InputStruct) ... data structure containing inputs\n\nidx_stor (Int)... index of storage unit for which to get cost\n\n\n\n\n\n","category":"function"},{"location":"model_coefficients/","page":"Coefficients","title":"Coefficients","text":"    Weight_Hour","category":"page"},{"location":"model_coefficients/#H2CS2.Weight_Hour","page":"Coefficients","title":"H2CS2.Weight_Hour","text":"Weight_Hour(inputs::InputStruct, idx_year::Int, idx_hour::Int)\n\nExtracts the hour weight (w_h) of a given hour in a given year.\n\nEach hour in the model is a \"representative\" for a collection of hours  throughout the year. For instance, we may simulate only one hour to represent all hours witin the month of January. The hour weight gives the number of real-life hours represented by a the given simuation hour. It is used to weight  the objective function. The hour weights are taken directly from the \"time\" input table.\n\nARGUMENTS:\n\ninputs (InputStruct) ... data structure containing inputs\n\nidx_year (Int) ... index of year for which to get cost\n\nidx_hour (Int)... index of hour for which to get cost\n\n\n\n\n\n","category":"function"},{"location":"model_coefficients/","page":"Coefficients","title":"Coefficients","text":"    Discount_Factor","category":"page"},{"location":"model_coefficients/#H2CS2.Discount_Factor","page":"Coefficients","title":"H2CS2.Discount_Factor","text":"Discount_Factor(inputs::InputStruct, idx_year::Int)\n\nCalculates the discount factor delta_y for a given year.\n\nThe discount factor is currently taken as a single-year discount factor of the  following form:\n\ndelta_y = frac1(1 + r)^t-t_0\n\nwhere r is the discount rate, t is the current simulation year, and t_0 is the base simulation year.\n\nARGUMENTS:\n\ninputs (InputStruct) ... data structure containing inputs\n\nidx_year (Int) ... index of year for which to get cost\n\n\n\n\n\n","category":"function"},{"location":"model_overview/#Model-Overview","page":"Model Overview","title":"Model Overview","text":"","category":"section"},{"location":"model_overview/","page":"Model Overview","title":"Model Overview","text":"H2CS2 optimizes hydrogen production subject to a fixed demand for hydrogen. It is flexible spatially and temporally, being able to simulate multiple regions, multiple years, and multiple hours within a year.","category":"page"},{"location":"model_overview/","page":"Model Overview","title":"Model Overview","text":"In the text below, we provide a brief description of the model file structure. More details on the model formulation can be found in the relevant tabs of the model documentation.","category":"page"},{"location":"model_overview/#Inputs","page":"Model Overview","title":"Inputs","text":"","category":"section"},{"location":"model_overview/","page":"Model Overview","title":"Model Overview","text":"The model inputs are in the form of an Excel Workbook. Example input files can be found in the inputs folder. Included in this folder are also two test input files. These test files contain simple scenarios for testing and developing the code.","category":"page"},{"location":"model_overview/#Source-Code","page":"Model Overview","title":"Source Code","text":"","category":"section"},{"location":"model_overview/","page":"Model Overview","title":"Model Overview","text":"The model source code is located in the src folder. This folder contains the following subfolders:","category":"page"},{"location":"model_overview/","page":"Model Overview","title":"Model Overview","text":"00_run - contains the function for running the H2CS2 model. \n01_input - contains all code for loading inputs from the inputs spreadsheets. The main file is 'load_inputs.jl'\n02_setup - contains all code for setting up the model. The main file is 'create_model.jl'\n03._results - contains all code for extracting the model results and formatting the outputs. The main file is 'get_results.jl'.","category":"page"},{"location":"model_overview/","page":"Model Overview","title":"Model Overview","text":"Each folder contains one main file. This main file calls on all other files in the folder to perform tasks. The main files, and the order in which they are called, are shown in the diagram below.","category":"page"},{"location":"model_overview/","page":"Model Overview","title":"Model Overview","text":"(Image: File structure of the H2CS2 model) Figure. File structure of the H2CS2 model","category":"page"},{"location":"model_overview/#Outputs","page":"Model Overview","title":"Outputs","text":"","category":"section"},{"location":"model_overview/","page":"Model Overview","title":"Model Overview","text":"The model output is a Excel Workbook. Outputs are saved to the folder which is specified in \"main.jl\". We recommend that you save the outputs into the outputs folder.","category":"page"},{"location":"model_overview/#Documentation","page":"Model Overview","title":"Documentation","text":"","category":"section"},{"location":"model_overview/","page":"Model Overview","title":"Model Overview","text":"Text and figures for the model documentation is located in the docs folder. All documentation is written in the markdowns files contained in this folder, or in docstrings directly in the code files themselves. In order to recreate the HTML documentation, run the file make.jl. This can be done using the following commands:","category":"page"},{"location":"model_overview/","page":"Model Overview","title":"Model Overview","text":"From inside the H2CS2 folder, open a julia project","category":"page"},{"location":"model_overview/","page":"Model Overview","title":"Model Overview","text":"julia --project=.","category":"page"},{"location":"model_overview/","page":"Model Overview","title":"Model Overview","text":"Run the make.jl file:","category":"page"},{"location":"model_overview/","page":"Model Overview","title":"Model Overview","text":"julia> include(\"docs/make.jl\")","category":"page"},{"location":"model_overview/#Miscellaneous","page":"Model Overview","title":"Miscellaneous","text":"","category":"section"},{"location":"model_overview/","page":"Model Overview","title":"Model Overview","text":"The Project.toml file stores information on the packages required for the model. This enables seamless installation of all required packages when the model is first run.","category":"page"},{"location":"model_overview/","page":"Model Overview","title":"Model Overview","text":"The Manifest.toml file, if present, stores specific information about how and where packages are installed on your computer. This is user specific and should not be pushed to the GitHub repository.","category":"page"},{"location":"model_formulation/#Model-Formulation","page":"Formulation","title":"Model Formulation","text":"","category":"section"},{"location":"model_formulation/","page":"Formulation","title":"Formulation","text":"The model code is divided into four sections. Each code file sets up a portion of the final model.  Description of all models and variables in the model can be found below.","category":"page"},{"location":"model_formulation/","page":"Formulation","title":"Formulation","text":"setup_base.jl\nsetup_storage.jl\nsetup_transport.jl\nsetup_policy.jl\nsetup_mass_balance.jl","category":"page"},{"location":"model_formulation/","page":"Formulation","title":"Formulation","text":"setup_base","category":"page"},{"location":"model_formulation/#H2CS2.setup_base","page":"Formulation","title":"H2CS2.setup_base","text":"setup_base(model::Model, inputs::InputStruct)\n\nEstablish an economic dispatch problem with all components except the mass  balance constraint. \n\nThe returned model has the following formulation:\n\nbeginaligned\n    min  quad  sum_i in P sum_y in Y  delta_y C_iy^I a_iy+\n    sum_i in Psum_y in Y delta_y C_iy^F (b_iy + a_iy - r_iy) +\r\n    sum_i in Psum_y in Y sum_h in H delta_y w_h C^V_iyh q_iyh \nendaligned\n\ntextsubject to\n\nProducer availability: \n\n    0 leq q_iyh leq Gamma_iyh (b_iy + a_iy - r_iy) qquadforall i y  h\n\nAdded capacity restrictions:\n\n    0 leq a_iy leq A_iy^max qquadforall i y\n\nRetired capacity restrictions:\n\n  0leq r_iy leq b_iy qquadforall iy\n\nAnnual capacity transfers:\n\n   b_iy = b_iy-1 + a_iy-1 -r_iy-1 qquadforall y0 i\n\nInitial Capacity:\n\n    b_i0 = B_i0 qquadforall i\n\n\n\n\n\n","category":"function"},{"location":"model_formulation/","page":"Formulation","title":"Formulation","text":"setup_storage","category":"page"},{"location":"model_formulation/#H2CS2.setup_storage","page":"Formulation","title":"H2CS2.setup_storage","text":"setup_storage(model::Model, inputs::InputStruct)\n\nThis function modifies the model created by \"setup_base\" in order to add storage units to the model.\n\nThese units store energy within a given simulation year. The storage levels at the beginning of the year are optimized by the model. Each storage resevoir may thus begin the year either full, empty, or anywhere in between. At the end of each  year, the storge unit must return to the same level as at the beginning.\n\nStorage units have two different types of capacity. The first, henceforth refered to as charge/discharge capacity, indicates the rate at which hydrogen can be added or removed  from the resevoir. This capacity is analagous to the \"power capacity\" of battery storage systems. In our model, we determine this capacity endogenously, meaning that the model can choose how much to build or retire. The second capacity, henceforth called the storage  capacity, indicates the total quantity of hydrogen that can be held in a given storage unit. This is analagous to the \"energy capacity\" of battery storage systems. In our model, the  storage capacity is an exogenous input parameter.\n\nTo implement storage, we make the following modifications to the model:\n\nbeginaligned\n    Objective mathrel+=sum_j in S sum_y in Y  delta_y C_jy^I a_jy+\n    sum_j in Ssum_y in Y delta_y C_jy^F (b_jy + a_jy - r_jy) +\r\n    sum_j in Ssum_y in Y sum_h in H delta_y w_h C^V_jyh q_iyh^c \nendaligned\n\nStorage charge availability\n\n0 leq q_jyh^c leq Gamma_jyh (b_jy + a_jy - r_jy) qquadforall j y  h\n\nStorage discharge availability\n\n0 leq q_jyh^d leq Gamma_jyh (b_jy + a_jy - r_jy) qquadforall j y  h\n\nAdded charge/discharge capacity restrictions\n\n0 leq a_jy leq A_jy^max qquadforall j y\n\nRetired capacity restrictions\n\n0leq r_jy leq b_jy qquadforall jy\n\nAnnual capacity transfers\n\nb_jy = b_jy-1 + a_jy-1 -r_jy-1 qquadforall y0 j\n\nInitial charge/discharge capacity\n\nb_j0 = B_j0 qquadforall i\n\nMaximum storage capacity\n\n0leq s_jyh leq S_j^max qquad forall j\n\nStorage levels after charging and discharging\n\ns_jyh = (1- lambda_j)^w_hs_jy-1h + eta_j^c  w_h q^c_jyh  - fracq_jyh^d w_heta_j^d qquad forall jyh\n\nThe last constraint is set to be periodic, so that the state of charge at  the end of each year is the same as at the beginning of the year.\n\n\n\n\n\n","category":"function"},{"location":"model_formulation/","page":"Formulation","title":"Formulation","text":"setup_transport","category":"page"},{"location":"model_formulation/#H2CS2.setup_transport","page":"Formulation","title":"H2CS2.setup_transport","text":"setup_transport(model::Model, inputs::InputStruct)\n\nThis function modifies the base model by adding regional transportation.\n\nThe following equations are added to the model:\n\n    Objective mathrel+= sum_e in E sum_y in Ysum_h in H delta_y w_h C^Trans_ey f_eyh\n\nFlow limits:\n\n    0 leq f_rjyh leq F_rjy^maxqquad forall rjyh\n\n\n\n\n\n","category":"function"},{"location":"model_formulation/","page":"Formulation","title":"Formulation","text":"setup_policy","category":"page"},{"location":"model_formulation/#H2CS2.setup_policy","page":"Formulation","title":"H2CS2.setup_policy","text":"setup_policy(model::Model, inputs::InputStruct)\n\nThis function modifies the base model by adding a carbon tax.\n\nThe carbon tax is implemented as a variable production cost in the objective function. In  the future, this function could be expanded to allow for more complex policies.\n\n    Objective mathrel+= sum_i in Psum_y in Y sum_h in H delta_y w_h tau_CO_2 q_iyh epsilon_i\n\n\n\n\n\n","category":"function"},{"location":"model_formulation/","page":"Formulation","title":"Formulation","text":"setup_mass_balance","category":"page"},{"location":"model_formulation/#H2CS2.setup_mass_balance","page":"Formulation","title":"H2CS2.setup_mass_balance","text":"setup_mass_balance(model::Model, inputs::InputStruct)\n\nThis function modifies the model by adding regional mass balance constraints \n\nThe added constraint is shown below. In the constraint formulation, P_r, S_r, and K_r represent the producers, storage units, and consumers that are located  in region r.\n\nMass balance:\n\nbeginaligned\n    0 =sum_iin P_r q_iyh + sum_jin S_r (q_jyh^d-q_jyh^c)\r\n     - sum_k in K_r D_ihr -sum_substacke in E textst e = (rj) (f_eyh) + sum_substacke in E textst e = (jr)  (f_eyh) qquadforall r y h\nendaligned\n\n\n\n\n\n","category":"function"},{"location":"model_notation/#Model-Notation","page":"Notation","title":"Model Notation","text":"","category":"section"},{"location":"model_notation/#Sets","page":"Notation","title":"Sets","text":"","category":"section"},{"location":"model_notation/","page":"Notation","title":"Notation","text":"","category":"page"},{"location":"model_notation/","page":"Notation","title":"Notation","text":"Notation Description\ni in P Set of all hydrogen producers.\ny in Y Set of all simulation years.\nh in H Set of all representative hours in the model.\ne in E Set of all transportation routes (i.e. \"Edges\" on the transportation graph). Each route connects two model regions.\nr in R Set of all model regions.\nk in K Set of all of hydrogen consumers.\nj in S Set of all storage units.","category":"page"},{"location":"model_notation/","page":"Notation","title":"Notation","text":"","category":"page"},{"location":"model_notation/#Decision-Variables","page":"Notation","title":"Decision Variables","text":"","category":"section"},{"location":"model_notation/","page":"Notation","title":"Notation","text":"","category":"page"},{"location":"model_notation/","page":"Notation","title":"Notation","text":"Notation Description\nq_iyh Production from producer i in year y and hour h\nq_jyh^c Hydrogen charged by storage unit j in year y and hour h\nq_jyh^d Hydrogen discharged by storage unit j in year y and hour h\nb_iy Preexisting production capacity of producer i at the beginning of year y before any capacity additions or retirements.\nb_jy Preexisting charge/discharge capacity of storage unit j at the beginning of year y before any capacity additions or retirements.\na_iy Added capacity built by producer i in year y.\na_jy Added charge/discharge capacity built by storage unit j in year y.\nr_jy Retired capacity by producer i in year y.\nr_iy Retired charge/discharge capacity by storage unit j in year y.\nf_e y h Quantity of hydrogen transported along route e in E in year y and hour h.\ns_jyh Total hydrogen in storage at storage unit j in year y and hour h.","category":"page"},{"location":"model_notation/","page":"Notation","title":"Notation","text":"","category":"page"},{"location":"model_notation/#Coefficients","page":"Notation","title":"Coefficients","text":"","category":"section"},{"location":"model_notation/","page":"Notation","title":"Notation","text":"","category":"page"},{"location":"model_notation/","page":"Notation","title":"Notation","text":"Notation Description\ndelta_y Discount factor applied to costs in year y\nw_h Weight of representative hour h\nC_iy^I Annualized investment cost of new capacity additions for producer i in year y\nC_jy^I Annualized investment cost of new charge/discharge capaciy additions for storage unit j in year y\nC_iy^F Fixed cost of capacity for producer i in year y\nC_jy^F Fixed cost of capacity for storage unit j in year y\nC_iyh^V Variable operating and maintenance cost for producer i in year y and hour h\nC_jyh^V Variable operating and maintenance cost for storage unit j in year y and hour h\nC_ey^Trans Cost of transporting hydrogen along edge e in year y.\nGamma_iyh Availability factor of producer i in year y and hour h.\nGamma_jyh Charge/discharge availability factor of storage unit j in year y and hour h.\nA_iy^max Maximum capacity additions feasible by consumer i in year y. We assume this is zero for all years except one \"build-year\". The build-year may vary by producer.\nA_jy^max Maximum charge/discharge capacity additions feasible by storage unit j in year y. We assume this is zero for all years except one \"build-year\".\nD_r y h Hydrogen demand in region r during year y and hour h. \\\nF_e y^max Max hydrogen transport along edge e in E and year y\nB_i0 Preexisting capacity of producer i at the beginning of the simulation\nB_j0 Preexisting charge/discharge capacity of storage unit j at the beginning of the simulation\nS_j^max Maximum quantity of hydrogen that can be stored by storage unit j (i.e. the energy capacity)\ntau_CO2y Carbon tax in year y\nepsilon_i Emission rate (kG CO2/kg H2) of producer i\nlambda_j Self-discharge rate of storage unit j\neta^c_j Charge efficiency of storage unit j\neta^d_j Discharge efficiency of storage unit j","category":"page"},{"location":"model_notation/","page":"Notation","title":"Notation","text":"","category":"page"},{"location":"#Introduction","page":"Home","title":"Introduction","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Welcome to the Hydrogen Case Study 2 (H2CS2) model!","category":"page"},{"location":"","page":"Home","title":"Home","text":"This model is a complete optimization model for the European Hydrogen system. It was developed by Davide Berti, Eric Ehrhardt, Christoph Funke, and Federico Sartore for the Case Study course of ETH's Masters in Energy Science and Technology. We hope that you enjoy our model.","category":"page"},{"location":"#Installation-Instructions","page":"Home","title":"Installation Instructions","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This model was developed using VS Code on Windows using Julia Version 1.8.  The model is programed as a package containing a series of functions and data structures which can be loaded and utilized in standard Julia code. The  following steps will install and activate the model under this setup.","category":"page"},{"location":"","page":"Home","title":"Home","text":"1. Clone the git repository ","category":"page"},{"location":"","page":"Home","title":"Home","text":"git clone https://github.com/ericehrhardt/Case-Study-ETH.git","category":"page"},{"location":"","page":"Home","title":"Home","text":"2. From inside the project directory, navigate into the folder H2CS2","category":"page"},{"location":"","page":"Home","title":"Home","text":"cd H2CS2","category":"page"},{"location":"","page":"Home","title":"Home","text":"3. Enter into to package environment. If done correctly, the termial should now turn into a julia promt.","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia --project=.","category":"page"},{"location":"","page":"Home","title":"Home","text":"4. Type ']' to enter Julia's package manager. If steps 1-3 are properly executed, the prompt should display: (H2CS2) pkg>. From the package manager, type 'instantiate' to install all required packages and dependencies for the model.","category":"page"},{"location":"","page":"Home","title":"Home","text":"instantiate","category":"page"},{"location":"","page":"Home","title":"Home","text":"Exit the package manager by pressing backspace until the \"julia>\" prompt returns.","category":"page"},{"location":"","page":"Home","title":"Home","text":"5. Run the model by executing:","category":"page"},{"location":"","page":"Home","title":"Home","text":"include(\"main.jl\")","category":"page"},{"location":"","page":"Home","title":"Home","text":"The function \"include\" is Julia's command for running a file. The standard \"run\"  button in VS Code does not work.","category":"page"},{"location":"#Gurobi","page":"Home","title":"Gurobi","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"The model currently uses Gurobi optimizer, although it can easily be adapted to use other solvers. To use Gurobi, first install Gurobi on your computer. Then add the path to Gurobi executing the following command in a Julia terminal:","category":"page"},{"location":"","page":"Home","title":"Home","text":"ENV[\"GUROBI_HOME\"] = <path_to_gurobi>","category":"page"},{"location":"","page":"Home","title":"Home","text":"The pathtogurobi may for instance be: \"C:\\gurobi1000\\win64\".","category":"page"},{"location":"","page":"Home","title":"Home","text":"After adding path, install the Julia Gurobi interface by running:","category":"page"},{"location":"","page":"Home","title":"Home","text":"Pkg.add(\"Gurobi\")\r\nPkg.build(\"Gurobi\")","category":"page"}]
}