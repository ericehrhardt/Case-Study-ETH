Model Notation
===============

## Sets
---
|**Notation** | **Description**|
| :------------ | :-----------|
|$i \in P$ | Set of all hydrogen producers. |
|$y \in Y$ | Set of all simulation years. |
|$h \in H$ | Set of all representative hours in the model. |
|$e \in E$ | Set of all transportation routes (i.e. "Edges" on the transportation graph). Each route connects two model regions. |
|$r \in R$ | Set of all model regions.|
|$k \in K$ | Set of all of hydrogen consumers.|
|$j \in S$ | Set of all storage units.| 
---

## Decision Variables
---
|**Notation** | **Description**|
| :------------ | :-----------|
|$q_{i,y,h}$| Production from producer $i$ in year $y$ and hour $h$|
|$q_{j,y,h}^c$| Hydrogen charged by storage unit $j$ in year $y$ and hour $h$|
|$q_{j,y,h}^d$| Hydrogen discharged by storage unit $j$ in year $y$ and hour $h$|
|$b_{i,y}$  | Preexisting production capacity of producer $i$ at the beginning of year $y$ before any capacity additions or retirements.|
|$b_{j,y}$  | Preexisting charge/discharge capacity of storage unit $j$ at the beginning of year $y$ before any capacity additions or retirements.|
|$a_{i,y}$ | Added capacity built by producer $i$ in year $y$.|
|$a_{j,y}$ | Added charge/discharge capacity built by storage unit $j$ in year $y$.|
|$r_{j,y}$ | Retired capacity by producer $i$ in year $y$.|
|$r_{i,y}$ | Retired charge/discharge capacity by storage unit $j$ in year $y$.|
|$f_{e, y, h}$ | Quantity of hydrogen transported along route $e \in E$ in year $y$ and hour $h$.|
|$s_{j,y,h}$ |Total hydrogen in storage at storage unit $j$ in year $y$ and hour $h$.|
---

## Coefficients
---
|**Notation** | **Description**|
| :------------ | :-----------|
|  $\delta_y$ | Discount factor applied to costs in year $y$ |
|  $w_h$ | Weight of representative hour $h$ |
|  $C_{i,y}^I$ | Annualized investment cost of new capacity additions for producer $i$ in year $y$ |
|  $C_{j,y}^I$ | Annualized investment cost of new charge/discharge capaciy additions for storage unit $j$ in year $y$ |
|  $C_{i,y}^F$ | Fixed cost of capacity for producer $i$ in year $y$ |
|  $C_{j,y}^F$ | Fixed cost of capacity for storage unit $j$ in year $y$ |
|  $C_{i,y,h}^V$ | Variable operating and maintenance cost for producer $i$ in year $y$ and hour $h$|
|  $C_{j,y,h}^V$ | Variable operating and maintenance cost for storage unit $j$ in year $y$ and hour $h$|
|  $C_{e,y}^{Trans}$ | Cost of transporting hydrogen along edge $e$ in year $y$. |
|  $\Gamma_{i,y,h}$ | Availability factor of producer $i$ in year $y$ and hour $h$. |
|  $\Gamma_{j,y,h}$ | Charge/discharge availability factor of storage unit $j$ in year $y$ and hour $h$. |
|  $A_{i,y}^{max}$ | Maximum capacity additions feasible by consumer $i$ in year $y$. We assume this is zero for all years except one "build-year". The build-year may vary by producer. |
|  $A_{j,y}^{max}$ | Maximum charge/discharge capacity additions feasible by storage unit $j$ in year $y$. We assume this is zero for all years except one "build-year".|
|  $D_{r, y, h}$ | Hydrogen demand in region $r$ during year $y$ and hour $h$. \\
|  $F_{e, y}^{max}$ | Max hydrogen transport along edge $e in E$ and year $y$|
|  $B_{i,0}$ | Preexisting capacity of producer $i$ at the beginning of the simulation |
|  $B_{j,0}$ | Preexisting charge/discharge capacity of storage unit $j$ at the beginning of the simulation |
|  $S_j^{max}$ | Maximum quantity of hydrogen that can be stored by storage unit $j$ (i.e. the energy capacity) |
|  $\tau_{CO2,y}$ | Carbon tax in year $y$|
|  $\epsilon_{i}$ | Emission rate (kG CO2/kg H2) of producer $i$|
|  $\lambda_j$ | Self-discharge rate of storage unit $j$|
|  $\eta^{c}_j$ | Charge efficiency of storage unit $j$|
|  $\eta^{d}_j$ | Discharge efficiency of storage unit $j$|
---
