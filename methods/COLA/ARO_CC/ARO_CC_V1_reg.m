function H = ARO_CC_V1_reg(reference,model,varargin)
    
    p = inputParser;
    addRequired(p,'reference');
    addRequired(p,'model');
    addParameter(p,'H_Init',eye(4));
    addParameter(p,'output_path',false);
    addParameter(p,'MaxIt',400);
    
    parse(p,reference,model,varargin{:})
    
    X = p.Results.reference;
    Y = p.Results.model;
    use_H_Init = ~any(strcmp(p.UsingDefaults,'H_Init'));
    use_output_path = ~any(strcmp(p.UsingDefaults,'output_path'));
    H_Init = p.Results.H_Init;
    output_path = p.Results.output_path;
    MaxIt = p.Results.MaxIt;
    
    rng(1)
    
    %% COLA Parameters
    c = 0.25;
    p = 2;

    %% Problem Definition
    problem.CostFunction = @(H) COLA_CC_3D(X,Y,c,p,H);  % Cost Function
    problem.nVar = 6;       % Number of Unknown (Decision) Variables
    
    %% wood_summer
%     Lim_Tx =  0.8;   % Upper and Lower Bound of Decision Variables
%     Lim_Ty =  0.3;   % Upper and Lower Bound of Decision Variables
%     Lim_Tz =  0.1;   % Upper and Lower Bound of Decision Variables
%     Lim_Roll = deg2rad(10); % Upper and Lower Bound of Decision Variables
%     Lim_Pitch = deg2rad(10); % Upper and Lower Bound of Decision Variables
%     Lim_Yaw = deg2rad(40); % Upper and Lower Bound of Decision Variables
%     %problem.VarMin = [-Lim_Roll, -Lim_Pitch, -Lim_Yaw, -Lim_T, -Lim_T, -Lim_T];  % Lower Bound of Decision Variables
%     %problem.VarMax = [Lim_Roll, Lim_Pitch, Lim_Yaw, Lim_T, Lim_T, Lim_T];  % Upper Bound of Decision Variables
%     %problem.VarMin = [-0.4446,-0.1181,-0.0662,0,-0.1812,-0.0172];  % Lower Bound of Decision Variables
%     %problem.VarMax = [0.6399,0.0681,0.0576,0.7142,0.2277,0.0571];  % Upper Bound of Decision Variables
%   
%     problem.VarMin = [min(-Lim_Roll,Lim_Roll), min(-Lim_Pitch,Lim_Pitch), min(-Lim_Yaw,Lim_Yaw), min(-Lim_Tx,Lim_Tx), min(-Lim_Ty,Lim_Ty), min(-Lim_Tz,Lim_Tz)];
%     problem.VarMax = [max(-Lim_Roll,Lim_Roll), max(-Lim_Pitch,Lim_Pitch), max(-Lim_Yaw,Lim_Yaw), max(-Lim_Tx,Lim_Tx), max(-Lim_Ty,Lim_Ty), max(-Lim_Tz,Lim_Tz)];
    
    %% stairs
    
    Lim_Tx =  0.7;   % Upper and Lower Bound of Decision Variables
    Lim_Ty =  0.3;   % Upper and Lower Bound of Decision Variables
    Lim_Tz =  0.3;   % Upper and Lower Bound of Decision Variables
    Lim_Roll = deg2rad(6); % Upper and Lower Bound of Decision Variables
    Lim_Pitch = deg2rad(35); % Upper and Lower Bound of Decision Variables
    Lim_Yaw = deg2rad(35); % Upper and Lower Bound of Decision Variables
    %problem.VarMin = [-Lim_Roll, -Lim_Pitch, -Lim_Yaw, -Lim_T, -Lim_T, -Lim_T];  % Lower Bound of Decision Variables
    %problem.VarMax = [Lim_Roll, Lim_Pitch, Lim_Yaw, Lim_T, Lim_T, Lim_T];  % Upper Bound of Decision Variables
    %problem.VarMin = [-0.4446,-0.1181,-0.0662,0,-0.1812,-0.0172];  % Lower Bound of Decision Variables
    %problem.VarMax = [0.6399,0.0681,0.0576,0.7142,0.2277,0.0571];  % Upper Bound of Decision Variables
  
    problem.VarMin = [min(-Lim_Roll,Lim_Roll), min(-Lim_Pitch,Lim_Pitch), min(-Lim_Yaw,Lim_Yaw), min(-Lim_Tx,Lim_Tx), min(-Lim_Ty,Lim_Ty), min(-Lim_Tz,Lim_Tz)];
    problem.VarMax = [max(-Lim_Roll,Lim_Roll), max(-Lim_Pitch,Lim_Pitch), max(-Lim_Yaw,Lim_Yaw), max(-Lim_Tx,Lim_Tx), max(-Lim_Ty,Lim_Ty), max(-Lim_Tz,Lim_Tz)];
    
    
    if use_H_Init
        problem.pos_init = euler_trans(H_Init);
    end

    %% ARO Settings
    params.MaxIt = MaxIt;              % Maximum Number of Iterations
    params.nPop = 60;               % Population Size (Colony Size)
    
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