Model Coefficients
===================

Each model coefficient its own function that reads the coefficient values from the input data. All model functions beginning with capital letters are such coefficients. The code for all of the coefficient functions is contained in the **coefficients.jl** file.

In this page, we proviide documentation for each of the coefficient functions. The documentation for each coefficient specifies exactly how the coefficient values are calculated from the input data. 

```@docs
    Cost_VOM
```

```@docs
    Cost_FOM
```

```@docs
    Cost_Invest
```

```@docs
    Producer_Availability
```

```@docs
    Max_Capacity
```

```@docs
    Existing_Capacity
```

```@docs
    Flow_Limit
```

```@docs
    Cost_Transport
```

```@docs
    Weight_Hour
```

```@docs
    Discount_Factor
```