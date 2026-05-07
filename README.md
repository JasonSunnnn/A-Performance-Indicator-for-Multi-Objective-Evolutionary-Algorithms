# This is the code for our paper: 'Integrating Performance Metrics for Multi-Objective Optimization: A Case Study with MOEAs'
Welcome to cite our work when using this code.

# Reference
Xu, S., Sun, J., Shen, Z., Eskandarpour, M. Integrating performance metrics for multi-objective optimization: a case study with MOEAs. Computers & Operations Research, 2026, 107531. https://doi.org/10.1016/j.cor.2026.107531

# Running the code
You can run the 'main.m' file to evaluate data. All the indicator data used in the experiment is stored in 'indicators. mat'.
The proposed evaluation model is calculated through Cplex. The program can be found in 'EvaluationModel.m'.
Note that using 'linprog' may result in errors due to significant differences in data dimensions.
