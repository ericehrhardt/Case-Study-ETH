using Documenter, H2CS2


makedocs(
    modules = [H2CS2],
    doctest = false,
    sitename = "H2CS2",
    pages = [
        "Home" => "index.md",
        "Model" => [
            "Model Overview" => "model_overview.md",
            "Notation" => "model_notation.md",
            "Formulation" => "model_formulation.md",
            "Coefficients" => "model_coefficients.md"
        ]
    ]
)

# deploydocs(
#     repo   = "github.com/ericehrhardt/Case-Study-ETH",
#     target = "build",
#     deps   = nothing,
#     make   = nothing
# )