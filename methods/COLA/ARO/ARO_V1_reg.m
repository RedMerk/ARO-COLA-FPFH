function H = ARO_V1_reg(reference,model,varargin)
    
    p = inputParser;
    addRequired(p,'reference');
    addRequired(p,'model');
    addParameter(p,'H_Init',eye(4));
    addParameter(p,'output_path',false);
    addParameter(p,'MaxIt',200);
    addParameter(p,'nPop',50);
    
    parse(p,reference,model,varargin{:})
    
    X = p.Results.reference;
    Y = p.Results.model;
    use_H_Init = ~any(strcmp(p.UsingDefaults,'H_Init'));
    use_output_path = ~any(strcmp(p.UsingDefaults,'output_path'));
    H_Init = p.Results.H_Init;
    output_path = p.Results.output_path;
    MaxIt = p.Results.MaxIt;
    nPop = p.Results.nPop;
    
    rng(1)
    
    %% COLA Parameters
    c = 0.15;
    p = 2;

    %% Problem Definition
    problem.CostFunction = @(H) COLA_3D(X,Y,c,p,H);  % Cost Function
    problem.nVar = 6;       % Number of Unknown (Decision) Variables
    Lim_T =  1;   % Upper and Lower Bound of Decision Variables
    Lim_Roll = deg2rad(180); % Upper and Lower Bound of Decision Variables
    Lim_Pitch = deg2rad(90); % Upper and Lower Bound of Decision Variables
    Lim_Yaw = deg2rad(180); % Upper and Lower Bound of Decision Variables
    problem.VarMin = [-Lim_Roll, -Lim_Pitch, -Lim_Yaw, -Lim_T, -Lim_T, -Lim_T];  % Lower Bound of Decision Variables
    problem.VarMax = [Lim_Roll, Lim_Pitch, Lim_Yaw, Lim_T, Lim_T, Lim_T];  % Upper Bound of Decision Variables
    if use_H_Init
        problem.pos_init = euler_trans(H_Init);
    end

    %% ARO Settings
    params.MaxIt = MaxIt;              % Maximum Number of Iterations
    params.nPop = nPop;               % Population Size (Colony Size)
    
    %% Calling ARO
    t = tic;
    out = ARO(problem, params);
    time = toc(t);

    H = pos_2_H(out.BestSol);
    
    %BestCosts = out.BestCosts;
    if use_output_path
        if MaxIt == 1000
            Algoritmo = "ARO_V1";
        else
            Algoritmo = sprintf("ARO_V1_MaxIt_%d",MaxIt);
        end
        EscribirOutput(H,time,output_path,Algoritmo)
    end
end